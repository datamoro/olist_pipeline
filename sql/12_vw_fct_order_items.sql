CREATE OR REPLACE VIEW analytics.vw_fct_order_items AS
SELECT
  oi.order_id,
  oi.order_item_id,
  oi.product_id,
  oi.seller_id,
  oi.price,
  oi.freight_value,
  oi.shipping_limit_date,
  -- Order context
  o.customer_id,
  o.order_status,
  o.order_purchase_timestamp,
  o.order_approved_at,
  o.order_delivered_carrier_date,
  o.order_delivered_customer_date,
  o.order_estimated_delivery_date,
  -- Customer location
  c.customer_unique_id,
  LPAD(c.customer_zip_code_prefix::text, 8, '0') AS customer_zip_code_prefix,
  c.customer_city,
  'BR-'||c.customer_state AS customer_state,
  -- Seller location
  s.seller_zip_code_prefix,
  s.seller_city,
  s.seller_state,
  -- Product & category
  pr.product_category_name,
  INITCAP(REPLACE(t.product_category_name_english, '_', ' ')) AS product_category_name_english,
  -- Review
  rl.review_id,
  rl.review_score,
  rl.review_creation_date,
  -- Payments
  pa.total_payment_value,
  pa.max_installments,
  pa.payment_methods,
  -- Derived metric
  (o.order_delivered_customer_date::date - o.order_purchase_timestamp::date) AS delivery_days
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o ON o.order_id = oi.order_id
LEFT JOIN olist_customers_dataset c ON c.customer_id = o.customer_id
LEFT JOIN olist_sellers_dataset s ON s.seller_id = oi.seller_id
LEFT JOIN olist_products_dataset pr ON pr.product_id = oi.product_id
LEFT JOIN product_category_name_translation t ON t.product_category_name = pr.product_category_name
LEFT JOIN analytics.vw_reviews_latest rl ON rl.order_id = o.order_id
LEFT JOIN analytics.vw_payments_agg pa ON pa.order_id = o.order_id;
