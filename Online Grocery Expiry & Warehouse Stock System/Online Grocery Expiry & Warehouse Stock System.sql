-- Online Grocery Expiry & Warehouse Stock System
-- Single File SQL Solution

CREATE DATABASE GroceryWarehouseDB;
USE GroceryWarehouseDB;

CREATE TABLE Supplier (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(80),
    phone VARCHAR(15),
    email VARCHAR(80),
    city VARCHAR(50)
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(80),
    category VARCHAR(50),
    unit VARCHAR(30),
    minimum_stock_level INT
);

CREATE TABLE Warehouse (
    warehouse_id INT PRIMARY KEY,
    warehouse_name VARCHAR(80),
    city VARCHAR(50),
    capacity_units INT
);

CREATE TABLE StockBatch (
    batch_id INT PRIMARY KEY,
    product_id INT,
    supplier_id INT,
    warehouse_id INT,
    batch_code VARCHAR(30),
    manufacturing_date DATE,
    expiry_date DATE,
    quantity_available INT,
    batch_status VARCHAR(30),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)
);

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(80),
    phone VARCHAR(15),
    email VARCHAR(80),
    city VARCHAR(50)
);

CREATE TABLE CustomerOrder (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(30),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE OrderItem (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price_per_unit DECIMAL(10,2),
    item_total DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES CustomerOrder(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE StockAlert (
    alert_id INT PRIMARY KEY,
    product_id INT,
    warehouse_id INT,
    alert_type VARCHAR(50),
    alert_message VARCHAR(150),
    alert_date DATE,
    alert_status VARCHAR(30),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)
);

INSERT INTO Supplier VALUES
(1, 'FreshFarm Supplies', '9000011111', 'freshfarm@email.com', 'Nagpur'),
(2, 'Daily Dairy Distributors', '9000022222', 'dairy@email.com', 'Pune'),
(3, 'Organic Basket Traders', '9000033333', 'organic@email.com', 'Mumbai'),
(4, 'GreenLeaf Wholesale', '9000044444', 'greenleaf@email.com', 'Bangalore');

INSERT INTO Product VALUES
(1, 'Milk', 'Dairy', 'Litre', 50),
(2, 'Bread', 'Bakery', 'Packet', 40),
(3, 'Apple', 'Fruits', 'Kg', 30),
(4, 'Rice', 'Grains', 'Kg', 100),
(5, 'Curd', 'Dairy', 'Cup', 60),
(6, 'Spinach', 'Vegetables', 'Bundle', 25);

INSERT INTO Warehouse VALUES
(1, 'Nagpur Cold Storage', 'Nagpur', 5000),
(2, 'Pune Grocery Hub', 'Pune', 7000),
(3, 'Mumbai Fresh Warehouse', 'Mumbai', 6000);

INSERT INTO StockBatch VALUES
(1, 1, 2, 1, 'MILK-B001', '2026-04-25', '2026-05-02', 120, 'Available'),
(2, 2, 1, 1, 'BREAD-B001', '2026-04-27', '2026-04-30', 35, 'Low Stock'),
(3, 3, 3, 2, 'APPLE-B001', '2026-04-20', '2026-05-10', 80, 'Available'),
(4, 4, 4, 2, 'RICE-B001', '2026-03-01', '2027-03-01', 300, 'Available'),
(5, 5, 2, 3, 'CURD-B001', '2026-04-24', '2026-04-28', 45, 'Expired'),
(6, 6, 3, 3, 'SPINACH-B001', '2026-04-28', '2026-05-01', 20, 'Low Stock'),
(7, 1, 2, 2, 'MILK-B002', '2026-04-28', '2026-05-05', 90, 'Available'),
(8, 3, 3, 1, 'APPLE-B002', '2026-04-18', '2026-04-30', 25, 'Near Expiry');

INSERT INTO Customer VALUES
(1, 'Atharva Kedar', '9999999999', 'atharva@email.com', 'Nagpur'),
(2, 'Rohan Mehta', '8888888888', 'rohan@email.com', 'Pune'),
(3, 'Sneha Patil', '7777777777', 'sneha@email.com', 'Mumbai'),
(4, 'Priya Sharma', '6666666666', 'priya@email.com', 'Bangalore');

INSERT INTO CustomerOrder VALUES
(1, 1, '2026-04-29', 'Delivered', 260.00),
(2, 2, '2026-04-29', 'Pending', 180.00),
(3, 3, '2026-04-28', 'Delivered', 420.00),
(4, 4, '2026-04-28', 'Cancelled', 150.00);

INSERT INTO OrderItem VALUES
(1, 1, 1, 2, 60.00, 120.00),
(2, 1, 2, 2, 35.00, 70.00),
(3, 1, 3, 1, 70.00, 70.00),
(4, 2, 6, 3, 30.00, 90.00),
(5, 2, 2, 2, 45.00, 90.00),
(6, 3, 4, 5, 60.00, 300.00),
(7, 3, 5, 3, 40.00, 120.00),
(8, 4, 3, 2, 75.00, 150.00);

INSERT INTO StockAlert VALUES
(1, 2, 1, 'Low Stock', 'Bread stock is below minimum level.', '2026-04-29', 'Open'),
(2, 5, 3, 'Expired Stock', 'Curd batch has expired and must be removed.', '2026-04-29', 'Open'),
(3, 6, 3, 'Low Stock', 'Spinach stock is below minimum level.', '2026-04-29', 'Open'),
(4, 3, 1, 'Near Expiry', 'Apple batch will expire soon.', '2026-04-29', 'In Review');

-- 1. Show all stock batches with product, supplier, and warehouse details
SELECT 
    sb.batch_id,
    sb.batch_code,
    p.product_name,
    p.category,
    s.supplier_name,
    w.warehouse_name,
    sb.manufacturing_date,
    sb.expiry_date,
    sb.quantity_available,
    sb.batch_status
FROM StockBatch sb
JOIN Product p
ON sb.product_id = p.product_id
JOIN Supplier s
ON sb.supplier_id = s.supplier_id
JOIN Warehouse w
ON sb.warehouse_id = w.warehouse_id;

-- 2. Find low-stock products
SELECT 
    p.product_name,
    w.warehouse_name,
    sb.quantity_available,
    p.minimum_stock_level,
    sb.batch_status
FROM StockBatch sb
JOIN Product p
ON sb.product_id = p.product_id
JOIN Warehouse w
ON sb.warehouse_id = w.warehouse_id
WHERE sb.quantity_available < p.minimum_stock_level;

-- 3. Find expired stock batches
SELECT 
    sb.batch_code,
    p.product_name,
    w.warehouse_name,
    sb.expiry_date,
    sb.quantity_available,
    sb.batch_status
FROM StockBatch sb
JOIN Product p
ON sb.product_id = p.product_id
JOIN Warehouse w
ON sb.warehouse_id = w.warehouse_id
WHERE sb.expiry_date < '2026-04-29'
   OR sb.batch_status = 'Expired';

-- 4. Find near-expiry stock batches within next 3 days
SELECT 
    sb.batch_code,
    p.product_name,
    w.warehouse_name,
    sb.expiry_date,
    sb.quantity_available,
    sb.batch_status
FROM StockBatch sb
JOIN Product p
ON sb.product_id = p.product_id
JOIN Warehouse w
ON sb.warehouse_id = w.warehouse_id
WHERE sb.expiry_date BETWEEN '2026-04-29' AND '2026-05-02';

-- 5. Total stock available for each product
SELECT 
    p.product_name,
    p.category,
    SUM(sb.quantity_available) AS total_available_stock
FROM StockBatch sb
JOIN Product p
ON sb.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_available_stock DESC;

-- 6. Warehouse-wise total stock
SELECT 
    w.warehouse_name,
    w.city,
    SUM(sb.quantity_available) AS total_stock_units
FROM StockBatch sb
JOIN Warehouse w
ON sb.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_name, w.city
ORDER BY total_stock_units DESC;

-- 7. Suppliers providing most products
SELECT 
    s.supplier_name,
    COUNT(DISTINCT sb.product_id) AS total_products_supplied
FROM StockBatch sb
JOIN Supplier s
ON sb.supplier_id = s.supplier_id
GROUP BY s.supplier_name
ORDER BY total_products_supplied DESC;

-- 8. Show customer orders with order status
SELECT 
    co.order_id,
    c.customer_name,
    c.city,
    co.order_date,
    co.order_status,
    co.total_amount
FROM CustomerOrder co
JOIN Customer c
ON co.customer_id = c.customer_id
ORDER BY co.order_date DESC;

-- 9. Pending or active customer orders
SELECT 
    co.order_id,
    c.customer_name,
    co.order_date,
    co.order_status,
    co.total_amount
FROM CustomerOrder co
JOIN Customer c
ON co.customer_id = c.customer_id
WHERE co.order_status = 'Pending';

-- 10. Most ordered grocery products
SELECT 
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_quantity_ordered
FROM OrderItem oi
JOIN Product p
ON oi.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_quantity_ordered DESC;

-- 11. Show all stock alerts
SELECT 
    sa.alert_id,
    p.product_name,
    w.warehouse_name,
    sa.alert_type,
    sa.alert_message,
    sa.alert_date,
    sa.alert_status
FROM StockAlert sa
JOIN Product p
ON sa.product_id = p.product_id
JOIN Warehouse w
ON sa.warehouse_id = w.warehouse_id;

-- 12. Update expired batch status
UPDATE StockBatch
SET batch_status = 'Expired'
WHERE expiry_date < '2026-04-29';