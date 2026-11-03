# FAQ RAG Architecture: Core Q&A (Prompt Builder Removal, Code Layers & Hybrid Search)

This document captures the foundational architectural insights for `TableCraft_Agent` (`subagent faq`): why we removed Prompt Builder in favor of on-demand RAG, the 3 code implementation layers for calling Data 360, how Hybrid Search (Dense Vector + BM25 + RRF) works, and Default vs. Custom Retrievers.

*(For the specific data model and `Restaurant_ID__c` pre-filtering on Salesforce Knowledge Articles (`Knowledge__kav`), see [`ambika-knowledge-articles-rag-architecture.md`](./ambika-knowledge-articles-rag-architecture.md).)*

---

## 1. Why Did Prompt Builder Force RAG (and a 2nd LLM Call) on Every Question?

### Question
In `Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml`, what is `<templateDataProviders>` doing, what parts of the chat does it send to RAG, and why does it run RAG even on a simple hours or phone number question?

### Insight
- **What `<templateDataProviders>` does:** It runs the Einstein Search Retriever (`invocable://getEinsteinRetrieverResults/File_Diner_Restaurant_FAQ_and_Policies_1Cx_8Ec8b60f20d`) **automatically before the Prompt Builder LLM (`DefaultGPT5Mini`) runs** so it can inject `{{EinsteinSearch...results}}` into the prompt body.
- **What it passes to RAG:** Only `searchText = {{Input.question}}` (not the full chat transcript, and not `restaurant_id`).
- **Why we don't need Prompt Builder at all for `subagent faq`:**
  1. `before_reasoning` (`validate_restaurant_context` → `CLL_DinerService.validateRestaurantByCode`) is pure deterministic Apex code (0 LLM calls). It already loads `operating_hours`, `escalation_phone_number`, and `current_date_time` from CRM (`Restaurant__c`) into `@variables` on `subagent faq`.
  2. When we move the 8 FAQ guardrails out of `Ambika_TableCraft_FAQ_Prompt` and into `subagent faq` (`reasoning.instructions`), the subagent's own LLM already has the guardrails and the CRM variables.
  3. If a diner asks *"What are your hours?"*, *"Are you open right now?"*, or *"What is your phone number?"*, `subagent faq` answers directly from `@variables` with **0 RAG calls and 0 Prompt Builder LLM calls** (verified in Agent Builder Preview trace: `Input → Transition to faq → Reasoning → Output Evaluation: GROUNDED`).
  4. Only when `subagent faq` decides it needs more information (menu, parking, dress code, policies, dietary options) does it need to call the RAG action.

---

## 2. The 3 Code Implementation Layers for Calling Data 360 RAG

### Question
Without looking at the UI, what are the exact code-level ways to invoke Data 360 RAG, and why choose Custom Apex over `getEinsteinRetrieverResults` for our specific use case?

### Insight
In Salesforce, the three layers stack on top of each other:

```text
[ Layer 1: Prompt Builder XML ]   generatePromptResponse://Ambika_TableCraft_FAQ_Prompt
        │  Calls invocable://getEinsteinRetrieverResults/... + forces a 2nd LLM call (DefaultGPT5Mini)
        ▼
[ Layer 2: Retriever Invocable ]  invocable://getEinsteinRetrieverResults/File_Diner_Restaurant...
        │  Runs the saved AI Models Retriever wrapper against the Search Index (no 2nd LLM)
        ▼
[ Layer 3: Custom Apex Query ]    ConnectApi.CdpQuery.queryAnsiSqlV2("SELECT ... FROM hybrid_search(...)")
           Directly queries ADL_Diner_Restauran_index__dlm & ADL_Diner_Restauran_chunk__dlm in Apex
```

