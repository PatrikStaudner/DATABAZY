-- Active: 1790182470823@@127.0.0.1@5432@superstore
CREATE INDEX idx_orders_order_date
ON orders(order_date);
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    SUM(sales) as total_sales
FROM orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month ASC;