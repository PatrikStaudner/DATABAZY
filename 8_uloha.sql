-- Active: 1790178974393@@127.0.0.1@5432@superstore
-- Active: 1790178974393@@127.0.0.1@5432@superstore
SELECT
    customers.customer_name,
    COUNT(orders.order_id) AS order_count
FROM
    customers
LEFT JOIN
    orders ON customers.customer_id = orders.customer_id
GROUP BY 
    customers.customer_name