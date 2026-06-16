# 📊 Data Engineering Zoomcamp — Module 4: Analytics Engineering 🚧

## 📋 Overview
This module covers analytics engineering using dbt (data build tool) with
DuckDB locally. It bridges the gap between raw data in the warehouse and
consumption-ready tables for business stakeholders — bringing software
engineering best practices like version control, testing, documentation,
and modularity into SQL transformations.

---

## 🏗️ What I Built
A complete dbt project transforming raw NYC Taxi trip data into a dimensional
model following Kimball's star schema methodology:

- **`stg_green_tripdata`** and **`stg_yellow_tripdata`** — cleaned, typed,
  renamed staging models from raw source tables
- **`int_trips_unioned`** — intermediate model combining yellow and green
  taxi data into a single unified dataset
- **`dim_zones`** — dimension table loaded from a CSV seed file mapping
  location IDs to borough and zone names
- **`fct_trips`** — fact table with one row per trip across both taxi types
- **Report models** — monthly revenue per zone for dashboard consumption

---

## 🛠️ Stack
![dbt](https://img.shields.io/badge/dbt-FF694B?style=flat&logo=dbt&logoColor=white)
![DuckDB](https://img.shields.io/badge/DuckDB-FFC107?style=flat&logo=duckdb&logoColor=black)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![uv](https://img.shields.io/badge/uv-DE5FE9?style=flat&logo=astral&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=flat&logo=postgresql&logoColor=white)

---

## 📚 Topics Covered

### 🎯 Analytics Engineering Fundamentals
- Why the analytics engineer role exists — the gap between DE and DA
- ETL vs ELT and where dbt fits (the T in ELT)
- Kimball's dimensional modeling — fact tables, dimension tables, star schema
- The kitchen analogy — staging (pantry) → intermediate (kitchen) → marts (dining hall)

### 🔧 dbt Core vs dbt Cloud
- Open-source Core vs SaaS Cloud — tradeoffs and when to use each
- dbt Fusion — the 2025 engine rewrite and what it changes
- Why this course uses Core: understanding the fundamentals before abstractions

### 🗂️ dbt Project Structure
- `dbt_project.yml` — the most important file, profile linking, materializations
- `models/` — staging, intermediate, and marts layers
- `macros/` — reusable SQL functions (Jinja templating)
- `seeds/` — CSV lookup tables loaded directly into the warehouse
- `snapshots/` — historical change tracking for overwriting source tables
- `tests/` — SQL assertions for custom data quality checks

### 🔌 dbt Sources
- Defining sources in `sources.yml` — database, schema, and table mapping
- `source()` vs `ref()` — raw tables vs dbt models
- How `ref()` builds the dependency graph automatically

### 🏗️ Building dbt Models
- Staging models — 1:1 copies with explicit casting, renaming, column ordering
- The union problem — reconciling yellow and green taxi schema differences
- Why `trip_type = 1` and `ehail_fee = 0` for yellow taxis (business context)
- Intermediate models with `int_` prefix for pre-mart transformations
- Fact and dimension tables in the marts layer

### 🌱 Seeds and Macros
- Seeds for lookup data — `taxi_zone_lookup.csv` → `dim_zones`
- Macros as single source of truth for repeating business logic
- Jinja templating — `{% set %}`, `{% for %}`, `{% macro %}`
- Why macros beat copy-pasted CASE WHEN statements

### 🧪 dbt Tests
- **Singular tests** — plain SQL assertions for one-off business rules
- **Source freshness tests** — `warn_after` and `error_after` thresholds in `sources.yml`
- **Generic tests** — `unique`, `not_null`, `accepted_values`, `relationships`
- **Custom generic tests** — parameterized Jinja test blocks in `tests/generic/`
- **Unit tests** — mock input/expected output testing for SQL logic (dbt v1.8+)
- **Model contracts** — schema enforcement that blocks builds on schema drift
- Community packages: `dbt-utils`, `dbt-expectations` for extended test coverage

### 📖 dbt Documentation
- Documenting sources, models, and columns in `schema.yml`
- Multi-line descriptions with YAML `|` and `>` operators
- Meta tags for PII flagging, ownership, and governance
- `dbt docs generate` + `dbt docs serve` for the lineage graph and catalog
- Difference between the Jinja source and compiled SQL views in the docs site

### 📦 dbt Packages
- `dbt-utils` — surrogate keys, cross-database macros, deduplication utilities
- `dbt-codegen` — auto-generating YAML from models and SQL from YAML specs
- `dbt-expectations` — extended generic tests (ranges, regex, proportions)
- `dbt-audit-helper` — comparing old vs new model outputs during refactors
- `packages.yml` + `dbt deps` workflow; `package-lock.yml` for reproducibility
- `dbt_utils.generate_surrogate_key` replacing manual `concat()` for trip IDs

### ⌨️ dbt Commands
- **Setup:** `dbt init`, `dbt debug`, `dbt deps`, `dbt clean`
- **Feature-specific:** `dbt seed`, `dbt snapshot`, `dbt source freshness`
- **Daily drivers:** `dbt compile`, `dbt run`, `dbt test`, `dbt build`, `dbt retry`
- **Key flags:** `--select` with graph operators (`+model`, `model+`, `+model+`),
  `--full-refresh`, `--fail-fast`, `--target`, state selectors (`state:modified+`)
- `dbt build` as the gold standard — DAG-aware run + test + seed + snapshot
- `dbt retry` for resuming from failure using `run_results.json`

---

## 🗂️ Architecture

### Data Model (Star Schema)
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

### dbt Materialization Strategy
```
staging/      → views     (lightweight, always current, no storage cost)
intermediate/ → views     (temporary logic, not for end users)
marts/        → tables    (materialized for fast dashboard queries)
seeds/        → tables    (static lookup data)
```

### Testing Strategy
```
Every staging model:
  ✓ unique + not_null on primary keys
  ✓ accepted_values on code columns (payment_type, trip_type, vendor_id)
  ✓ relationships on foreign keys to dimension tables

Every mart model:
  ✓ unique + not_null on primary keys
  ✓ Contract enforced on fct_trips
  ✓ Singular test for positive fare_amount

Sources:
  ✓ Freshness: warn after 6h, error after 12h

Macros:
  ✓ Unit tests for get_payment_type_description edge cases
```

---

## 📁 Key Files
| File | Description |
|------|-------------|
| `04-analytics-engineering/taxi_rides_ny/dbt_project.yml` | dbt project configuration |
| `04-analytics-engineering/profiles.yml` | DuckDB connection profile |
| `04-analytics-engineering/taxi_rides_ny/models/staging/sources.yml` | Raw source definitions |
| `04-analytics-engineering/taxi_rides_ny/models/staging/stg_green_tripdata.sql` | Green taxi staging model |
| `04-analytics-engineering/taxi_rides_ny/models/staging/stg_yellow_tripdata.sql` | Yellow taxi staging model |
| `04-analytics-engineering/taxi_rides_ny/models/intermediate/int_trips_unioned.sql` | Combined trips |
| `04-analytics-engineering/taxi_rides_ny/models/marts/fct_trips.sql` | Final fact table |
| `04-analytics-engineering/taxi_rides_ny/models/marts/dim_zones.sql` | Zone dimension table |
| `04-analytics-engineering/taxi_rides_ny/macros/get_payment_type_description.sql` | Payment type macro |
| `04-analytics-engineering/taxi_rides_ny/seeds/taxi_zone_lookup.csv` | Zone lookup data |
| `04-analytics-engineering/taxi_rides_ny/packages.yml` | dbt package declarations |
| `04-analytics-engineering/ingest.py` | Downloads and loads taxi data into DuckDB |
| `04-analytics-engineering/Dockerfile` | Container definition |
| `04-analytics-engineering/docker-compose.yaml` | Container orchestration |
| `04-analytics-engineering/.devcontainer/devcontainer.json` | VS Code container attachment |
