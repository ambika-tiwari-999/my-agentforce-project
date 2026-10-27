# Ambika_Monday_Demo_Agent — FAQ subagent pipeline (design checklist)

**Scope:** FAQ path only (`faq_subagent` + `Answer_TableCraft_FAQ` + shared org RAG). Not Joe’s agent, Guest Concierge, or bookings agents.

**Inputs (agent variables):** `restaurant_id`, `escalation_phone_number` + user question in **transcript**.

---

## End-to-end chain (input → output)

```text
User message
  → [0] Inputs (variables + transcript)
  → [1] agent_router (transitions only — hyperclassifier)
  → [1b] faq_context_setup (when vars missing — set_faq_context)
  → [2] faq_subagent entry guards
  → [3] faq_subagent reasoning instructions (planner)
  → [4] Einstein Trust Layer (generative call — planner/action path)
  → [5] Agent Script action → Prompt Builder invocation
  → [6] Einstein Trust Layer (prompt / LLM request)
  → [7] RAG (Einstein retriever → Data 360 FAQ library)
  → [8] Prompt template (guardrails + LLM answer)
  → [9] Einstein Trust Layer (LLM response)
  → [10] faq_subagent relay → user message
  → [11] Stay in faq_subagent OR return to agent_router
```

---

## Step 0 — Inputs

**Input names:**

- `restaurant_id`
- `escalation_phone_number`
- FAQ question (transcript — not an agent variable)
- **What runs:** Agent variables are set (or awaiting set); user question arrives in the conversation transcript.
- **Agentforce design decision:** Domain context is **agent variables**, not Messaging session links; the FAQ question is **not** stored in a dedicated variable—it is read from the transcript when the action runs.
- **Guardrails around:** Required **restaurant** (`restaurant_id`) and **escalation phone** (`escalation_phone_number`) before FAQ; empty defaults until **`set_faq_context`** in **`faq_context_setup`**.
- **Executed in:** Agent Script (`variables` block).
- **Code location:** [Ambika_Monday_Demo_Agent.agent](../force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.agent) — `variables:` (`restaurant_id`, `escalation_phone_number`).

---

## Step 1 — `agent_router`

- **What runs:** Router classifies the user message and **transitions only** (`go_to_faq_context_setup`, `go_to_faq_subagent`, escalation, off-topic, ambiguous). No `@utils.setVariables` on the router (required when using `DefaultEinsteinHyperClassifier`).
- **Agentforce design decision:** **Routing** lives in Agent Script; FAQ is an in-bundle **subagent**, not a separate published agent (contrast: Guest Concierge `connected_subagent`).
- **Guardrails around:** FAQ with missing vars → **`faq_context_setup`**; FAQ with both vars set → **`faq_subagent`**; send escalation / off-topic / ambiguous requests to template subagents.
- **Executed in:** Agent Script (router + `DefaultEinsteinHyperClassifier`).
- **Code location:** [Ambika_Monday_Demo_Agent.agent](../force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.agent) — `start_agent agent_router`, `go_to_faq_context_setup`, `go_to_faq_subagent` (`available when` both inputs non-empty).

---

## Step 1b — `faq_context_setup`

- **What runs:** Subagent planner collects **`restaurant_id`** and **`escalation_phone_number`**, calls **`set_faq_context`** (`@utils.setVariables`), then transitions to **`faq_subagent`** when both are non-empty (or **`return_to_router`**).
- **Agentforce design decision:** Variable writes belong on a **regular subagent**, not the hyperclassifier router—required for **`sf agent publish authoring-bundle`** to compile.
- **Guardrails around:** Do not run grounded FAQ until both agent variables are set.
- **Executed in:** Agent Script (`subagent faq_context_setup` planner + `set_faq_context`).
- **Code location:** [Ambika_Monday_Demo_Agent.agent](../force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.agent) — `subagent faq_context_setup`.

---

## Step 2 — `faq_subagent.before_reasoning`

- **What runs:** Deterministic check before the FAQ subagent planner runs.
- **Agentforce design decision:** **Hard prerequisites** belong in Agent Script, not in Prompt Builder—fail closed before any retrieval or LLM call.
- **Guardrails around:** Block FAQ if `restaurant_id` or `escalation_phone_number` is empty; transition to **`faq_context_setup`**.
- **Executed in:** Agent Script (`before_reasoning`, no LLM).
- **Code location:** [Ambika_Monday_Demo_Agent.agent](../force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.agent) — `subagent faq_subagent` → `before_reasoning`.

