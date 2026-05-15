# 🚕 Data Engineering Zoomcamp — Module 1: Containerization and Infrastructure

## 📋 Overview
This module covers the fundamentals of setting up a local data engineering environment using Docker, building and ingesting data into PostgreSQL, orchestrating the stack with Docker Compose, and provisioning cloud infrastructure on GCP using Terraform.

---

## 🏗️ What I Built
A fully containerized data pipeline that:
- Downloads NYC Yellow Taxi trip data from the web
- Ingests ~1.4M rows into a PostgreSQL database in chunks
- Is parameterized via CLI (year, month, table name, database credentials)
- Runs entirely in Docker — reproducible on any machine

A cloud infrastructure setup using Terraform that provisions:
- A Google Cloud Storage bucket (Data Lake)
- A BigQuery dataset (Data Warehouse)

A reproducible Codespaces development environment using devcontainer that
auto-installs all required tools on every rebuild.

## 🛠️ Stack

### Docker & Data Ingestion
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=flat&logo=pandas&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat&logo=docker&logoColor=white)
![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-D71F00?style=flat&logo=sqlalchemy&logoColor=white)
![uv](https://img.shields.io/badge/uv-DE5FE9?style=flat&logo=astral&logoColor=white)
![click](https://img.shields.io/badge/click-4CAF50?style=flat&logo=python&logoColor=white)
![pgAdmin](https://img.shields.io/badge/pgAdmin-336791?style=flat&logo=postgresql&logoColor=white)

### Cloud Infrastructure
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white)
![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=flat&logo=googlecloud&logoColor=white)
![BigQuery](https://img.shields.io/badge/BigQuery-4285F4?style=flat&logo=googlebigquery&logoColor=white)
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

### 🌍 Terraform & GCP
- Infrastructure-as-Code concepts: reproducibility, version control, cost control
- Provisioned a GCS bucket (Data Lake) and BigQuery dataset (Data Warehouse)
- GCP service account setup, IAM roles, and API configuration
- Terraform workflow: `init` → `plan` → `apply` → `destroy`
- Safe credential handling: `.gitignore` patterns for keys and state files

### 💻 Dev Environment (Beyond the Course)
- Configured `.devcontainer/devcontainer.json` for GitHub Codespaces
- Auto-installs Terraform and Google Cloud CLI on every rebuild
- Docker socket mounting for running Docker Compose inside Codespaces
- `.gitignore` strategies for credentials, state files, and large data files
---

## 🗂️ Architecture

### Data Pipeline
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

### Cloud Infrastructure (Terraform)
```
variables.tf + main.tf
↓ terraform init → terraform apply
GCP Project
├── GCS Bucket       ← Data Lake (raw files)
└── BigQuery Dataset ← Data Warehouse (analytics)
↓ terraform destroy
Everything removed, billing stops
```
---

## 📁 Key Files
| File | Description |
|------|-------------|
| `pipeline/ingest_data.py` | Parameterized ingestion script |
| `pipeline/Dockerfile` | Container definition for ingestion |
| `pipeline/docker-compose.yaml` | Full local stack (Postgres + pgAdmin) |
| `pipeline/pyproject.toml` | Python dependencies |
| `terraform-gcp/main.tf` | GCP resources (bucket + BigQuery dataset) |
| `terraform-gcp/variables.tf` | Configurable input variables |
| `.devcontainer/devcontainer.json` | Codespaces environment configuration |
| `.devcontainer/setup.sh` | Tool installation script for Codespaces |
| `.gitignore` | Excludes credentials, state files, and data files |