# RAG Knowledge Article (`Knowledge__kav`) Setup & Implementation Plan

This step-by-step build sequence sets up the **Salesforce Knowledge (`Knowledge__kav`)** RAG pipeline (`Restaurant_ID__c` + `Category__c`) and wires it into `TableCraft_Agent` (`subagent faq`) via `CLL_DiningKnowledgeRetriever.cls`.

---

## Step 1: Enable "Knowledge User" & Lightning Knowledge in Salesforce Setup (UI — 2 mins)

Before Salesforce lets you see `Knowledge__kav` or create articles, enable Knowledge on your user record:
1. Go to **Setup → Users → Users**, click **Edit** next to your user record, check the **`Knowledge User`** checkbox, and click **Save**.
2. In Quick Find, search **Knowledge Settings** → if **Lightning Knowledge** isn't enabled yet, check **Enable Lightning Knowledge** and click **Save**.

---

## Step 2: Create the 2 Custom Metadata Fields on `Knowledge__kav` (Metadata Deploy or Object Manager)

Because `Knowledge__kav` already comes with `Summary` (`TextArea`) and **`Detail__c`** (`Rich Text Area`, `131072` length, already on the page layout) for the article body that Data 360 chunks and embeds, we only need to add the 2 structured metadata fields in **Setup → Object Manager → Knowledge (`Knowledge__kav`) → Fields & Relationships**:
1. **`Restaurant_ID__c`** (`Text(50)`) — holds `REST-ATX-01`, `REST-NYC-01`, etc.
2. **`Category__c`** (`Picklist`: `Menu`, `Parking_And_Access`, `Policies`) — separates topics per restaurant so updating a restaurant's menu only re-indexes the `Menu` article row.
3. **Field-Level Security (FLS):** Grant **Read** access on `Restaurant_ID__c`, `Category__c`, and `Detail__c` to:
   - **Data Cloud Salesforce Connector** permission set (so Data 360 ingests `Restaurant_ID__c`, `Category__c`, and `Detail__c`).
   - **System Administrator** and **Agentforce Service Agent** user profile/permission set.

---

## Step 3: Seed & Publish the `Knowledge__kav` Articles for Our Restaurants (Automated via Apex Script)

- **Saved Script (Executed Nov 3, 2026 at 9:09 AM PST):** [`../scripts/seed_post_oak_menu_knowledge.apex`](../scripts/seed_post_oak_menu_knowledge.apex)
- **Live Record Created in `agentforce-org`:** `Knowledge__kav` ID `ka0g7000001cvSvAAI` (`ArticleNumber = 000001042`, `Restaurant_ID__c = 'REST-ATX-02'`, `Category__c = 'Menu'`, `PublishStatus = 'Online'`)

Instead of manually typing articles in the Salesforce UI, run an **Anonymous Apex script** (`sf apex run --file docs/FAQ_TableCraft_Agent/scripts/seed_post_oak_menu_knowledge.apex --target-org agentforce-org`) that creates and publishes the `Knowledge__kav` articles (`Menu`, `Parking_And_Access`, `Policies`):

```apex
// Example of seeding AND publishing a Knowledge__kav article via Anonymous Apex:
Knowledge__kav menuArticle = new Knowledge__kav(
    Title = 'Post Oak Smokehouse — Menu & Happy Hour',
    UrlName = 'post-oak-smokehouse-menu',
    Restaurant_ID__c = 'REST-ATX-01',
    Category__c = 'Menu',
    Summary = 'Menu highlights, BBQ specialties, craft beer, and dietary options for Post Oak Smokehouse.',
    Detail__c = '<h2>Post Oak Smokehouse Menu (REST-ATX-01)</h2>'
        + '<ul><li><b>14-Hour Oak-Smoked Brisket</b>: Prime Texas brisket smoked over post oak.</li>'
        + '<li><b>Craft Beer & Sides</b>: Southern sides, mac and cheese, jalapeño cheddar sausage.</li></ul>'
);
insert menuArticle;

// Query back the parent KnowledgeArticleId and publish it to 'Online' status
// (Data 360 only indexes Published / 'Online' articles!)
Id kaId = [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE Id = :menuArticle.Id].KnowledgeArticleId;
KbManagement.PublishingService.publishArticle(kaId, true);
```

---

## Step 4: Connect Knowledge to Agentforce Data Library & Set `Restaurant_ID__c` + `Category__c` Pre-Filters (UI — 3 mins)

1. Go to **Setup → Agentforce Data Library** → click **New Library** (or edit the library) and choose **Salesforce Knowledge** as the Data Source:
   - **Identifying Fields:** `Title`, `Summary`, `Restaurant_ID__c`, `Category__c`
   - **Content Fields (to chunk & index):** `Detail__c`, `Summary`
   - Click **Save**.
2. Behind the scenes, Salesforce automatically provisions the Data 360 DMO (`Knowledge_kav_Home__dlm`), Chunk table (`_chunk__dlm`), and Vector Search Index (`_index__dlm`).
3. Go to **App Launcher → Data Cloud → Search Indexes** (or **Einstein Studio → Retrievers**), open the Knowledge Search Index, and mark **both `Restaurant_ID__c` and `Category__c` as Pre-Filter Fields**.

---

## Step 5: Update `CLL_DiningKnowledgeRetriever.cls` and `TableCraft_Agent.agent` (In Code)

1. **In `force-app/main/default/classes/CLL_DiningKnowledgeRetriever.cls`:**
   - Add an optional `@InvocableVariable public String category;` (`Menu`, `Parking_And_Access`, or `Policies`) to `CLL_DiningKnowledgeRetriever.Request` alongside `restaurantId` and `question`.
   - Build the dynamic pre-filter string so it always filters by `Restaurant_ID__c`, and narrows even further by `Category__c` whenever `subagent faq` passes a category:
   ```apex
   String preFilter = 'Restaurant_ID__c = \'' + String.escapeSingleQuotes(req.restaurantId) + '\'';
   if (String.isNotBlank(req.category)) {
       preFilter += ' AND Category__c = \'' + String.escapeSingleQuotes(req.category) + '\'';
   }
   ```
   - Pass `preFilter` into the Data 360 `hybrid_search` query (using a lean `topK = 3` when `category` is specified):
   ```sql
   SELECT
       Chunk__c,
       hybrid_score__c
   FROM hybrid_search(
       TABLE(Knowledge_kav_index__dlm),
       :question,
       :preFilter,
       3
   )
   ORDER BY hybrid_score__c DESC
   ```
2. **In `force-app/main/default/aiAuthoringBundles/TableCraft_Agent/TableCraft_Agent.agent`:**
   - In `subagent faq`, add `category` as an optional input on `retrieve_dining_knowledge` with description:
     - `"Optional topic filter: 'Menu' (dishes, prices, happy hour, dietary), 'Parking_And_Access' (valet, lot, patio, entrance), or 'Policies' (dress code, kids, pets, private dining, large groups). Leave empty if the question spans multiple categories."`
   - Set `filter_from_agent: False` on `retrieve_dining_knowledge.outputs.passages`, expose `retrieve_dining_knowledge` in `reasoning.actions` (passing `restaurantId = @variables.restaurant_id`, `category = ...`, and `question = ...`), and remove `Answer_TableCraft_FAQ` (`Ambika_TableCraft_FAQ_Prompt`).
   - Keep `operating_hours` and `escalation_phone_number` answered directly from `@variables` (loaded deterministically in `before_reasoning` with 0 RAG calls), calling `retrieve_dining_knowledge` only for menu, parking, dress code, policies, and group/event questions.
