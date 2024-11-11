drop database if exists interv_prep_1 ;
create database interv_prep_1;
use interv_prep_1;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50),
    created_at DATE,
    region VARCHAR(20)
);

INSERT INTO customers (customer_id, name, email, created_at, region) VALUES
(1, 'Alice', 'alice@example.com', '2023-01-15', 'East'),
(2, 'Bob', 'bob@example.com', '2023-03-20', 'West'),
(3, 'Charlie', 'charlie@example.com', '2023-02-10', 'East'),
(4, 'David', 'david@example.com', '2022-12-01', 'South'),
(5, 'Emma', 'emma@example.com', '2023-04-25', 'North'),
(6, 'Frank', 'frank@example.com', '2022-10-18', 'East'),
(7, 'Grace', 'grace@example.com', '2023-05-05', 'South'),
(8, 'Hannah', 'hannah@example.com', '2022-11-30', 'West'),
(9, 'Ian', 'ian@example.com', '2023-01-10', 'North'),
(10, 'Julia', 'julia@example.com', '2023-03-12', 'East');

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders (order_id, customer_id, order_date, total_amount, status) VALUES
(101, 1, '2023-03-01', 250.00, 'Completed'),
(102, 2, '2023-03-15', 100.00, 'Completed'),
(103, 1, '2023-04-05', 150.00, 'Completed'),
(104, 3, '2023-02-20', 300.00, 'Completed'),
(105, 4, '2022-12-15', 500.00, 'Completed'),
(106, 5, '2023-04-30', 200.00, 'Cancelled'),
(107, 7, '2023-05-10', 350.00, 'Completed'),
(108, 8, '2022-11-01', 150.00, 'Pending'),
(109, 9, '2023-01-15', 250.00, 'Completed'),
(110, 10, '2023-03-20', 300.00, 'Pending');

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

INSERT INTO products (product_id, name, category, price) VALUES
(1, 'Laptop', 'Electronics', 1000.00),
(2, 'Phone', 'Electronics', 500.00),
(3, 'Tablet', 'Electronics', 300.00),
(4, 'Chair', 'Furniture', 150.00),
(5, 'Desk', 'Furniture', 200.00),
(6, 'Monitor', 'Electronics', 200.00),
(7, 'Keyboard', 'Electronics', 50.00),
(8, 'Headphones', 'Electronics', 100.00),
(9, 'Sofa', 'Furniture', 600.00),
(10, 'Coffee Table', 'Furniture', 120.00);


CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES
(1, 101, 1, 1),
(2, 101, 4, 2),
(3, 102, 2, 1),
(4, 103, 3, 1),
(5, 104, 5, 3),
(6, 105, 1, 1),
(7, 106, 2, 1),
(8, 107, 9, 1),
(9, 107, 2, 2),
(10, 108, 4, 1),
(11, 108, 5, 1),
(12, 109, 4, 1),
(13, 109, 10, 1),
(14, 110, 8, 2);
