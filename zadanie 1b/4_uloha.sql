-- Active: 1790182470823@@127.0.0.1@5432@datacraftinglab_db
SELECT
    product_name, total_amount, 
    (SELECT avg(total_amount) FROM flourmills_sales) AS avg_amount 
FROM flourmills_sales 
WHERE total_amount = 9511208.41