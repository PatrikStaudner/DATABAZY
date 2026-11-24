-- Active: 1790182470823@@127.0.0.1@5432@datacraftinglab_db
SELECT product_name, total_amount,
    total_amount / (SELECT SUM(total_amount) FROM flourmills_sales) AS amount_share
FROM flourmills_sales 
    
