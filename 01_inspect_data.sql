COPY olist.order_reviews (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)
FROM 'C:/SQL PRACTICE/olist-data/olist_order_reviews_dataset.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');SELECT
    COUNT(*) AS total_reviews,
    ROUND(AVG(review_score::numeric), 2) AS average_review_score,
    COUNT(*) FILTER (WHERE review_score <= 2) AS low_score_reviews,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE review_score <= 2) / COUNT(*),
        2
    ) AS low_score_percentage
FROM olist.order_reviews;SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
        THEN 'On time or early'
        ELSE 'Late'
    END AS delivery_group,
    COUNT(*) AS review_records,
    ROUND(AVG(r.review_score::numeric), 2) AS average_review_score
FROM olist.orders AS o
JOIN olist.order_reviews AS r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_group
ORDER BY delivery_group;SELECT
    