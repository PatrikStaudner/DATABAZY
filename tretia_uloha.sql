-- Active: 1790178974393@@127.0.0.1@5432@superstore
-- Active: 1790178974393@@127.0.0.1@5432@superstore
SELECT 
    orders.order_id,
    customers.customer_name,
    products.category,
    orders.sales
FROM
    orders
JOIN 
    customers ON orders.customer_id = customers.customer_id
JOIN
    products ON orders.product_id = products.product_id;