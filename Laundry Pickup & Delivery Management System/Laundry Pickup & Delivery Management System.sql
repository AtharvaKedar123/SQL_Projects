-- Smart Laundry Pickup & Delivery Management System
-- Single File SQL Solution

CREATE DATABASE LaundryServiceDB;
USE LaundryServiceDB;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(80),
    address VARCHAR(150),
    city VARCHAR(50)
);

CREATE TABLE ServiceType (
    service_id INT PRIMARY KEY,
    service_name VARCHAR(50),
    price_per_item DECIMAL(10,2),
    estimated_days INT
);

CREATE TABLE DeliveryPartner (
    partner_id INT PRIMARY KEY,
    partner_name VARCHAR(50),
    phone VARCHAR(15),
    vehicle_type VARCHAR(30)
);

CREATE TABLE LaundryOrder (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    pickup_date DATE,
    order_status VARCHAR(30),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE OrderItem (
    item_id INT PRIMARY KEY,
    order_id INT,
    service_id INT,
    item_name VARCHAR(50),
    quantity INT,
    item_total DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES LaundryOrder(order_id),
    FOREIGN KEY (service_id) REFERENCES ServiceType(service_id)
);

CREATE TABLE PickupDelivery (
    delivery_id INT PRIMARY KEY,
    order_id INT,
    partner_id INT,
    pickup_time DATETIME,
    delivery_time DATETIME,
    pickup_status VARCHAR(30),
    delivery_status VARCHAR(30),
    FOREIGN KEY (order_id) REFERENCES LaundryOrder(order_id),
    FOREIGN KEY (partner_id) REFERENCES DeliveryPartner(partner_id)
);

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_amount DECIMAL(10,2),
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    payment_date DATE,
    FOREIGN KEY (order_id) REFERENCES LaundryOrder(order_id)
);

INSERT INTO Customer VALUES
(1, 'Rahul Sharma', '9999999999', 'rahul@email.com', 'Civil Lines', 'Nagpur'),
(2, 'Sneha Patil', '8888888888', 'sneha@email.com', 'Dharampeth', 'Nagpur'),
(3, 'Aman Verma', '7777777777', 'aman@email.com', 'Kothrud', 'Pune'),
(4, 'Priya Mehta', '6666666666', 'priya@email.com', 'Andheri', 'Mumbai'),
(5, 'Atharva Kedar', '5555555555', 'atharva@email.com', 'Sitabuldi', 'Nagpur');

INSERT INTO ServiceType VALUES
(1, 'Wash Only', 40.00, 2),
(2, 'Wash and Iron', 70.00, 3),
(3, 'Dry Cleaning', 150.00, 4),
(4, 'Iron Only', 30.00, 1),
(5, 'Premium Fabric Care', 250.00, 5);

INSERT INTO DeliveryPartner VALUES
(1, 'Ramesh Yadav', '9000011111', 'Bike'),
(2, 'Suresh Patil', '9000022222', 'Scooter'),
(3, 'Amit Verma', '9000033333', 'Bike');

INSERT INTO LaundryOrder VALUES
(1, 1, '2026-04-25', '2026-04-26', 'Washing', 280.00),
(2, 2, '2026-04-26', '2026-04-27', 'Ready for Delivery', 450.00),
(3, 3, '2026-04-27', '2026-04-28', 'Delivered', 300.00),
(4, 4, '2026-04-28', NULL, 'Pickup Pending', 500.00),
(5, 5, '2026-04-29', '2026-04-29', 'Ironing', 210.00);

INSERT INTO OrderItem VALUES
(1, 1, 2, 'Shirt', 2, 140.00),
(2, 1, 2, 'Jeans', 2, 140.00),
(3, 2, 3, 'Jacket', 3, 450.00),
(4, 3, 1, 'Bedsheet', 5, 200.00),
(5, 3, 4, 'T-Shirt', 3, 90.00),
(6, 4, 5, 'Curtain', 2, 500.00),
(7, 5, 2, 'Formal Shirt', 3, 210.00);

