-- Active: 1790182470823@@127.0.0.1@5432@superstore
CREATE VIEW analyst_orders AS
SELECT
    order_id,
    customer_id,
    product_id,
    sales,
    quantity,
    discount
FROM orders;

SELECT *
FROM analyst_orders;