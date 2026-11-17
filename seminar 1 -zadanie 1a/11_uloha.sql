-- Active: 1790178974393@@127.0.0.1@5432@superstore
-- Active: 1790178974393@@127.0.0.1@5432@superstore
SELECT 
    customers.region, 
    SUM(orders.sales) AS total_sales, 
    AVG(orders.discount) AS avg_discount, 
    COUNT(orders.order_id) AS order_count
FROM 
    customers
JOIN 
    orders ON customers.customer_id = orders.customer_id
GROUP BY 
    customers.region;