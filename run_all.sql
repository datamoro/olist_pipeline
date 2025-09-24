-- Create schemas
\i sql/00_create_schemas.sql

-- Dimension tables
\i sql/01_dim_customers.sql
\i sql/02_dim_sellers.sql
\i sql/03_dim_products.sql
\i sql/04_dim_date.sql

-- Aggregation helper views
\i sql/10_vw_payments_agg.sql
\i sql/11_vw_reviews_latest.sql

-- Fact views
\i sql/12_vw_fct_order_items.sql
\i sql/13_vw_fct_orders.sql

-- Dashboards views
\i sql/20_vw_monthly_sales.sql
\i sql/21_vw_category_sales.sql
\i sql/22_vw_delivery_performance.sql
