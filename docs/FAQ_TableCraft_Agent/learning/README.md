# Learning — Current `TableCraft_Agent` FAQ & RAG Architecture

Active architecture concept docs for **`TableCraft_Agent` (`subagent faq`)** using **Salesforce Knowledge Articles (`Knowledge__kav`)** with `Restaurant_ID__c` + `Category__c` pre-filtered RAG and direct subagent reasoning (0 Prompt Builder LLM hops).

| Doc | Topic |
|-----|--------|
| [ambika-knowledge-articles-rag-architecture.md](./ambika-knowledge-articles-rag-architecture.md) | **Primary Architecture:** Salesforce Knowledge Articles (`Knowledge__kav`), hybrid DB schema, `Restaurant_ID__c` pre-filtered RAG queries, scaling (`Restaurant_ID__c` + `Category__c`), and setup/pre-processing considerations |
| [ambika-subagent-context-vs-prompt-builder.md](./ambika-subagent-context-vs-prompt-builder.md) | Why `subagent faq` runs without Prompt Builder: subagent context windows vs. secondary LLM calls & RAG observability metrics |
| [ambika-rag-architecture-qa.md](./ambika-rag-architecture-qa.md) | Core Q&A: Why Prompt Builder forced RAG on every turn, the 3 code layers for calling Data 360 (`CLL_DiningKnowledgeRetriever.cls`), and Dense Vector vs. BM25 vs. Hybrid Search |

Archived docs from earlier iterations (Prompt Builder `Ambika_TableCraft_FAQ_Prompt` + Unstructured PDF `ADL_Diner_Restauran`): [../learning_archived/README.md](../learning_archived/README.md).
