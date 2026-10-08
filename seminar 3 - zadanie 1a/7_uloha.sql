-- Active: 1790182470823@@127.0.0.1@5432@superstore
EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id = 'C001';