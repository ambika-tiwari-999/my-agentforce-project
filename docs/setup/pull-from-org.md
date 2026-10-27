# Pull org metadata & data into this project

Run commands from the **project root**:

```bash
cd /Users/ambika.tiwari/Documents/salesforce_onboarding_notes/my-agentforce-project
```

**Org:** `agentforce-org` — see [org-data-inventory.md](../org-data-inventory.md) for what exists today.

**Remember:** `sf project retrieve` gets **schema (metadata)** only. **Rows** are exported separately into `data/` with `sf data query`.

**CLI tip:** For multiple metadata components, pass **separate** `--metadata` (or `-m`) flags. Do **not** comma-separate inside one `-m` value — the CLI treats the whole string as one name.

---



## Before you start

```bash
sf org display --target-org agentforce-org
```

**Check:**

- [x] `connectedStatus` is **Connected**
- [x] Username matches the org you expect

---



## 1. Source restaurant & reservation objects (required for clone-first work)

These objects live in the org but are **not** in git until you retrieve them.

```bash
# Use one --metadata (-m) per component (comma in a single -m is parsed as part of the name)
sf project retrieve start \
  --metadata CustomObject:Restaurant__c \
  --metadata CustomObject:Reservation__c \
  --target-org agentforce-org
```

**Check — folders exist:**

```bash
ls force-app/main/default/objects/Restaurant__c
ls force-app/main/default/objects/Reservation__c
```

**Check — key fields present (files under** `fields/`**):**


| Object           | Expected custom field files (API names)                                                                                       |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `Restaurant__c`  | `Restaurant_ID__c`, `Name__c`, `Zip_Code__c`, `Phone_Number__c`, `Operating_Hours__c`, `Parking_Policy__c`, `Menu_Details__c` |
| `Reservation__c` | `Reservation_ID__c`, `Restaurant_ID__c`, `Party_Size__c`, `Reservation_Time__c`, `Status__c`, `Contact_ID__c`                 |


**Check — org matches (optional):**

1. sf data query --target-org agentforce-org \
  -q "SELECT COUNT() FROM Restaurant__c"

sf data query --target-org agentforce-org \
  -q "SELECT COUNT() FROM Reservation__c"

Expect **5** restaurants and **30** reservations (as of last inventory).

---



## 2. Ambika CRM objects (sync org → repo)

If `Ambika_Restaurant__c` / `Ambika_Reservation__c` exist in the org, retrieve so local metadata matches the org (or skip if you are rebuilding Ambika from clones in step 1).

```bash
sf project retrieve start \
  --metadata CustomObject:Ambika_Restaurant__c \
  --metadata CustomObject:Ambika_Reservation__c \
  --target-org agentforce-org
```

**Check:**

```bash
ls force-app/main/default/objects/Ambika_Restaurant__c/fields
ls force-app/main/default/objects/Ambika_Reservation__c/fields
```

```bash
sf data query --target-org agentforce-org -q "SELECT COUNT() FROM Ambika_Restaurant__c"
sf data query --target-org agentforce-org -q "SELECT COUNT() FROM Ambika_Reservation__c"
```

If the objects were deleted in the org, retrieve may remove or fail — that is expected; rely on step 1 + clone workflow in [ambika_schema.md](../ambika_schema.md).

---



## 3. Agentforce agents (TableCraft demo set)

**Project API version:** `sfdx-project.json` should use **68.0** (org API) so `AiAgentDefinition` / `AiAgentDefinitionVersion` retrieve works.

Refresh **authoring bundles** (`.agent` — use published bot developer name, not the `_1` suffix shown in Setup lists):

```bash
sf project retrieve start \
  --metadata AiAuthoringBundle:Ambika_Monday_Demo_Agent \
  --metadata AiAuthoringBundle:Joe_Test_FAQ_Agent \
  --metadata AiAuthoringBundle:TableCraft_Bookings_Test \
  --metadata AiAuthoringBundle:Intelligent_Dinner_CLL_Agent \
  --metadata AiAuthoringBundle:Intelligent_Diner_Support_Agent \
  --metadata AiAuthoringBundle:Guest_Concierge_Agent \
  --metadata AiAuthoringBundle:Intelligent_Dinner_Test_Agent \
  --target-org agentforce-org
```

