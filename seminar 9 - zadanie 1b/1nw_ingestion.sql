CREATE SCHEMA IF NOT EXISTS bronze;

CREATE TABLE IF NOT EXISTS bronze.categories (
    categoryid INT,
    categoryname TEXT,
    description TEXT
);

CREATE TABLE IF NOT EXISTS bronze.customers (
    customerid INT,
    customername TEXT,
    contactname TEXT,
    address TEXT,
    city TEXT,
    postalcode TEXT,
    country TEXT
);

CREATE TABLE IF NOT EXISTS bronze.employees (
    employeeid INT,
    lastname TEXT,
    firstname TEXT,
    birthdate TIMESTAMP,
    photo TEXT,
    notes TEXT
);

CREATE TABLE IF NOT EXISTS bronze.orderdetails (
    orderdetailid INT,
    orderid INT,
    productid INT,
    quantity INT
);

CREATE TABLE IF NOT EXISTS bronze.orders (
    orderid INT,
    customerid INT,
    employeeid INT,
    orderdate TIMESTAMP,
    shipperid INT
);

CREATE TABLE IF NOT EXISTS bronze.products (
    productid INT,
    productname TEXT,
    supplierid INT,
    categoryid INT,
    unit TEXT,
    price NUMERIC(10, 2)
);

CREATE TABLE IF NOT EXISTS bronze.shippers (
    shipperid INT,
    shippername TEXT,
    phone TEXT
);

CREATE TABLE IF NOT EXISTS bronze.suppliers (
    supplierid INT,
    suppliername TEXT,
    contactname TEXT,
    address TEXT,
    city TEXT,
    postalcode TEXT,
    country TEXT,
    phone TEXT
);

TRUNCATE bronze.categories, bronze.customers, bronze.employees, bronze.orderdetails,
         bronze.orders, bronze.products, bronze.shippers, bronze.suppliers;

\copy bronze.categories FROM '../csv/northwind/categories.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';
\copy bronze.customers FROM '../csv/northwind/customers.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';
\copy bronze.employees FROM '../csv/northwind/employees.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';
\copy bronze.orderdetails FROM '../csv/northwind/orderdetails.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';
\copy bronze.orders FROM '../csv/northwind/orders.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';
\copy bronze.products FROM '../csv/northwind/products.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';
\copy bronze.shippers FROM '../csv/northwind/shippers.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';
\copy bronze.suppliers FROM '../csv/northwind/suppliers.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8';