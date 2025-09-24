CREATE OR REPLACE VIEW analytics.vw_monthly_sales AS
SELECT
  DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month,
  COUNT(DISTINCT o.order_id) AS orders,
  SUM(o.items_revenue) AS items_revenue,
  SUM(o.freight_revenue) AS freight_revenue,
  SUM(o.total_payment_value) AS total_payment_value,
  AVG(o.delivery_days) AS avg_delivery_days
FROM analytics.vw_fct_orders o
GROUP BY 1
ORDER BY 1;
