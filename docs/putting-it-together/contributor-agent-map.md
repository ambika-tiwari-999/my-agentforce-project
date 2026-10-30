# TableCraft agents — who built what (org + git)

**Org:** `agentforce-org` (`ambika.tiwari3@salesforce.com`, 00Dg700000M98EcEAJ)  
**Checked:** 2026-10-30 via `sf data query` on `BotDefinition`, `ApexClass`, `FlowDefinitionView`, plus retrieve of authoring bundles.

Work is split across several published agents. **TableCraft Agent** (`TableCraft_Agent`, created 2026-10-30 by Christian Lozano) is the in-org merge draft; git copy is under `aiAuthoringBundles/TableCraft_Agent_1/`. It is not validated as the single production agent yet.

---

## Joseph Onwuchekwa (Joe) — router, FAQ RAG path, guardrail topics

**Agent (org):** `Joe_Test_FAQ_Agent` — created 2026-10-27 by Joseph Onwuchekwa

**Topics:** `agent_router` (DefaultEinsteinHyperClassifier), `faq_handler`, `escalation`, `off_topic`, `ambiguous_question`

**What it does:** Hyperclassifier routes FAQ vs escalation vs off-topic vs ambiguous. FAQ uses prompt `Joe_FAQ_Prompt` + Data 360 RAG (`knowledge.rag_feature_config_id` ARFPC_1JDg7000005k8HRGAY).

**Einstein Trust Layer:** Org-level generative policy (Setup), not in git. Joe’s bundle relies on it on planner/prompt paths; documented in `docs/ambika-monday-demo-faq-pipeline.md` (steps 3, 5, 8).

**Git:**
- `force-app/main/default/aiAuthoringBundles/Joe_Test_FAQ_Agent/Joe_Test_FAQ_Agent.agent`
- `force-app/main/default/bots/Joe_Test_FAQ_Agent/`
- `force-app/main/default/genAiPromptTemplates/Joe_FAQ_Prompt.genAiPromptTemplate-meta.xml` (after retrieve)
- `force-app/main/default/aiAgentDefinitionVersions/Joe_Test_FAQ_Agent#1/` (if retrieved)

**Related (git only, not in org BotDefinition list):** `Guest_Concierge_Agent` — multi-agent router wiring `TableCraft_Bookings_Test` + `Joe_Test_FAQ_Agent` via `connected_subagent` (`force-app/main/default/aiAuthoringBundles/Guest_Concierge_Agent/`).

---

## Luke Swint — CRM objects + reservation CRUD (flows)

**Agents (org):**
- `TableCraft_Bookings_Test` — created 2026-10-25, last modified 2026-10-27 by Luke Swint
- `TableCraft_Agent_LS_Test` — created 2026-10-29 by Luke Swint (merge test; Luke booking Apex in booking subagent)

**Topics (Bookings Test):** `agent_router`, `ReservationManagement`, `escalation`

**Actions:** Agent Script calls **flows** on `Restaurant__c` / `Reservation__c`:
- `Search_Restaurants`, `Create_Reservation`, `Modify_Reservation`, `Cancel_Reservation`, `Get_Reservation_Details`, `Check_Table_Availability`, `Find_Contact_By_Email`

**Apex (org, Luke):** `LS_CreateReservation`, `LS_GetReservation`, `LS_ModifyReservation`, `LS_ReservationActionsTest`, `LS_TimeZoneUtil`, `LS_TimeZoneUtilTest`

**Git:**
- `force-app/main/default/aiAuthoringBundles/TableCraft_Bookings_Test/` (and published suffix folder e.g. `TableCraft_Bookings_Test_5/`)
- `force-app/main/default/aiAuthoringBundles/TableCraft_Agent_LS_Test_1/TableCraft_Agent_LS_Test_1.agent`
- `force-app/main/default/aiAgentDefinitionVersions/TableCraft_Bookings_Test#3/` (+ localActions under ReservationManagement, CaseManagement, etc.)
- `force-app/main/default/objects/Restaurant__c/`, `Reservation__c/`
- `force-app/main/default/flows/Search_Restaurants.flow-meta.xml` (only one flow in git; other reservation flows live in org)
- `data/restaurant__c_records.csv`, `data/reservation__c_records.csv`

---

## Ambika Tiwari — FAQ subagent, CRM pre-gate, Data 360 + prompt

**Agent (org):** `Ambika_Monday_Demo_Agent` — created 2026-10-26, last modified 2026-10-28 by Ambika Tiwari

**Topics:** `agent_router`, `faq_context_setup`, `faq_subagent`

**What it does:** FAQ-only demo harness (stub router/context setup). Production-intent pieces: `validate_restaurant_context` → `apex://CLL_DinerService` (Ambika last modified this class in org), `Answer_TableCraft_FAQ` → `Ambika_TableCraft_FAQ_Prompt` + Einstein retriever on FAQ PDF library.

