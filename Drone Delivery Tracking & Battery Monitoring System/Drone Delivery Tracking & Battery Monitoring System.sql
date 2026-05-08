

CREATE DATABASE DroneDeliveryDB;
USE DroneDeliveryDB;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(80),
    delivery_address VARCHAR(150),
    city_zone VARCHAR(50)
);

CREATE TABLE Drone (
    drone_id INT PRIMARY KEY,
    drone_code VARCHAR(30),
    model_name VARCHAR(50),
    max_payload_kg DECIMAL(5,2),
    battery_capacity_percent INT,
    drone_status VARCHAR(30)
);

CREATE TABLE Package (
    package_id INT PRIMARY KEY,
    customer_id INT,
    package_type VARCHAR(50),
    package_weight_kg DECIMAL(5,2),
    package_priority VARCHAR(30),
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE DeliveryRoute (
    route_id INT PRIMARY KEY,
    route_name VARCHAR(50),
    city_zone VARCHAR(50),
    estimated_distance_km DECIMAL(6,2),
    route_risk_level VARCHAR(30)
);

CREATE TABLE DeliveryAssignment (
    assignment_id INT PRIMARY KEY,
    drone_id INT,
    package_id INT,
    route_id INT,
    assigned_time DATETIME,
    delivery_time DATETIME,
    delivery_status VARCHAR(30),
    failure_reason VARCHAR(100),
    FOREIGN KEY (drone_id) REFERENCES Drone(drone_id),
    FOREIGN KEY (package_id) REFERENCES Package(package_id),
    FOREIGN KEY (route_id) REFERENCES DeliveryRoute(route_id)
);

CREATE TABLE BatteryLog (
    battery_log_id INT PRIMARY KEY,
    drone_id INT,
    log_time DATETIME,
    battery_percent INT,
    charging_status VARCHAR(30),
    FOREIGN KEY (drone_id) REFERENCES Drone(drone_id)
);

INSERT INTO Customer VALUES
(1, 'Rahul Sharma', '9999999999', 'rahul@email.com', 'Civil Lines, Nagpur', 'Central Zone'),
(2, 'Sneha Patil', '8888888888', 'sneha@email.com', 'Dharampeth, Nagpur', 'West Zone'),
(3, 'Aman Verma', '7777777777', 'aman@email.com', 'Sitabuldi, Nagpur', 'Central Zone'),
(4, 'Priya Mehta', '6666666666', 'priya@email.com', 'Manish Nagar, Nagpur', 'South Zone'),
(5, 'Atharva Kedar', '5555555555', 'atharva@email.com', 'Sadar, Nagpur', 'North Zone');

INSERT INTO Drone VALUES
(1, 'DRN-101', 'Falcon X1', 3.50, 100, 'Available'),
(2, 'DRN-102', 'Swift Air 2', 2.00, 100, 'In Delivery'),
(3, 'DRN-103', 'SkyDrop Pro', 5.00, 100, 'Charging'),
(4, 'DRN-104', 'MiniFly Lite', 1.50, 100, 'Maintenance'),
(5, 'DRN-105', 'Falcon X2', 4.00, 100, 'Available');

INSERT INTO Package VALUES
(1, 1, 'Medicine', 0.80, 'High', '2026-04-29'),
(2, 2, 'Electronics', 1.50, 'Medium', '2026-04-29'),
(3, 3, 'Documents', 0.30, 'High', '2026-04-29'),
(4, 4, 'Food Parcel', 1.20, 'High', '2026-04-29'),
(5, 5, 'Clothing', 2.50, 'Low', '2026-04-29'),
(6, 1, 'Grocery Pack', 3.20, 'Medium', '2026-04-28');

INSERT INTO DeliveryRoute VALUES
(1, 'Central Express Route', 'Central Zone', 6.50, 'Low'),
(2, 'West Market Route', 'West Zone', 8.20, 'Medium'),
(3, 'South Residential Route', 'South Zone', 10.50, 'Medium'),
(4, 'North Quick Route', 'North Zone', 7.00, 'Low');

INSERT INTO DeliveryAssignment VALUES
(1, 2, 1, 1, '2026-04-29 09:00:00', NULL, 'In Progress', NULL),
(2, 1, 2, 2, '2026-04-29 09:30:00', '2026-04-29 10:05:00', 'Delivered', NULL),
(3, 5, 3, 1, '2026-04-29 10:00:00', '2026-04-29 10:25:00', 'Delivered', NULL),
(4, 2, 4, 3, '2026-04-29 11:00:00', NULL, 'Failed', 'Low battery during route'),
(5, 3, 5, 4, '2026-04-29 12:00:00', NULL, 'Pending', NULL),
(6, 1, 6, 1, '2026-04-28 15:00:00', '2026-04-28 15:40:00', 'Delivered', NULL);

INSERT INTO BatteryLog VALUES
(1, 1, '2026-04-29 08:00:00', 95, 'Not Charging'),
(2, 2, '2026-04-29 08:00:00', 72, 'Not Charging'),
(3, 3, '2026-04-29 08:00:00', 28, 'Charging'),
(4, 4, '2026-04-29 08:00:00', 60, 'Not Charging'),
(5, 5, '2026-04-29 08:00:00', 88, 'Not Charging'),
(6, 2, '2026-04-29 11:15:00', 18, 'Not Charging'),
(7, 3, '2026-04-29 12:15:00', 35, 'Charging');

-- 1. Available drones
SELECT 
    drone_code,
    model_name,
    max_payload_kg,
    drone_status
FROM Drone
WHERE drone_status = 'Available';

-- 2. Pending or in-progress deliveries
SELECT 
    da.assignment_id,
    d.drone_code,
    c.customer_name,
    p.package_type,
    dr.route_name,
    da.assigned_time,
    da.delivery_status
FROM DeliveryAssignment da
JOIN Drone d
ON da.drone_id = d.drone_id
JOIN Package p
ON da.package_id = p.package_id
JOIN Customer c
ON p.customer_id = c.customer_id
JOIN DeliveryRoute dr
ON da.route_id = dr.route_id
WHERE da.delivery_status IN ('Pending', 'In Progress');

-- 3. Drones with low battery
SELECT 
    d.drone_code,
    d.model_name,
    bl.battery_percent,
    bl.charging_status,
    bl.log_time
FROM BatteryLog bl
JOIN Drone d
ON bl.drone_id = d.drone_id
WHERE bl.battery_percent < 30
ORDER BY bl.battery_percent ASC;

-- 4. Drone delivery performance
SELECT 
    d.drone_code,
    d.model_name,
    COUNT(da.assignment_id) AS completed_deliveries
FROM DeliveryAssignment da
JOIN Drone d
ON da.drone_id = d.drone_id
WHERE da.delivery_status = 'Delivered'
GROUP BY d.drone_code, d.model_name
ORDER BY completed_deliveries DESC;

-- 5. Deliveries by city zone
SELECT 
    dr.city_zone,
    COUNT(da.assignment_id) AS total_deliveries
FROM DeliveryAssignment da
JOIN DeliveryRoute dr
ON da.route_id = dr.route_id
GROUP BY dr.city_zone
ORDER BY total_deliveries DESC;

-- 6. Failed deliveries
SELECT 
    da.assignment_id,
    d.drone_code,
    c.customer_name,
    p.package_type,
    da.delivery_status,
    da.failure_reason
FROM DeliveryAssignment da
JOIN Drone d
ON da.drone_id = d.drone_id
JOIN Package p
ON da.package_id = p.package_id
JOIN Customer c
ON p.customer_id = c.customer_id
WHERE da.delivery_status = 'Failed';

-- 7. Packages exceeding drone payload limit
SELECT 
    da.assignment_id,
    d.drone_code,
    d.max_payload_kg,
    p.package_type,
    p.package_weight_kg
FROM DeliveryAssignment da
JOIN Drone d
ON da.drone_id = d.drone_id
JOIN Package p
ON da.package_id = p.package_id
WHERE p.package_weight_kg > d.max_payload_kg;

-- 8. Complete drone delivery report
SELECT 
    da.assignment_id,
    d.drone_code,
    d.model_name,
    c.customer_name,
    c.city_zone,
    p.package_type,
    p.package_weight_kg,
    dr.route_name,
    dr.estimated_distance_km,
    da.delivery_status,
    da.failure_reason
FROM DeliveryAssignment da
JOIN Drone d
ON da.drone_id = d.drone_id
JOIN Package p
ON da.package_id = p.package_id
JOIN Customer c
ON p.customer_id = c.customer_id
JOIN DeliveryRoute dr
ON da.route_id = dr.route_id;
