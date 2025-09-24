CREATE OR REPLACE VIEW analytics.dim_customers AS
SELECT DISTINCT
  c.customer_id,
  c.customer_unique_id,
  LPAD(c.customer_zip_code_prefix::text, 8, '0') AS customer_zip_code_prefix,
  c.customer_city,
  c.customer_state
FROM olist_customers_dataset c;
