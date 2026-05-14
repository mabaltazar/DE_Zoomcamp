# 🚕 Data Engineering Zoomcamp — Module 1: Containerization and Infrastructure

## 📋 Overview
This module covers the fundamentals of setting up a local data engineering environment using Docker, building and ingesting data into PostgreSQL, and orchestrating the stack with Docker Compose.

---

## 🏗️ What I Built
A fully containerized data pipeline that:
- Downloads NYC Yellow Taxi trip data from the web
- Ingests ~1.4M rows into a PostgreSQL database in chunks
- Is parameterized via CLI (year, month, table name, database credentials)
- Runs entirely in Docker — reproducible on any machine

## 🛠️ Stack
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=flat&logo=pandas&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat&logo=docker&logoColor=white)
![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-D71F00?style=flat&logo=sqlalchemy&logoColor=white)
![uv](https://img.shields.io/badge/uv-DE5FE9?style=flat&logo=astral&logoColor=white)
![click](https://img.shields.io/badge/click-4CAF50?style=flat&logo=python&logoColor=white)
![pgAdmin](https://img.shields.io/badge/pgAdmin-336791?style=flat&logo=postgresql&logoColor=white)

---

## 📚 Topics Covered

### 🐳 Docker
- Container lifecycle: images, containers, statelessness, and volumes
- Running services (PostgreSQL, pgAdmin) without local installation
- Docker networking: connecting containers via named networks
- Writing Dockerfiles with layer caching and the uv multi-stage pattern
- `.dockerignore` for clean build contexts

### 🐍 Python Environment & Virtual Environments
- Managing isolated Python environments with `uv`
- `pyproject.toml` and `uv.lock` for reproducible dependency management
- Bridging local virtual environments to Docker via `uv export`

### 🔄 Data Ingestion Pipeline
- Explored the NYC TLC dataset in Jupyter, handled type inference issues
- Built `ingest_data.py`: a parameterized CLI script using `click`
- Chunked ingestion with `pandas` + `SQLAlchemy` for memory efficiency
- Validated results in pgcli and pgAdmin

### ⚙️ Docker Compose
- Defined multi-container infrastructure (Postgres + pgAdmin) in a single file
- Automatic networking, named volumes, `depends_on` service ordering
- `.env` files for keeping credentials out of version control

---

## 🗂️ Architecture

```
Internet (NYC TLC data)
    ↓
taxi_ingest container (Python + pandas)
    ↓ writes to
pgdatabase container (PostgreSQL 18)
    ↑ browsed via
pgAdmin container (port 8085)
    
All containers communicate via Docker Compose network.
Data persists in named Docker volumes.
```

---

## 📁 Key Files
| File | Description |
|------|-------------|
| `pipeline/ingest_data.py` | Parameterized ingestion script |
| `pipeline/Dockerfile` | Container definition for the ingestion script |
| `pipeline/docker-compose.yaml` | Full local stack definition |
| `pipeline/pyproject.toml` | Python dependencies |