# Ambika FAQ — Data 360 and RAG (simple)

How **Answer TableCraft FAQ** gets grounded text. CRM (`Restaurant__c`) is a **different** path (step 1 validate + phone). This doc is **only** the FAQ file search.

---

## Connection chain (Preview)

```text
User question
  → FAQ Subagent → Answer_TableCraft_FAQ (agent action)
  → Ambika_TableCraft_FAQ_Prompt (Prompt Builder)
  → Einstein retriever: File_Diner_Restaurant_FAQ_and_Policies
  → Data 360 file library: ADL_Diner_Restauran (indexed FAQ PDF in the org)
  → Passages injected into the prompt → LLM → reply (or “not in our FAQ” + CRM phone)
```

Nothing in git **deploys** the FAQ corpus. Git has the **wiring** (prompt + retriever name). The **content** lives in the org’s Data 360 / Agentforce Data Library.

---

## What plugs into what

| Piece | Role | Where it lives |
|--------|------|----------------|
| **Agent action** | Calls the prompt with `question`, `restaurant_id`, `escalation_phone_number` | [Ambika_Monday_Demo_Agent.agent](../force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.agent) → `Answer_TableCraft_FAQ` |
| **Prompt template** | Runs retriever + guardrails + LLM | [Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml](../force-app/main/default/genAiPromptTemplates/Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml) |
| **Einstein retriever** | Search index over the FAQ library; query = **`Input.question` only** | Org: **File_Diner_Restaurant_FAQ_and_Policies** (`…_1Cx_8Ec8b60f20d` in metadata) |
| **Data 360 library** | Ingested FAQ files + search index | Org: **`ADL_Diner_Restauran`** |
| **Source file (tests)** | Text the retriever can actually find | Org PDF: **`Diner & Restaurant FAQ and Policies.pdf`** (see [data360_assets.json](../data/data360_assets.json)) |

**Not used for this FAQ action:** `knowledge.rag_feature_config_id` on the agent bundle (that ID is documented in `data360_assets.json` for Joe’s agent; Ambika’s path is **prompt → retriever**, not that field).

**Not passed to search today:** `restaurant_id` is for prompt framing and handoff copy only—it does **not** filter the retriever yet.

---

## What file you need for tests

For Preview to **answer** (not just hand off to the phone):

1. The question’s answer must appear in the **org** FAQ corpus—the PDF **`Diner & Restaurant FAQ and Policies.pdf`** in library **`ADL_Diner_Restauran`**, not in `Restaurant__c` and not in git by default.

2. **`data/restaurant__c_records.csv` / `Restaurant__c`** — used for **REST-ATX-01** validate and **`(512) 555-0199`**; **hours on CRM are not searched** unless the same facts are in the FAQ PDF.

3. **`data/ambika_restaurant_faq.csv`** — optional local/export artifact; **not** what `Ambika_TableCraft_FAQ_Prompt` searches unless you ingest it into the same Data 360 library in the org.

**Practical test:** Ask something you know is **written in that PDF** (or add Monday hours for REST-ATX-01 to the PDF in Data 360 and re-index). If the PDF has no match, you get: *“I don’t have that in our FAQ…”* with the CRM phone—that still means RAG **ran**, with **zero useful hits**.

---

## Org checks (when answers are always “not in FAQ”)

1. **Setup → Prompt Builder → Ambika TableCraft FAQ Prompt** — Einstein Search provider = **File_Diner_Restaurant_FAQ_and_Policies**, `searchText` = question.

2. **Setup → Einstein Search / retrievers** — same retriever → source = **`ADL_Diner_Restauran`**.

3. **Data 360** — library **`ADL_Diner_Restauran`** contains **`Diner & Restaurant FAQ and Policies.pdf`** (path/id in [data360_assets.json](../data/data360_assets.json)).

Inventory sync notes: [setup/pull-from-org.md](./setup/pull-from-org.md) (Data 360 section).

---

## Related

- [ambika-monday-demo-faq-pipeline.md](./ambika-monday-demo-faq-pipeline.md) — steps 4–8 (prompt + retriever in the full pipeline)
- [learning/ambika-einstein-retriever.md](./learning/ambika-einstein-retriever.md) — slightly more detail on retrievers (optional)
