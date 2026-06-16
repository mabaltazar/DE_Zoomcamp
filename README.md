# 🚕 Data Engineering Zoomcamp by DataTalks.Club

My notes, code, and projects from the 
[DataTalks.Club Data Engineering Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp).

---

## 📦 Module 1: Containerization and Infrastructure ✅

### 🏗️ What I Built
A fully containerized data ingestion pipeline that downloads NYC Yellow Taxi trip data (~1.4M rows), processes it with pandas, and loads it into PostgreSQL — parameterized via CLI and reproducible on any machine via Docker.

A cloud infrastructure setup using Terraform that provisions a GCS bucket (Data Lake) and BigQuery dataset (Data Warehouse) on GCP.

A reproducible Codespaces dev environment using devcontainer that auto-installs all tools on every rebuild — built beyond the course scope.


### 🛠️ Stack

#### Docker & Data Ingestion
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=flat&logo=pandas&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat&logo=docker&logoColor=white)
![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-D71F00?style=flat&logo=sqlalchemy&logoColor=white)
![uv](https://img.shields.io/badge/uv-DE5FE9?style=flat&logo=astral&logoColor=white)
![click](https://img.shields.io/badge/click-4CAF50?style=flat&logo=python&logoColor=white)

#### Cloud Infrastructure
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white)
![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=flat&logo=googlecloud&logoColor=white)
![BigQuery](https://img.shields.io/badge/BigQuery-4285F4?style=flat&logo=googlebigquery&logoColor=white)

### 🗂️ Architecture
```
Internet (NYC TLC data)
    ↓
taxi_ingest container (Python + pandas + click)
    ↓ writes to
pgdatabase container (PostgreSQL 18)
    ↑ browsed via
pgAdmin container (port 8085)

All containers communicate via Docker Compose network.
Data persists in named Docker volumes.
```

### 📚 Topics Covered
**Docker** — container lifecycle, volumes, networking, Dockerfiles, layer caching, Docker Compose for multi-container orchestration

**Python Environments** — virtual environments with `uv`, `pyproject.toml` + `uv.lock` for reproducible dependency management

**Data Ingestion** — chunked CSV ingestion with pandas, type handling, SQLAlchemy for database connectivity parameterized CLI with click

**Terraform & GCP** — IaC concepts, provisioning GCS and BigQuery, IAM setup, full `init → plan → apply → destroy` workflow

**Dev Environment** *(beyond course scope)* — GitHub Codespaces devcontainer with auto-install of Terraform, gcloud, Docker, and git-lfs

### 📁 Key Files
| File | Description    |
|------|-------------|
| `01-docker-terraform/docker-sql/pipeline/ingest_data.py` | Parameterized ingestion script |
| `01-docker-terraform/docker-sql/pipeline/Dockerfile` | Container definition for ingestion |
| `01-docker-terraform/docker-sql/pipeline/docker-compose.yaml` | Full local stack (Postgres + pgAdmin) |
| `01-docker-terraform/docker-sql/pipeline/pyproject.toml` | Python dependencies |
| `01-docker-terraform/terraform-gcp/main.tf` | GCP resources |
| `01-docker-terraform/terraform-gcp/variables.tf` | Input variables |
| `.devcontainer/devcontainer.json` | Codespaces configuration |

---

## 🔄 Module 2: Workflow Orchestration ✅

### 🏗️ What I Built
Two complete data pipelines orchestrated with Kestra — one ETL pipeline loading NYC Taxi data into a local PostgreSQL database, and one ELT pipeline loading the full historical dataset into Google Cloud Storage and BigQuery. Both pipelines include scheduling, backfilling, and idempotent loading.

Also solved a real-world engineering challenge: configuring Kestra secrets
without the Enterprise edition by using Base64-encoded environment variables
injected via Docker Compose.

### 🛠️ Stack
![Kestra](https://img.shields.io/badge/Kestra-6228D7?style=flat&logo=kestra&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)
![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=flat&logo=googlecloud&logoColor=white)
![BigQuery](https://img.shields.io/badge/BigQuery-4285F4?style=flat&logo=googlebigquery&logoColor=white)
![DuckDB](https://img.shields.io/badge/DuckDB-FFC107?style=flat&logo=duckdb&logoColor=black)

### 🗂️ Architecture

```
Local ETL (Postgres)                    Cloud ELT (GCP)
────────────────────                    ───────────────
GitHub (CSV files)                      GitHub (CSV files)
↓ extract                               ↓ extract
Kestra internal storage                 Kestra internal storage
↓ COPY IN → staging table               ↓ upload
↓ MD5 hash + MERGE                  GCS bucket (Data Lake)
PostgreSQL (ny_taxi)                        ↓ external table → CTAS
BigQuery (Data Warehouse)
partitioned by date
```

### 📚 Topics Covered
**Workflow Orchestration** — ETL vs ELT, orchestrators vs cron jobs,
Kestra vs Airflow, scheduling and event-based triggers

**Kestra Fundamentals** — flows, tasks, inputs, outputs, variables,
plugin defaults, concurrency, `trigger.date` for scheduled pipelines

**Local ETL Pipeline** — staging + MERGE pattern for idempotent loads,
MD5 deduplication, PostgreSQL COPY IN for bulk loading, backfill support

**Cloud ELT Pipeline** — GCS as Data Lake, BigQuery as Data Warehouse,
external tables, CTAS transformations, date partitioning, full dataset backfill

**Secrets Management** *(beyond course scope)* — configuring Kestra secrets
without Enterprise edition using Base64-encoded env vars via Docker Compose

### 📁 Key Files
| File | Description |
|------|-------------|
| `02-workflow-orchestration/flows/04_postgres_taxi.yaml` | ETL pipeline — manual trigger |
| `02-workflow-orchestration/flows/05_postgres_taxi_scheduled.yaml` | ETL pipeline — scheduled + backfill |
| `02-workflow-orchestration/flows/08_gcp_taxi.yaml` | ELT pipeline — manual trigger |
| `02-workflow-orchestration/flows/09_gcp_taxi_scheduled.yaml` | ELT pipeline — scheduled + full backfill |
| `02-workflow-orchestration/docker-compose.yaml` | Full stack with Kestra + Postgres + pgAdmin |
| `.env.example` | Template for GCP credentials setup |

---

## 🏛️ Module 3: Data Warehouse ✅

### 🏗️ What I Learned
The theory and practice of data warehousing using BigQuery — covering OLAP vs
OLTP fundamentals, BigQuery's serverless architecture, table design strategies
for cost and performance optimization, the internals of how BigQuery processes
queries at petabyte scale, and how to train and serve ML models directly in
BigQuery using only SQL.

### 🛠️ Stack
![BigQuery](https://img.shields.io/badge/BigQuery-4285F4?style=flat&logo=googlebigquery&logoColor=white)
![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=flat&logo=googlecloud&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=flat&logo=postgresql&logoColor=white)

### 🗂️ Architecture
```
BigQuery Internal Architecture
──────────────────────────────
Client (REST API / Web UI / bq CLI)
    ↓
Dremel — distributed query execution tree
    ├── Root Server    → coordinates aggregation
    ├── Mixer Nodes    → combine partial results
    └── Leaf Nodes     → read columnar data from storage
         ↕ Jupiter (petabit network)
Colossus — distributed columnar storage (Capacitor format)

Partition pruning → skips entire date partitions
Cluster pruning  → skips storage blocks within partitions
Both together    → maximum cost and performance efficiency
```

### 📚 Topics Covered
**OLAP vs OLTP** — purpose, design, backup, productivity, and user
differences between transactional and analytical systems

**Data Warehouse Structure** — raw data, metadata, summary layers,
staging areas, data marts, and user access patterns

**BigQuery Architecture** — serverless design, storage/compute separation,
on-demand vs flat-rate pricing, cost reduction strategies

**Partitioning** — time-unit, ingestion time, and integer range types;
daily/hourly/monthly/yearly granularity; 4,000 partition limit

**Clustering** — block-level pruning, column order significance,
supported types, automatic re-clustering, combining with partitioning

**Best Practices** — avoiding `SELECT *`, partition filtering,
JOIN optimization, denormalization, approximate aggregations

**BigQuery Internals** — Colossus, Jupiter, Dremel, columnar storage,
query execution tree, why column-oriented storage enables fast analytics

**BigQuery ML** — `CREATE MODEL` → `ML.EVALUATE` → `ML.PREDICT`
workflow; regression, classification, clustering, time series, anomaly detection

### 📁 Key Files
| File | Description |
|------|-------------|
| `03-data-warehouse/big_query_ml.sql` | BigQuery ML examples |
| `03-data-warehouse/big_query.sql` | Partitioning and clustering examples |
| `03-data-warehouse/model_deploy.md` | ML model deployment notes |

---

## 📊 Module 4: Analytics Engineering ✅

### 🏗️ What I Built
A complete dbt project transforming raw NYC Taxi trip data into a dimensional
model following Kimball's star schema methodology — staging models, an
intermediate union layer, dimension tables, and a fact table combining yellow
and green taxi data across 2019–2020.

### 🛠️ Stack
![dbt](https://img.shields.io/badge/dbt-FF694B?style=flat&logo=dbt&logoColor=white)
![DuckDB](https://img.shields.io/badge/DuckDB-FFC107?style=flat&logo=duckdb&logoColor=black)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat&logo=docker&logoColor=white)
![uv](https://img.shields.io/badge/uv-DE5FE9?style=flat&logo=astral&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=flat&logo=postgresql&logoColor=white)

### 🗂️ Architecture
```
sources (raw data in DuckDB prod schema)
    ↓
stg_green_tripdata    stg_yellow_tripdata    taxi_zone_lookup (seed)
         ↓                    ↓                      ↓
         └──────────┬─────────┘              dim_zones (mart)
                    ↓
           int_trips_unioned (intermediate)
                    ↓
               fct_trips (mart)
                    ↓
         report_monthly_revenue (mart)
```

### 📚 Topics Covered
**Analytics Engineering** — why the role exists, ETL vs ELT,
Kimball's dimensional modeling, star schema, the kitchen analogy

**dbt Fundamentals** — Core vs Cloud, Fusion engine, project structure,
materializations (view/table/incremental/ephemeral)

**dbt Sources** — `sources.yml`, `source()` vs `ref()`,
dependency graph, naming conventions (`stg_`, `int_`, `fct_`, `dim_`)

**dbt Models** — staging, intermediate, and mart layers;
reconciling yellow and green taxi schemas; business context in data decisions

**Seeds and Macros** — CSV lookup tables, Jinja templating,
reusable SQL functions as single source of truth

**dbt Tests** — singular, source freshness, generic (4 built-ins + custom),
unit tests (dbt v1.8+), model contracts for schema enforcement

**dbt Documentation** — `schema.yml` descriptions, meta tags,
`dbt docs generate` + `dbt docs serve`, lineage graph exploration

**dbt Packages** — `dbt-utils`, `dbt-expectations`, `dbt-codegen`,
surrogate key generation with `dbt_utils.generate_surrogate_key`

**dbt Commands** — full command reference: `dbt build`, `dbt retry`,
`--select` with graph operators, `--full-refresh`, state selectors


### 📁 Key Files
| File | Description |
|------|-------------|
| `04-analytics-engineering/taxi_rides_ny/models/staging/stg_green_tripdata.sql` | Green taxi staging |
| `04-analytics-engineering/taxi_rides_ny/models/staging/stg_yellow_tripdata.sql` | Yellow taxi staging |
| `04-analytics-engineering/taxi_rides_ny/models/intermediate/int_trips_unioned.sql` | Combined trips |
| `04-analytics-engineering/taxi_rides_ny/models/marts/fct_trips.sql` | Fact table |
| `04-analytics-engineering/taxi_rides_ny/models/marts/dim_zones.sql` | Zone dimension |
| `04-analytics-engineering/taxi_rides_ny/macros/get_payment_type_description.sql` | Payment type macro |
| `04-analytics-engineering/taxi_rides_ny/packages.yml` | dbt package declarations |
| `04-analytics-engineering/ingest.py` | Data download and DuckDB ingestion |
| `04-analytics-engineering/docker-compose.yaml` | Container orchestration |
| `04-analytics-engineering/.devcontainer/devcontainer.json` | VS Code container attachment |
---

## 📊 Progress

| Module | Topic | Status |
|--------|-------|--------|
| 1 | Containerization & Infrastructure | ✅ Complete |
| 2 | Workflow Orchestration | ✅ Complete |
| 3 | Data Warehouse | ✅ Complete |
| 4 | Analytics Engineering | ✅ Complete |
| 5 | Data Platforms | ⏳ Not Started |
| 6 | Batch Processing | ⏳ Not Started |
| 7 | Streaming | ⏳ Not Started |
