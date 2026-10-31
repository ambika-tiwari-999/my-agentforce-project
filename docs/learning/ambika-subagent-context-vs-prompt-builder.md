# Subagent Context Windows vs. Prompt Builder Secondary LLM Calls

This document explains how LLM calls and context windows work inside an Agent Script subagent (`subagent faq`), why a Prompt Builder template (`GenAiPromptTemplate`) is usually redundant for short RAG turns, and what observability metrics would justify re-introducing a Prompt Builder template in the future.

---

## 1. Does a Subagent Get Its Own LLM Call and Context Window?

**Yes.** Whenever `orchestrator` transitions to `subagent faq` (visible in the trace as `Transition to Subagent (faq)` → `Reasoning (llmStep FAQ)`), `subagent faq` executes its **own LLM call** with a **scoped context window**:

### What IS inside `subagent faq`'s context window:
1. **Top-level `system.instructions`:** The global persona and safety rules at the top of `TableCraft_Agent.agent`.
2. **`subagent faq`'s own `reasoning.instructions`:** Including all `@variables` interpolated into the instructions (`{!@variables.operating_hours}`, `{!@variables.escalation_phone_number}`, `{!@variables.current_date_time}`).
3. **`subagent faq`'s own `actions:` list:** Only the actions declared inside `subagent faq` (it does **not** see `booking` or `orchestrator` actions).
4. **The shared conversation transcript:** All user/assistant messages in the session so far, plus any action outputs returned to the planner during the session (unless hidden with `filter_from_agent: True`).

### What is NOT inside `subagent faq`'s context window:
- It does **not** load `booking.reasoning.instructions`, `orchestrator.reasoning.instructions`, or their local action schemas.

---

## 2. Why Calling a Prompt Builder Template Inside a Subagent Adds a Secondary LLM Call

When `subagent faq` calls an action with `target: "generatePromptResponse://Ambika_TableCraft_FAQ_Prompt"`, two separate LLMs run back-to-back on the same turn:

```text
[LLM Call #1: subagent faq planner]
  Reads transcript + instructions -> decides to call Answer_TableCraft_FAQ
        │
        ▼
[Data 360 Retriever] -> fetches top K chunks
        │
        ▼
[LLM Call #2: Prompt Builder (DefaultGPT5Mini)]  <-- Separate, ephemeral context window!
  Reads chunks + prompt template guardrails -> generates 2-sentence promptResponse
        │
        ▼
[LLM Call #1 (resumed): subagent faq planner]
  Reads promptResponse -> relays final message to diner
```

Notice the key architectural difference:
- **Without Prompt Builder (Apex returns chunks directly to `subagent faq`):** Only `subagent faq`'s LLM runs. The retrieved chunks are returned as tool output directly into `subagent faq`'s context window.
- **With Prompt Builder:** The Prompt Template spins up a **separate, isolated context window** that reads the raw chunks, compresses them into a short answer (`promptResponse`), and **discards the raw chunks** so they never enter the main agent conversation transcript.

---

## 3. When Is Prompt Builder's Secondary LLM Call Genuinely Useful?

### A. Outside of Conversational Agents (90% of Prompt Builder use cases)
- Record-page summary fields, Flow-triggered outbound emails, or one-shot UI buttons where no conversational agent exists.

### B. Inside an Agent (3 specific engineering cases)
1. **Context Window Compression ("Map-Reduce" over large RAG payloads):**
   - If a retriever returns 15–20 large chunks (e.g., 5,000–10,000 tokens of menu/policy text) and those raw chunks are returned directly to `subagent faq`, they stay in the agent's conversation history for every subsequent turn (`booking`, `escalation`, etc.).
   - A Prompt Builder template acts as a **context firewall**: its isolated context window absorbs the 10,000 tokens of raw chunks and returns only a 50-token answer to the main agent transcript.
2. **Model Routing:**
   - Using a smaller, cheaper, or specialized `<primaryModel>` (e.g., `DefaultGPT5Mini`) strictly for reading chunks, while the main subagent planner uses a different model.
3. **Generating Artifacts for a Different Audience (e.g., Internal Case Summary):**
   - Writing a structured internal `Case.Description` for a Service Cloud human rep during `escalation` while the subagent's own LLM writes the diner-facing message.

---

## 4. Why We Removed Prompt Builder in `subagent faq` Now — and What Observability Metrics Would Bring It Back

### Why `subagent faq` does NOT need Prompt Builder today:
1. **Hours & Phone Questions (`0` RAG chunks):** Handled directly from `@variables.operating_hours`, `@variables.escalation_phone_number`, and `@variables.current_date_time` loaded deterministically in `before_reasoning`.
2. **Small RAG Payload (`topK = 3–5` chunks):** For restaurant FAQ/menu/parking questions, retrieving 3–5 chunks (~300–600 tokens) directly into `subagent faq` via Apex (`CLL_DiningKnowledgeRetriever.cls`) adds minimal context growth while saving an entire LLM hop (~1.5–2s latency) and Digital Wallet Flex Credits.

### Future Observability Metrics That Would Justify Re-Introducing Prompt Builder as a "Context Firewall":
In UAT / production observability (Splunk traces, Event Monitoring, and Data 360 query logs), we would track four metrics to decide whether `subagent faq` genuinely needs a secondary LLM call with its own isolated context window for the RAG step:

| Observability Metric | Healthy Threshold (Keep Direct Apex RAG in `subagent faq`) | Trigger to Re-Introduce Prompt Builder (Isolated RAG Context Window) |
| :--- | :--- | :--- |
| **1. Retrieved Chunk Token Volume per Turn** (`sum(length(Chunk__c))` per RAG call) | **< 800 tokens** per RAG call (`topK = 3–5` concise chunks) | **> 2,500 tokens** per RAG call (e.g., full multi-page tasting menus or wine lists where high `topK` is required for recall) |
| **2. Multi-Turn Conversation Length** (Average turns per diner session across `faq` → `booking`) | **2–4 turns** per session (diner asks 1–2 FAQ questions, then books) | **8+ turns** per session with multiple FAQ lookups (raw chunks from turns 1–5 accumulate in the shared transcript and degrade `booking` planner accuracy or latency) |
| **3. Planner Latency & Token Growth across Turns** (`llmStep` latency on Turn \(N\) vs. Turn 1) | Turn 4 latency within **< 20%** of Turn 1 latency | Turn 4+ planner latency spikes or hits context limits because prior raw RAG chunks are sitting in the transcript history |
| **4. Instruction Adherence / Grounding Drift** (Testing Center & Output Evaluation `GROUNDED` rate) | **100%** guardrail adherence & `GROUNDED` evaluation in `subagent faq` | `subagent faq` struggles to simultaneously balance routing rules (`go_booking`, `go_escalation`) and strict passage-only extraction when chunks are noisy |
