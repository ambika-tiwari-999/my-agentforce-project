# Ambika schema (planned)

**Status:** **Implemented in org** (2026-10-26). CRM objects + data loaded; FAQ CSV ready for Data 360 ingest.  
**Replaces for demo work:** `Restaurant__c`, `Reservation__c` (originals stay until we deprecate).

---

## CRM objects (structured)

### `Ambika_Restaurant__c`

**Copy of:** `Restaurant__c`

**Changes in this copy:**

- **Remove fields** (content moves to Data 360 FAQ): `Operating_Hours__c`, `Menu_Details__c`, `Parking_Policy__c`
- **Add fields:** `Street_Address__c`, `Phone__c`
- **Replace on copy:** `Phone_Number__c` → `Phone__c` (same values; one phone field per restaurant)
- **Keep as-is:** `Restaurant_ID__c`, `Name__c`, `Zip_Code__c`, standard `Name`
- **Data:** Same 5 TableCraft rows; same `Restaurant_ID__c` values

| Field | Type | Notes |
|-------|------|--------|
| `Name` | Auto Number / Text | Salesforce record name |
| `Restaurant_ID__c` | Text (external id) | Business PK, e.g. `REST-ATX-01` |
| `Name__c` | Text | Display name |
| `Street_Address__c` | Text | **New** — for lookup / disambiguation |
| `Zip_Code__c` | Text | |
| `Phone__c` | Phone | Restaurant line (public + agent handoff for demo) |

---

### `Ambika_Reservation__c`

**Copy of:** `Reservation__c`

**Changes in this copy:**

- **Remove fields:** none (source object has no long-text / FAQ fields)
- **Add fields:** none for v1 (optional later: lookup to `Ambika_Restaurant__c` instead of text-only `Restaurant_ID__c`)
- **Keep as-is:** `Reservation_ID__c`, `Restaurant_ID__c`, `Party_Size__c`, `Reservation_Time__c`, `Status__c`, `Contact_ID__c`, standard `Name`
- **Data:** Copy all 30 rows; `Restaurant_ID__c` values unchanged and must match `Ambika_Restaurant__c.Restaurant_ID__c`
- **Cleanup on load (recommended):** fix or drop rows pointing at `REST-ATX-02` (no matching restaurant today)

| Field | Type | Notes |
|-------|------|--------|
| `Name` | Auto | |
| `Reservation_ID__c` | Text (external id) | e.g. `RES-001` |
| `Restaurant_ID__c` | Text | Same IDs as `Ambika_Restaurant__c.Restaurant_ID__c` (lookup optional later) |
| `Party_Size__c` | Number | |
| `Reservation_Time__c` | DateTime | |
| `Status__c` | Text | |
| `Contact_ID__c` | Number | Demo placeholder |

---

## Data 360 (content + RAG)

Single FAQ corpus for Phase 1 (menus as FAQ chunks until menu DMO exists).

### FAQ DMO (logical columns)

| Column | Example |
|--------|---------|
| `restaurant_id` | `REST-ATX-01` |
| `category` | `hours`, `parking`, `menu`, `policy` |
| `question` | `What are your hours on Sunday?` |
| `answer` | Short answer derived from old CRM text |

**Sourced from removed CRM fields:**

| Old field | Data 360 treatment |
|-----------|-------------------|
| `Operating_Hours__c` | Split into several FAQ rows (`category=hours`) |
| `Parking_Policy__c` | Split into FAQ rows (`category=parking`) |
| `Menu_Details__c` | Split into overview + item/dietary FAQs (`category=menu`) |

Agent FAQ subagent: retriever filtered by `restaurant_id`. CRM action optional for phone / address only.

---

## How we will do it

1. **Create** `Ambika_Restaurant__c` and `Ambika_Reservation__c` in org (Setup or metadata in `force-app`).
2. **Export** existing `Restaurant__c` / `Reservation__c` (Data Loader or SOQL).
3. **Build FAQ CSV** — parse the three long-text fields per restaurant into `restaurant_id` + `category` + Q&A rows.
4. **Load CRM** — insert Ambika objects with structured columns only; same IDs as today.
5. **Ingest Data 360** — CSV → DLO → DMO → search index → retriever; wire agent `knowledge` when ready.
6. **Point agent/actions** at `Ambika_*` tables + FAQ retriever; leave old objects read-only until deleted.

**Test restaurant first:** `REST-ATX-01`, then replicate for other four locations.

### Org implementation notes (2026-10-26)

- Metadata in `force-app/main/default/objects/Ambika_*`
- **5** `Ambika_Restaurant__c` rows loaded (`data/ambika_restaurants_core.csv`)
- **29** `Ambika_Reservation__c` rows loaded (`data/ambika_reservations_core.csv`; 2 orphan `REST-ATX-02` skipped)
- **25** FAQ rows in `data/ambika_restaurant_faq.csv` (hours, parking, menu, phone, zip) — **upload to Data 360 next**
- **Known org quirk:** On this orgfarm tenant, only `Name__c` + `Restaurant_ID__c` (and reservation IDs) are queryable via API until remaining custom fields finish provisioning. Phone/zip/address metadata is deployed; use FAQ file for phone/zip in Phase 1. Re-test SOQL on `Phone__c` / `Zip_Code__c` in Setup or after a few minutes.

---

## Related docs

- [org-data-inventory.md](./org-data-inventory.md) — current org state  
- [restaurant-phone-agent-spec.md](./restaurant-phone-agent-spec.md) — agent phases  
