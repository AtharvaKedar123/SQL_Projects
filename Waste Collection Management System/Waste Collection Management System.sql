

CREATE DATABASE SmartWasteDB;
USE SmartWasteDB;

CREATE TABLE GarbageBin (
    bin_id INT PRIMARY KEY,
    bin_code VARCHAR(30),
    area_name VARCHAR(50),
    location_description VARCHAR(100),
    bin_type VARCHAR(30),
    capacity_kg INT,
    bin_status VARCHAR(30)
);

CREATE TABLE SensorReading (
    reading_id INT PRIMARY KEY,
    bin_id INT,
    reading_time DATETIME,
    fill_level_percent INT,
    waste_weight_kg DECIMAL(10,2),
    battery_percent INT,
    FOREIGN KEY (bin_id) REFERENCES GarbageBin(bin_id)
);

CREATE TABLE Driver (
    driver_id INT PRIMARY KEY,
    driver_name VARCHAR(50),
    phone VARCHAR(15),
    vehicle_number VARCHAR(20),
    vehicle_type VARCHAR(30)
);

CREATE TABLE CollectionRoute (
    route_id INT PRIMARY KEY,
    route_name VARCHAR(50),
    zone_name VARCHAR(50),
    driver_id INT,
    route_status VARCHAR(30),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);

CREATE TABLE RouteBin (
    route_bin_id INT PRIMARY KEY,
    route_id INT,
    bin_id INT,
    stop_order INT,
    FOREIGN KEY (route_id) REFERENCES CollectionRoute(route_id),
    FOREIGN KEY (bin_id) REFERENCES GarbageBin(bin_id)
);

CREATE TABLE PickupSchedule (
    schedule_id INT PRIMARY KEY,
    bin_id INT,
    route_id INT,
    scheduled_date DATE,
    scheduled_time TIME,
    pickup_priority VARCHAR(30),
    pickup_status VARCHAR(30),
    FOREIGN KEY (bin_id) REFERENCES GarbageBin(bin_id),
    FOREIGN KEY (route_id) REFERENCES CollectionRoute(route_id)
);

CREATE TABLE CollectionRecord (
    record_id INT PRIMARY KEY,
    schedule_id INT,
    collected_weight_kg DECIMAL(10,2),
    collection_time DATETIME,
    collection_status VARCHAR(30),
    remarks VARCHAR(255),
    FOREIGN KEY (schedule_id) REFERENCES PickupSchedule(schedule_id)
);

INSERT INTO GarbageBin VALUES
(1, 'BIN-NGP-001', 'Civil Lines', 'Near Central Park Gate', 'Dry Waste', 100, 'Active'),
(2, 'BIN-NGP-002', 'Dharampeth', 'Opposite Shopping Complex', 'Wet Waste', 120, 'Active'),
(3, 'BIN-NGP-003', 'Sitabuldi', 'Near Bus Stop', 'Mixed Waste', 150, 'Active'),
(4, 'BIN-NGP-004', 'Mahal', 'Near Market Area', 'Wet Waste', 130, 'Active'),
(5, 'BIN-NGP-005', 'Sadar', 'Near Hospital Road', 'Dry Waste', 100, 'Maintenance'),
(6, 'BIN-NGP-006', 'Manish Nagar', 'Near Apartment Gate', 'Mixed Waste', 140, 'Active');

INSERT INTO SensorReading VALUES
(1, 1, '2026-04-29 07:00:00', 85, 82.50, 90),
(2, 2, '2026-04-29 07:05:00', 92, 110.00, 85),
(3, 3, '2026-04-29 07:10:00', 60, 90.00, 75),
(4, 4, '2026-04-29 07:15:00', 96, 124.00, 80),
(5, 5, '2026-04-29 07:20:00', 40, 38.00, 35),
(6, 6, '2026-04-29 07:25:00', 78, 105.00, 88),
(7, 1, '2026-04-29 12:00:00', 88, 86.00, 89),
(8, 2, '2026-04-29 12:05:00', 95, 114.00, 84);

INSERT INTO Driver VALUES
(1, 'Ramesh Yadav', '9999999999', 'MH31TR1001', 'Garbage Truck'),
(2, 'Suresh Patil', '8888888888', 'MH31TR1002', 'Mini Truck'),
(3, 'Amit Verma', '7777777777', 'MH31TR1003', 'Garbage Truck');

