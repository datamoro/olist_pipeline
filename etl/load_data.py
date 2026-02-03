import pandas as pd
from sqlalchemy import create_engine
import os
import argparse

# ------------------------------
# Argument Parsing
# ------------------------------
def get_args():
    parser = argparse.ArgumentParser(description="Clean and load Olist CSV data into PostgreSQL")

    parser.add_argument("--host", default="localhost", help="PostgreSQL host (default: localhost)")
    parser.add_argument("--port", default="5432", help="PostgreSQL port (default: 5432)")
    parser.add_argument("--user", required=True, help="PostgreSQL user")
    parser.add_argument("--password", required=True, help="PostgreSQL password")
    parser.add_argument("--database", default="olist_db", help="PostgreSQL database name (default: olist_db)")
    parser.add_argument("--schema", default="raw", help="PostgreSQL schema for raw data (default: raw)")
    parser.add_argument("--data-path", default="../data/", help="Path to directory containing CSV files")

    return parser.parse_args()

# ------------------------------
# Data Cleaning Logic
# ------------------------------
def clean_dataframe(df: pd.DataFrame) -> pd.DataFrame:
    # Step 1: Drop duplicates
    df.drop_duplicates(inplace=True)

    # Step 2: Replace 'nan' string values with proper nulls
    df.replace("nan", pd.NA, inplace=True)

    # Step 3: Convert date and timestamp columns
    for col in df.columns:
        if "timestamp" in col.lower() or "date" in col.lower():
            try:
                df[col] = pd.to_datetime(df[col], errors="coerce")
            except Exception as e:
                print(f"Warning: Failed to convert {col} to datetime: {e}")

    # Step 4: Format ZIP code columns
    for col in df.columns:
        if "zip_code" in col.lower():
            df[col] = df[col].astype(str).str.zfill(8)

    return df

# ------------------------------
# Main Loader
# ------------------------------
def main():
    args = get_args()

    # Build connection string
    conn_str = f"postgresql://{args.user}:{args.password}@{args.host}:{args.port}/{args.database}"
    engine = create_engine(conn_str)

    # Get list of CSV files
    data_path = args.data_path
    files = [f for f in os.listdir(data_path) if f.endswith(".csv")]

    for file in files:
        table_name = file.replace(".csv", "")
        file_path = os.path.join(data_path, file)
        print(f"\n Processing: {file} → Table: {args.schema}.{table_name}")

        # Read and clean
        df = pd.read_csv(file_path)
        df = clean_dataframe(df)

        # Load into PostgreSQL
        df.to_sql(table_name, engine, schema=args.schema, if_exists="replace", index=False)
        print(f"Loaded: {table_name} ({df.shape[0]} rows)")

    print("\n All files loaded successfully.")

if __name__ == "__main__":
    main()
