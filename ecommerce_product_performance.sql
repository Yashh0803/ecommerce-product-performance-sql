-- ============================================
-- E-COMMERCE PRODUCT PERFORMANCE ANALYSIS
-- Author: Yash
-- Tools: MySQL / PostgreSQL
-- ============================================

-- 1️⃣ CREATE DATABASE
CREATE DATABASE ecommerce_analysis;
USE ecommerce_analysis;

-- ============================================
-- 2️⃣ CREATE TABLES
-- ============================================

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock_quantity INT
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ============================================
-- 3️⃣ INSERT DATA
-- ============================================

INSERT INTO products VALUES
(1, 'iPhone 14', 'Electronics', 70000, 40),
(2, 'Samsung Galaxy S23', 'Electronics', 65000, 35),
(3, 'Dell Laptop', 'Electronics', 55000, 25),
(4, 'Sony Headphones', 'Electronics', 3000, 80),
(5, 'Nike Shoes', 'Fashion', 4500, 100),
(6, 'Adidas Shoes', 'Fashion', 4200, 90),
(7, 'Levi Jeans', 'Fashion', 2500, 120),
(8, 'Kitchen Mixer', 'Home Appliances', 6000, 40),
(9, 'Office Chair', 'Furniture', 8500, 30),
(10, 'Study Table', 'Furniture', 12000, 20);

INSERT INTO orders VALUES
(101, '2025-01-05'),
(102, '2025-01-12'),
(103, '2025-01-18'),
(104, '2025-02-02'),
(105, '2025-02-10'),
(106, '2025-02-15'),
(107, '2025-03-01'),
(108, '2025-03-10'),
(109, '2025-03-18'),
(110, '2025-03-25');

INSERT INTO order_items VALUES
(1, 101, 1, 2),
(2, 101, 5, 1),
(3, 102, 2, 1),
(4, 102, 7, 2),
(5, 103, 3, 1),
(6, 103, 4, 3),
(7, 104, 1, 1),
(8, 104, 6, 2),
(9, 105, 5, 3),
(10, 105, 8, 1),
(11, 106, 4, 2),
(12, 106, 9, 1),
(13, 107, 2, 2),
(14, 107, 7, 1),
(15, 108, 10, 1),
(16, 108, 3, 1),
(17, 109, 5, 2),
(18, 109, 4, 1),
(19, 110, 6, 3),
(20, 110, 8, 2);

-- ============================================
-- 4️⃣ INDEXES (QUERY OPTIMIZATION)
-- ============================================

CREATE INDEX idx_product_id ON order_items(product_id);
CREATE INDEX idx_order_id ON order_items(order_id);
CREATE INDEX idx_order_date ON orders(order_date);

-- ============================================
-- 5️⃣ ANALYSIS QUERIES
-- ============================================

-- 🔹 Product Demand Analysis
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_units_sold DESC;

-- 🔹 Monthly Revenue Analysis
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(oi.quantity * p.price) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY month
ORDER BY month;

-- 🔹 Category Performance
SELECT 
    p.category,
    SUM(oi.quantity * p.price) AS category_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;

-- 🔹 Inventory Risk (High Demand, Low Stock)
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_sold,
    p.stock_quantity
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name, p.stock_quantity
HAVING total_sold > p.stock_quantity;

-- ============================================
-- END OF PROJECT
-- ============================================
