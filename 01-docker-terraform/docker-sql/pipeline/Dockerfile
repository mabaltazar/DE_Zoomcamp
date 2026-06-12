# base Docker image that we will build on
FROM python:3.13.11-slim 

# Copy uv binary from official uv image (multi-stage build pattern)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

# set up our image by installing prerequisites
# we don't need to install pandas and pyarrow here because we will use uv to manage our dependencies and install them in the next step. This keeps our Docker image smaller and more efficient.
# RUN pip install pandas pyarrow 

# Specify the working directory inside the container
WORKDIR /code 

# Add virtual environment to PATH so we can use installed packages
# we can set this up instead of activating the virtual environment in the entrypoint script because it allows us to use the installed packages without needing to activate the environment every time we run a command. This is especially useful in a Docker container where we want to keep things simple and efficient.
ENV PATH="/code/.venv/bin:$PATH"

# Copy dependency files first (better layer caching)
COPY "pyproject.toml" "uv.lock" ".python-version" ./

# Install dependencies from lock file (ensures reproducible builds)
RUN uv sync --locked

# copy the script to the container.
COPY ingest_data.py .

# this is will be executed when we do docker run
ENTRYPOINT ["python", "ingest_data.py"]