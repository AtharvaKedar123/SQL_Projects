-- Online Food Delivery Analytics System
-- Single File SQL Solution

CREATE DATABASE FoodDeliveryDB;
USE FoodDeliveryDB;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(80)
);

CREATE TABLE Restaurant (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(80),
    cuisine VARCHAR(50),
    city VARCHAR(50),
    rating DECIMAL(2,1)
);

CREATE TABLE MenuItem (
    item_id INT PRIMARY KEY,
    restaurant_id INT,
    item_name VARCHAR(80),
    category VARCHAR(50),
    price DECIMAL(10,2),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id)
);

CREATE TABLE DeliveryPartner (
    partner_id INT PRIMARY KEY,
    partner_name VARCHAR(50),
    vehicle_type VARCHAR(30),
    phone VARCHAR(15)
);

CREATE TABLE FoodOrder (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    partner_id INT,
    order_date DATE,
    order_status VARCHAR(30),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id),
    FOREIGN KEY (partner_id) REFERENCES DeliveryPartner(partner_id)
);

CREATE TABLE OrderItem (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT,
    item_total DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES FoodOrder(order_id),
    FOREIGN KEY (item_id) REFERENCES MenuItem(item_id)
);

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    payment_amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES FoodOrder(order_id)
);

INSERT INTO Customer VALUES
(1, 'Atharva Kedar', 'Nagpur', '9999999999', 'atharva@email.com'),
(2, 'Rohan Mehta', 'Pune', '8888888888', 'rohan@email.com'),
(3, 'Sneha Patil', 'Mumbai', '7777777777', 'sneha@email.com'),
(4, 'Priya Sharma', 'Nagpur', '6666666666', 'priya@email.com');

INSERT INTO Restaurant VALUES
(1, 'Spice Hub', 'Indian', 'Nagpur', 4.5),
(2, 'Pizza Planet', 'Italian', 'Pune', 4.3),
(3, 'Burger Town', 'Fast Food', 'Mumbai', 4.1),
(4, 'Healthy Bowl', 'Healthy Food', 'Nagpur', 4.6);

INSERT INTO MenuItem VALUES
(101, 1, 'Paneer Butter Masala', 'Main Course', 220.00),
(102, 1, 'Veg Biryani', 'Rice', 180.00),
(103, 1, 'Butter Naan', 'Bread', 40.00),
(201, 2, 'Cheese Pizza', 'Pizza', 299.00),
(202, 2, 'Garlic Bread', 'Starter', 120.00),
(301, 3, 'Veg Burger', 'Burger', 149.00),
(302, 3, 'French Fries', 'Snacks', 99.00),
(401, 4, 'Protein Salad Bowl', 'Healthy', 250.00),
(402, 4, 'Fruit Smoothie', 'Beverage', 160.00);

INSERT INTO DeliveryPartner VALUES
(1, 'Suresh Yadav', 'Bike', '9000011111'),
(2, 'Vikas Thakur', 'Scooter', '9000022222'),
(3, 'Aman Khan', 'Bike', '9000033333');

INSERT INTO FoodOrder VALUES
(1, 1, 1, 1, '2026-04-29', 'Delivered', 440.00),
(2, 2, 2, 2, '2026-04-29', 'Out for Delivery', 419.00),
(3, 3, 3, 3, '2026-04-28', 'Delivered', 248.00),
(4, 4, 4, 1, '2026-04-28', 'Delivered', 410.00),
(5, 1, 1, 2, '2026-04-27', 'Cancelled', 220.00);

INSERT INTO OrderItem VALUES
(1, 1, 101, 1, 220.00),
(2, 1, 102, 1, 180.00),
(3, 1, 103, 1, 40.00),
(4, 2, 201, 1, 299.00),
(5, 2, 202, 1, 120.00),
(6, 3, 301, 1, 149.00),
(7, 3, 302, 1, 99.00),
(8, 4, 401, 1, 250.00),
(9, 4, 402, 1, 160.00),
(10, 5, 101, 1, 220.00);

INSERT INTO Payment VALUES
(1, 1, 'UPI', 'Paid', 440.00),
(2, 2, 'Cash', 'Pending', 419.00),
(3, 3, 'Card', 'Paid', 248.00),
(4, 4, 'UPI', 'Paid', 410.00),
(5, 5, 'UPI', 'Refunded', 220.00);

-- 1. Show all delivered orders
SELECT 
    fo.order_id,
    c.customer_name,
    r.restaurant_name,
    dp.partner_name,
    fo.order_date,
    fo.total_amount,
    fo.order_status
FROM FoodOrder fo
JOIN Customer c
ON fo.customer_id = c.customer_id
JOIN Restaurant r
ON fo.restaurant_id = r.restaurant_id
JOIN DeliveryPartner dp
ON fo.partner_id = dp.partner_id
WHERE fo.order_status = 'Delivered';

-- 2. Total revenue generated from paid orders
SELECT 
    SUM(payment_amount) AS total_revenue
FROM Payment
WHERE payment_status = 'Paid';

-- 3. Revenue by restaurant
SELECT 
    r.restaurant_name,
    SUM(fo.total_amount) AS restaurant_revenue
FROM FoodOrder fo
JOIN Restaurant r
ON fo.restaurant_id = r.restaurant_id
JOIN Payment p
ON fo.order_id = p.order_id
WHERE p.payment_status = 'Paid'
GROUP BY r.restaurant_name
ORDER BY restaurant_revenue DESC;

-- 4. Most popular food items
SELECT 
    mi.item_name,
    SUM(oi.quantity) AS total_quantity_ordered
FROM OrderItem oi
JOIN MenuItem mi
ON oi.item_id = mi.item_id
GROUP BY mi.item_name
ORDER BY total_quantity_ordered DESC;

-- 5. Customers with highest number of orders
SELECT 
    c.customer_name,
    COUNT(fo.order_id) AS total_orders
FROM FoodOrder fo
JOIN Customer c
ON fo.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;

-- 6. Pending or active orders
SELECT 
    fo.order_id,
    c.customer_name,
    r.restaurant_name,
    fo.order_status,
    p.payment_status,
    fo.total_amount
FROM FoodOrder fo
JOIN Customer c
ON fo.customer_id = c.customer_id
JOIN Restaurant r
ON fo.restaurant_id = r.restaurant_id
JOIN Payment p
ON fo.order_id = p.order_id
WHERE fo.order_status IN ('Out for Delivery', 'Preparing')
   OR p.payment_status = 'Pending';

-- 7. Delivery partner performance
SELECT 
    dp.partner_name,
    COUNT(fo.order_id) AS completed_deliveries
FROM FoodOrder fo
JOIN DeliveryPartner dp
ON fo.partner_id = dp.partner_id
WHERE fo.order_status = 'Delivered'
GROUP BY dp.partner_name
ORDER BY completed_deliveries DESC;

-- 8. Orders by city
SELECT 
    c.city,
    COUNT(fo.order_id) AS total_orders
FROM FoodOrder fo
JOIN Customer c
ON fo.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_orders DESC;