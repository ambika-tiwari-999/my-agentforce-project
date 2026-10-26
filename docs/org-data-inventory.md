# Org data inventory & Data 360 plan

**Org alias:** `agentforce-org`  
**Username:** `ambika.tiwari3@salesforce.com`  
**Instance:** `https://orgfarm-9ca6cfa6c3.my.salesforce.com`  
**Org ID:** `00Dg700000M98EcEAJ`  
**Last inventoried:** 2026-10-26 (CLI queries from this DX project)

Related design doc: [restaurant-phone-agent-spec.md](./restaurant-phone-agent-spec.md)

---

## Summary

| Area | Status in org |
|------|----------------|
| **CRM — Restaurants** | **Created** — `Restaurant__c`, 5 TableCraft locations, rich text for hours / menu / parking |
| **CRM — Bookings** | **Created** — `Reservation__c`, 30 rows; string `Restaurant_ID__c` (not a lookup) |
| **CRM — FAQ records** | **Not created** — no FAQ custom object; policy Q&A lives partly in `Parking_Policy__c` / long text only |
| **Data 360 — FAQs** | **Not detected** via CLI (configure in Data Cloud UI; document DLO/DMO names here when built) |
| **Data 360 — Menus** | **Not created** — menu content currently on `Restaurant__c.Menu_Details__c` only |
| **Agentforce agent** | **Created** — `Ambika_Monday_Demo_Agent` (published); default router template, **no FAQ/RAG wired** |
| **Knowledge articles** | 42 **Draft** `Knowledge__kav` records — **not** restaurant FAQ corpus (0 Online) |

**In this git repo:** agent metadata + `.agent` bundle only. **`Restaurant__c` / `Reservation__c` are org-only** until retrieved into `force-app`.

---

## CRM data created in the org

### `Restaurant__c` (label: Restaurant)

**Record count:** 5

| API field | Type | Populated | Spec alignment |
|-----------|------|-----------|----------------|
| `Restaurant_ID__c` | Text | Yes — business PK (e.g. `REST-ATX-01`) | Matches spec `restaurant_id` concept |
| `Name__c` | Text | Yes — display name | Matches spec **Name** |
| `Zip_Code__c` | Text | Yes | Matches spec **Zip Code** |
| `Phone_Number__c` | Phone | Yes | Matches spec **Phone number** |
| `Operating_Hours__c` | Long text | Yes — detailed hours | Matches spec **Hours** |
| `Menu_Details__c` | Long text | Yes — full menu narrative | Spec **Menus** (CRM path / Phase 1 blurb) |
| `Parking_Policy__c` | Long text | Yes — FAQ-like parking content | Partial FAQ substitute |
| `Name` | Auto Name | Auto (record name) | Not used as display name |

**Not on object yet (spec gaps):**

- Street address
- Escalation phone (`escalation_phone_number` for agent handoff)
- Master-detail or lookup to `Reservation__c`

**Current rows (demo brand “TableCraft”):**

| `Restaurant_ID__c` | `Name__c` | `Zip_Code__c` |
|--------------------|-----------|---------------|
| `REST-ATX-01` | TableCraft Austin | 78701 |
| `REST-NYC-01` | TableCraft Manhattan | 10012 |
| `REST-LA-03` | TableCraft West Hollywood | 90069 |
| `REST-CHI-02` | TableCraft River North | 60654 |
| `REST-MIA-01` | TableCraft South Beach | 33139 |

**Phase 1 FAQ suggestion:** Use **`REST-ATX-01` (TableCraft Austin)** as default test restaurant — rich sample text in hours, menu, and parking fields.

Example SOQL:

```sql
SELECT Restaurant_ID__c, Name__c, Zip_Code__c, Phone_Number__c,
       Operating_Hours__c, Parking_Policy__c, Menu_Details__c
FROM Restaurant__c
WHERE Restaurant_ID__c = 'REST-ATX-01'
```

---

### `Reservation__c` (label: Reservation)

**Record count:** 30  
**Owner / phase:** Luke — **Phase 3** bookings subagent (not FAQ Phase 1).

