/**
 * ============================================================================
 * Class:       CLL_DiningKnowledgeRetriever
 * Language:    Apex — Salesforce's strongly typed, Java-like server-side language.
 *
 * Agent connection:
 *   TableCraft_Agent.agent declares `target: "apex://CLL_DiningKnowledgeRetriever"`.
 *   Agentforce therefore calls the `@InvocableMethod` below and maps the Agent
 *   Script inputs to `Request`, then maps `Result` back to Agent Script outputs.
 *
 * End-to-end path:
 *   FAQ subagent -> Agent Script action -> this Apex class -> CRM visibility check
 *   -> Data 360 hybrid search -> source-labeled passages -> FAQ subagent response.
 *
 * Plan Doc:    docs/FAQ_TableCraft_Agent/specs_plans/rag_knowledge_article_setup.md (Step 5)
 * Pipeline:    docs/FAQ_TableCraft_Agent/specs_plans/ambika-monday-demo-faq-pipeline.md (Step 3)
 *
 * Overview:
 *   On-demand Data 360 RAG retriever invoked by `subagent faq` (`retrieve_dining_knowledge`)
 *   when a diner asks about restaurant menus, dietary options, happy hour, parking, dress code,
 *   kids/pets, or group/event policies (questions beyond operating hours and phone number,
 *   which are answered directly from CRM `@variables` loaded in `before_reasoning` with 0 RAG calls).
 *
 * How It Connects to Data 360 & Salesforce Knowledge (`Knowledge__kav`):
 *   1. Executes `ConnectApi.CdpQuery.queryAnsiSqlV2` against the Data 360 Hybrid Search Index
 *      `KA_TableCraft_FAQ_Knowledge_index__dlm` (dense vector E5-Large + BM25 keyword fusion),
 *      joined to `KA_TableCraft_FAQ_Knowledge_chunk__dlm` (`c`) and
 *      `ssot__KnowledgeArticleVersion__dlm` (`k`).
 *   2. Filters strictly by `k.Restaurant_ID_c__c = :restaurantId` (and optionally narrows further
 *      by `k.Category_c__c = :category` when `Menu`, `Parking_And_Access`, or `Policies` is provided).
 *   3. Labels every returned chunk with `[SOURCE: <Article Title> | Category: <Category>]` so
 *      `subagent faq` can ground its answer and cite the exact Knowledge Article source.
 * ============================================================================
 */
