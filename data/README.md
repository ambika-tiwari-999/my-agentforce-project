# Demo data files

| File | Purpose |
|------|---------|
| `ambika_restaurants_core.csv` | CRM load for `Ambika_Restaurant__c` (`Name`, `Restaurant_ID__c`, `Name__c`) |
| `ambika_restaurants.csv` | Full row incl. phone/zip/address — use after extra fields are active in org |
| `ambika_reservations.csv` | `Ambika_Reservation__c` (29 rows; skipped 2 orphan `REST-ATX-02`) |
| `ambika_restaurant_faq.csv` | **Data 360 ingest** — hours, parking, menu, phone, zip per restaurant |

## Data 360 (manual in org UI)

1. **Data Cloud** → Ingest → Upload `ambika_restaurant_faq.csv`
2. Create **DLO** → map to **DMO** (`restaurant_id`, `category`, `question`, `answer`, `source`)
3. Create **search index** on question + answer
4. Create **retriever**; copy ID into agent `knowledge.rag_feature_config_id`

See [ambika_schema.md](../docs/ambika_schema.md).
