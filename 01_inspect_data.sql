SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE order_status = 'delivered')
        / COUNT(*),
        2
    ) AS delivered_percentage
FROM olist.orders;