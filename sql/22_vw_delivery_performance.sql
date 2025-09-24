CREATE OR REPLACE VIEW analytics.vw_delivery_performance AS
SELECT
  o.customer_state,
  COUNT(DISTINCT o.order_id) AS orders,
  AVG(o.delivery_days) AS avg_delivery_days,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY o.delivery_days) AS p50_delivery_days,
  PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY o.delivery_days) AS p90_delivery_days
FROM analytics.vw_fct_orders o
WHERE o.delivery_days IS NOT NULL
GROUP BY o.customer_state
ORDER BY avg_delivery_days DESC;
