-- Active: 1790182470823@@127.0.0.1@5432@datacraftinglab_db
SELECT *
FROM flourmills_sales t1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.product_name = t1.product_name 
    GROUP BY t2.product_name 
    HAVING COUNT(DISTINCT EXTRACT(MONTH FROM t2.sale_date)) > 1
);