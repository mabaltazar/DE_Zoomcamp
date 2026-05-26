import duckdb
import requests
from pathlib import Path

BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download"

# Absolute paths — work correctly regardless of working directory
BASE_DIR = Path("/usr/app")
DB_PATH = BASE_DIR / "taxi_rides_ny.duckdb"
DATA_DIR = BASE_DIR / "data"


def download_and_convert_files(taxi_type: str) -> None:
    """
    Downloads CSV.gz files from GitHub for a given taxi type,
    converts each to Parquet format, and removes the original CSV.gz.

    Using Parquet instead of CSV because:
    - Parquet is columnar — faster for analytical queries
    - Parquet preserves data types — no type inference needed
    - Parquet compresses better — ~70% smaller than CSV
    - DuckDB reads Parquet natively and extremely fast
    """
    data_dir = DATA_DIR / taxi_type
    data_dir.mkdir(exist_ok=True, parents=True)

    for year in [2019, 2020]:
        for month in range(1, 13):
            parquet_filename = f"{taxi_type}_tripdata_{year}-{month:02d}.parquet"
            parquet_filepath = data_dir / parquet_filename

            # Skip if already downloaded — makes the script resumable
            # if interrupted partway through (e.g., network timeout)
            if parquet_filepath.exists():
                print(f"Skipping {parquet_filename} (already exists)")
                continue

            # Download the compressed CSV file
            csv_gz_filename = f"{taxi_type}_tripdata_{year}-{month:02d}.csv.gz"
            csv_gz_filepath = data_dir / csv_gz_filename

            print(f"Downloading {csv_gz_filename}...")
            response = requests.get(
                f"{BASE_URL}/{taxi_type}/{csv_gz_filename}",
                stream=True,
                # stream=True downloads in chunks rather than loading
                # the entire file into memory — essential for large files
            )
            response.raise_for_status()
            # Raises an exception immediately for HTTP errors
            # (404 not found, 500 server error, etc.)

            with open(csv_gz_filepath, "wb") as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
                # 8192 bytes = 8KB per chunk
                # Balances memory usage and download speed

            # Convert CSV.gz to Parquet using DuckDB
            # DuckDB reads compressed CSV natively — no manual
            # decompression step needed
            print(f"Converting {csv_gz_filename} to Parquet...")
            con = duckdb.connect()
            # No path argument = in-memory database
            # We only need DuckDB here for the conversion,
            # not for persistent storage
            con.execute(f"""
                COPY (
                    SELECT * FROM read_csv_auto('{csv_gz_filepath}')
                )
                TO '{parquet_filepath}' (FORMAT PARQUET)
            """)
            # read_csv_auto — DuckDB infers column names and types
            # automatically from the CSV header and data
            con.close()

            # Remove the CSV.gz file to save disk space
            # The Parquet file is significantly smaller
            csv_gz_filepath.unlink()
            print(f"Completed: {parquet_filename}")


def load_to_duckdb() -> None:
    """
    Loads all downloaded Parquet files into the persistent DuckDB database.
    Creates the prod schema and one table per taxi type containing
    all months of data combined.
    """
    print(f"\nLoading data into DuckDB at {DB_PATH}...")
    con = duckdb.connect(str(DB_PATH))

    con.execute("CREATE SCHEMA IF NOT EXISTS prod")
    # IF NOT EXISTS — safe to run multiple times without error

    for taxi_type in ["yellow", "green"]:
        parquet_pattern = str(DATA_DIR / taxi_type / "*.parquet")

        con.execute(f"""
            CREATE OR REPLACE TABLE prod.{taxi_type}_tripdata AS
            SELECT * FROM read_parquet('{parquet_pattern}', union_by_name=true)
        """)
        # read_parquet with glob pattern — reads all monthly Parquet files
        # and combines them into one table
        #
        # union_by_name=true — matches columns by name across files
        # rather than by position. Handles cases where different months
        # have slightly different column ordering or added columns.
        #
        # CREATE OR REPLACE — drops and recreates the table if it exists
        # Safe to re-run if you want to refresh the data

        row_count = con.execute(
            f"SELECT COUNT(*) FROM prod.{taxi_type}_tripdata"
        ).fetchone()[0]
        print(f"Loaded prod.{taxi_type}_tripdata — {row_count:,} rows")

    con.close()


def update_gitignore() -> None:
    """
    Adds the data/ directory to .gitignore if not already present.
    The downloaded Parquet files are several GB and should never
    be committed to git — they can always be re-downloaded.
    """
    gitignore_path = BASE_DIR / ".gitignore"
    content = gitignore_path.read_text() if gitignore_path.exists() else ""

    if "data/" not in content:
        with open(gitignore_path, "a") as f:
            f.write("\n# Downloaded taxi data (regenerable)\ndata/\n")
        print("Added data/ to .gitignore")


if __name__ == "__main__":
    update_gitignore()

    for taxi_type in ["yellow", "green"]:
        download_and_convert_files(taxi_type)

    load_to_duckdb()

    print("\nIngestion complete.")
    print(f"Database ready at: {DB_PATH}")
    print("Next step: cd taxi_rides_ny && dbt debug")