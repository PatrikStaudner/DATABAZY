-- Active: 1790178974393@@127.0.0.1@5432@superstore
-- Active: 1790178974393@@127.0.0.1@5432@superstore
SELECT
    customers.customer_name,
    orders.order_id,
    orders.sales
FROM
    customers
FULL JOIN 
    orders ON customers.customer_id = orders.customer_id;