---

## Step 3 — `faq_subagent` reasoning instructions

- **What runs:** Subagent **planner** LLM decides to invoke `Answer_TableCraft_FAQ` and bind inputs from variables + transcript.
- **Agentforce design decision:** **Thin orchestration**—one action, relay output; **do not** duplicate FAQ content policy here (that lives in Prompt Builder).
- **Guardrails around:** Tool use only; no general-knowledge answers; do not repeat prompt rules to the user.
- **Executed in:** Agent Script (subagent planner LLM).
- **Code location:** [Ambika_Monday_Demo_Agent.agent](../force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.agent) — `subagent faq_subagent` → `reasoning.instructions` and action bindings (`with "Input:question"`, `with "Input:restaurant_id"`, etc.).

---

## Step 3b — Agent-wide system instructions (light touch)

- **What runs:** May influence tone across subagents when the platform merges system context.
- **Agentforce design decision:** High-level **agent persona** for the whole bundle—not the detailed FAQ policy layer.
- **Guardrails around:** “Use approved FAQ retrieval only”; no restaurant answers from general knowledge (summary level).
- **Executed in:** Agent Script.
- **Code location:** [Ambika_Monday_Demo_Agent.agent](../force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.agent) — `system.instructions`.

---

## Step 4 — Einstein Trust Layer (planner / invocable path)

- **What runs:** Platform policy on generative or invocable AI calls when the subagent planner and/or action is invoked.
- **Agentforce design decision:** **Einstein Trust Layer** is org-level—not where you author TableCraft FAQ wording or retrieval rules.
- **Guardrails around:** Platform safety, toxicity, data masking, audit/logging (as configured in the org).
- **Executed in:** Einstein Trust Layer (Setup / org policy).
- **Code location:** Not in git — configure in the **Salesforce org** (Trust Layer / Einstein generative AI settings).

---

## Step 5 — `Answer_TableCraft_FAQ` action

- **What runs:** Agent Script action calls `generatePromptResponse://Ambika_TableCraft_FAQ_Prompt` with prompt inputs.
- **Agentforce design decision:** **One local action = one Prompt Builder template** for grounded FAQ generation.
- **Guardrails around:** Wire `Input.question`, `Input.restaurant_id`, `Input.escalation_phone_number` from agent state into the prompt.
- **Executed in:** Agent Script action → Prompt Builder invocation.
- **Code location:**
  - Action definition: [Ambika_Monday_Demo_Agent.agent](../force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.agent) — `subagent faq_subagent` → `actions.Answer_TableCraft_FAQ`
  - Target template: [Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml](../force-app/main/default/genAiPromptTemplates/Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml)

---

## Step 6 — Einstein Trust Layer (prompt / LLM request)

- **What runs:** Trust policies applied when the prompt template executes its generative step.
- **Agentforce design decision:** Same Trust Layer as step 4; applies to **Prompt Builder** LLM calls.
- **Guardrails around:** Pre-generation checks on prompt payload and inputs (org-configured).
- **Executed in:** Einstein Trust Layer.
- **Code location:** Not in git — org configuration.

---

## Step 7 — RAG retrieval

- **What runs:** Einstein Search data provider runs retriever with `searchText` = `Input.question`; hits Data 360–backed FAQ file library chunks.
- **Agentforce design decision:** **Retrieval is configured on the prompt template**, not via agent `knowledge.rag_feature_config_id` for this FAQ action path.
- **Guardrails around:** Retrieve from the **shared FAQ file library** only; `searchText` is the user question (**no `restaurant_id` filter on retriever yet**).
- **Executed in:** Einstein retriever + Data 360 (file ingest / search index in org).
- **Code location:**
  - Retriever binding (git): [Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml](../force-app/main/default/genAiPromptTemplates/Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml) — `templateDataProviders` (`File_Diner_Restaurant_FAQ_and_Policies_1Cx_8Ec8b60f20d`)
  - Org asset inventory (reference): [data360_assets.json](../data/data360_assets.json) — `ADL_Diner_Restauran`, RAG feature IDs
  - Live corpus: **org only** (Data Cloud UI / `ADL_Diner_Restauran__dlm` SOQL), not deployable as DLO metadata in this repo today