| API field | Type | Notes |
|-----------|------|--------|
| `Reservation_ID__c` | Text | Business PK (e.g. `RES-001`) |
| `Restaurant_ID__c` | Text | Links to restaurant by ID string — **not** a Salesforce relationship field |
| `Party_Size__c` | Number | |
| `Reservation_Time__c` | DateTime | |
| `Status__c` | Text | e.g. `Active`, `Completed` |
| `Contact_ID__c` | Number | Placeholder / demo |

**Reservations by restaurant (approx.):**

| `Restaurant_ID__c` | Count |
|--------------------|-------|
| `REST-NYC-01` | 9 |
| `REST-CHI-02` | 7 |
| `REST-ATX-01` | 7 |
| `REST-LA-03` | 5 |
| `REST-ATX-02` | 2 |

**Data quality note:** `REST-ATX-02` appears on reservations but **no** matching `Restaurant__c` row (5 restaurants only). `REST-MIA-01` has **no** reservations in this breakdown. Fix or document before bookings demo.

---

### Other custom objects (not restaurant demo core)

| Object | Records | Relevance |
|--------|---------|-----------|
| `CustomerAddress__c` | 250 | Unrelated demo / template data |
| `Loyalty__c` | (not counted) | Unrelated |
| `SME__c` | (not counted) | Unrelated |

---

## Agent & messaging data in the org

### `Ambika_Monday_Demo_Agent`

| Item | State |
|------|--------|
| Bot / agent definition | Present in org (`Ambika_Monday_Demo_Agent`) |
| Local `.agent` bundle | `force-app/.../Ambika_Monday_Demo_Agent.agent` |
| Knowledge / RAG | **Empty** — `rag_feature_config_id: ""`, citations off |
| Subagents in bundle | Template: `agent_router`, `escalation`, `off_topic`, `ambiguous_question` — **no `faq_subagent`** |
| Bot user | `ambika_monday_demo_agent@00dg700000m98ec572901936.ext` |
| Context variables | Messaging session fields (`MessagingEndUser`, `MessagingSession`, etc.) |

### Other GenAI functions in org (sample)

Org includes many template actions (e.g. `AnswerQuestionsWithKnowledge_*`, `FinalizeReservation_*`, `GetReservationTimeSlots_*`). These are **not** verified as wired to `Restaurant__c` / `Reservation__c` for this demo agent.

---

## Knowledge (`Knowledge__kav`)

| Metric | Value |
|--------|--------|
| Total articles | 42 |
| Online | 0 |
| Draft | 42 |

**Not** used as the restaurant FAQ source today. Phase 1 FAQ can ignore these unless you deliberately publish TableCraft FAQs here instead of Data 360.

---

## Data 360 (Data Cloud) — current vs planned

### What exists today

CLI could not list Data Cloud metadata types (`DataLakeObjectDefinition`, etc.) from this org connection — typical until objects are created and API access is confirmed.

**Assumption for this doc:** No restaurant **FAQ** or **Menu** lakehouse objects are documented in git or wired to the demo agent yet.

When you create assets in the UI, **fill in the table below** in this file:

| Asset | Developer name / ID | Status |
|-------|---------------------|--------|
| Data space | | TBD |
| FAQ DLO / file ingest | | TBD |
| FAQ DMO | | TBD |
| Search index | | TBD |
| Retriever (for Agent Script `knowledge`) | | TBD |
| Menu DLO / DMO | | Deferred (Phase 2+) |

---

### What we need to create for Data 360 (Phase 1 FAQ — Ambika)

Goal: **RAG over restaurant FAQs** keyed by `restaurant_id`, while CRM keeps structured hours / phone / menu blurb for Path A or hybrid demos.

#### 1. FAQ corpus (required for Path B)

**Recommended ingest:** CSV or structured file upload → Data Lake Object.

**Logical schema (minimum columns):**

| Column | Type | Required | Example |
|--------|------|----------|---------|
| `restaurant_id` | Text | Yes | `REST-ATX-01` |
| `question` | Text | Yes | `Do you offer gluten-free options?` |
| `answer` | Text | Yes | Short answer aligned with `Menu_Details__c` / policies |
| `category` | Text | No | `dietary`, `hours`, `parking`, `reservations`, `general` |
| `source` | Text | No | `demo_v1` |
| `last_updated` | Date | No | |

