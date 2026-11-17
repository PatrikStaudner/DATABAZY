-- Active: 1790182470823@@127.0.0.1@5432@datacraftinglab_db
SELECT product_name, region, total_amount,
    (
        SELECT MIN(total_amount)
        FROM flourmills_sales t2
        WHERE  t2.region = t1.region
    ) AS region_min_amount
FROM flourmills_sales t1;