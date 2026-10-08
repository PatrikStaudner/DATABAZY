-- Active: 1790182470823@@127.0.0.1@5432@superstore
CREATE OR REPLACE PROCEDURE apply_regional_discount(
    region_name VARCHAR,
    discount_rate NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE orders
    SET sales = sales * (1 - discount_rate)
    FROM customers
    WHERE orders.customer_id = customers.customer_id
      AND customers.region = region_name;

    RAISE NOTICE 'Aplikovana zlava % pre region %', discount_rate, region_name;
END;
$$;

CALL apply_regional_discount('West', 0.10);