-- Active: 1790182470823@@127.0.0.1@5432@superstore
WITH monthly_aggregated AS (
    SELECT
        DATE_TRUNC('month', order_date):: DATE AS month,
        SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)::DATE
),
monthly_with_lag AS (
    SELECT
        month,
        monthly_sales,
        LAG(monthly_sales) OVER (ORDER BY month ASC) AS prev_month_sales
    FROM monthly_aggregated
)
SELECT
    month,
    monthly_sales,
    prev_month_sales,
    (monthly_sales - prev_month_sales) AS sales_change,
    ROUND(
        ((monthly_sales - prev_month_sales) / prev_month_sales) * 100,
        2
    ) AS growth_percenage
FROM monthly_with_lag
ORDER BY month ASC;