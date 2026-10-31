SELECT
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
            THEN 'On time or early'
        ELSE 'Late'
    END AS delivery_group,
    COUNT(*) AS order_count
FROM olist.orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_group
ORDER BY order_count DESC;SELECT
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