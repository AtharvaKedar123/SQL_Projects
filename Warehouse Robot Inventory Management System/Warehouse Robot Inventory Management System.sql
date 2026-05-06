-- Smart Warehouse Robot Inventory Management System
-- Single File SQL Solution

CREATE DATABASE WarehouseRobotDB;
USE WarehouseRobotDB;

CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(80),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    reorder_level INT
);

CREATE TABLE Rack (
    rack_id INT PRIMARY KEY,
    rack_code VARCHAR(30),
    zone_name VARCHAR(50),
    rack_capacity INT,
    rack_status VARCHAR(30)
);

CREATE TABLE InventoryStock (
    stock_id INT PRIMARY KEY,
    product_id INT,
    rack_id INT,
    quantity_available INT,
    last_updated DATE,
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (rack_id) REFERENCES Rack(rack_id)
);

CREATE TABLE WarehouseRobot (
    robot_id INT PRIMARY KEY,
    robot_code VARCHAR(30),
    max_load_kg DECIMAL(6,2),
    battery_percent INT,
    robot_status VARCHAR(30)
);

CREATE TABLE RobotTask (
    task_id INT PRIMARY KEY,
    robot_id INT,
    task_type VARCHAR(50),
    source_rack_id INT,
    destination_location VARCHAR(80),
    task_status VARCHAR(30),
    assigned_time DATETIME,
    completed_time DATETIME,
    FOREIGN KEY (robot_id) REFERENCES WarehouseRobot(robot_id),
    FOREIGN KEY (source_rack_id) REFERENCES Rack(rack_id)
);

CREATE TABLE CustomerOrder (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    order_date DATE,
    order_status VARCHAR(30)
);

