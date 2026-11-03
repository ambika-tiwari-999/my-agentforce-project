# Data Lake Objects (DLOs), Metadata, Retrievers, and Real-World Ingestion

This guide explains how Data 360 (`agentforce-org`) stores, chunks, indexes, and retrieves restaurant FAQ and menu documents, based on the actual objects and schemas inspected in our org.

---

## 1. What a Data Lake Object (DLO) Is

In Salesforce Data 360 (Data Cloud), when you create an **Agentforce Data Library** (in our org, `ADL_Diner_Restauran` with library ID `1JDg7000005k8HRGAY`), Salesforce automatically provisions **three linked Data Lake Objects (`__dll` / `__dlm`)** behind the scenes:

| Table Name in `agentforce-org` | Queryable API Name | Category | Total Fields | What It Stores |
| :--- | :--- | :--- | :--- | :--- |
| **`ADL_Diner_Restauran`** | `ADL_Diner_Restauran__dlm` | `Directory Table` | 18 | **One row per uploaded file.** Stores the file path (`FILEPATH__C`), MIME type (`CONTENTTYPE__C`), byte size (`SIZE__C`), ETag hash (`ETAG__C`), and file-level metadata (`METADATA__C`, `COL1__C`–`COL5__C`). |
| **`ADL_Diner_Restauran chunk`** | `ADL_Diner_Restauran_chunk__dlm` | `Content` | 14 | **One row per text chunk** extracted from the files in `ADL_Diner_Restauran__dlm`. Stores the raw chunk string (`Chunk__c`), sequence number (`ChunkSequenceNumber__c`), citation info (`Citations__c`), and foreign key back to the parent file (`SourceRecordId__c`). |
| **`ADL_Diner_Restauran index`** | `ADL_Diner_Restauran_index__dlm` | `Vector Embedding` | 10 | **One row per vector embedding.** Stores the float array embedding (`VectorEmbedding__c`), the chunk text (`Chunk__c`), and the foreign key (`SourceRecordId__c`) linking back to `ADL_Diner_Restauran_chunk__dlm`. |

### What is currently inside `ADL_Diner_Restauran__dlm` in our org
Querying `SELECT FIELDS(ALL) FROM ADL_Diner_Restauran__dlm` returns 1 file row:
- `ID`: `qGw000B33eGXMmOCCX`
- `FILEPATH__C`: `1JDg7000005k8HRGAY/Diner & Restaurant FAQ and Policies.pdf`
- `RESOLVEDFILEPATH__C`: `ADL_Diner_Restauran__dll:1JDg7000005k8HRGAY/Diner & Restaurant FAQ and Policies.pdf`
- `CONTENTTYPE__C`: `application/pdf`
- `SIZE__C`: `246711`
- `METADATA__C`: `null`

---

## 2. How Metadata Works Within the DLO

There are two levels of columns across those three tables:

### A. Directory Table (`ADL_Diner_Restauran__dlm` — File-Level Metadata)
Every uploaded file row has these 18 columns:
- `FILEPATH__C` (`String`) — `<LibraryId>/<FileName>` (e.g. `1JDg7000005k8HRGAY/REST-ATX-01_Menu.pdf`)
- `CONTENTTYPE__C` (`String`) — e.g. `application/pdf`
- `METADATA__C` (`String`) — JSON/key-value metadata string attached during ingestion
- `COL1__C`, `COL2__C`, `COL3__C`, `COL4__C`, `COL5__C` (`String`) — 5 custom attribute slots available on the directory table
- `SIZE__C`, `LASTMODIFIED__C`, `ETAG__C`, `PARENTID__C`

### B. Chunk & Index Tables (`ADL_Diner_Restauran_chunk__dlm` & `ADL_Diner_Restauran_index__dlm`)
Every chunk row has these columns:
- `RecordId__c` (`String`) — Primary key of the chunk
- `SourceRecordId__c` (`String`) — Foreign key pointing to the file row `Id` in `ADL_Diner_Restauran__dlm` (via the relationship `rel_1793063003969_end__c`)
- `Chunk__c` (`String`) — The actual text passage extracted from the PDF
- `ChunkSequenceNumber__c` (`Double`) — Order of the chunk within the PDF (`1, 2, 3...`)
- `Citations__c` (`String`) — Source file/page citation metadata
- `MediaSource__c`, `ChunkType__c`, `ChunkFormat__c`