INSERT INTO PickupDelivery VALUES
(1, 1, 1, '2026-04-26 10:00:00', NULL, 'Picked Up', 'Pending'),
(2, 2, 2, '2026-04-27 11:00:00', NULL, 'Picked Up', 'Out for Delivery'),
(3, 3, 1, '2026-04-28 09:30:00', '2026-04-29 17:00:00', 'Picked Up', 'Delivered'),
(4, 4, 3, NULL, NULL, 'Pending', 'Pending'),
(5, 5, 2, '2026-04-29 12:00:00', NULL, 'Picked Up', 'Pending');

INSERT INTO Payment VALUES
(1, 1, 280.00, 'UPI', 'Pending', NULL),
(2, 2, 450.00, 'Card', 'Paid', '2026-04-27'),
(3, 3, 300.00, 'UPI', 'Paid', '2026-04-29'),
(4, 4, 500.00, 'Cash', 'Pending', NULL),
(5, 5, 210.00, 'UPI', 'Paid', '2026-04-29');

-- 1. Orders currently in washing
SELECT 
    lo.order_id,
    c.customer_name,
    lo.order_date,
    lo.pickup_date,
    lo.order_status,
    lo.total_amount
FROM LaundryOrder lo
JOIN Customer c
ON lo.customer_id = c.customer_id
WHERE lo.order_status = 'Washing';

-- 2. Pending pickups
SELECT 
    lo.order_id,
    c.customer_name,
    c.address,
    c.city,
    pd.pickup_status,
    dp.partner_name
FROM PickupDelivery pd
JOIN LaundryOrder lo
ON pd.order_id = lo.order_id
JOIN Customer c
ON lo.customer_id = c.customer_id
JOIN DeliveryPartner dp
ON pd.partner_id = dp.partner_id
WHERE pd.pickup_status = 'Pending';

-- 3. Delivery partner completed deliveries
SELECT 
    dp.partner_name,
    COUNT(pd.delivery_id) AS completed_deliveries
FROM PickupDelivery pd
JOIN DeliveryPartner dp
ON pd.partner_id = dp.partner_id
WHERE pd.delivery_status = 'Delivered'
GROUP BY dp.partner_name
ORDER BY completed_deliveries DESC;

-- 4. Customers with pending payments
SELECT 
    c.customer_name,
    lo.order_id,
    p.payment_amount,
    p.payment_method,
    p.payment_status
FROM Payment p
JOIN LaundryOrder lo
ON p.order_id = lo.order_id
JOIN Customer c
ON lo.customer_id = c.customer_id
WHERE p.payment_status = 'Pending';

-- 5. Revenue by service type
SELECT 
    st.service_name,
    SUM(oi.item_total) AS service_revenue
FROM OrderItem oi
JOIN ServiceType st
ON oi.service_id = st.service_id
JOIN LaundryOrder lo
ON oi.order_id = lo.order_id
JOIN Payment p
ON lo.order_id = p.order_id
WHERE p.payment_status = 'Paid'
GROUP BY st.service_name
ORDER BY service_revenue DESC;

-- 6. Most ordered laundry items
SELECT 
    item_name,
    SUM(quantity) AS total_quantity
FROM OrderItem
GROUP BY item_name
ORDER BY total_quantity DESC;

-- 7. Orders ready for delivery
SELECT 
    lo.order_id,
    c.customer_name,
    c.phone,
    lo.order_status,
    pd.delivery_status
FROM LaundryOrder lo
JOIN Customer c
ON lo.customer_id = c.customer_id
JOIN PickupDelivery pd
ON lo.order_id = pd.order_id
WHERE lo.order_status = 'Ready for Delivery';

-- 8. Complete laundry order report
SELECT 
    lo.order_id,
    c.customer_name,
    st.service_name,
    oi.item_name,
    oi.quantity,
    oi.item_total,
    dp.partner_name,
    pd.pickup_status,
    pd.delivery_status,
    lo.order_status,
    p.payment_status
FROM LaundryOrder lo
JOIN Customer c
ON lo.customer_id = c.customer_id
JOIN OrderItem oi
ON lo.order_id = oi.order_id
JOIN ServiceType st
ON oi.service_id = st.service_id
JOIN PickupDelivery pd
ON lo.order_id = pd.order_id
JOIN DeliveryPartner dp
ON pd.partner_id = dp.partner_id
JOIN Payment p
ON lo.order_id = p.order_id;