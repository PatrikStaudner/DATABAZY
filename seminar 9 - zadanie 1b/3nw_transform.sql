BEGIN;

CREATE SCHEMA IF NOT EXISTS gold;

CREATE TABLE IF NOT EXISTS gold.sdim_supplier (
    supplier_id INT PRIMARY KEY,
    supplier_name TEXT,
    supplier_contact TEXT,
    city TEXT,
    country TEXT
);

CREATE TABLE IF NOT EXISTS gold.dim_product (
    product_id INT PRIMARY KEY,
    product_name TEXT,
    product_price NUMERIC(10, 2),
    supplier_id INT REFERENCES gold.sdim_supplier(supplier_id)
);

CREATE TABLE IF NOT EXISTS gold.dim_category (
    category_id INT PRIMARY KEY,
    category_name TEXT
);

CREATE TABLE IF NOT EXISTS gold.sdim_country (
    country_id SERIAL PRIMARY KEY,
    country_name TEXT UNIQUE
);

CREATE TABLE IF NOT EXISTS gold.sdim_city (
    city_id SERIAL PRIMARY KEY,
    city_name TEXT UNIQUE
);

CREATE TABLE IF NOT EXISTS gold.dim_customer (
    customer_id INT PRIMARY KEY,
    customer_name TEXT,
    contact_name TEXT,
    address TEXT,
    city_id INT REFERENCES gold.sdim_city(city_id),
    country_id INT REFERENCES gold.sdim_country(country_id)
);

CREATE TABLE IF NOT EXISTS gold.dim_employee (
    employee_id INT PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    birth_date DATE
);

CREATE TABLE IF NOT EXISTS gold.dim_shipper (
    shipper_id INT PRIMARY KEY,
    shipper_name TEXT
);

CREATE TABLE IF NOT EXISTS gold.sdim_month (
    month_id INT PRIMARY KEY,
    month_name TEXT
);

CREATE TABLE IF NOT EXISTS gold.sdim_quarter (
    quarter_id INT PRIMARY KEY,
    quarter_name TEXT
);

CREATE TABLE IF NOT EXISTS gold.dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day INT NOT NULL,
    week_day INT NOT NULL,
    week INT NOT NULL,
    year INT NOT NULL,
    month_id INT REFERENCES gold.sdim_month(month_id),
    quarter_id INT REFERENCES gold.sdim_quarter(quarter_id)
);

