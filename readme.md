# 📘 Olist E-commerce Analytics – Data Pipeline with PostgreSQL, Docker & Superset

## 📖 Project Overview
This project implements an **end-to-end data pipeline** for the [Olist Brazilian E-commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).  


It demonstrates:
- **Data ingestion** into PostgreSQL
- **Cleaning & transformation** with Python (pandas + SQLAlchemy)
- **Dimensional modeling** with SQL views
- **Interactive BI dashboards** in Apache Superset
- **Containerized orchestration** with Docker

---

## ⚙️ Architecture

(Architecture diagram in text)

                 +-------------------+
                 |   Kaggle Dataset  |
                 |   (CSV files)     |
                 +---------+---------+
                           |
                           v
                 +-------------------+
                 |  Python (pandas)  |
                 |  load_data.py     |
                 |  - cleaning       |
                 |  - deduplication  |
                 |  - type casting   |
                 +---------+---------+
                           |
                           v
                 +-------------------+
                 | PostgreSQL (raw)  |
                 +---------+---------+
                           |
                           v
                 +-------------------+
                 | PostgreSQL (views)|
                 |  analytics schema |
                 |  - facts          |
                 |  - dimensions     |
                 +---------+---------+
                           |
                           v
                 +-------------------+
                 | Apache Superset   |
                 | - Datasets        |
                 | - Filters         |
                 | - Dashboards      |
                 +-------------------+

---

## 🛠️ Tech Stack
- **PostgreSQL 15** – relational database & SQL views  
- **Docker & docker-compose** – container orchestration  
- **Python 3.10 + pandas + SQLAlchemy** – ETL and cleaning  
- **Apache Superset** – dashboarding and BI  

---

## 📂 Repository Structure

~~~text
olist_pipeline/
│
├── data/                   # Raw CSVs from Kaggle
├── etl/
│   ├── load_data.py        # ETL script with cleaning
│   └── requirements.txt    # Python dependencies
│
├── sql/
│   └── 00_create_schemas.sql
│   └── 01_dim_customers.sql
│   └── 02_dim_sellers.sql
│   └── 03_dim_products.sql
│   └── 04_dim_date.sql
│   └── 10_vw_payments_agg.sql
│   └── 11_vw_reviews_latest.sql
│   └── 12_vw_fct_order_items.sql
│   └── 13_vw_fct_orders.sql
│   └── 20_vw_monthly_sales.sql
│   └── 21_vw_category_sales.sql
│   └── 22_vw_delivery_performance.sql
│
├── superset/
│   ├── docker-init.sh      # Init script for Superset
│   └── superset_config.py  # Superset config
│
├── docker-compose.yml      # Services (Postgres, Superset)
└── README.md               # Documentation
~~~

---

## 🚀 Setup & Execution

### 1) Clone the repo
~~~bash
git clone https://github.com/<your-username>/olist-pipeline.git
cd olist-pipeline
~~~

### 2) Start containers
~~~bash
docker-compose up --build
~~~
- PostgreSQL → `localhost:5432`  
- Superset → `http://localhost:8088`

### 3) Load the data
From the `etl/` folder:

~~~bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

python load_data.py \
  --user <db_user> \
  --password <db_password> \
  --host <db_host> \
  --port <db_port> \
  --database <db_name> \
  --schema raw \
  --data-path ../data/
~~~

> ℹ️ Connection args can also come from environment variables (e.g., a `.env` file).

### 4) Create analytics views
Run your SQL scripts (e.g., `vw_fct_orders.sql`, `vw_fct_order_items.sql`, `dim_customers.sql`) in the `analytics` schema using DBeaver or `psql`.

### 5) Connect Superset
- Open `http://localhost:8088`  
- Add DB connection:  
  `postgresql://<db_user>:<db_password>@olist_postgres:5432/olist_db`  
- Register datasets from schema **analytics**  
- Build charts and dashboards  

---

## 🧼 Data Cleaning Rules
The ETL applies:
1. Remove duplicates  
2. Replace `"nan"` strings with NULL  
3. Cast `timestamp`/`date` columns → proper datetime  
4. Format `zip_code` columns as 8-character strings (leading zeros)

---

## 📐 Data Modeling

We use a **star schema** with denormalized facts for BI.

### Fact views
- **`analytics.vw_fct_order_items`** – item-level fact joining orders, products (with category translation), sellers, customers, payments (aggregated), and latest review. Includes derived fields like `delivery_days`, and filter-friendly columns such as:
  - `iso_state` = `'BR-' || customer_state`
  - `category_display` = `COALESCE(product_category_name_english, product_category_name)`
- **`analytics.vw_fct_orders`** – order-level fact aggregating items and payments; includes `delivery_days`.

### Dimension views
- `analytics.dim_customers`
- `analytics.dim_sellers`
- `analytics.dim_products` (with English categories)
- `analytics.dim_date`

### Helper views
- `analytics.vw_payments_agg` – payments aggregated at order level
- `analytics.vw_reviews_latest` – latest review per order

---

## 📊 Dashboard Features

**Global filters**
- Date (`order_purchase_timestamp`)  
- State (`iso_state`)  
- Product category (`category_display`)  

**Example charts**
- Monthly revenue trend (line)  
- Revenue by category (bar)  
- Orders by state (map)  
- Delivery days distribution (histogram, bin size 5, filter `delivery_days <= 60`)  
- Seller leaderboard (table)  
- Payment method mix (pie/bar)  
- Review score distribution (hist/box)

**KPIs**
- Total revenue = `SUM(total_payment_value)`  
- Orders = `COUNT DISTINCT order_id`  
- Avg delivery days = `AVG(delivery_days)`  
- Avg review score = `AVG(review_score)`

---

## 📈 Example Insights (v1)
- Most deliveries take **7–15 days**; long tail > **30 days**  
- **SP** leads revenue and order volume  
- Top categories include **Health & Beauty**, **Bed & Bath**, **Computers/Accessories**  
- **Credit card** dominates payments  

---

## 🗓️ Roadmap
- Materialized views for heavy queries  
- Orchestration (Airflow/Prefect)  
- dbt for SQL transformation versioning  
- New analyses: retention, repeat purchases, cohort charts

---

## 📜 License
MIT License.