| Dimension | Layer 1: Prompt Builder (`Ambika_TableCraft_FAQ_Prompt`) | Layer 2: Retriever Invocable (`getEinsteinRetrieverResults`) | Layer 3: Custom Apex (`CLL_DiningKnowledgeRetriever.cls`) |
| :--- | :--- | :--- | :--- |
| **Extra LLM Call?** | **Yes** (2nd LLM hop adds latency & cost) | **No** (`subagent faq` LLM only) | **No** (`subagent faq` LLM only) |
| **When to use it** | Standalone prompt templates reused in Flows/Emails outside an agent. | **Multiple agents or subagents** share the same retriever config and admins tune filters in the UI. | **A single subagent (`faq`)** is the sole consumer of the DMO, and engineers want `restaurant_id` filtering, joins, and `topK` controlled in git. |
| **Can filter by `restaurant_id` in code?** | No (Default Retriever only accepts `searchText`). | No (Default Retriever is non-customizable; requires creating a new Custom Retriever in UI). | **Yes** — takes `restaurantId` + `question` in Apex and filters/joins directly in SQL. |
| **Tracked in Git?** | Only the pointer name is in XML. | No (Retriever settings live in Org UI). | **100% in `CLL_DiningKnowledgeRetriever.cls`.** |

**Why Layer 3 fits `TableCraft_Agent`:**
- `subagent faq` is the **only** subagent in `TableCraft_Agent` that queries restaurant FAQ knowledge.
- Christian Lozano created `CLL_DiningKnowledgeRetriever.cls` (on Oct 26, 2026 for `Intelligent_Dinner_CLL_Agent` v1–v3) as a fake placeholder retriever querying CRM `Restaurant__c` fields, with the input/output contract (`restaurantId` + `question` in, `hasSource` + `passages` out) ready to be replaced by real Data 360 retrieval in Apex.

---

## 3. Dense Vector Search vs. BM25 vs. Hybrid Search

### Question
What do Dense Vector Similarity, BM25, and Reciprocal Rank Fusion (RRF) actually do inside a Search Index?

### Insight
- **Dense Vector Similarity (Semantic Search):** Embeds the user's question into a float vector and computes cosine similarity against `VectorEmbedding__c`. Matches meaning even when exact words differ (e.g., *"Can I bring my dog?"* matches *"Pets are welcome on the patio"*).
- **BM25 (Keyword / Lexical Search — not an embedding model):** Classic search-engine exact word matching over `Chunk__c`, weighted by term frequency and inverse document frequency. Excels at exact codes (`REST-ATX-01`) and dish names (`Kuro Omakase`).
- **Fusion Ranker (Reciprocal Rank Fusion / Linear Fusion Ranker):** Data 360's `hybrid_search()` runs both the vector search (`vector_score__c`) and keyword search (`keyword_score__c`) and merges them into a single ranked list (`hybrid_score__c`).

---

## 4. Why Docs Say "Default Retrievers Are No Longer Auto-Created" vs. What Happened in Our Org

### Question
Salesforce Help ([Manage Retrievers](https://help.salesforce.com/s/articleView?id=data.c360_a_ai_retriever.htm&type=5) / [About Retrievers](https://help.salesforce.com/s/articleView?id=sf.c360_a_ai_retriever_about.htm&type=5)) says *"Data 360 no longer creates default Retrievers automatically when you create a search index"* and *"You can't customize a default retriever."* Why did our org auto-create `File_Diner_Restaurant_FAQ_and_Policies_1Cx_8Ec8b60f20d`?

### Insight
As documented in [Example: Agentic RAG with Advanced Data 360 Setup](https://help.salesforce.com/s/articleView?id=ai.generative_ai_rag_example.htm&type=5), there are **two different setup paths**:
1. **"Quick Start" (`Setup → Agentforce Data Library`):**
   - An **all-in-one installer** that automatically creates the DLO (`__dll`), DMO (`__dlm`), Search Index (`_chunk__dlm` + `_index__dlm`), **AND** a Default Retriever.
   - Because Default Retrievers cannot be customized (no pre-filters), using a raw Default Retriever directly cannot filter by `restaurant_id`.
2. **"Advanced" / Pre-Filtered Search Index (`Data Cloud → Search Index / Custom Retriever`):**
   - When you configure a Search Index or Custom Retriever in Data 360 (such as on `Knowledge__kav` with `Restaurant_ID__c` checked as a **Pre-Filter field**), you either query `hybrid_search(...)` with the pre-filter expression directly from Apex (`CLL_DiningKnowledgeRetriever.cls`) or invoke a Custom Retriever with the `Restaurant_ID__c` filter applied.
