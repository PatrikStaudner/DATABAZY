-- Active: 1790178974393@@127.0.0.1@5432@superstore
-- Active: 1790178974393@@127.0.0.1@5432@superstore
SELECT 
    customers.customer_name, 
    SUM(orders.sales) AS total_sales
FROM 
    customers
JOIN 
    orders ON customers.customer_id = orders.customer_id
GROUP BY 
    customers.customer_name
HAVING 
    SUM(orders.sales) > 2000;