**Volume (Phase 1):** ~10–15 rows for **`REST-ATX-01`** first; optionally duplicate pattern for other TableCraft IDs later.

**Content sources to mine when writing FAQs:**

- Existing `Operating_Hours__c`, `Parking_Policy__c`, `Menu_Details__c` on each `Restaurant__c` row
- New Q&A not fully covered in long text (dress code, large parties, escalation policy, “how to change a reservation”)

**Suggested starter FAQ categories for Austin demo:**

- Hours / holidays / brunch
- Parking / valet
- Dietary (gluten-free, allergies)
- Reservations policy (changes → human / bookings agent later)
- Menu highlights (“do you have…?”)
- Location / contact (phone; add address when field exists on CRM)

#### 2. Data Cloud pipeline (required for Path B)

| Step | Deliverable |
|------|-------------|
| Ingest | FAQ CSV → **DLO** (e.g. `Restaurant_FAQ__dlm` or team naming convention) |
| Model | **DMO** with fields above; map from DLO |
| Identity | Include `restaurant_id` on every row for **filtering at retrieval time** |
| Search | **Search index** on `question` + `answer` (and optionally `category`) |
| Agent link | **Retriever** ID → set `knowledge.rag_feature_config_id` (or equivalent) on FAQ agent / subagent |

**Retrieval behavior (design):**

- FAQ subagent receives `restaurant_id` (default `REST-ATX-01` in Phase 1).
- Retriever queries should **scope to that restaurant** (filter / metadata predicate — exact mechanism depends on retriever config in org).

#### 3. Menus in Data 360 (deferred)

| Item | Phase | Notes |
|------|-------|--------|
| Menu line items (SKU, price, dietary tags) | **Phase 2+** | CRM `Menu_Details__c` is enough for Phase 1 chat FAQ |
| Menu DLO/DMO | Later | Optional when “do you have X on the menu” needs structured RAG vs one text blob |

**If menus are added later, suggested schema:**

| Column | Example |
|--------|---------|
| `restaurant_id` | `REST-ATX-01` |
| `item_name` | Truffle Mac & Cheese |
| `category` | Sides |
| `description` | … |
| `dietary_tags` | vegetarian, gluten-free optional |
| `available` | true |

#### 4. CRM ↔ Data 360 alignment

| Concept | CRM today | Data 360 target |
|---------|-----------|-----------------|
| Restaurant key | `Restaurant__c.Restaurant_ID__c` | Same string on every FAQ (and future menu) row |
| Hours / phone | Long text / phone field | FAQ answers should **not contradict** CRM; CRM can remain source of truth for “call this number” |
| Bookings | `Reservation__c` | Out of Data 360 scope for FAQ Phase 1 |

---

## Gaps vs [product spec](./restaurant-phone-agent-spec.md)

| Spec need | Org today | Action |
|-----------|-----------|--------|
| `escalation_phone_number` | Missing on `Restaurant__c` | Add field + populate per restaurant |
| Street address | Missing | Add for Phase 2 lookup / disambiguation |
| Lookup Restaurants → Bookings | Text `Restaurant_ID__c` only | Optional: master-detail or lookup + fix `REST-ATX-02` orphan |
| FAQ object or Data 360 FAQ | Neither wired to agent | Create Data 360 FAQ set **or** CRM FAQ child object (Path A) |
| `faq_subagent` | Not in `.agent` | Implement in Phase 1 |
| RAG | Disabled | Create retriever + link after Data 360 FAQ index |

---

## Suggested next steps (data only)

1. **Confirm Phase 1 restaurant:** `REST-ATX-01`.
2. **Draft FAQ CSV** (10–15 rows) consistent with Austin CRM text.
3. **Ingest FAQ CSV in Data Cloud** → DLO → DMO → search index → retriever; record names in the asset table above.
4. **Optional CRM:** add `Escalation_Phone__c` (and `Street_Address__c`) on `Restaurant__c` for escalation demos.
5. **Retrieve metadata to git** when stable: `sf project retrieve start -m CustomObject:Restaurant__c -m CustomObject:Reservation__c --target-org agentforce-org`.

---

## Change log

| Date | Change |
|------|--------|
| 2026-10-26 | Initial inventory from `agentforce-org` queries; Data 360 planned FAQ schema |
