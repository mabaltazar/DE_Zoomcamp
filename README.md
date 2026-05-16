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
| `'01 docker-terraform'/docker-sql/pipeline/ingest_data.py` | Parameterized ingestion script |
| `'01 docker-terraform'/docker-sql/pipeline/Dockerfile` | Container definition for ingestion |
| `'01 docker-terraform'/docker-sql/pipeline/docker-compose.yaml` | Full local stack (Postgres + pgAdmin) |
| `'01 docker-terraform'/docker-sql/pipeline/pyproject.toml` | Python dependencies |
| `'01 docker-terraform'/terraform-gcp/main.tf` | GCP resources |
| `'01 docker-terraform'/terraform-gcp/variables.tf` | Input variables |
| `.devcontainer/devcontainer.json` | Codespaces configuration |

---

## 🔄 Module 2: Workflow Orchestration 🚧 In Progress

### 🏗️ What I'm Building
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
| `'02 workflow orchestration'/flows/04_postgres_taxi.yaml` | ETL pipeline — manual trigger |
| `'02 workflow orchestration'/flows/05_postgres_taxi_scheduled.yaml` | ETL pipeline — scheduled + backfill |
| `'02 workflow orchestration'/flows/08_gcp_taxi.yaml` | ELT pipeline — manual trigger |
| `'02 workflow orchestration'/flows/09_gcp_taxi_scheduled.yaml` | ELT pipeline — scheduled + full backfill |
| `'02 workflow orchestration'/docker-compose.yaml` | Full stack with Kestra + Postgres + pgAdmin |
| `.env.example` | Template for GCP credentials setup |

---

## 📊 Progress

| Module | Topic | Status |
|--------|-------|--------|
| 1 | Containerization & Infrastructure | ✅ Complete |
| 2 | Workflow Orchestration | ✅ Complete |
| 3 | Data Warehousing | ⏳ Not Started |
| 4 | Analytics Engineering | ⏳ Not Started |
| 5 | Batch Processing | ⏳ Not Started |
| 6 | Streaming | ⏳ Not Started |