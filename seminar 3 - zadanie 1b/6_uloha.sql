-- Active: 1790182470823@@127.0.0.1@5432@datacraftinglab_db
WITH RECURSIVE date_boundaries AS (
    SELECT MIN(sale_date) AS min_date, MAX(sale_date) AS max_date
    FROM flourmills_sales
),
calendar AS (
    SELECT min_date AS cal_date, max_date
    FROM date_boundaries
    UNION ALL
    SELECT cal_date + INTERVAL '1 day', max_date
    FROM calendar
    WHERE cal_date < max_date
)
SELECT cal_date
FROM calendar
ORDER BY cal_date ASC;