# What is an Einstein retriever? (Ambika FAQ context)

An **Einstein retriever** is a **named search configuration** in Salesforce. In Prompt Builder it appears as an **Einstein Search** data provider on a prompt template. It runs **before** the LLM generates text: it takes a query string, searches an indexed knowledge corpus, and returns **text chunks** that the prompt injects as grounded context.

This doc explains the concept for the **Ambika Monday Demo** FAQ path. Step-by-step placement in the agent flow is in [ambika-monday-demo-faq-pipeline.md](./ambika-monday-demo-faq-pipeline.md) (Step 7 — RAG retrieval).

---

## What it does in one FAQ turn

1. **Input:** `searchText` — for Ambika, **`Input.question`** (the diner’s question).
2. **Search:** Semantic / vector search (plus any org-configured filters) against the retriever’s **indexed source**.
3. **Output:** Top matching **passages** (chunks from ingested files, etc.).
4. **Prompt merge:** Passages appear in the template as `{{EinsteinSearch.<retriever>.results}}`.
5. **LLM:** The prompt model reads those passages and answers under the template guardrails ([ambika-faq-prompt-guardrails.md](./ambika-faq-prompt-guardrails.md)).

The retriever answers: *Which pieces of our FAQ library might answer this question?*  
The LLM answers: *Given only those pieces, what do I say?*

---

## What it is not

| Concept | Role |
|--------|------|
| **Data 360 (Agentforce Data Library)** | Where files are ingested, chunked, and indexed (e.g. **`ADL_Diner_Restauran`**). The bookshelf. |
| **Einstein retriever** | The **search engine** configured to query that index (or a defined subset). |
| **Prompt template** | Wires retriever + guardrails + LLM (`Ambika_TableCraft_FAQ_Prompt`). |
| **Agent `knowledge.rag_feature_config_id`** | A **separate** Agentforce RAG path on the agent bundle. **`Answer_TableCraft_FAQ` does not use it**; FAQ retrieval is on the prompt’s `templateDataProviders`. |
| **CRM SOQL** | Not the same thing — retrievers here target **file-library / unstructured** search unless the org retriever type is configured differently. |

---

## Ambika’s retriever in git vs org

**In metadata (pointer only):** the prompt binds the retriever via `templateDataProviders`:

- **Developer name:** `File_Diner_Restaurant_FAQ_and_Policies_1Cx_8Ec8b60f20d`
- **Invocable:** `invocable://getEinsteinRetrieverResults/File_Diner_Restaurant_FAQ_and_Policies_1Cx_8Ec8b60f20d`
- **File:** [Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml](../force-app/main/default/genAiPromptTemplates/Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml)

The XML does **not** list `ADL_Diner_Restauran` by name. That link is defined in the **org** when the retriever is created (Einstein Search / retriever setup → data library / source).

**Org inventory (reference):** [data360_assets.json](../data/data360_assets.json) — library **`ADL_Diner_Restauran`**, FAQ PDF path, chunk/index lake object `ADL_Diner_Restauran__dlm`, and the same retriever reference name Joe’s template uses.

**Important for Phase 1:** `searchText` is the **question only**. `restaurant_id` is passed into the prompt for framing and escalation copy, **not** into the retriever until a filter or scoped corpus is added.

---

## Why Salesforce uses retrievers

- **Reuse:** One retriever can back multiple prompts (Joe’s and Ambika’s share this FAQ retriever; Ambika differs in **guardrails**, not necessarily in index).
- **Operate:** Tune library, chunking, or result count in Setup without rewriting every prompt body.
- **Separate concerns:** Retrieval (search) vs generation (LLM) vs policy (prompt rules).

---

## Where to verify in the org

1. **Prompt Builder** → **Ambika TableCraft FAQ Prompt** → Einstein Search data provider → confirm retriever name and `searchText` = question.
2. **Einstein Search / retrievers** (Setup) → open **`File_Diner_Restaurant_FAQ_and_Policies`** → confirm source library (expect **`ADL_Diner_Restauran`** / FAQ PDF ingest).
3. **Data 360** → query or browse **`ADL_Diner_Restauran__dlm`** if you need to confirm chunks exist for Preview tests.

---

## Related

- [ambika-monday-demo-faq-pipeline.md](./ambika-monday-demo-faq-pipeline.md) — full FAQ pipeline
- [ambika-faq-prompt-guardrails.md](./ambika-faq-prompt-guardrails.md) — prompt-layer rules after retrieval
- [ambika-faq-subagent-flow.md](./ambika-faq-subagent-flow.md) — router → subagent → action
