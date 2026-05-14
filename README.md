# 🚕 Data Engineering Zoomcamp by DataTalks.Club

My notes, code, and projects from the 
[DataTalks.Club Data Engineering Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp).

---

## 📦 Module 1: Containerization and Infrastructure ✅

### 🏗️ What I Built
A fully containerized data ingestion pipeline that downloads NYC Yellow Taxi trip data (~1.4M rows), processes it with pandas, and loads it into PostgreSQL — parameterized via CLI and reproducible on any machine via Docker.

### 🛠️ Stack
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=flat&logo=pandas&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat&logo=docker&logoColor=white)
![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-D71F00?style=flat&logo=sqlalchemy&logoColor=white)
![uv](https://img.shields.io/badge/uv-DE5FE9?style=flat&logo=astral&logoColor=white)
![click](https://img.shields.io/badge/click-4CAF50?style=flat&logo=python&logoColor=white)

### 🗂️ Architecture
\```
Internet (NYC TLC data)
    ↓
taxi_ingest container (Python + pandas + click)
    ↓ writes to
pgdatabase container (PostgreSQL 18)
    ↑ browsed via
pgAdmin container (port 8085)

All containers communicate via Docker Compose network.
Data persists in named Docker volumes.
\```

### 📚 Topics Covered
**Docker** — container lifecycle, volumes, networking, Dockerfiles, layer caching, Docker Compose for multi-container orchestration

**Python Environments** — virtual environments with `uv`, `pyproject.toml` + `uv.lock` for reproducible dependency management

**Data Ingestion** — chunked CSV ingestion with pandas, type handling, SQLAlchemy for database connectivity parameterized CLI with click

### 📁 Key Files
| File | Description    |
|------|-------------|
| `pipeline/ingest_data.py` | Parameterized ingestion script |
| `pipeline/Dockerfile` | Container definition for ingestion |
| `pipeline/docker-compose.yaml` | Full local stack (Postgres + pgAdmin) |
| `pipeline/pyproject.toml` | Python dependencies |

---

## 🔄 Module 2: Workflow Orchestration 🚧 In Progress

### 🏗️ What I'm Building
Orchestrating the Module 1 ingestion pipeline using Kestra — replacing manual `docker run` commands with scheduled, monitored, and parameterized flows.

### 🛠️ Stack
![Kestra](https://img.shields.io/badge/Kestra-6228D7?style=flat&logo=kestra&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)

### 📚 Topics Covered So Far
**Workflow Orchestration** — ETL vs ELT, why orchestrators exist, Kestra vs Airflow

**Kestra Fundamentals** — flows, tasks, inputs, outputs, variables, triggers, plugin defaults, concurrency

**Running Python in Kestra** — inline scripts, namespace files, git-synced scripts, Docker task runner, `Kestra outputs()` for passing data between Python and Kestra

### 🗓️ Coming Up
- Orchestrating the NYC taxi ingestion pipeline end-to-end
- Scheduled triggers and backfill strategies
- Error handling and alerting

---

## 📊 Progress

| Module | Topic | Status |
|--------|-------|--------|
| 1 | Containerization & Infrastructure | ✅ Complete |
| 2 | Workflow Orchestration | 🚧 In Progress |
| 3 | Data Warehousing | ⏳ Not Started |
| 4 | Analytics Engineering | ⏳ Not Started |
| 5 | Batch Processing | ⏳ Not Started |
| 6 | Streaming | ⏳ Not Started |