CREATE TABLE IF NOT EXISTS gold.sdim_hour (
    hour_id INT PRIMARY KEY,
    hour_12 INT NOT NULL,
    am_pm TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.sdim_day_part (
    day_part_id INT PRIMARY KEY,
    part_of_day TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.dim_time (
    time_id INT PRIMARY KEY,
    full_time TIME NOT NULL,
    minute INT NOT NULL,
    second INT NOT NULL,
    hour_id INT REFERENCES gold.sdim_hour(hour_id),
    day_part_id INT REFERENCES gold.sdim_day_part(day_part_id)
);

CREATE TABLE IF NOT EXISTS gold.fact_orders (
    fact_orders_id INT PRIMARY KEY,
    quantity INT NOT NULL,
    product_unit TEXT,
    sales_amount NUMERIC(10, 2) NOT NULL,
    category_id INT REFERENCES gold.dim_category(category_id),
    product_id INT REFERENCES gold.dim_product(product_id),
    customer_id INT REFERENCES gold.dim_customer(customer_id),
    employee_id INT REFERENCES gold.dim_employee(employee_id),
    shipper_id INT REFERENCES gold.dim_shipper(shipper_id),
    date_id INT REFERENCES gold.dim_date(date_id),
    time_id INT REFERENCES gold.dim_time(time_id)
);

CREATE INDEX IF NOT EXISTS idx_fact_orders_category ON gold.fact_orders(category_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_product ON gold.fact_orders(product_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_customer ON gold.fact_orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_employee ON gold.fact_orders(employee_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_shipper ON gold.fact_orders(shipper_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_date ON gold.fact_orders(date_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_time ON gold.fact_orders(time_id);

TRUNCATE gold.fact_orders, gold.dim_product, gold.sdim_supplier, gold.dim_category,
         gold.dim_customer, gold.sdim_city, gold.sdim_country, gold.dim_employee,
         gold.dim_shipper, gold.dim_date, gold.sdim_month, gold.sdim_quarter,
         gold.dim_time, gold.sdim_hour, gold.sdim_day_part
RESTART IDENTITY CASCADE;

INSERT INTO gold.sdim_supplier (supplier_id, supplier_name, supplier_contact, city, country)
SELECT supplier_id, supplier_name, supplier_contact, city, country
FROM silver.stg_suppliers;

INSERT INTO gold.dim_product (product_id, product_name, product_price, supplier_id)
SELECT product_id, product_name, product_price, supplier_id
FROM silver.stg_products;

INSERT INTO gold.dim_category (category_id, category_name)
SELECT category_id, category_name
FROM silver.stg_categories;

INSERT INTO gold.sdim_country (country_name)
SELECT DISTINCT country
FROM silver.stg_customers
WHERE country IS NOT NULL;

INSERT INTO gold.sdim_city (city_name)
SELECT DISTINCT city
FROM silver.stg_customers
WHERE city IS NOT NULL;

INSERT INTO gold.dim_customer (customer_id, customer_name, contact_name, address, city_id, country_id)
SELECT
    c.customer_id,
    c.customer_name,
    c.contact_name,
    c.address,
    ci.city_id,
    co.country_id
FROM silver.stg_customers c
LEFT JOIN gold.sdim_city ci ON c.city = ci.city_name
LEFT JOIN gold.sdim_country co ON c.country = co.country_name;

INSERT INTO gold.dim_employee (employee_id, first_name, last_name, birth_date)
SELECT employee_id, first_name, last_name, birth_date
FROM silver.stg_employees;

INSERT INTO gold.dim_shipper (shipper_id, shipper_name)
SELECT shipper_id, shipper_name
FROM silver.stg_shippers;

INSERT INTO gold.sdim_month (month_id, month_name)
SELECT DISTINCT
    EXTRACT(MONTH FROM order_date)::INT,
    TRIM(TO_CHAR(order_date, 'Month'))
FROM silver.stg_orders
WHERE order_date IS NOT NULL;

INSERT INTO gold.sdim_quarter (quarter_id, quarter_name)
SELECT DISTINCT
    EXTRACT(QUARTER FROM order_date)::INT,
    'Q' || EXTRACT(QUARTER FROM order_date)::INT
FROM silver.stg_orders
WHERE order_date IS NOT NULL;

INSERT INTO gold.dim_date (date_id, full_date, day, week_day, week, year, month_id, quarter_id)
SELECT DISTINCT
    TO_CHAR(order_date, 'YYYYMMDD')::INT,
    order_date::DATE,
    EXTRACT(DAY FROM order_date)::INT,
    EXTRACT(ISODOW FROM order_date)::INT,
    EXTRACT(WEEK FROM order_date)::INT,
    EXTRACT(YEAR FROM order_date)::INT,
    EXTRACT(MONTH FROM order_date)::INT,
    EXTRACT(QUARTER FROM order_date)::INT
FROM silver.stg_orders
WHERE order_date IS NOT NULL;

INSERT INTO gold.sdim_hour (hour_id, hour_12, am_pm)
SELECT DISTINCT
    EXTRACT(HOUR FROM order_date)::INT,
    CASE
        WHEN EXTRACT(HOUR FROM order_date)::INT % 12 = 0 THEN 12
        ELSE EXTRACT(HOUR FROM order_date)::INT % 12
    END,
    CASE
        WHEN EXTRACT(HOUR FROM order_date)::INT < 12 THEN 'AM'
        ELSE 'PM'
    END
FROM silver.stg_orders
WHERE order_date IS NOT NULL;

INSERT INTO gold.sdim_day_part (day_part_id, part_of_day) VALUES
    (1, 'Night'),
    (2, 'Morning'),
    (3, 'Afternoon'),
    (4, 'Evening');

INSERT INTO gold.dim_time (time_id, full_time, minute, second, hour_id, day_part_id)
SELECT DISTINCT
    TO_CHAR(DATE_TRUNC('second', order_date), 'HH24MISS')::INT,
    DATE_TRUNC('second', order_date)::TIME,
    EXTRACT(MINUTE FROM order_date)::INT,
    EXTRACT(SECOND FROM order_date)::INT,
    EXTRACT(HOUR FROM order_date)::INT,
    CASE
        WHEN EXTRACT(HOUR FROM order_date)::INT BETWEEN 0 AND 5 THEN 1
        WHEN EXTRACT(HOUR FROM order_date)::INT BETWEEN 6 AND 11 THEN 2
        WHEN EXTRACT(HOUR FROM order_date)::INT BETWEEN 12 AND 17 THEN 3
        ELSE 4
    END
FROM silver.stg_orders
WHERE order_date IS NOT NULL;

INSERT INTO gold.fact_orders (
    fact_orders_id, quantity, product_unit, sales_amount,
    category_id, product_id, customer_id, employee_id, shipper_id, date_id, time_id
)
SELECT
    od.order_detail_id,
    od.quantity,
    p.product_unit,
    od.quantity * p.product_price,
    p.category_id,
    od.product_id,
    o.customer_id,
    o.employee_id,
    o.shipper_id,
    TO_CHAR(o.order_date, 'YYYYMMDD')::INT,
    TO_CHAR(DATE_TRUNC('second', o.order_date), 'HH24MISS')::INT
FROM silver.stg_orderdetails od
JOIN silver.stg_orders o ON od.order_id = o.order_id
JOIN silver.stg_products p ON od.product_id = p.product_id;

COMMIT;