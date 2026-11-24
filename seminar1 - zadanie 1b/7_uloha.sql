-- Active: 1790182470823@@127.0.0.1@5432@datacraftinglab_db
SELECT product_category, total_sales
FROM (
    SELECT product_category,
        SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY product_category
) AS category_summary
WHERE total_sales > 50000000
ORDER BY total_sales DESC;