CREATE TABLE OrderItem (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity_ordered INT,
    FOREIGN KEY (order_id) REFERENCES CustomerOrder(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE PickingRecord (
    picking_id INT PRIMARY KEY,
    task_id INT,
    order_id INT,
    product_id INT,
    quantity_picked INT,
    picking_status VARCHAR(30),
    FOREIGN KEY (task_id) REFERENCES RobotTask(task_id),
    FOREIGN KEY (order_id) REFERENCES CustomerOrder(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

INSERT INTO Product VALUES
(1, 'Wireless Mouse', 'Electronics', 799.00, 20),
(2, 'Bluetooth Keyboard', 'Electronics', 1499.00, 15),
(3, 'Office Chair', 'Furniture', 5999.00, 10),
(4, 'Water Bottle', 'Accessories', 299.00, 30),
(5, 'Laptop Stand', 'Accessories', 999.00, 25);

INSERT INTO Rack VALUES
(1, 'R-A01', 'Zone A', 200, 'Active'),
(2, 'R-A02', 'Zone A', 150, 'Active'),
(3, 'R-B01', 'Zone B', 100, 'Active'),
(4, 'R-C01', 'Zone C', 80, 'Maintenance');

INSERT INTO InventoryStock VALUES
(1, 1, 1, 18, '2026-04-29'),
(2, 2, 1, 40, '2026-04-29'),
(3, 3, 3, 8, '2026-04-29'),
(4, 4, 2, 120, '2026-04-29'),
(5, 5, 2, 22, '2026-04-29');

INSERT INTO WarehouseRobot VALUES
(1, 'BOT-101', 25.00, 90, 'Available'),
(2, 'BOT-102', 30.00, 45, 'In Task'),
(3, 'BOT-103', 20.00, 18, 'Charging'),
(4, 'BOT-104', 35.00, 75, 'Available');

INSERT INTO RobotTask VALUES
(1, 2, 'Pick Item', 1, 'Packing Station 1', 'In Progress', '2026-04-29 09:00:00', NULL),
(2, 1, 'Restock Rack', 2, 'Rack R-A02', 'Completed', '2026-04-29 08:00:00', '2026-04-29 08:30:00'),
(3, 4, 'Pick Item', 3, 'Packing Station 2', 'Pending', '2026-04-29 10:00:00', NULL),
(4, 1, 'Move Inventory', 1, 'Zone B', 'Completed', '2026-04-28 15:00:00', '2026-04-28 15:35:00');

INSERT INTO CustomerOrder VALUES
(1, 'Rahul Sharma', '2026-04-29', 'Picking'),
(2, 'Sneha Patil', '2026-04-29', 'Ready for Packing'),
(3, 'Aman Verma', '2026-04-28', 'Delivered'),
(4, 'Priya Mehta', '2026-04-29', 'Pending');

INSERT INTO OrderItem VALUES
(1, 1, 1, 2),
(2, 1, 2, 1),
(3, 2, 4, 3),
(4, 3, 5, 1),
(5, 4, 3, 1);

INSERT INTO PickingRecord VALUES
(1, 1, 1, 1, 2, 'Picked'),
(2, 1, 1, 2, 1, 'Pending'),
(3, 2, 2, 4, 3, 'Picked'),
(4, 4, 3, 5, 1, 'Picked');

-- 1. Products low in stock
SELECT 
    p.product_name,
    p.category,
    i.quantity_available,
    p.reorder_level
FROM InventoryStock i
JOIN Product p
ON i.product_id = p.product_id
WHERE i.quantity_available <= p.reorder_level;

-- 2. Available robots
SELECT 
    robot_code,
    max_load_kg,
    battery_percent,
    robot_status
FROM WarehouseRobot
WHERE robot_status = 'Available';

-- 3. Pending or in-progress robot tasks
SELECT 
    rt.task_id,
    wr.robot_code,
    rt.task_type,
    r.rack_code,
    rt.destination_location,
    rt.task_status,
    rt.assigned_time
FROM RobotTask rt
JOIN WarehouseRobot wr
ON rt.robot_id = wr.robot_id
JOIN Rack r
ON rt.source_rack_id = r.rack_id
WHERE rt.task_status IN ('Pending', 'In Progress');

-- 4. Orders ready for packing
SELECT 
    order_id,
    customer_name,
    order_date,
    order_status
FROM CustomerOrder
WHERE order_status = 'Ready for Packing';

-- 5. Robot completed task count
SELECT 
    wr.robot_code,
    COUNT(rt.task_id) AS completed_tasks
FROM RobotTask rt
JOIN WarehouseRobot wr
ON rt.robot_id = wr.robot_id
WHERE rt.task_status = 'Completed'
GROUP BY wr.robot_code
ORDER BY completed_tasks DESC;

-- 6. Low battery robots
SELECT 
    robot_code,
    battery_percent,
    robot_status
FROM WarehouseRobot
WHERE battery_percent < 25;

-- 7. Order picking progress
SELECT 
    co.order_id,
    co.customer_name,
    p.product_name,
    oi.quantity_ordered,
    COALESCE(pr.quantity_picked, 0) AS quantity_picked,
    pr.picking_status
FROM CustomerOrder co
JOIN OrderItem oi
ON co.order_id = oi.order_id
JOIN Product p
ON oi.product_id = p.product_id
LEFT JOIN PickingRecord pr
ON co.order_id = pr.order_id
AND p.product_id = pr.product_id;

-- 8. Complete inventory movement report
SELECT 
    rt.task_id,
    wr.robot_code,
    rt.task_type,
    p.product_name,
    r.rack_code,
    r.zone_name,
    pr.quantity_picked,
    rt.destination_location,
    rt.task_status,
    rt.assigned_time,
    rt.completed_time
FROM RobotTask rt
JOIN WarehouseRobot wr
ON rt.robot_id = wr.robot_id
JOIN Rack r
ON rt.source_rack_id = r.rack_id
LEFT JOIN PickingRecord pr
ON rt.task_id = pr.task_id
LEFT JOIN Product p
ON pr.product_id = p.product_id;