CREATE OR REPLACE VIEW analytics.vw_fct_orders AS
WITH items AS (
  SELECT
    oi.order_id,
    COUNT(*) AS items_count,
    SUM(oi.price) AS items_revenue,
    SUM(oi.freight_value) AS freight_revenue
  FROM raw.olist_order_items_dataset oi
  GROUP BY oi.order_id
)
SELECT
  o.order_id,
  o.customer_id,
  o.order_status,
  o.order_purchase_timestamp,
  o.order_approved_at,
  o.order_delivered_carrier_date,
  o.order_delivered_customer_date,
  o.order_estimated_delivery_date,
  -- Customer
  c.customer_unique_id,
  LPAD(c.customer_zip_code_prefix::text, 8, '0') AS customer_zip_code_prefix,
  c.customer_city,
  'BR-'||c.customer_state AS customer_state,
  -- Aggregates
  it.items_count,
  it.items_revenue,
  it.freight_revenue,
  COALESCE(pa.total_payment_value, 0) AS total_payment_value,
  -- Review
  rl.review_score,
  -- Derived
  (o.order_delivered_customer_date::date - o.order_purchase_timestamp::date) AS delivery_days
FROM raw.olist_orders_dataset o
LEFT JOIN raw.olist_customers_dataset c ON c.customer_id = o.customer_id
LEFT JOIN items it ON it.order_id = o.order_id
LEFT JOIN analytics.vw_payments_agg pa ON pa.order_id = o.order_id
LEFT JOIN analytics.vw_reviews_latest rl ON rl.order_id = o.order_id;
