# To-Do: Remaining Implementation Items Before Final Presentation

Items referenced in the pitch / presentation deck that are not yet wired into `TableCraft_Agent` (`v3`):

---

## 1. `faq` Subagent — Steps 4 & 5 of Strangler Fig Plan (Ambika)
- **Hydrate Data 360 Search Index & Upload Restaurant-Tagged PDFs:**
  - Upload restaurant menu / FAQ PDFs tagged with `restaurant_id` into `ADL_Diner_Restauran` (`ADL_Diner_Restauran__dlm`) and refresh/rebuild the Search Index in Data Cloud so `ADL_Diner_Restauran_chunk__dlm` and `ADL_Diner_Restauran_index__dlm` are hydrated (currently `0` rows / `Unhydrated`).
- **Step 4 — Replace Fake CRM Lookup in `CLL_DiningKnowledgeRetriever.cls`:**
  - Replace the placeholder `Restaurant__c` SOQL inside [`force-app/main/default/classes/CLL_DiningKnowledgeRetriever.cls`](../force-app/main/default/classes/CLL_DiningKnowledgeRetriever.cls) with the real Data 360 RAG query (scoped by `restaurantId` and `question`), and expose `retrieve_dining_knowledge` in `subagent faq` `reasoning.actions`.
- **Step 5 — Remove `Answer_TableCraft_FAQ` (`Ambika_TableCraft_FAQ_Prompt`) from `subagent faq`:**
  - Delete `Answer_TableCraft_FAQ` from `TableCraft_Agent.agent` once `retrieve_dining_knowledge` is returning Data 360 chunks directly to `subagent faq`.

---

## 2. `escalation` Subagent — `Case` Creation + AI Summary Wiring (Joseph / Christian)
- **Current state in `TableCraft_Agent.agent` (`v3`):**
  - `subagent escalation` (lines 561–585) only calls `@utils.escalate` (`flow://Route_CLL_Escalations`) with the comment `# ESCALATION (standard Omni-Channel handoff, no Case)`.
- **To-Do:**
  - Verify whether `flow://Route_CLL_Escalations` already creates the `Case` with the summary, or wire [`CLL_EscalateToHuman.cls`](../force-app/main/default/classes/CLL_EscalateToHuman.cls) into `subagent escalation` before `@utils.escalate` so a `Case` with the AI summary is created as described in the presentation.

---

## 3. `booking` Subagent — `specialRequests` Input & Timezone Handling (Luke)
- **Current state in `TableCraft_Agent.agent` (`v3`):**
  - Line 285 has `# with specialRequests = ... # UNCOMMENT after CLL_CreateReservation accepts it (also uncomment the input at the bottom)`.
- **To-Do:**
  - Add `specialRequests` to `CLL_CreateReservation.cls` (and `Reservation__c` if needed) and uncomment `specialRequests` in `TableCraft_Agent.agent` so dietary/occasion notes are persisted on the reservation record.
  - Confirm restaurant local timezone conversion fix (`LS_TimeZoneUtil`) is applied where needed.
