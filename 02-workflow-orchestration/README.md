# 🔄 Data Engineering Zoomcamp — Module 2: Workflow Orchestration

## 📋 Overview
This module covers workflow orchestration using Kestra — from understanding ETL vs ELT patterns to building fully automated, scheduled, and backfillable data pipelines. Two pipelines are built: a local ETL pipeline loading NYC Taxi data into PostgreSQL, and a cloud ELT pipeline loading the full historical dataset into GCS and BigQuery.

---

## 🏗️ What I Built

Two production-grade data pipelines orchestrated with Kestra:

**Local ETL Pipeline** — extracts NYC Taxi CSV data from GitHub, loads it into a PostgreSQL staging table, deduplicates with MD5 hashing, and merges into a permanent table. Runs on a monthly schedule with full backfill support.

**Cloud ELT Pipeline** — extracts the same data, uploads raw CSVs to Google Cloud Storage (Data Lake), creates BigQuery external tables pointing to GCS, materializes them into date-partitioned native tables, and merges into permanent tables. Backfills the complete 2019–2020 dataset for both taxi types.

Also solved a real-world engineering challenge *(beyond course scope)*:
configuring Kestra secrets without the Enterprise edition using Base64-encoded
environment variables injected via Docker Compose and a `.env` file.

---

## 🛠️ Stack

### Orchestration & Infrastructure
![Kestra](https://img.shields.io/badge/Kestra-6228D7?style=flat&logo=kestra&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat&logo=docker&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)
![DuckDB](https://img.shields.io/badge/DuckDB-FFC107?style=flat&logo=duckdb&logoColor=black)

### Cloud
![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=flat&logo=googlecloud&logoColor=white)
![BigQuery](https://img.shields.io/badge/BigQuery-4285F4?style=flat&logo=googlebigquery&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)

---

## 📚 Topics Covered

### 🎼 Workflow Orchestration Concepts
- ETL vs ELT — when to transform before vs after loading
- Why orchestrators replace cron jobs and shell scripts
- Kestra vs Apache Airflow — tradeoffs and when to use each
- Scheduling, event-based triggers, retry logic, dependency management

### 🔑 Kestra Fundamentals
- Flows, tasks, inputs, outputs, variables, plugin defaults, concurrency
- Pebble templating: `render()`, `~` concatenation, `| date()` filters
- `trigger.date` for scheduled pipelines and backfills
- KV Store for configuration vs secrets for credentials
- Conditional branching with `io.kestra.plugin.core.flow.If`
- Labels for execution tracking and audit

### 🗄️ Local ETL Pipeline (Postgres)
- Staging + MERGE pattern for idempotent, duplicate-free loading
- MD5 hashing for row deduplication without a natural primary key
- PostgreSQL `COPY IN` for fast bulk loading
- `TRUNCATE` → `COPY` → `MERGE` workflow explained
- Monthly scheduling with `concurrency limit: 1` to protect shared staging
- Backfilling historical data via Kestra UI

### ☁️ Cloud ELT Pipeline (GCS + BigQuery)
- GCS as Data Lake — raw files stored permanently for reprocessing
- BigQuery external tables — schema wrapper over GCS files, no data copy
- `CREATE TABLE AS SELECT` (CTAS) for BigQuery-native transformations
- Date partitioning with `PARTITION BY DATE(column)` for cost and performance
- `BYTES` type for MD5 unique IDs in BigQuery
- Column-level documentation with `OPTIONS (description = '...')`
- Full dataset backfill (48 executions) without local resource constraints
- Parallel backfill execution — no concurrency limit needed (isolated temp tables)

### 🔐 Secrets Management *(Beyond Course Scope)*
- Kestra secrets via environment variables for open-source edition
- Base64 encoding requirement for `SECRET_*` env vars
- `.env` file with `env_file:` in Docker Compose
- Generating Base64 credentials: `base64 -w 0 key.json`
- `.env.example` template for safe documentation in git

---

## 🗂️ Architecture

### Local ETL (Postgres)
```
GitHub (CSV files)
↓ wget + gunzip (shell task, process runner)
Kestra internal storage
↓ PostgreSQL COPY IN
public.yellow_tripdata_staging
↓ UPDATE — add MD5 unique_row_id + filename
↓ MERGE — insert only new rows
public.yellow_tripdata (permanent)
Schedule: 1st of month, 9 AM UTC (green) / 10 AM UTC (yellow)
Concurrency: limit 1 — sequential execution protects shared staging
```

### Cloud ELT (GCS + BigQuery)
```
GitHub (CSV files)
↓ wget + gunzip (shell task, process runner)
Kestra internal storage
↓ gcs.Upload
GCS bucket (Data Lake)
gs://bucket/yellow_tripdata_2019-01.csv  ← preserved permanently
↓ CREATE EXTERNAL TABLE (_ext)
↓ CREATE TABLE AS SELECT (add MD5 + filename)
zoomcamp.yellow_tripdata_2019_01 (monthly temp)
↓ MERGE
zoomcamp.yellow_tripdata (permanent, partitioned by date)
Schedule: 1st of month, 9 AM UTC (green) / 10 AM UTC (yellow)
Concurrency: none — each month has isolated temp tables, safe to parallelize
```

---

## 📁 Key Files
| File | Description |
|------|-------------|
| `flows/01_hello_world.yaml` | Kestra concepts demo — inputs, outputs, variables, triggers |
| `flows/02_python.yaml` | Running Python in Kestra with Docker task runner |
| `flows/03_getting_started_data_pipeline.yaml` | Mini ETL — HTTP → Python → DuckDB |
| `flows/04_postgres_taxi.yaml` | Local ETL — manual trigger, year/month inputs |
| `flows/05_postgres_taxi_scheduled.yaml` | Local ETL — scheduled + backfill |
| `flows/06_gcp_kv.yaml` | GCP configuration setup — populates KV Store |
| `flows/07_gcp_setup.yaml` | Creates GCS bucket and BigQuery dataset |
| `flows/08_gcp_taxi.yaml` | Cloud ELT — manual trigger, year/month inputs |
| `flows/09_gcp_taxi_scheduled.yaml` | Cloud ELT — scheduled + full dataset backfill |
| `docker-compose.yaml` | Full stack: Kestra + Postgres + pgAdmin |
| `.env.example` | Template for GCP credentials setup |

---

## 🔐 GCP Credentials Setup

This module requires GCP credentials to run the cloud ELT pipeline. Since
Kestra secrets require the Enterprise edition, credentials are injected via
Base64-encoded environment variables.

**Quick setup:**

```bash
# 1. Base64-encode your service account key
base64 -w 0 your-service-account-key.json   # Linux
base64 -i your-service-account-key.json     # macOS

# 2. Copy the template and fill in your values
cp .env.example .env
# Edit .env — paste the Base64 output as SECRET_GCP_CREDS

# 3. Start the stack
docker compose up -d
```

See `.env.example` for the full format. Never commit `.env` to git.

---

## 🔄 Pipeline Comparison

| Flow | Backend | Trigger | Date source | Backfill scope |
|------|---------|---------|-------------|----------------|
| `04_postgres_taxi` | PostgreSQL | Manual | `inputs.year` + `inputs.month` | One month |
| `05_postgres_taxi_scheduled` | PostgreSQL | Schedule | `trigger.date` | Green 2019 only |
| `08_gcp_taxi` | GCS + BigQuery | Manual | `inputs.year` + `inputs.month` | One month |
| `09_gcp_taxi_scheduled` | GCS + BigQuery | Schedule | `trigger.date` | Full dataset |