-- Active: 1790182470823@@127.0.0.1@5432@superstore
WITH customers_profits AS (
    SELECT
        c.region,
        c.customer_name,
        SUM(o.profit) AS total_profit
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.region, c.customer_name
)
SELECT
    region,
    customer_name,
    total_profit,
    RANK() OVER (
        PARTITION BY region
        ORDER BY total_profit DESC
    ) AS rank_poradie,
    DENSE_RANK() OVER (
        PARTITION BY region
        ORDER BY total_profit DESC
    ) AS dense_rank_poradie
FROM customers_profits
ORDER BY region ASC, total_profit DESC;