**Published bots + planner versions:**

```bash
sf project retrieve start \
  --metadata Bot:Ambika_Monday_Demo_Agent \
  --metadata Bot:Joe_Test_FAQ_Agent \
  --metadata Bot:TableCraft_Bookings_Test \
  --metadata Bot:Intelligent_Dinner_CLL_Agent \
  --metadata Bot:Intelligent_Diner_Support_Agent \
  --target-org agentforce-org
```

**Agent definitions, graphs, and local action schemas** (after API 68 in project):

```bash
sf project retrieve start \
  --metadata AiAgentDefinition:Joe_Test_FAQ_Agent \
  --metadata AiAgentDefinition:TableCraft_Bookings_Test \
  --metadata AiAgentDefinitionVersion:Joe_Test_FAQ_Agent#1 \
  --metadata AiAgentDefinitionVersion:TableCraft_Bookings_Test#3 \
  --target-org agentforce-org
```

**FAQ / Data 360 prompt (Joe’s retriever-backed template):**

```bash
sf project retrieve start \
  --metadata GenAiPromptTemplate:Joe_FAQ_Prompt \
  --target-org agentforce-org
```

**Supporting automation (bookings / CLL agent):**

```bash
sf project retrieve start \
  --metadata Flow:Search_Restaurants \
  --metadata ApexClass:CLL_DinerService \
  --metadata ApexClass:CLL_DiningKnowledgeRetriever \
  --metadata ApexClass:CLL_FindRestaurant \
  --metadata ApexClass:CLL_GetDinerContext \
  --metadata ApexClass:CLL_GetReservation \
  --metadata ApexClass:CLL_CreateReservation \
  --metadata ApexClass:CLL_ModifyReservation \
  --metadata ApexClass:CLL_CancelReservation \
  --metadata ApexClass:CLL_EscalateToHuman \
  --target-org agentforce-org
```

**Single agent (Ambika bundle only):**

```bash
sf project retrieve start \
  --metadata AiAuthoringBundle:Ambika_Monday_Demo_Agent \
  --target-org agentforce-org
```

**Check:**

- [ ] `force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.agent` updated (timestamp / content)
- [ ] `Ambika_Monday_Demo_Agent.bundle-meta.xml` present

**Published agent metadata (Bot, versions, graph — optional but useful):**

```bash
sf project retrieve start \
  --metadata Agent:Ambika_Monday_Demo_Agent \
  --target-org agentforce-org
```

**Check:**

- [ ] `force-app/main/default/aiAgents/Ambika_Monday_Demo_Agent.aiAgentDefinition-meta.xml`
- [ ] `force-app/main/default/aiAgentDefinitionVersions/` contains `Ambika_Monday_Demo_Agent#...`

```bash
sf data query --target-org agentforce-org \
  -q "SELECT DeveloperName FROM BotDefinition WHERE DeveloperName = 'Ambika_Monday_Demo_Agent'"
```

Expect **one** row.

---



## 4. Export CRM **records** to `data/` (not retrieve)

Create the folder if needed: `mkdir -p data`

**Restaurants (full demo columns):**

```bash
sf data query --target-org agentforce-org \
  -q "SELECT Restaurant_ID__c, Name__c, Zip_Code__c, Phone_Number__c, Operating_Hours__c, Parking_Policy__c, Menu_Details__c FROM Restaurant__c" \
  --result-format csv > data/restaurant__c_records.csv
```

**Reservations:**

```bash
sf data query --target-org agentforce-org \
  -q "SELECT Reservation_ID__c, Restaurant_ID__c, Party_Size__c, Reservation_Time__c, Status__c, Contact_ID__c FROM Reservation__c" \
  --result-format csv > data/reservation__c_records.csv
```

**Check:**

```bash
wc -l data/restaurant__c_records.csv    # expect 6 lines (header + 5 rows)
wc -l data/reservation__c_records.csv     # expect 31 lines (header + 30 rows)
```