// `public` lets Agentforce invoke the class. `with sharing` applies the current
// agent user's record-sharing rules instead of silently running with unrestricted access.
public with sharing class CLL_DiningKnowledgeRetriever {

    // `@InvocableMethod` exposes one Apex method to declarative Salesforce tools
    // and to the Agent Script target `apex://CLL_DiningKnowledgeRetriever`.
    @InvocableMethod(
        // Human-readable name shown in Salesforce tooling.
        label='CLL Dining Knowledge Retriever'
        // Human-readable explanation of the action's contract.
        description='Executes Data 360 Hybrid Search on Salesforce Knowledge articles scoped by restaurantId and optional category (Menu, Parking_And_Access, Policies), returning source-labeled passages.'
    )
    // Agentforce sends requests as a list because invocable Apex must be bulk-capable.
    // The method is static, so Salesforce invokes it without constructing this class.
    public static List<Result> execute(List<Request> requests) {
        // Create the list that will be returned to Agentforce.
        List<Result> results = new List<Result>();
        // Process every request supplied in this invocation.
        for (Request req : requests) {
            // Delegate one request to the private retrieval method and save its result.
            results.add(retrieve(req));
        }
        // Return results in the same order as the incoming requests.
        return results;
    }

    /**
     * Pipeline Step 3: Queries the Data 360 Hybrid Search Index (`KA_TableCraft_FAQ_Knowledge_index__dlm`)
     * scoped to `req.restaurantId` and optional `req.category`.
     */
    // `private` keeps the implementation internal; callers enter through `execute`.
    private static Result retrieve(Request req) {
        // Allocate the output object that maps back to Agent Script's `@outputs`.
        Result r = new Result();
        // Collect each authorized Knowledge chunk that Data 360 returns.
        List<String> passages = new List<String>();

        // A restaurant ID is the tenant boundary. Without it, do not search globally.
        if (req == null || String.isBlank(req.restaurantId)) {
            // Tell the FAQ subagent that no grounded source was found.
            r.hasSource = false;
            // Return an empty passage string instead of null.
            r.passages = '';
            // Stop immediately so no query can run without restaurant scoping.
            return r;
        }

        // Trim the restaurant ID and escape apostrophes before inserting it into Data 360 SQL.
        String safeRestaurantId = String.escapeSingleQuotes(req.restaurantId.trim());
        // Sanitize the natural-language question; use an empty string when none was supplied.
        String safeQuestion = String.isNotBlank(req.question)
            ? String.escapeSingleQuotes(req.question.trim())
            : '';
        // Sanitize the optional category filter in the same way.
        String safeCategory = String.isNotBlank(req.category)
            ? String.escapeSingleQuotes(req.category.trim())
            : '';
        // Prefixing the question with the restaurant ID reinforces restaurant-specific retrieval.
        String searchQuery = String.isNotBlank(safeQuestion)
            ? safeRestaurantId + ' ' + safeQuestion
            : safeRestaurantId;

        // 0. CRM Knowledge__kav Visibility Gate (WITH USER_MODE):
        //    Verify that the Agent User can only surface articles that are Online, Latest Version,
        //    and marked visible in the Public Knowledge Base / App (blocking Draft or Archived internal articles).
        // Run the CRM authorization check before asking Data 360 for any content.
        Set<Id> allowedArticleVersionIds = getPublishedVisibleArticleIds(req.restaurantId.trim(), req.category);
        // If CRM says the agent can access no matching articles, Data 360 must not return any.
        if (allowedArticleVersionIds.isEmpty()) {
            // Report an ungrounded result.
            r.hasSource = false;
            // Return no content to the model.
            r.passages = '';
            // Exit before the Data 360 API call.
            return r;
        }

        // 1. Primary Path: Data 360 Hybrid Search on KA_TableCraft_FAQ_Knowledge_index__dlm
        //    joined to chunk DMO and KnowledgeArticleVersion DMO, scoped by Restaurant_ID_c__c,
        //    Online publication status, and public/app visibility (+ optional Category_c__c)
        try {
            // Build mandatory tenant, publication, visibility, and useful-content filters.
            String whereClause = 'WHERE k.Restaurant_ID_c__c = \'' + safeRestaurantId + '\' '
                + 'AND k.ssot__KnowledgePublicationStatus__c = \'Online\' '
                + 'AND k.ssot__IsLatestVersion__c = \'true\' '
                + 'AND (k.ssot__IsVisibleInPublicKnowledgeBase__c = \'true\' OR k.ssot__IsVisibleInApp__c = \'true\') '
                + 'AND LENGTH(c.Chunk__c) > 120';
            // Narrow the query when Agentforce selected Menu, Parking, or Policies.
            if (String.isNotBlank(safeCategory)) {
                // Append the already escaped category value to the SQL filter.
                whereClause += ' AND k.Category_c__c = \'' + safeCategory + '\'';
            }

            // Create the Connect API request object used for Data 360 ANSI SQL.
            ConnectApi.CdpQueryInput queryInput = new ConnectApi.CdpQueryInput();

            // Build a hybrid vector + keyword query:
            // - `hybrid_search` finds relevant indexed records.
            // - the chunk join supplies text.
            // - the Knowledge join supplies title, restaurant, category, status, and version.
            // - the WHERE clause enforces tenant and visibility boundaries.
            // - sorting and LIMIT retain the five strongest matches.

            // HERE1: HYBRID SEARCH ranks matches from the SEARCH INDEX: KA_TableCraft_FAQ_Knowledge_index__dlm
            queryInput.sql = 'SELECT c.Chunk__c, k.ssot__Name__c, k.Restaurant_ID_c__c, k.Category_c__c, h.hybrid_score__c, k.ssot__Id__c '
                + 'FROM hybrid_search('
                + '    TABLE(KA_TableCraft_FAQ_Knowledge_index__dlm), '
                + '    \'' + searchQuery + '\', '
                + '    \'\', '
                + '    50'
                + ') h ';

            // HERE2: This JOIN fetches the actual passage text from the CHUNK TABLE: KA_TableCraft_FAQ_Knowledge_chunk__dlm
            queryInput.sql += 'JOIN KA_TableCraft_FAQ_Knowledge_chunk__dlm c '
                + '    ON h.SourceRecordId__c = c.RecordId__c '
                + 'JOIN ssot__KnowledgeArticleVersion__dlm k '
                + '    ON c.SourceRecordId__c = k.ssot__Id__c '
                + whereClause + ' '
                + 'ORDER BY h.hybrid_score__c DESC '
                + 'LIMIT 5';

            // Send the SQL to Data 360 synchronously through Salesforce Connect API.
            ConnectApi.CdpQueryOutputV2 output = ConnectApi.CdpQuery.queryAnsiSqlV2(queryInput);
            // Guard against an empty API response before iterating over rows.
            if (output != null && output.data != null) {
                // Data 360 returns each result row as a generic Object.
                for (Object rowObj : output.data) {
                    // Convert the generic row into a list so columns can be read by index.
                    List<Object> row = (List<Object>) JSON.deserializeUntyped(JSON.serialize(rowObj));
                    // Ignore null or malformed empty rows.
                    if (row != null && !row.isEmpty()) {
                        // Column 0 is the retrieved Knowledge chunk.
                        String chunkText = row[0] != null ? String.valueOf(row[0]).trim() : '';
                        // Column 1 is the article title; provide a safe fallback label.
                        String articleTitle = (row.size() > 1 && row[1] != null) ? String.valueOf(row[1]).trim() : 'Knowledge Article';
                        // Column 3 is the optional article category.
                        String articleCategory = (row.size() > 3 && row[3] != null) ? String.valueOf(row[3]).trim() : '';
                        // Column 5 is the Knowledge article-version ID used for the CRM authorization check.
                        String versionIdStr = (row.size() > 5 && row[5] != null) ? String.valueOf(row[5]).trim() : '';

                        // Accept the chunk only when its version passed the CRM visibility query.
                        // The blank-ID fallback supports result shapes that do not include the version ID.
                        Boolean isAuthorizedInCrm = String.isBlank(versionIdStr)
                            || allowedArticleVersionIds.contains((Id) versionIdStr);

                        // Skip metadata-only stub chunks and any chunk not backed by an Online, visible CRM Knowledge__kav record
                        if (isAuthorizedInCrm && String.isNotBlank(chunkText) && chunkText.length() > 80) {
                            // Produce a readable source name, adding the category when present.
                            String sourceLabel = articleTitle + (String.isNotBlank(articleCategory) ? ' (' + articleCategory + ')' : '');
                            // Flatten line breaks and prepend a citation before exposing text to the FAQ subagent.
                            passages.add('[SOURCE: ' + sourceLabel + '] ' + chunkText.replace('\n', ' '));
                        }
                    }
                }
            }
        // Retrieval failures are handled as "no source" so the FAQ subagent can abstain safely.
        } catch (Exception e) {
            // Record diagnostic information without exposing internal errors to the diner.
            System.debug(LoggingLevel.WARN, 'Data 360 hybrid_search warning: ' + e.getMessage());
        }

        // A source exists only when at least one authorized passage survived all filters.
        r.hasSource = !passages.isEmpty();
        // Combine passages into the single string expected by the Agent Script output schema.
        r.passages = String.join(passages, '\n');
        // Return the grounded result to `execute`, which returns it to Agentforce.
        return r;
    }

    /**
     * Enforces CRM-level Knowledge__kav restriction in USER_MODE:
     * Only returns Knowledge__kav version IDs where PublishStatus = 'Online', IsLatestVersion = true,
     * and the article is marked visible in PKB / App (preventing Draft or Archived internal articles from being surfaced).
     */
    // This helper asks CRM which Knowledge versions the current agent user may expose.
    private static Set<Id> getPublishedVisibleArticleIds(String restaurantId, String category) {
        // A Set gives fast membership checks and automatically removes duplicate IDs.
        Set<Id> allowedIds = new Set<Id>();
        // Normalize the optional category once before deciding which SOQL query to run.
        String cat = String.isNotBlank(category) ? category.trim() : '';
        // Declare the list that will receive the SOQL result.
        List<Knowledge__kav> articles;
        // Use a category-scoped query when the request includes a category.
        if (String.isNotBlank(cat)) {
            // Static SOQL binds Apex variables with `:` and enforces CRUD/FLS via USER_MODE.
            articles = [
                SELECT Id
                FROM Knowledge__kav
                WHERE Restaurant_ID__c = :restaurantId
                  AND Category__c = :cat
                  AND PublishStatus = 'Online'
                  AND IsLatestVersion = true
                  AND (IsVisibleInPkb = true OR IsVisibleInApp = true)
                WITH USER_MODE
            ];
        } else {
            // Without a category, retrieve every visible current article for this restaurant.
            articles = [
                SELECT Id
                FROM Knowledge__kav
                WHERE Restaurant_ID__c = :restaurantId
                  AND PublishStatus = 'Online'
                  AND IsLatestVersion = true
                  AND (IsVisibleInPkb = true OR IsVisibleInApp = true)
                WITH USER_MODE
            ];
        }
        // Copy the authorized CRM IDs into the Set used to validate Data 360 rows.
        for (Knowledge__kav kav : articles) {
            // Add this article version's Salesforce record ID.
            allowedIds.add(kav.Id);
        }
        // Return the allow-list to the retrieval method.
        return allowedIds;
    }

    // This inner class defines the input contract shown under `inputs:` in Agent Script.
    public class Request {
        // Agent Script's `restaurantId` value is deserialized into this field.
        @InvocableVariable(label='Restaurant ID' description='Restaurant code, for example REST-ATX-02' required=true)
        public String restaurantId;

        /**
         * What this connects to & where it sits in the FAQ pipeline:
         * 1. Pipeline Position:
         *    - Step 1 (`before_reasoning` -> `validate_restaurant_context`): Deterministically loads `restaurant_id`,
         *      `operating_hours`, `escalation_phone_number`, and `current_date_time` from `Restaurant__c`.
         *    - Step 2 (`subagent faq` reasoning): If the diner's question is about hours or phone number, `subagent faq`
         *      answers directly from `@variables` (0 RAG calls). Otherwise, for menu, parking, or policy questions,
         *      `subagent faq`'s LLM invokes `retrieve_dining_knowledge` (`CLL_DiningKnowledgeRetriever`) and passes
         *      `restaurantId`, `question`, and this optional `category` (`Menu`, `Parking_And_Access`, or `Policies`).
         * 2. Data 360 / CRM Connection:
         *    - Connects to the `Category__c` picklist field on Salesforce Knowledge (`Knowledge__kav`), which is synced
         *      via the `Knowledge_kav_Home` Data Stream into the Data 360 DMO column `ssot__KnowledgeArticleVersion__dlm.Category_c__c`
         *      and linked to the Hybrid Search Index (`KA_TableCraft_FAQ_Knowledge_index__dlm` / `KA_TableCraft_FAQ_Knowledge_chunk__dlm`).
         *    - Narrows the RAG search space to only chunks from that restaurant's specific topic article
         *      (`WHERE k.Restaurant_ID_c__c = :restaurantId AND k.Category_c__c = :category`).
         */
        // Agent Script's optional `category` value is deserialized into this field.
        @InvocableVariable(label='Category' description='Optional topic filter: Menu, Parking_And_Access, or Policies' required=false)
        public String category;

        // Agent Script's diner `question` is deserialized into this field.
        @InvocableVariable(label='Question' description='Diner question used for Data 360 vector + keyword hybrid search' required=true)
        public String question;
    }

    // This inner class defines the output contract shown under `outputs:` in Agent Script.
    public class Result {
        // Agent Script reads this as `@outputs.hasSource`.
        @InvocableVariable(label='Has Source' description='True when at least one grounded Knowledge chunk was found')
        public Boolean hasSource;

        // Agent Script reads this as `@outputs.passages`.
        @InvocableVariable(label='Passages' description='Source-labeled Knowledge chunks ([SOURCE: <Article Title>] <Chunk Text>), one per line')
        public String passages;
    }
}
