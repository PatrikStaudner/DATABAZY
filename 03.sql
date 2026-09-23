CREATE Table orders (
    order_id VARCHAR(20) PRIMARY KEY ,
    customer_id VARCHAR(20),
    product_id VARCHAR(20),
    order_date DATE,
    sales DECIMAL(10, 2),
    quantity INT,
    discount DECIMAL(10, 2),
    profit DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);