**See also:** [What is an Einstein retriever?](./ambika-einstein-retriever.md)

---

## Step 8 — Prompt template body + LLM

- **What runs:** Jinja prompt assembles passages + GUARDRAILS + diner question; `DefaultGPT5Mini` produces the FAQ reply.
- **Agentforce design decision:** **Content guardrails and refusal copy belong in Prompt Builder** for every grounded FAQ answer.
- **Guardrails around:** Passages-only facts; exact “no FAQ” strings with escalation phone; allergen/medical handoff; defer bookings; brevity; no meta (“sources”, “rules”).
- **Executed in:** Prompt Builder (`GenAiPromptTemplate`).
- **Code location:** [Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml](../force-app/main/default/genAiPromptTemplates/Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml) — `templateVersions.content`, `primaryModel`  
  - Rule checklist mirror: [ambika-faq-prompt-guardrails.md](./ambika-faq-prompt-guardrails.md)

**See also:** [What is a Jinja prompt?](./ambika-jinja-prompt.md)

---

## Step 9 — Einstein Trust Layer (model output)

- **What runs:** Post-generation filtering / logging on LLM output before it returns to the action.
- **Agentforce design decision:** Platform output governance—not custom TableCraft logic.
- **Guardrails around:** Output safety and compliance policies (org-configured).
- **Executed in:** Einstein Trust Layer.
- **Code location:** Not in git — org configuration.

---

## Step 10 — Output to user

- **What runs:** `promptResponse` returns to the FAQ subagent; planner sends text to the user in Messaging / preview.
- **Agentforce design decision:** Subagent **relays** prompt output; avoids a second “creative” pass that could hallucinate.
- **Guardrails around:** “Relay only” (reinforced in step 3 reasoning instructions).
- **Executed in:** Agent Script subagent planner + action outputs.
- **Code location:** [Ambika_Monday_Demo_Agent.agent](../force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.agent) — `faq_subagent` reasoning; `Answer_TableCraft_FAQ` → `outputs.promptResponse`.

---

## Step 11 — Stay in FAQ or return to `agent_router`

- **What runs:** Next user message is handled in `faq_subagent` again (typical FAQ follow-up), **or** script transitions to router.
- **Agentforce design decision:** FAQ is **sticky** in the subagent until context changes or an explicit transition fires—not every turn re-enters the router.
- **Guardrails around:** `return_to_router` when restaurant/phone context changes; `before_reasoning` bounce to **`faq_context_setup`** if inputs cleared; router handles new intents on transition.
- **Executed in:** Agent Script.
- **Code location:** [Ambika_Monday_Demo_Agent.agent](../force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.agent) — `return_to_router`; step 2 `before_reasoning`; steps 1 / 1b for re-entry and context collection.

---

## Not on this FAQ path (Ambika bundle)

- `**knowledge.rag_feature_config_id**` on the agent — defined in [Ambika_Monday_Demo_Agent.agent](../force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.agent) (`knowledge:`). **Not used** by `Answer_TableCraft_FAQ`; retriever is on the prompt. ID documented in [data360_assets.json](../data/data360_assets.json) for alignment / future use.
- `**Joe_FAQ_Prompt**` — org template used by Joe’s agent only. Ambika uses [Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml](../force-app/main/default/genAiPromptTemplates/Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml).
- **Messaging linked variables** (`ContactId`, `EndUserId`, etc.) — removed from this bundle; not required for FAQ retrieval.

---

## File index (Ambika FAQ only)

- Router, variables, `faq_subagent`, action wiring — [Ambika_Monday_Demo_Agent.agent](../force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.agent)
- Bundle metadata — [Ambika_Monday_Demo_Agent.bundle-meta.xml](../force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.bundle-meta.xml)
- FAQ guardrails + retriever + LLM — [Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml](../force-app/main/default/genAiPromptTemplates/Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml)
- Prompt guardrail checklist — [ambika-faq-prompt-guardrails.md](./ambika-faq-prompt-guardrails.md)
- Input contract + flow diagram — [ambika-faq-subagent-flow.md](./ambika-faq-subagent-flow.md)
- Data 360 / RAG IDs (reference) — [data360_assets.json](../data/data360_assets.json)

---

## Related

- [ambika-faq-subagent-flow.md](./ambika-faq-subagent-flow.md)
- [ambika-faq-prompt-guardrails.md](./ambika-faq-prompt-guardrails.md)

