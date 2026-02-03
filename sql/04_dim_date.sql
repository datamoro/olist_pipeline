CREATE OR REPLACE VIEW analytics.dim_date AS
WITH d AS (
  SELECT DISTINCT (o.order_purchase_timestamp::date) AS dt
  FROM raw.olist_orders_dataset o
  WHERE o.order_purchase_timestamp IS NOT NULL
)
SELECT
  dt AS date,
  EXTRACT(YEAR FROM dt)::int AS year,
  EXTRACT(MONTH FROM dt)::int AS month,
  TO_CHAR(dt, 'YYYY-MM') AS year_month,
  EXTRACT(DAY FROM dt)::int AS day,
  TO_CHAR(dt, 'Day') AS day_name,
  EXTRACT(ISODOW FROM dt)::int AS iso_dow,
  TO_CHAR(dt, 'Q')::int AS quarter
FROM d;
