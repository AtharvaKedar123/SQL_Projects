CREATE DATABASE CloudKitchenDB;
USE CloudKitchenDB;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    phone VARCHAR(20),
    city VARCHAR(50)
);

CREATE TABLE MenuItem (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(80),
    category VARCHAR(50),
    price DECIMAL(10,2),
    preparation_time_minutes INT
);

CREATE TABLE Ingredient (
    ingredient_id INT PRIMARY KEY,
    ingredient_name VARCHAR(50),
    unit VARCHAR(20),
    available_quantity DECIMAL(10,2),
    reorder_level DECIMAL(10,2)
);

CREATE TABLE Recipe (
    recipe_id INT PRIMARY KEY,
    item_id INT,
    ingredient_id INT,
    required_quantity DECIMAL(10,2),
    FOREIGN KEY (item_id) REFERENCES MenuItem(item_id),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredient(ingredient_id)
);

CREATE TABLE FoodOrder (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(30),
    preparation_status VARCHAR(30),
    payment_status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE OrderItem (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES FoodOrder(order_id),
    FOREIGN KEY (item_id) REFERENCES MenuItem(item_id)
);

CREATE TABLE DeliveryPartner (
    partner_id INT PRIMARY KEY,
    partner_name VARCHAR(50),
    phone VARCHAR(20)
);

CREATE TABLE DeliveryOrder (
    delivery_id INT PRIMARY KEY,
    order_id INT,
    partner_id INT,
    assigned_time VARCHAR(20),
    delivered_time VARCHAR(20),
    delivery_status VARCHAR(30),
    FOREIGN KEY (order_id) REFERENCES FoodOrder(order_id),
    FOREIGN KEY (partner_id) REFERENCES DeliveryPartner(partner_id)
);

INSERT INTO Customer VALUES
(1, 'Atharva Kedar', '9876543210', 'Nagpur'),
(2, 'Neha Sharma', '9876543211', 'Mumbai'),
(3, 'Rohan Mehta', '9876543212', 'Pune'),
(4, 'Priya Patil', '9876543213', 'Nagpur');

INSERT INTO MenuItem VALUES
(1, 'Paneer Tikka Bowl', 'North Indian', 249.00, 20),
(2, 'Chicken Biryani', 'Biryani', 299.00, 35),
(3, 'Veg Fried Rice', 'Chinese', 179.00, 18),
(4, 'Cheese Burst Pizza', 'Italian', 349.00, 30),
(5, 'Masala Dosa Box', 'South Indian', 149.00, 15);

INSERT INTO Ingredient VALUES
(1, 'Paneer', 'kg', 8.50, 3.00),
(2, 'Chicken', 'kg', 12.00, 5.00),
(3, 'Rice', 'kg', 25.00, 10.00),
(4, 'Cheese', 'kg', 2.50, 3.00),
(5, 'Dosa Batter', 'litre', 4.00, 5.00),
(6, 'Vegetables', 'kg', 9.00, 4.00),
(7, 'Spices', 'kg', 1.50, 2.00);

INSERT INTO Recipe VALUES
(1, 1, 1, 0.20),
(2, 1, 7, 0.05),
(3, 2, 2, 0.30),
(4, 2, 3, 0.25),
(5, 2, 7, 0.07),
(6, 3, 3, 0.20),
(7, 3, 6, 0.15),
(8, 4, 4, 0.25),
(9, 4, 6, 0.10),
(10, 5, 5, 0.30),
(11, 5, 7, 0.04);

INSERT INTO FoodOrder VALUES
(1, 1, '2026-04-01', 'Completed', 'Prepared', 'Paid'),
(2, 2, '2026-04-02', 'Completed', 'Prepared', 'Paid'),
(3, 3, '2026-04-03', 'In Progress', 'Preparing', 'Paid'),
(4, 4, '2026-04-04', 'Pending', 'Not Started', 'Pending'),
(5, 1, '2026-04-05', 'Completed', 'Prepared', 'Paid');

INSERT INTO OrderItem VALUES
(1, 1, 1, 2),
(2, 1, 3, 1),
(3, 2, 2, 2),
(4, 3, 4, 1),
(5, 3, 5, 3),
(6, 4, 2, 1),
(7, 5, 1, 1),
(8, 5, 5, 2);

INSERT INTO DeliveryPartner VALUES
(1, 'SpeedGo Delivery', '9000011111'),
(2, 'QuickRide Logistics', '9000022222'),
(3, 'FreshDrop Partner', '9000033333');

INSERT INTO DeliveryOrder VALUES
(1, 1, 1, '12:00', '12:35', 'Delivered'),
(2, 2, 2, '13:10', '14:00', 'Delivered'),
(3, 3, 1, '15:00', NULL, 'Out for Delivery'),
(4, 4, 3, '16:00', NULL, 'Pending'),
(5, 5, 2, '18:00', '18:25', 'Delivered');

-- 1. Most ordered menu items
SELECT 
    mi.item_name,
    mi.category,
    SUM(oi.quantity) AS total_ordered_quantity
FROM OrderItem oi
JOIN MenuItem mi
ON oi.item_id = mi.item_id
GROUP BY mi.item_name, mi.category
ORDER BY total_ordered_quantity DESC;

-- 2. Low stock ingredients
SELECT 
    ingredient_name,
    available_quantity,
    reorder_level,
    unit
FROM Ingredient
WHERE available_quantity < reorder_level;

-- 3. Revenue from completed and paid orders
SELECT 
    SUM(mi.price * oi.quantity) AS total_revenue
FROM FoodOrder fo
JOIN OrderItem oi
ON fo.order_id = oi.order_id
JOIN MenuItem mi
ON oi.item_id = mi.item_id
WHERE fo.order_status = 'Completed'
AND fo.payment_status = 'Paid';

-- 4. Orders still being prepared
SELECT 
    fo.order_id,
    c.customer_name,
    fo.order_date,
    fo.preparation_status,
    fo.order_status
FROM FoodOrder fo
JOIN Customer c
ON fo.customer_id = c.customer_id
WHERE fo.preparation_status IN ('Preparing', 'Not Started');

-- 5. Delivery partners with most deliveries
SELECT 
    dp.partner_name,
    COUNT(do.delivery_id) AS total_deliveries
FROM DeliveryOrder do
JOIN DeliveryPartner dp
ON do.partner_id = dp.partner_id
GROUP BY dp.partner_name
ORDER BY total_deliveries DESC;

-- 6. Customers with most orders
SELECT 
    c.customer_name,
    COUNT(fo.order_id) AS total_orders
FROM FoodOrder fo
JOIN Customer c
ON fo.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;

-- 7. Menu items requiring highest number of ingredients
SELECT 
    mi.item_name,
    COUNT(r.ingredient_id) AS total_ingredients_required
FROM Recipe r
JOIN MenuItem mi
ON r.item_id = mi.item_id
GROUP BY mi.item_name
ORDER BY total_ingredients_required DESC;

-- 8. Orders not delivered yet
SELECT 
    fo.order_id,
    c.customer_name,
    do.delivery_status,
    do.assigned_time,
    do.delivered_time
FROM DeliveryOrder do
JOIN FoodOrder fo
ON do.order_id = fo.order_id
JOIN Customer c
ON fo.customer_id = c.customer_id
WHERE do.delivery_status <> 'Delivered';

-- 9. Ingredient usage required for all orders
SELECT 
    i.ingredient_name,
    i.unit,
    SUM(r.required_quantity * oi.quantity) AS total_required_quantity
FROM OrderItem oi
JOIN Recipe r
ON oi.item_id = r.item_id
JOIN Ingredient i
ON r.ingredient_id = i.ingredient_id
GROUP BY i.ingredient_name, i.unit
ORDER BY total_required_quantity DESC;

-- 10. Order-wise bill amount
SELECT 
    fo.order_id,
    c.customer_name,
    SUM(mi.price * oi.quantity) AS total_bill
FROM FoodOrder fo
JOIN Customer c
ON fo.customer_id = c.customer_id
JOIN OrderItem oi
ON fo.order_id = oi.order_id
JOIN MenuItem mi
ON oi.item_id = mi.item_id
GROUP BY fo.order_id, c.customer_name
ORDER BY total_bill DESC;