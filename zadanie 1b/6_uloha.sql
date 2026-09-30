-- Active: 1790182470823@@127.0.0.1@5432@datacraftinglab_db
SELECT month, monthly_sales
FROM (
    SELECT EXTRACT(MONTH FROM sale_date) AS month,
            SUM(total_amount) AS monthly_sales
    FROM flourmills_sales
    GROUP BY EXTRACT(MONTH FROM sale_date)
) AS monthly_summary
ORDER BY monthly_sales DESC;