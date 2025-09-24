CREATE OR REPLACE VIEW analytics.vw_category_sales AS
SELECT
  COALESCE(fi.product_category_name_english, fi.product_category_name) AS category,
  COUNT(DISTINCT fi.order_id) AS orders,
  SUM(fi.price) AS revenue,
  SUM(fi.freight_value) AS freight
FROM analytics.vw_fct_order_items fi
GROUP BY 1
ORDER BY revenue DESC;
