SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'olist'
ORDER BY table_name;

$csv = Import-Csv .\olist-data\olist_customers_dataset.csv
$csv.Count

CREATE TABLE IF NOT EXISTS olist.customers (
    customer_id VARCHAR(32) PRIMARY KEY,
    customer_unique_id VARCHAR(32),
    customer_zip_code_prefix VARCHAR(5),
    customer_city TEXT,
    customer_state CHAR(2)
);

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'olist'
ORDER BY table_name;

SELECT COUNT(*) AS customer_rows
FROM olist.customers;

COPY olist.customers (
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)
FROM 'C:/SQL PRACTICE/olist-data/olist_customers_dataset.csv'
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

SELECT COUNT(*) AS customer_rows
FROM olist.customers;

SELECT *
FROM olist.customers
LIMIT 5;

SELECT
    COUNT(*) AS customer_records,
    COUNT(DISTINCT customer_unique_id) AS unique_customers,
    COUNT(DISTINCT customer_state) AS states
FROM olist.customers;

SELECT *
FROM olist.customers
LIMIT 5;

SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM olist.customers
GROUP BY customer_state
ORDER BY unique_customers DESC
LIMIT 10;

SELECT COUNT(*) AS customer_records_in_sp
FROM olist.customers
WHERE customer_state = 'SP';

SELECT ROUND(
    100.0 * COUNT(DISTINCT customer_unique_id) /
    (SELECT COUNT(DISTINCT customer_unique_id)
     FROM olist.customers),
    2
) AS sp_percent_of_customers
FROM olist.customers
WHERE customer_state = 'SP';


SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS rows_with_customer_id,
    COUNT(customer_city) AS rows_with_city,
    COUNT(customer_state) AS rows_with_state
FROM olist.customers;


SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_unique_id) AS rows_with_unique_id,
    COUNT(customer_zip_code_prefix) AS rows_with_zip_prefix
FROM olist.customers;

CREATE TABLE IF NOT EXISTS olist.orders (
    order_id VARCHAR(32) PRIMARY KEY,
    customer_id VARCHAR(32),
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'olist'
ORDER BY table_name;

SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE order_status = 'delivered')
        / COUNT(*),
        2
    ) AS delivered_percentage
FROM olist.orders;

SELECT
    COUNT(*) FILTER (
        WHERE order_delivered_customer_date <= order_estimated_delivery_date
    ) AS on_time_orders,
    COUNT(*) AS delivered_orders_with_dates,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE order_delivered_customer_date <= order_estimated_delivery_date
        ) / COUNT(*),
        2
    ) AS on_time_delivery_percentage
FROM olist.orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

  CREATE TABLE IF NOT EXISTS olist.order_reviews (
    review_id VARCHAR(32),
    order_id VARCHAR(32),
    review_score SMALLINT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

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
WITH (FORMAT CSV, HEADER TRUE, ENCODING 'UTF8');

SELECT
    COUNT(*) AS total_reviews,
    ROUND(AVG(review_score::numeric), 2) AS average_review_score,
    COUNT(*) FILTER (WHERE review_score <= 2) AS low_score_reviews,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE review_score <= 2) / COUNT(*),
        2
    ) AS low_score_percentage
FROM olist.order_reviews;

SELECT
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
ORDER BY delivery_group;

