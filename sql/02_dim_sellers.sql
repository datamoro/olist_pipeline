CREATE OR REPLACE VIEW analytics.dim_sellers AS
SELECT DISTINCT
  s.seller_id,
  LPAD(s.seller_zip_code_prefix::text, 8, '0') AS seller_zip_code_prefix,
  s.seller_city,
  s.seller_state
FROM olist_sellers_dataset s;