### How `restaurant_id` links to chunks
Because `ADL_Diner_Restauran_chunk__dlm` links to `ADL_Diner_Restauran__dlm` via `SourceRecordId__c` (and also stores the text in `Chunk__c`), there are two ways a chunk knows its `restaurant_id`:
1. **Relational / File Metadata:** The parent file row in `ADL_Diner_Restauran__dlm` has `FILEPATH__C` (e.g. `.../REST-ATX-01_Menu.pdf`) or `METADATA__C` / `COL1__C = 'REST-ATX-01'`, which joins to `ADL_Diner_Restauran_chunk__dlm` via `SourceRecordId__c`.
2. **Embedded Chunk Prefix:** Every page/section of the PDF includes `[restaurant_id: REST-ATX-01]`, so every `Chunk__c` row in `ADL_Diner_Restauran_chunk__dlm` directly contains the string `REST-ATX-01`.

---

## 3. What the Default Settings of an Einstein Retriever Are

When you create an **Agentforce Data Library** (`ADL_Diner_Restauran`), Salesforce automatically creates a **default Einstein Retriever** (`File_Diner_Restaurant_FAQ_and_Policies_1Cx_8Ec8b60f20d`).

Yes — **using the auto-created default retriever is the standard starting point in Salesforce**, and then teams either tune it in **Einstein Studio → Retrievers** or create a custom retriever on the same Search Index if they need custom filters.

### Default settings of an Agentforce Data Library Retriever:
1. **Search Type:** **Hybrid Search** (combines dense vector similarity on `VectorEmbedding__c` + keyword/BM25 matching on `Chunk__c` and merges the scores with Reciprocal Rank Fusion).
2. **Search Index Object:** `ADL_Diner_Restauran_index__dlm`
3. **Chunk Object Returned:** `ADL_Diner_Restauran_chunk__dlm` (`Chunk__c`)
4. **Filter Conditions:** **None by default** (searches across all files in `ADL_Diner_Restauran` unless you add a filter condition in Einstein Studio).
5. **Top \(K\) Results Returned:** **Default is 5–10 chunks** per query.
6. **Fields Returned:** `Chunk__c` (and `Citations__c` when citations are enabled).

---

## 4. How Document Text & Metadata Are Chunked, What RAG Returns, and Where the Code Lives

