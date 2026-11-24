-- Active: 1790178974393@@127.0.0.1@5432@superstore
-- Active: 1790178974393@@127.0.0.1@5432@superstore
SELECT 
    products.category, 
    AVG(orders.discount) AS priemer
FROM 
    products
JOIN 
    orders ON products.product_id = orders.product_id
GROUP BY 
    products.category;