-- Active: 1790182470823@@127.0.0.1@5432@datacraftinglab_db
SELECT * 
FROM flourmills_sales t1
WHERE EXISTS(
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.region = t1.region
    AND EXTRACT(YEAR FROM t2.sale_date) = 2024
)