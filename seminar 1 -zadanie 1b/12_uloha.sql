-- Active: 1790182470823@@127.0.0.1@5432@datacraftinglab_db
SELECT DISTINCT product_category
FROM flourmills_sales t1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.product_category = t1.product_category
    GROUP BY t2.product_category
    HAVING COUNT(DISTINCT t2.region) > 3
);