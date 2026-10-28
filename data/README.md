# Demo data files

| File | Purpose |
|------|---------|
| `ambika_restaurant_faq.csv` | **Data 360 ingest** (optional) — hours, parking, menu, phone, zip per restaurant |
| `restaurant__c_records.csv` | Org export of `Restaurant__c` (refresh via [pull-from-org.md](../docs/setup/pull-from-org.md)) |
| `reservation__c_records.csv` | Org export of `Reservation__c` |
| `data360_assets.json` | Data Cloud lake objects + RAG/retriever IDs wired in org (not MDAPI-retrievable) |

## Data 360 (manual in org UI)

1. **Data Cloud** → Ingest → Upload `ambika_restaurant_faq.csv` (if using CSV corpus)
2. Create **DLO** → map to **DMO** (`restaurant_id`, `category`, `question`, `answer`, `source`)
3. Create **search index** on question + answer
4. Create **retriever**; copy ID into agent `knowledge.rag_feature_config_id`

See [ambika_schema.md](../docs/ambika_schema.md).
