-- E-Commerce Return & Refund Tracking System
-- Single File SQL Solution

CREATE DATABASE ReturnRefundDB;
USE ReturnRefundDB;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    email VARCHAR(80),
    city VARCHAR(50),
    phone VARCHAR(15)
);

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(80),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE CustomerOrder (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    order_status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE OrderItem (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    item_total DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES CustomerOrder(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE ReturnRequest (
    return_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    return_date DATE,
    return_reason VARCHAR(100),
    return_status VARCHAR(30),
    FOREIGN KEY (order_id) REFERENCES CustomerOrder(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE Refund (
    refund_id INT PRIMARY KEY,
    return_id INT,
    refund_amount DECIMAL(10,2),
    refund_status VARCHAR(30),
    refund_date DATE,
    FOREIGN KEY (return_id) REFERENCES ReturnRequest(return_id)
);

INSERT INTO Customer VALUES
(1, 'Karan Mehta', 'karan@email.com', 'Nagpur', '9999999999'),
(2, 'Sneha Patil', 'sneha@email.com', 'Pune', '8888888888'),
(3, 'Rohan Sharma', 'rohan@email.com', 'Mumbai', '7777777777'),
(4, 'Priya Verma', 'priya@email.com', 'Delhi', '6666666666');

INSERT INTO Product VALUES
(1, 'Bluetooth Headphones', 'Electronics', 1499.00),
(2, 'Running Shoes', 'Fashion', 2499.00),
(3, 'Smart Watch', 'Electronics', 3999.00),
(4, 'Cotton T-Shirt', 'Fashion', 799.00),
(5, 'Mixer Grinder', 'Home Appliance', 2999.00);

INSERT INTO CustomerOrder VALUES
(1, 1, '2026-04-20', 1499.00, 'Delivered'),
(2, 2, '2026-04-21', 2499.00, 'Delivered'),
(3, 3, '2026-04-22', 3999.00, 'Delivered'),
(4, 4, '2026-04-23', 3798.00, 'Delivered'),
(5, 1, '2026-04-24', 799.00, 'Delivered');

INSERT INTO OrderItem VALUES
(1, 1, 1, 1, 1499.00),
(2, 2, 2, 1, 2499.00),
(3, 3, 3, 1, 3999.00),
(4, 4, 5, 1, 2999.00),
(5, 4, 4, 1, 799.00),
(6, 5, 4, 1, 799.00);

INSERT INTO ReturnRequest VALUES
(1, 1, 1, '2026-04-25', 'Sound not working', 'Approved'),
(2, 2, 2, '2026-04-26', 'Wrong size', 'Approved'),
(3, 3, 3, '2026-04-26', 'Defective item', 'Pending'),
(4, 4, 5, '2026-04-27', 'Damaged product', 'Rejected'),
(5, 5, 4, '2026-04-28', 'Wrong color delivered', 'Approved');

INSERT INTO Refund VALUES
(1, 1, 1499.00, 'Refunded', '2026-04-26'),
(2, 2, 2499.00, 'Processing', NULL),
(3, 3, 3999.00, 'Pending', NULL),
(4, 4, 0.00, 'Rejected', NULL),
(5, 5, 799.00, 'Refunded', '2026-04-29');

-- 1. Products returned the most
SELECT 
    p.product_name,
    p.category,
    COUNT(rr.return_id) AS total_returns
FROM ReturnRequest rr
JOIN Product p
ON rr.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_returns DESC;

-- 2. Customers with most return requests
SELECT 
    c.customer_name,
    COUNT(rr.return_id) AS total_return_requests
FROM ReturnRequest rr
JOIN CustomerOrder co
ON rr.order_id = co.order_id
JOIN Customer c
ON co.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_return_requests DESC;

-- 3. Pending refunds
SELECT 
    c.customer_name,
    p.product_name,
    rr.return_reason,
    rf.refund_amount,
    rf.refund_status
FROM Refund rf
JOIN ReturnRequest rr
ON rf.return_id = rr.return_id
JOIN Product p
ON rr.product_id = p.product_id
JOIN CustomerOrder co
ON rr.order_id = co.order_id
JOIN Customer c
ON co.customer_id = c.customer_id
WHERE rf.refund_status IN ('Pending', 'Processing');

-- 4. Total refunded amount
SELECT 
    SUM(refund_amount) AS total_refunded_amount
FROM Refund
WHERE refund_status = 'Refunded';

-- 5. Most common return reasons
SELECT 
    return_reason,
    COUNT(return_id) AS reason_count
FROM ReturnRequest
GROUP BY return_reason
ORDER BY reason_count DESC;

-- 6. Return count by product category
SELECT 
    p.category,
    COUNT(rr.return_id) AS total_returns
FROM ReturnRequest rr
JOIN Product p
ON rr.product_id = p.product_id
GROUP BY p.category
ORDER BY total_returns DESC;

-- 7. Approved return requests
SELECT 
    c.customer_name,
    p.product_name,
    rr.return_date,
    rr.return_reason,
    rr.return_status
FROM ReturnRequest rr
JOIN Product p
ON rr.product_id = p.product_id
JOIN CustomerOrder co
ON rr.order_id = co.order_id
JOIN Customer c
ON co.customer_id = c.customer_id
WHERE rr.return_status = 'Approved';

-- 8. Refund summary with customer and product details
SELECT 
    rf.refund_id,
    c.customer_name,
    p.product_name,
    rr.return_status,
    rf.refund_amount,
    rf.refund_status,
    rf.refund_date
FROM Refund rf
JOIN ReturnRequest rr
ON rf.return_id = rr.return_id
JOIN Product p
ON rr.product_id = p.product_id
JOIN CustomerOrder co
ON rr.order_id = co.order_id
JOIN Customer c
ON co.customer_id = c.customer_id;