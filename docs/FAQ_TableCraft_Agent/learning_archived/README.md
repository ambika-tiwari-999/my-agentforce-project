# Archived Learning Docs (Superseded Architectures)

These docs cover earlier iterations of the FAQ pipeline that are **no longer part of our active `TableCraft_Agent` architecture**:

1. **Iteration 1 (Prompt Builder + Unfiltered Default Retriever):** Used `Ambika_TableCraft_FAQ_Prompt` (Jinja template in Prompt Builder) which forced a secondary LLM call (`DefaultGPT5Mini`) and an unfiltered retriever call on every turn.
2. **Iteration 2 (Unstructured PDF File Upload DLO — `ADL_Diner_Restauran__dlm`):** Used uploaded PDFs in an Agentforce Data Library where file-level metadata columns (`METADATA__C`, `COL1__C`) were locked in the UI.

*(For our current architecture using **Salesforce Knowledge Articles (`Knowledge__kav`)** with `Restaurant_ID__c` pre-filtering and direct `subagent faq` reasoning, see [`../learning/README.md`](../learning/README.md).)*

| Archived Doc | Superseded Component |
| :--- | :--- |
| [ambika-einstein-retriever.md](./ambika-einstein-retriever.md) | Phase 1 Prompt Builder `templateDataProviders` + unfiltered `File_Diner_Restaurant_FAQ_and_Policies` retriever |
| [ambika-jinja-prompt.md](./ambika-jinja-prompt.md) | Phase 1 Jinja templating inside `Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml` |
| [ambika-faq-prompt-guardrails.md](./ambika-faq-prompt-guardrails.md) | Phase 1 Prompt Builder guardrails (now moved directly into `subagent faq` in `TableCraft_Agent.agent`) |
| [ambika-dlo-metadata-and-ingestion.md](./ambika-dlo-metadata-and-ingestion.md) | Phase 2 Unstructured PDF File DLO (`ADL_Diner_Restauran__dlm`) 18-column directory schema & S3 PDF ingestion |
| [advanced-rag-restaurant-id-plan.md](./advanced-rag-restaurant-id-plan.md) | Phase 2 Unstructured PDF `FILEPATH__C` / S3 sidecar metadata plan (superseded by `Knowledge__kav`) |
