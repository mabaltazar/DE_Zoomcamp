# BASE IMAGE
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*
# gcc + g++  → needed to compile some Python C extensions
# git        → dbt uses git for version detection and packages
# curl       → useful for debugging inside the container

# INSTALL UV
# Copy uv binary from the official uv image
# This is the same pattern used in Module 1's Dockerfile
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

# WORKING DIR
WORKDIR /usr/app

# ADD VENV TO PATH
ENV PATH="/usr/app/.venv/bin:$PATH"
# Tells the OS to look in the uv virtual environment first
# So 'dbt' and 'python' resolve to the venv versions automatically

# INSTALL DEPENDENCIES
# Copy dependency files first for layer caching
# If only your code changes, Docker reuses this cached layer
COPY pyproject.toml uv.lock .python-version ./
RUN uv sync --locked
# --locked enforces exact versions from uv.lock
# Guarantees identical environment every build

# COPY FILES
COPY . .
# Copies everything else: taxi_rides_ny/, profiles.yml, ingest.py, etc.

# DBT PROFILE
RUN mkdir -p /root/.dbt
#COPY profiles.yml /root/.dbt/profiles.yml
# dbt looks for profiles.yml at ~/.dbt/profiles.yml by default
# Copying it here means every dbt command finds it automatically

# DEFAULT COMMAND
CMD ["bash"]
# Opens an interactive shell so you can run dbt commands manually