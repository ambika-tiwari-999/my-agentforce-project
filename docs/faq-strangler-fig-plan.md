# FAQ Subagent Strangler Fig Plan (`TableCraft_Agent`)

Incremental step-by-step plan to replace the dual-prompt setup in `subagent faq` with direct subagent reasoning + Apex Data 360 RAG. Each step is independently deployable and testable.

---

## Step 1 — Rename `dining_info` to `faq` *(Done — `v2`)*
- Rename `subagent dining_info`, `@subagent.dining_info`, `go_dining_info`, and `active_area == "dining_info"` to `faq` / `go_faq`.
- Update subagent description.

---

## Step 2 — Hydrate `operating_hours` and `current_date_time` in `before_reasoning` (Apex)
- **Files:** `CLL_DinerService.cls`, `TableCraft_Agent.agent`
- Update `CLL_DinerService.validateRestaurantByCode` (`validate_restaurant_context`) to also return `Operating_Hours__c` and current date/time alongside `Phone_Number__c`.
- Store them in `@variables.operating_hours` and `@variables.current_date_time` inside `faq.before_reasoning`.
- *Safe checkpoint:* Existing actions still work; new variables are now populated in session state.

---

## Step 3 — Move FAQ guardrails into `subagent faq` and delete `answer_dining_question` (`CLL_Answer_Dining_Question`)
- **Files:** `TableCraft_Agent.agent`
- Copy the 8 guardrails from `Ambika_TableCraft_FAQ_Prompt` into `subagent faq` `reasoning.instructions`, injecting `{!@variables.operating_hours}`, `{!@variables.escalation_phone_number}`, and `{!@variables.current_date_time}`.
- Instruct `subagent faq` to answer hours and phone questions directly from those `@variables` without calling any action.
- Remove the `answer_dining_question` (`answer_question`) action and the automatic `run @actions.retrieve_dining_knowledge` call at the top of `reasoning.instructions`.
- *Safe checkpoint:* Hours/phone questions are answered directly by `subagent faq` (0 prompt calls); policy/menu/parking questions still fall back to `Answer_TableCraft_FAQ`.

---

## Step 4 — Replace fake CRM lookup in `CLL_DiningKnowledgeRetriever.cls` with real Data 360 RAG
- **Files:** `CLL_DiningKnowledgeRetriever.cls`
- Replace the fake `Restaurant__c` SOQL in `CLL_DiningKnowledgeRetriever.retrieve()` with the Apex call to the Data 360 retriever (`File_Diner_Restaurant_FAQ_and_Policies_1Cx_8Ec8b60f20d` / `ADL_Diner_Restauran__dlm`), scoped by `restaurantId` and `question`.
- Expose `retrieve_dining_knowledge` in `subagent faq` `reasoning.actions` as an on-demand tool so the planner calls it only when it needs FAQ/menu/parking/policy passages.
- *Safe checkpoint:* `retrieve_dining_knowledge` now returns real Data 360 chunks directly to `subagent faq`.

---

## Step 5 — Delete `Answer_TableCraft_FAQ` (`Ambika_TableCraft_FAQ_Prompt`)
- **Files:** `TableCraft_Agent.agent`
- Remove `Answer_TableCraft_FAQ` from `subagent faq` `reasoning.actions` and `actions`.
- `subagent faq` now has only **2 Apex actions**:
  1. `validate_restaurant_context` (`before_reasoning` — loads CRM hours, phone, current date/time)
  2. `retrieve_dining_knowledge` (called on-demand by the planner when Data 360 RAG is needed)
