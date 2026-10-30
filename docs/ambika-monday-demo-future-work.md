# Ambika Monday Demo Agent — future work

Tracked gaps and improvements discovered while testing **Preview** on the FAQ harness (step 0) and FAQ bundle (steps 1–10). Not blockers for documenting the pipeline; address when hardening the demo or merging into the team agent.

---

## FAQ Context Setup trap after step 1 bounce

**Observed (Preview):** User asks a hours/FAQ question → trace shows **Transition to FAQ Subagent**, then immediately **Transition to FAQ Context Setup**, then **Reasoning: FAQ Context Setup** with **SMALL_TALK**. No **Answer TableCraft FAQ** / retriever step.

**Cause chain:**

1. **Step 1** (`faq_subagent.before_reasoning`) runs `validate_restaurant_context`. If `restaurant_validated` stays **false** (empty `restaurant_id`, CRM miss, Apex/permission failure), Agent Script **always** transitions to `faq_context_setup`.
2. **FAQ Context Setup** has **no** FAQ retrieval action—only `set_faq_context`, `go_to_faq_subagent`, `return_to_router`.
3. Follow-up messages (e.g. “just the opening time”) are often handled as **conversational** small talk instead of **`go_to_faq_subagent`**, so the agent may *say* it will retrieve hours without invoking the prompt/RAG path.

**Why it feels broken:** The model can mention `REST-ATX-01` from chat or variables while still sitting in the wrong topic; that is not evidence that step 1 or retrieval ran.

**Future fixes (pick one or combine):**

| Area | Idea |
|------|------|
| **Script — `faq_context_setup`** | When `restaurant_id` is non-empty and the user asks any restaurant FAQ (hours, parking, menu, policies), **require** `go_to_faq_subagent` on that turn; never answer those topics from planner memory. |
| **Script — step 1 failure path** | On validate failure, transition to a dedicated **error/re-prompt** topic (invalid ID, CRM unavailable) instead of generic context setup that only collects ID. |
| **Script — `before_reasoning`** | Optional: surface validate `message` to the user when bouncing (today outputs are mostly for the planner). |
| **Ops** | Ensure demo `Restaurant__c` rows exist in the target org and the **default agent user** can read them (`CLL_DinerService` uses `WITH USER_MODE`). |
| **Production merge** | Replace step **0.3** with orchestrator handoff; keep step **1** gate on FAQ entry. |

**Related:** [ambika-monday-demo-faq-pipeline.md](./ambika-monday-demo-faq-pipeline.md) (step 0 vs step 1), [publish-ambika-monday-demo-agent.md](./setup/publish-ambika-monday-demo-agent.md) (Preview / router model).

---

## Preview testing until the above is fixed

Treat Preview as **two explicit steps**:

1. **Set context** — message that triggers `set_faq_context` with a **`Restaurant_ID__c` value that exists in the org** (demo default: `REST-ATX-01` from [data/restaurant__c_records.csv](../data/restaurant__c_records.csv) after data load).
2. **Ask FAQ** — hours/parking/menu question; confirm trace stays in **FAQ Subagent**, shows **Validate Restaurant Context**, then **Answer TableCraft FAQ**.

Check **Context Variables**: `restaurant_validated = true` and `escalation_phone_number` populated after step 1 before trusting FAQ answers.

---

## Other backlog (lightweight)

- **Router + single utterance:** “I’m at REST-ATX-01, what are Sunday hours?” may or may not set context and route in one turn; two-message sequence remains the reliable demo.
- **Retriever filter by `restaurant_id`:** Pipeline step 6 future work (shared library vs per-restaurant filter)—see main pipeline doc.
