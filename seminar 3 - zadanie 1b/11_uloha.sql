-- Active: 1790182470823@@127.0.0.1@5432@retail_sales
CREATE OR REPLACE PROCEDURE get_sales_between(
    start_date DATE,
    end_date DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_sales NUMERIC(10,2);
BEGIN
    -- Výpočet súčtu predajov pre zadané obdobie
    SELECT SUM(sales)
    INTO v_total_sales
    FROM orders
    WHERE order_date BETWEEN start_date AND end_date;

    -- Výpis začiatku, konca a vypočítanej hodnoty
    RAISE NOTICE 'Celkovy predaj od % do % je: %', start_date, end_date, v_total_sales;
END;
$$;
CALL get_sales_between('2024-01-01', '2024-03-31');
SELECT SUM(sales)
FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-03-31';