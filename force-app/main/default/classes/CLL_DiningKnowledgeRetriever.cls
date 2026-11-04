/**
 * ============================================================================
 * Class:       CLL_DiningKnowledgeRetriever
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
public with sharing class CLL_DiningKnowledgeRetriever {

    @InvocableMethod(
        label='CLL Dining Knowledge Retriever'
        description='Executes Data 360 Hybrid Search on Salesforce Knowledge articles scoped by restaurantId and optional category (Menu, Parking_And_Access, Policies), returning source-labeled passages.'
    )
    public static List<Result> execute(List<Request> requests) {
        List<Result> results = new List<Result>();
        for (Request req : requests) {
            results.add(retrieve(req));
        }
        return results;
    }

    /**
     * Pipeline Step 3: Queries the Data 360 Hybrid Search Index (`KA_TableCraft_FAQ_Knowledge_index__dlm`)
     * scoped to `req.restaurantId` and optional `req.category`.
     */
    private static Result retrieve(Request req) {
        Result r = new Result();
        List<String> passages = new List<String>();

        if (req == null || String.isBlank(req.restaurantId)) {
            r.hasSource = false;
            r.passages = '';
            return r;
        }

        String safeRestaurantId = String.escapeSingleQuotes(req.restaurantId.trim());
        String safeQuestion = String.isNotBlank(req.question)
            ? String.escapeSingleQuotes(req.question.trim())
            : '';
        String safeCategory = String.isNotBlank(req.category)
            ? String.escapeSingleQuotes(req.category.trim())
            : '';
        String searchQuery = String.isNotBlank(safeQuestion)
            ? safeRestaurantId + ' ' + safeQuestion
            : safeRestaurantId;

        // 0. CRM Knowledge__kav Visibility Gate (WITH USER_MODE):
        //    Verify that the Agent User can only surface articles that are Online, Latest Version,
        //    and marked visible in the Public Knowledge Base / App (blocking Draft or Archived internal articles).
        Set<Id> allowedArticleVersionIds = getPublishedVisibleArticleIds(req.restaurantId.trim(), req.category);
        if (allowedArticleVersionIds.isEmpty()) {
            r.hasSource = false;
            r.passages = '';
            return r;
        }

        // 1. Primary Path: Data 360 Hybrid Search on KA_TableCraft_FAQ_Knowledge_index__dlm
        //    joined to chunk DMO and KnowledgeArticleVersion DMO, scoped by Restaurant_ID_c__c,
        //    Online publication status, and public/app visibility (+ optional Category_c__c)
        try {
            String whereClause = 'WHERE k.Restaurant_ID_c__c = \'' + safeRestaurantId + '\' '
                + 'AND k.ssot__KnowledgePublicationStatus__c = \'Online\' '
                + 'AND k.ssot__IsLatestVersion__c = \'true\' '
                + 'AND (k.ssot__IsVisibleInPublicKnowledgeBase__c = \'true\' OR k.ssot__IsVisibleInApp__c = \'true\') '
                + 'AND LENGTH(c.Chunk__c) > 120';
            if (String.isNotBlank(safeCategory)) {
                whereClause += ' AND k.Category_c__c = \'' + safeCategory + '\'';
            }

            ConnectApi.CdpQueryInput queryInput = new ConnectApi.CdpQueryInput();
            queryInput.sql = 'SELECT c.Chunk__c, k.ssot__Name__c, k.Restaurant_ID_c__c, k.Category_c__c, h.hybrid_score__c, k.ssot__Id__c '
                + 'FROM hybrid_search('
                + '    TABLE(KA_TableCraft_FAQ_Knowledge_index__dlm), '
                + '    \'' + searchQuery + '\', '
                + '    \'\', '
                + '    50'
                + ') h '
                + 'JOIN KA_TableCraft_FAQ_Knowledge_chunk__dlm c '
                + '    ON h.SourceRecordId__c = c.RecordId__c '
                + 'JOIN ssot__KnowledgeArticleVersion__dlm k '
                + '    ON c.SourceRecordId__c = k.ssot__Id__c '
                + whereClause + ' '
                + 'ORDER BY h.hybrid_score__c DESC '
                + 'LIMIT 5';

            ConnectApi.CdpQueryOutputV2 output = ConnectApi.CdpQuery.queryAnsiSqlV2(queryInput);
            if (output != null && output.data != null) {
                for (Object rowObj : output.data) {
                    List<Object> row = (List<Object>) JSON.deserializeUntyped(JSON.serialize(rowObj));
                    if (row != null && !row.isEmpty()) {
                        String chunkText = row[0] != null ? String.valueOf(row[0]).trim() : '';
                        String articleTitle = (row.size() > 1 && row[1] != null) ? String.valueOf(row[1]).trim() : 'Knowledge Article';
                        String articleCategory = (row.size() > 3 && row[3] != null) ? String.valueOf(row[3]).trim() : '';
                        String versionIdStr = (row.size() > 5 && row[5] != null) ? String.valueOf(row[5]).trim() : '';

                        Boolean isAuthorizedInCrm = String.isBlank(versionIdStr)
                            || allowedArticleVersionIds.contains((Id) versionIdStr);

                        // Skip metadata-only stub chunks and any chunk not backed by an Online, visible CRM Knowledge__kav record
                        if (isAuthorizedInCrm && String.isNotBlank(chunkText) && chunkText.length() > 80) {
                            String sourceLabel = articleTitle + (String.isNotBlank(articleCategory) ? ' (' + articleCategory + ')' : '');
                            passages.add('[SOURCE: ' + sourceLabel + '] ' + chunkText.replace('\n', ' '));
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.WARN, 'Data 360 hybrid_search warning: ' + e.getMessage());
        }

        r.hasSource = !passages.isEmpty();
        r.passages = String.join(passages, '\n');
        return r;
    }

    /**
     * Enforces CRM-level Knowledge__kav restriction in USER_MODE:
     * Only returns Knowledge__kav version IDs where PublishStatus = 'Online', IsLatestVersion = true,
     * and the article is marked visible in PKB / App (preventing Draft or Archived internal articles from being surfaced).
     */
    private static Set<Id> getPublishedVisibleArticleIds(String restaurantId, String category) {
        Set<Id> allowedIds = new Set<Id>();
        String cat = String.isNotBlank(category) ? category.trim() : '';
        List<Knowledge__kav> articles;
        if (String.isNotBlank(cat)) {
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
        for (Knowledge__kav kav : articles) {
            allowedIds.add(kav.Id);
        }
        return allowedIds;
    }

    public class Request {
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
        @InvocableVariable(label='Category' description='Optional topic filter: Menu, Parking_And_Access, or Policies' required=false)
        public String category;

        @InvocableVariable(label='Question' description='Diner question used for Data 360 vector + keyword hybrid search' required=true)
        public String question;
    }

    public class Result {
        @InvocableVariable(label='Has Source' description='True when at least one grounded Knowledge chunk was found')
        public Boolean hasSource;

        @InvocableVariable(label='Passages' description='Source-labeled Knowledge chunks ([SOURCE: <Article Title>] <Chunk Text>), one per line')
        public String passages;
    }
}
