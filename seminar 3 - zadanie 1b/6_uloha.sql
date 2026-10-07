-- Active: 1790182470823@@127.0.0.1@5432@superstore
CREATE INDEX idx_orders_region_category
ON orders(customer_id, order_date);
SELECT
    c.customer_id,
    c.customer_name,
    c.region,
    o.order_date,
    o.profit
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.region = 'West'
    AND o.order_date >= '2024-01-01'