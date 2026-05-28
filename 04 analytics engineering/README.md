# 📊 Data Engineering Zoomcamp — Module 4: Analytics Engineering 🚧

## 📋 Overview
This module covers analytics engineering using dbt (data build tool) with
DuckDB locally. It bridges the gap between raw data in the warehouse and
consumption-ready tables for business stakeholders — bringing software
engineering best practices like version control, testing, documentation,
and modularity into SQL transformations.

---

## 🏗️ What I'm Building
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

