CREATE OR REPLACE VIEW analytics.vw_reviews_latest AS
WITH ranked AS (
  SELECT
    r.*,
    ROW_NUMBER() OVER (
      PARTITION BY r.order_id
      ORDER BY r.review_creation_date DESC NULLS LAST,
               r.review_answer_timestamp DESC NULLS LAST
    ) AS rn
  FROM olist_order_reviews_dataset r
)
SELECT
  order_id,
  review_id,
  review_score,
  review_comment_title,
  review_comment_message,
  review_creation_date,
  review_answer_timestamp
FROM ranked
WHERE rn = 1;
