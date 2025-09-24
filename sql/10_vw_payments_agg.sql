CREATE OR REPLACE VIEW analytics.vw_payments_agg AS
SELECT
  p.order_id,
  SUM(p.payment_value) AS total_payment_value,
  MAX(p.payment_installments) AS max_installments,
  STRING_AGG(DISTINCT p.payment_type, ',') AS payment_methods
FROM olist_order_payments_dataset p
GROUP BY p.order_id;
