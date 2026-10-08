-- Active: 1790182470823@@127.0.0.1@5432@datacraftinglab_db
WITH customer_transactions AS (
    SELECT 
        customer_id,
        product_name,
        sale_date,
        total_amount,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sale_date DESC) AS row_num
    FROM flourmills_sales
)
SELECT 
    customer_id,
    product_name,
    sale_date,
    total_amount
FROM customer_transactions
WHERE row_num = 1
ORDER BY customer_id ASC;