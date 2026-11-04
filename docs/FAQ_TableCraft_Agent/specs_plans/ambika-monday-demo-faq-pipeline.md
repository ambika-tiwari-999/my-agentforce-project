# `TableCraft_Agent` — `subagent faq` Pipeline (Current Architecture)

This document is the end-to-end scaffolding of how **`subagent faq`** works inside **`TableCraft_Agent`** (`force-app/main/default/aiAuthoringBundles/TableCraft_Agent/TableCraft_Agent.agent`) using:
1. **Deterministic CRM Context (`Restaurant__c`)** in `before_reasoning` (0 LLM calls, 0 RAG calls) for hours and phone number.
2. **On-Demand Pre-Filtered Data 360 RAG (`Knowledge__kav` $\rightarrow$ `KA_TableCraft_FAQ_Knowledge`)** via `CLL_DiningKnowledgeRetriever.cls` (`restaurantId` + `category` + `question`) for menu, parking, dress code, and policy questions.
3. **Single-LLM Subagent Reasoning** (no Prompt Builder secondary LLM hop).

---

## 1. End-to-End Pipeline Flow (Input $\rightarrow$ Output)

```text
[Step 0] Orchestrator (start_agent orchestrator)
  │  - Calls find_restaurant (apex://CLL_FindRestaurant)
  │  - Sets @variables.restaurant_id (e.g. 'REST-ATX-02'), @variables.restaurant_name, @variables.restaurant_selected = True
  │  - Routes diner question via go_faq -> transitions to subagent faq
  ▼
[Step 1] subagent faq: before_reasoning (Deterministic Apex Gate — 0 LLM Calls)
  │  - If @variables.restaurant_id is empty -> transitions back to orchestrator
  │  - If @variables.restaurant_validated == False -> runs validate_restaurant_context (apex://CLL_DinerService)
  │  - Hydrates CRM @variables from Restaurant__c:
  │      • @variables.operating_hours
  │      • @variables.escalation_phone_number
  │      • @variables.current_date_time
  │      • @variables.restaurant_validated = True
  ▼
[Step 2] subagent faq: Reasoning & Action Selection (LLM Call #1 — Planner)
  │
  ├──► PATH A: Hours ("Are you open tonight?") or Phone Number Question
  │      • Answered directly from @variables.operating_hours / @variables.current_date_time / @variables.escalation_phone_number
  │      • 0 RAG calls, 0 Apex action calls during reasoning
  │
  └──► PATH B: Menu, Parking, Dress Code, Kids/Pets, Happy Hour, or Group Policy Question
         • Calls retrieve_dining_knowledge (apex://CLL_DiningKnowledgeRetriever)
         • Passes:
             - restaurantId = @variables.restaurant_id  (e.g. 'REST-ATX-02')
             - category     = 'Menu' | 'Parking_And_Access' | 'Policies' (optional topic filter)
             - question     = <diner's question>
         ▼
[Step 3] Data 360 Hybrid Search (CLL_DiningKnowledgeRetriever.cls — 0 LLM Calls)
  │  - Queries KA_TableCraft_FAQ_Knowledge_index__dlm joined to KA_TableCraft_FAQ_Knowledge_chunk__dlm
  │    and ssot__KnowledgeArticleVersion__dlm
  │  - Filters by k.Restaurant_ID_c__c = :restaurantId (and k.Category_c__c = :category when provided)
  │  - Computes Dense Vector (Multilingual E5 Large) + BM25 Keyword Hybrid Score
  │  - Returns top K chunks labeled with [SOURCE: <Article Title>] (from Identifying Fields: Title + Restaurant ID)
  ▼
[Step 4] subagent faq: Grounded Response & Citation (Resumed Planner)
     - Reads returned passages + guardrails in subagent faq.reasoning.instructions
     - Replies in <= 3 warm, concise sentences using only facts from context/passages
     - Cites the source title (e.g. "Post Oak Smokehouse — Menu & Craft Beer")
     - If answer is not in passages, offers @variables.escalation_phone_number or transitions via go_escalation
```

---

## 2. Step-by-Step Component & File Map

| Pipeline Step | Component | File / Org Object | What It Does |
| :--- | :--- | :--- | :--- |
| **Step 0: Handoff** | `start_agent orchestrator` | `TableCraft_Agent.agent` | Resolves restaurant name/city/cuisine to `@variables.restaurant_id` (`REST-ATX-02`) via `CLL_FindRestaurant.cls` and transitions to `@subagent.faq`. |
| **Step 1: CRM Gate** | `subagent faq` (`before_reasoning`) | `TableCraft_Agent.agent` + `CLL_DinerService.cls` | Confirms `Restaurant__c` exists for `restaurant_id` and loads `Operating_Hours__c`, `Phone_Number__c`, and `currentDateTime` into `@variables`. |
| **Step 2: Routing / Fast Path** | `subagent faq` (`reasoning.instructions`) | `TableCraft_Agent.agent` | Answers hours/phone questions immediately from `@variables` (Path A), or invokes `retrieve_dining_knowledge` with `restaurantId`, `category`, and `question` (Path B). |
| **Step 3: Scoped RAG** | `retrieve_dining_knowledge` | `CLL_DiningKnowledgeRetriever.cls` | Runs `ConnectApi.CdpQuery.queryAnsiSqlV2` `hybrid_search` against `KA_TableCraft_FAQ_Knowledge_index__dlm` filtered by `Restaurant_ID_c__c` and `Category_c__c`. |
| **Step 3 Data Store** | Salesforce Knowledge + Data 360 | `Knowledge__kav` $\rightarrow$ `Knowledge_kav_Home__dll` $\rightarrow$ `ssot__KnowledgeArticleVersion__dlm` | Stores published (`Online`) articles per restaurant + category (`Menu`, `Parking_And_Access`, `Policies`) with body in `Detail__c`, chunked into `KA_TableCraft_FAQ_Knowledge_chunk__dlm`. |
| **Step 4: Guardrails & Citation** | `subagent faq` (`reasoning.instructions`) | `TableCraft_Agent.agent` | Enforces strict passage-only grounding, source citation (`Title`), $\le 3$ sentence brevity, allergen safety handoff (`go_escalation`), and booking transitions (`go_booking`). |

---

## 3. Related Specs & Learning Docs

- **Setup & Implementation Steps:** [`rag_knowledge_article_setup.md`](./rag_knowledge_article_setup.md)
- **Strangler Fig Migration Plan:** [`faq-strangler-fig-plan.md`](./faq-strangler-fig-plan.md)
- **Knowledge Articles RAG Architecture:** [`../learning/ambika-knowledge-articles-rag-architecture.md`](../learning/ambika-knowledge-articles-rag-architecture.md)
- **Why We Removed Prompt Builder (Context Windows vs. 2nd LLM Hop):** [`../learning/ambika-subagent-context-vs-prompt-builder.md`](../learning/ambika-subagent-context-vs-prompt-builder.md)