Open CSVs and confirm `REST-ATX-01` and sample reservation IDs appear.

**Ambika tables (if populated in org):**

```bash
sf data query --target-org agentforce-org \
  -q "SELECT Restaurant_ID__c, Name__c, Zip_Code__c, Phone__c FROM Ambika_Restaurant__c" \
  --result-format csv > data/ambika_restaurant__c_records.csv

sf data query --target-org agentforce-org \
  -q "SELECT Reservation_ID__c, Restaurant_ID__c, Party_Size__c, Reservation_Time__c, Status__c FROM Ambika_Reservation__c" \
  --result-format csv > data/ambika_reservation__c_records.csv
```

Adjust SELECT if your org’s Ambika fields differ. If query fails, object may be missing or fields not provisioned — note in [org-data-inventory.md](../org-data-inventory.md).

---



## 5. Data 360 (lake objects + RAG IDs)

**In org today (2026-10-27):** file-ingest data libraries **`ADL_Diner_Restauran`** (FAQ PDF) and **`ADL_TestMenu`** (menu PDF), with chunk/index lake rows. Queryable via SOQL on `ADL_Diner_Restauran__dlm` and `ADL_TestMenu__dlm`.

**Not in Metadata API:** DLO/DMO definitions for those ADL names do not retrieve via `MktDataTranObject` / `DataSourceObject` in this org. Track IDs locally in `data/data360_assets.json` (RAG feature config, Einstein retriever reference on `Joe_FAQ_Prompt`).

**Inventory check:**

```bash
sf data query --target-org agentforce-org \
  -q "SELECT Name FROM DataLakeObjectInstance WHERE Name LIKE 'ADL_%' ORDER BY Name"
```

**CSV FAQ corpus (optional parallel to PDF library):**

- `data/ambika_restaurant_faq.csv` — see [data/README.md](../../data/README.md)

Regenerate from `Restaurant__c` long-text fields when source data changes. PDFs themselves stay in Data Cloud file storage unless you download them manually from the Data Cloud UI.

**Check:**

- [ ] `data/data360_assets.json` lists current ADL names and `rag_feature_config_id` values from `.agent` / prompt templates
- [ ] `data/ambika_restaurant_faq.csv` exists if you still use CSV ingest

---



## 6. Optional (pull when you add them)

Only retrieve if these exist in **Setup** and you use them in the demo.


| Piece                          | Command                                                                                      |
| ------------------------------ | -------------------------------------------------------------------------------------------- |
| Flow used by agent             | `sf project retrieve start --metadata Flow:Your_Flow_Api_Name --target-org agentforce-org`   |
| Apex for lookups               | `sf project retrieve start --metadata ApexClass:YourClass --target-org agentforce-org`       |
| GenAI functions wired to agent | Retrieve via `Agent:Ambika_Monday_Demo_Agent` (step 3) or list in Setup → Agentforce Actions |


**Check:** matching files under `force-app/main/default/flows/`, `classes/`, etc.

---



## Quick “do I have enough locally?” checklist


| Need                      | Location                                                                                                    |
| ------------------------- | ----------------------------------------------------------------------------------------------------------- |
| Original table **schema** | `force-app/.../objects/Restaurant__c`, `Reservation__c`                                                     |
| Original table **rows**   | `data/restaurant__c_records.csv`, `data/reservation__c_records.csv`                                         |
| Ambika **schema**         | `force-app/.../objects/Ambika_`*                                                                            |
| Agent **script**          | `force-app/.../aiAuthoringBundles/.../*.agent`                                                              |
| FAQ for Data 360 ingest   | `data/ambika_restaurant_faq.csv` + Data Cloud config in docs                                                |
| Full org clone            | **Not** — selective pull is normal; see [restaurant-phone-agent-spec.md](../restaurant-phone-agent-spec.md) |


---



## Related docs

- [org-data-inventory.md](../org-data-inventory.md) — what is in the org
- [ambika_schema.md](../ambika_schema.md) — target Ambika CRM shape & clone plan
- [restaurant-phone-agent-spec.md](../restaurant-phone-agent-spec.md) — agent phases