### A. How Data 360 Chunks a PDF (Search Index Settings)
When a PDF lands in `ADL_Diner_Restauran__dlm`, Data 360's unstructured pipeline runs:
1. **Text Extraction / Parse:** Extracts text and HTML/markdown structure (headings, paragraphs, tables) from the PDF.
2. **Chunking Strategy (Default):** **Passage / Semantic HTML-aware chunking**
   - **Max tokens per chunk:** ~**512 tokens** (~350–400 words)
   - **Chunk overlap:** ~**50–64 tokens** (so a sentence split across two chunks isn't lost)
   - **Header prepending:** Section titles / document headers are prepended to chunks when detected.
3. **Embedding Generation:** Passes each `Chunk__c` through the embedding model (e.g. `sfdc_ai__DefaultTextEmbeddingAda002` / E5 multilingual) and writes the vector into `ADL_Diner_Restauran_index__dlm.VectorEmbedding__c`.

### B. Where to View or Edit Chunking & Retriever Settings in the Org
Chunking and index settings are **org configuration in Data Cloud**, not XML files in git:
- **To edit chunk size / overlap / vector model:** Go to **App Launcher → Data Cloud → Search Indexes → `ADL_Diner_Restauran index`**.
- **To edit Retriever filters / Top \(K\) results / returned fields:** Go to **App Launcher → Einstein Studio → Retrievers → `File_Diner_Restaurant_FAQ_and_Policies`**.

### C. Where the Code Lives in Git (and How We Call & Edit It in Apex)
In our repository, the Apex class that will execute retrieval for `subagent faq` is:
- **File:** [`force-app/main/default/classes/CLL_DiningKnowledgeRetriever.cls`](../../force-app/main/default/classes/CLL_DiningKnowledgeRetriever.cls)

In Apex, there are two ways to query Data 360 from `CLL_DiningKnowledgeRetriever.cls`:
1. **Via ConnectApi / Invocable Action (`getEinsteinRetrieverResults` or `ConnectApi.CdpQuery`):**
   - Calls the Einstein Retriever (`File_Diner_Restaurant_FAQ_and_Policies_1Cx_8Ec8b60f20d`) or Data Cloud semantic search function `vector_search(TABLE(ADL_Diner_Restauran_index__dlm), :query, '', 5)` via ANSI SQL / SOQL.
2. **Direct SOQL / Data Cloud Query on `ADL_Diner_Restauran_chunk__dlm`:**
   - Queries `SELECT Chunk__c, Citations__c, SourceRecordId__c FROM ADL_Diner_Restauran_chunk__dlm` (filtering by `restaurantId` on the parent file or chunk content).

What `CLL_DiningKnowledgeRetriever.cls` returns to `subagent faq`:
- `hasSource` (`Boolean`): `true` if matching passages were found.
- `passages` (`String`): The joined `Chunk__c` strings returned from Data 360.

---

## 5. How Uploading to This DLO Works: Our Sandbox vs. Real-World OpenTable Scale

### A. How Uploading Works in Our Sandbox (`agentforce-org`) Today
Because `ADL_Diner_Restauran` was created as an **Agentforce Data Library (File Upload type)**:
1. You open **Setup → Agentforce Data Library → `ADL_Diner_Restauran`** and upload a PDF file.
2. Salesforce stores the file in Data Cloud's internal S3 bucket under the prefix `1JDg7000005k8HRGAY/<filename>.pdf`.
3. A new row appears in `ADL_Diner_Restauran__dlm`, and Data Cloud automatically triggers the chunking + embedding job to populate `ADL_Diner_Restauran_chunk__dlm` and `ADL_Diner_Restauran_index__dlm`.

*(Note: In our sandbox right now, `SELECT COUNT() FROM ADL_Diner_Restauran_chunk__dlm` returned `0` rows because `HYDRATIONSTATUS` on `ADL_Diner_Restauran chunk` is currently `Unhydrated` — meaning the Search Index in Data Cloud needs to be rebuilt/refreshed after upload so chunks populate!)*

### B. How a Real Company Like OpenTable / TableCraft Would Do This in Production
At OpenTable scale (50,000+ restaurants updating menus, seasonal hours, and policies daily), **no human admin would manually upload PDFs in Salesforce Setup**.

In production, there are two standard ingestion pipelines into Data 360:

#### Pattern 1: Unstructured File Connector (Amazon S3 / GCS / Azure Blob → Data 360 DLO)
When restaurants upload PDF menus in their merchant portal (e.g., "TableCraft for Restaurants"):
1. **Merchant Portal Upload:** The restaurant owner (authenticated as `restaurant_id = REST-ATX-01`) uploads `dinner_menu.pdf` in the web app.
2. **Backend writes PDF + Sidecar Metadata to S3:** The backend saves:
   - `s3://tablecraft-menus/REST-ATX-01/dinner_menu.pdf`
   - A metadata payload (or S3 object tags) containing `{"restaurant_id": "REST-ATX-01", "category": "menu", "updated_at": "2026-10-30"}`.
3. **Data 360 S3 File Notification Pipeline:** Data 360's S3 connector listens to `s3://tablecraft-menus/` via SQS/EventBridge. Whenever a PDF is added or updated, Data 360 automatically ingests the file into `ADL_Diner_Restauran__dlm`, populates `METADATA__C` / `COL1__C = 'REST-ATX-01'`, chunks the PDF, and updates the vector index with zero human intervention.

#### Pattern 2: Structured / Semi-Structured Ingestion API (JSON / CSV → Data 360 Ingestion API)
For menus and FAQs that are already structured in a merchant database (dish name, description, price, dietary tags, policy Q&A):
1. The backend pushes JSON records to the **Data 360 Ingestion API** with explicit columns: `restaurant_id`, `category`, `title`, `content`.
2. Data 360 maps `restaurant_id` directly as a filterable column on the DMO (`Restaurant_Knowledge__dlm`) and chunks/embeds only the `content` column.
3. The Einstein Retriever applies an exact pre-filter (`WHERE restaurant_id__c = :restaurantId`) before running vector search.