**Data 360 (org, tracked locally):** `data/data360_assets.json` — library `ADL_Diner_Restauran`, retriever `File_Diner_Restaurant_FAQ_and_Policies`, shared with Joe’s prompt path.

**Git:**
- `force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.agent`
- `force-app/main/default/aiAgentDefinitionVersions/Ambika_Monday_Demo_Agent#3/` … `#11/` (published versions)
- `force-app/main/default/genAiPromptTemplates/Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml`
- `force-app/main/default/classes/CLL_DinerService.cls` (Christian created; Ambika modified in org)
- `docs/ambika-monday-demo-faq-pipeline.md`, `docs/ambika-data360-faq-rag.md`, `docs/learning/ambika-*`

**Also org (Ambika created):** `Intelligent_Diner_Support_Agent` — large OOTB-style service agent template (many topics); not the thin FAQ demo.

---

## Christian Lozano — reservation subagent (CLL), escalation, merge agent

**Agents (org):**
- `Intelligent_Dinner_CLL_Agent` — created 2026-10-26, last modified 2026-10-28 by Christian Lozano
- `TableCraft_Agent` — created 2026-10-30 by Christian Lozano (merged orchestrator + booking + dining_info + escalation script)

**Reservation subagent (CLL agent):** Topics `orchestrator`, `booking`, `dining_info`. Booking uses **Christian’s Apex:** `CLL_GetReservation`, `CLL_CreateReservation`, `CLL_ModifyReservation`, `CLL_CancelReservation`, plus `CLL_FindRestaurant`, `CLL_GetDinerContext`, `CLL_DiningKnowledgeRetriever`.

**Escalation / case / Omni:**
- `CLL_EscalateToHuman` (Apex) — wired in `Intelligent_Dinner_CLL_Agent.agent` and in `TableCraft_Agent_LS_Test_1` escalation path
- Messaging: `flow://Route_CLL_Escalations` (org flow, last modified 2026-10-28)
- `TableCraft_Agent` draft escalation subagent: `@utils.escalate` to Omni (comment in merge script mentions Case + Joe’s Human_Escalation pattern; published `TableCraft_Agent` bundle should be checked in Builder for what actually shipped)

**Git:**
- `force-app/main/default/aiAuthoringBundles/Intelligent_Dinner_CLL_Agent/` (+ `Intelligent_Dinner_CLL_Agent_3/`)
- `force-app/main/default/aiAuthoringBundles/TableCraft_Agent_1/TableCraft_Agent_1.agent` (merge draft; maps orchestrator=Joe role, booking=Luke+CLL guardrails, dining_info=Ambika FAQ prompt, escalation=handoff)
- `force-app/main/default/aiAgentDefinitionVersions/Intelligent_Dinner_CLL_Agent#2/`
- `force-app/main/default/classes/CLL_*.cls`
- `force-app/main/default/bots/Intelligent_Dinner_CLL_Agent/`

**Case-style escalation elsewhere:** `TableCraft_Bookings_Test` / `Intelligent_Diner_Support_Agent` use template flow `SvcCopilotTmpl__CreateCaseEnhancedData` in version metadata (Luke/Ambika template agents, not CLL Apex).

---

## Org agents table (TableCraft-relevant only)

| DeveloperName | Label | CreatedBy (org) | Role |
|---------------|-------|-----------------|------|
| Joe_Test_FAQ_Agent | Joe Test FAQ Agent | Joseph Onwuchekwa | Router + FAQ RAG |
| TableCraft_Bookings_Test | TableCraft - Bookings Test | Luke Swint | CRM reservation flows |
| TableCraft_Agent_LS_Test | TableCraft Agent LS Test | Luke Swint | Merge test (Luke Apex) |
| Ambika_Monday_Demo_Agent | Ambika Monday Demo Agent | Ambika Tiwari | FAQ subagent demo |
| Intelligent_Dinner_CLL_Agent | Intelligent Dinner CLL Agent | Christian Lozano | CLL booking + dining |
| TableCraft_Agent | TableCraft Agent | Christian Lozano | Combined draft |
| Intelligent_Diner_Support_Agent | Intelligent Diner Support Agent | Ambika Tiwari | Broad service template |

Org also has OrgFarm intent test bots and `Copilot_for_Salesforce` (Christian) — not part of TableCraft demo path.

---

## Heroku

No Heroku references in this git repo or in retrieved agent metadata. If the team has Heroku middleware, it is outside this project unless linked from another repo or org config not queried here.

---

## Next step (this chat’s eventual goal)

Single new agent with one orchestrator/router and in-process subagents (booking, FAQ/dining_info, escalation), pulling from the rows above instead of `connected_subagent` / separate bots.