INSERT INTO CollectionRoute VALUES
(1, 'Route A', 'Central Zone', 1, 'Active'),
(2, 'Route B', 'Market Zone', 2, 'Active'),
(3, 'Route C', 'Residential Zone', 3, 'Active');

INSERT INTO RouteBin VALUES
(1, 1, 1, 1),
(2, 1, 2, 2),
(3, 2, 3, 1),
(4, 2, 4, 2),
(5, 3, 5, 1),
(6, 3, 6, 2);

INSERT INTO PickupSchedule VALUES
(1, 1, 1, '2026-04-29', '14:00:00', 'High', 'Pending'),
(2, 2, 1, '2026-04-29', '14:30:00', 'Urgent', 'Pending'),
(3, 3, 2, '2026-04-29', '15:00:00', 'Normal', 'Completed'),
(4, 4, 2, '2026-04-29', '15:30:00', 'Urgent', 'Pending'),
(5, 6, 3, '2026-04-29', '16:00:00', 'High', 'Completed');

INSERT INTO CollectionRecord VALUES
(1, 3, 88.00, '2026-04-29 15:10:00', 'Collected', 'Bin cleared successfully'),
(2, 5, 102.00, '2026-04-29 16:15:00', 'Collected', 'Bin cleared successfully');

-- 1. Bins that are almost full
SELECT 
    gb.bin_code,
    gb.area_name,
    gb.location_description,
    sr.fill_level_percent,
    sr.waste_weight_kg,
    sr.reading_time
FROM SensorReading sr
JOIN GarbageBin gb
ON sr.bin_id = gb.bin_id
WHERE sr.fill_level_percent >= 80
ORDER BY sr.fill_level_percent DESC;

-- 2. Bins needing urgent pickup
SELECT 
    gb.bin_code,
    gb.area_name,
    gb.location_description,
    ps.pickup_priority,
    ps.pickup_status,
    ps.scheduled_time
FROM PickupSchedule ps
JOIN GarbageBin gb
ON ps.bin_id = gb.bin_id
WHERE ps.pickup_priority = 'Urgent'
AND ps.pickup_status = 'Pending';

-- 3. Driver assigned to each route
SELECT 
    cr.route_name,
    cr.zone_name,
    d.driver_name,
    d.phone,
    d.vehicle_number,
    d.vehicle_type
FROM CollectionRoute cr
JOIN Driver d
ON cr.driver_id = d.driver_id;

-- 4. Pending pickups
SELECT 
    ps.schedule_id,
    gb.bin_code,
    gb.area_name,
    cr.route_name,
    ps.scheduled_date,
    ps.scheduled_time,
    ps.pickup_priority,
    ps.pickup_status
FROM PickupSchedule ps
JOIN GarbageBin gb
ON ps.bin_id = gb.bin_id
JOIN CollectionRoute cr
ON ps.route_id = cr.route_id
WHERE ps.pickup_status = 'Pending'
ORDER BY ps.pickup_priority DESC, ps.scheduled_time;

-- 5. Area generating the most waste
SELECT 
    gb.area_name,
    SUM(sr.waste_weight_kg) AS total_waste_recorded
FROM SensorReading sr
JOIN GarbageBin gb
ON sr.bin_id = gb.bin_id
GROUP BY gb.area_name
ORDER BY total_waste_recorded DESC;

-- 6. Successfully collected bins
SELECT 
    gb.bin_code,
    gb.area_name,
    cr.route_name,
    d.driver_name,
    crd.collected_weight_kg,
    crd.collection_time,
    crd.collection_status
FROM CollectionRecord crd
JOIN PickupSchedule ps
ON crd.schedule_id = ps.schedule_id
JOIN GarbageBin gb
ON ps.bin_id = gb.bin_id
JOIN CollectionRoute cr
ON ps.route_id = cr.route_id
JOIN Driver d
ON cr.driver_id = d.driver_id
WHERE crd.collection_status = 'Collected';

-- 7. Low battery sensors
SELECT 
    gb.bin_code,
    gb.area_name,
    sr.battery_percent,
    sr.reading_time
FROM SensorReading sr
JOIN GarbageBin gb
ON sr.bin_id = gb.bin_id
WHERE sr.battery_percent < 40;

-- 8. Route-wise bin count
SELECT 
    cr.route_name,
    cr.zone_name,
    COUNT(rb.bin_id) AS total_bins_assigned
FROM RouteBin rb
JOIN CollectionRoute cr
ON rb.route_id = cr.route_id
GROUP BY cr.route_name, cr.zone_name;
