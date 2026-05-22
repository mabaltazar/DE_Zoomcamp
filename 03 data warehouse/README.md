# 🏛️ Data Engineering Zoomcamp — Module 3: Data Warehouse

## 📋 Overview
This module covers data warehouse concepts and BigQuery — Google's serverless,
highly scalable cloud data warehouse. Topics include the distinction between
OLAP and OLTP systems, BigQuery's architecture and internals, partitioning and
clustering strategies for cost and performance optimization, best practices, and
machine learning directly inside BigQuery using SQL.

---

## 🏗️ What I Learned
- The architectural and purpose differences between OLTP and OLAP systems
- How data warehouses are structured and how data flows into them
- BigQuery's serverless architecture and separation of storage from compute
- How to design cost-efficient tables using partitioning and clustering
- BigQuery internals — Colossus, Jupiter, Dremel, and columnar storage
- How to train and deploy ML models using only SQL in BigQuery ML

---

## 🛠️ Stack
![BigQuery](https://img.shields.io/badge/BigQuery-4285F4?style=flat&logo=googlebigquery&logoColor=white)
![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=flat&logo=googlecloud&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=flat&logo=postgresql&logoColor=white)

---

## 📚 Topics Covered

### 🔄 OLAP vs OLTP
- Purpose, design, and use case differences
- When to use a data warehouse vs a transactional database
- User profiles and productivity impacts of each system type

### 🏛️ Data Warehouse Concepts
- Raw data, metadata, and summary layers
- Data flow: source systems → staging area → warehouse → data marts
- How different user groups access different layers of the warehouse

### ☁️ BigQuery Overview
- Serverless architecture — no servers, no installs, no capacity planning
- Separation of storage (Colossus) and compute (Dremel) via Jupiter network
- Built-in ML, geospatial analysis, and BI integration
- On-demand vs flat-rate pricing models

### 🗂️ Partitioning
- Time-unit column, ingestion time, and integer range partition types
- Daily, hourly, monthly, and yearly partition granularity
- 4,000 partition limit and how to work within it
- How partition pruning reduces bytes scanned and query cost

### 🔲 Clustering
- How clustering sorts data within blocks for block-level pruning
- Supported column types and up to 4 clustering columns
- Column order significance — most selective column first
- Automatic re-clustering by BigQuery in the background

### ⚖️ Partitioning vs Clustering
- Cost visibility tradeoffs — known upfront vs unknown
- When to use each, and when to combine both
- When clustering alone is preferable to partitioning

### 💡 Best Practices
- Cost reduction: avoid `SELECT *`, price before running, materialize stages
- Performance: filter on partition columns, denormalize, optimize JOIN order
- Anti-patterns: oversharding, `WITH` clauses as prepared statements, `ORDER BY` early

### 🔧 BigQuery Internals
- Colossus — distributed file storage in columnar Capacitor format
- Jupiter — petabit network connecting storage and compute
- Dremel — distributed query execution tree (root → mixers → leaf nodes)
- Column-oriented vs record-oriented storage and why it matters

### 🤖 Machine Learning in BigQuery
- Target audience: analysts and managers using SQL only
- No Python, no data export, no separate deployment
- Model types: regression, classification, clustering, time series, anomaly detection
- `CREATE MODEL` → `ML.EVALUATE` → `ML.PREDICT` workflow
- Free tier: 10 GB storage, 1 TB queries, first 10 GB of training per month

---

## 🗂️ Architecture

### Data Warehouse Structure
```
Source Systems
    ├── OLTP Databases
    ├── Flat Files          ──→ Staging Area ──→ Data Warehouse ──→ Data Marts ──→ Users
    └── Operational Systems
                                                      ↕
                                              Raw Data / Metadata
                                              / Summary Data
```

### BigQuery Internal Architecture
```
Client (REST API / Web UI / bq CLI)
    ↓
Client Interface
    ↓
Dremel (Query Execution Engine)
    ├── Root Server    — receives query, coordinates result aggregation
    ├── Mixer Nodes    — combine partial results from leaf nodes
    └── Leaf Nodes     — read column data from Colossus, execute sub-queries
         ↕  (Jupiter — petabit network)
Colossus (Distributed Storage)
    └── Data stored in columnar Capacitor format
```

### Dremel Query Execution
```
Query: SELECT A, COUNT(B) FROM T GROUP BY A
    ↓
Root Server
    ├── Mixer 11 ──→ Leaf 21 ──→ Colossus (subset of data)
    ├── Mixer 12 ──→ Leaf 22 ──→ Colossus (subset of data)
    │            ──→ Leaf 23 ──→ Colossus (subset of data)
    └── Mixer 13 ──→ Leaf 24 ──→ Colossus (subset of data)

Each leaf reads only relevant columns from storage.
Results flow back up: partial counts → mixed aggregates → final result.
```

### BigQuery ML Workflow
```
Raw Data in BigQuery
    ↓ Feature engineering (SQL)
    ↓ CREATE MODEL → train/test split → cross validation
Trained Model (stored in BigQuery)
    ↓ ML.EVALUATE → performance metrics
    ↓ ML.PREDICT  → scored results back into BigQuery
```

---

## 📁 Key Files
| File | Description |
|------|-------------|
| `'03 data warehouse'/big_query_ml.sql | |
| `'03 data warehouse'/big_query.sql | |
| `'03 data warehouse'/model_deploy.md | |

---

## 🔗 References
- [BigQuery Documentation](https://cloud.google.com/bigquery/docs/how-to)
- [Dremel Paper — Google Research](https://research.google/pubs/pub36632/)
- [BigQuery Architecture Overview](https://panoply.io/data-warehouse-guide/bigquery-architecture/)
- [A Look at Dremel](http://www.goldsborough.me/distributed-systems/2019/05/18/21-09-00-a_look_at_dremel/)

