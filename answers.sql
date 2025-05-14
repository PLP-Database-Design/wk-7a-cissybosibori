-- GOAL:
-- ✅ Understand the principles of good database design and normalization
-- ✅ Apply 1NF, 2NF, 3NF
-- ✅ Practice JOINs (INNER, LEFT, RIGHT)
-- ✅ Retrieve meaningful information from multiple related tables

-- STEP 1: SETUP DATABASE
CREATE DATABASE IF NOT EXISTS salesDB;
USE salesDB;

-- STEP 2: UNNORMALIZED STRUCTURE EXAMPLE
-- Example (not implemented):
-- | order_id | customer_name | product_names     | total_price |
-- |----------|----------------|-------------------|-------------|
-- | 1        | Alice          | Laptop, Mouse     | 700         |
-- | 2        | Bob            | Keyboard          | 150         |

-- STEP 3: NORMALIZED STRUCTURE
-- 1NF: Break multi-value fields
-- 2NF: Remove partial dependencies
-- 3NF: Remove transitive dependencies

-- CUSTOMERS
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  customer_name VARCHAR(100)
);

-- PRODUCTS
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  price DECIMAL(10,2)
);

-- ORDERS
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ORDER ITEMS (junction table for orders and products)
CREATE TABLE order_items (
  order_id INT,
  product_id INT,
  quantity INT,
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- STEP 4: INSERT DATA
INSERT INTO customers VALUES
(1, 'Alice'),
(2, 'Bob');

INSERT INTO products VALUES
(101, 'Laptop', 600.00),
(102, 'Mouse', 50.00),
(103, 'Keyboard', 150.00);

INSERT INTO orders VALUES
(1, 1, '2025-05-01'),
(2, 2, '2025-05-02');

INSERT INTO order_items VALUES
(1, 101, 1),
(1, 102, 1),
(2, 103, 1);

-- STEP 5: PRACTICE JOINS

-- INNER JOIN: Show each order with customer and product details
SELECT o.order_id, c.customer_name, p.product_name, oi.quantity
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id;

-- LEFT JOIN: Show all customers even if they haven't made orders
SELECT c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- RIGHT JOIN (simulate using LEFT JOIN with reversed tables in MySQL):
-- Show all products and any orders they belong to
SELECT p.product_name, oi.order_id
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id;
