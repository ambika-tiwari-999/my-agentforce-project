# Data 360 Unstructured PDF RAG Setup Plan: Presentation Story vs. Demo Implementation

## Crucial Context: Presentation Roleplay vs. Actual Demo Code
Because this is a **roleplay presentation** of how TableCraft would operate as a fully deployed production system (while our actual deliverable is **demo-level code** inside a sandbox without an external AWS S3 pipeline):

1. **What we WILL SAY we did (Production Architecture Story — Section A below):**
   - We ingest restaurant PDFs (menus, FAQs, policies) via an unstructured cloud storage pipeline with sidecar metadata (`restaurant_id`), mapping `restaurant_id` onto the UDLO/UDMO (`METADATA__C` / `COL1__C`) and configuring `restaurant_id` as a first-class **Pre-Filter field** on the Data 360 Hybrid Search Index.
2. **What we are ACTUALLY doing in the demo code (Pragmatic Sandbox Implementation — Section B below):**
   - Because Agentforce Data Library (`ADL_Diner_Restauran`) locks `METADATA__C` and `COL1__C` (`updateable: false`) unless connected to external S3 storage, we keep our existing `ADL_Diner_Restauran` library, **prefix the uploaded PDF filename with `restaurant_id` (e.g., `REST-ATX-01_Menu.pdf`) so it lands in `FILEPATH__C`**, and filter on `FILEPATH__C LIKE '%' || :restaurantId || '%'` (joined to `ADL_Diner_Restauran_chunk__dlm` via `SourceRecordId__c = Id`) inside `CLL_DiningKnowledgeRetriever.cls`.

---

## Section A: What We Will Say in the Presentation (Full Production Architecture)

*(Note: Unlike the Salesforce Help `Case` walkthrough [`ai.generative_ai_rag_example.htm`](https://help.salesforce.com/s/articleView?id=ai.generative_ai_rag_example.htm&type=5), which indexes a structured CRM table, our production story indexes **unstructured restaurant PDFs** scoped by `restaurant_id`.)*

### Step 1: Prepare the PDF + Sidecar Metadata (`restaurant_id`)
- When a restaurant uploads a menu or FAQ PDF (e.g. `post_oak_menu.pdf`), the backend pairs it with a JSON metadata payload specifying its `restaurant_id` (`{"restaurant_id": "REST-ATX-01", "category": "menu"}`).

### Step 2: Ingest the Unstructured PDFs + Metadata into Data 360 (UDLO / UDMO)
- Data 360's unstructured storage connector ingests both the PDF file bytes and the sidecar metadata into the Directory Data Lake Object / Data Model Object (`METADATA__C` / `COL1__C = 'REST-ATX-01'`).

### Step 3: Build the Hybrid Search Index on the PDF Chunks with `restaurant_id` as a Pre-Filter
- Data 360 chunks and vectorizes the PDF content into `_chunk__dlm` and `_index__dlm`, with the parent file's `restaurant_id` attribute configured as a **Pre-Filter field** on the Hybrid Search Index.

### Step 4: Query the Search Index from Apex (`CLL_DiningKnowledgeRetriever.cls`)
- `subagent faq` invokes `CLL_DiningKnowledgeRetriever.cls` on demand (only when a question cannot be answered by the CRM `operating_hours` and `escalation_phone_number` loaded in `before_reasoning`), passing `restaurantId` and `question` to `hybrid_search(...)`.

---

## Section B: What We Actually Do in the Demo Code (`FILEPATH__C` Workaround on Existing ADL)

### Step 1 (Demo): Name the PDF with `restaurant_id` and Upload to `ADL_Diner_Restauran`
- Name the PDF file `<restaurant_id>_<name>.pdf` (e.g., `REST-ATX-01_Menu.pdf` — and optionally include `REST-ATX-01` in the PDF header text).
- Upload it in **Setup → Agentforce Data Library → `Diner & Restaurant FAQ and Policies` (`ADL_Diner_Restauran`)**.
- This populates `ADL_Diner_Restauran__dlm.FILEPATH__C` with `1JDg7000005k8HRGAY/REST-ATX-01_Menu.pdf` and chunks the PDF into `ADL_Diner_Restauran_chunk__dlm`.

### Step 2 (Demo): Filter on `FILEPATH__C` in `CLL_DiningKnowledgeRetriever.cls`
- Update `CLL_DiningKnowledgeRetriever.cls` to query `ADL_Diner_Restauran_index__dlm` / `ADL_Diner_Restauran_chunk__dlm` joined to `ADL_Diner_Restauran__dlm` (`ON c.SourceRecordId__c = f.Id`), filtering where `f.FILEPATH__C` contains `req.restaurantId` (or matching `req.restaurantId` in the chunk/search query).

### Step 3 (Demo): Wire `retrieve_dining_knowledge` into `subagent faq` and Remove `Answer_TableCraft_FAQ`
- In `TableCraft_Agent.agent`, expose `retrieve_dining_knowledge` (`apex://CLL_DiningKnowledgeRetriever`) as the on-demand RAG action in `subagent faq` and remove `Answer_TableCraft_FAQ` (`Ambika_TableCraft_FAQ_Prompt`).
