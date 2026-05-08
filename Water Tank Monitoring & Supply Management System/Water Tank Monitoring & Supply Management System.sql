

CREATE DATABASE WaterTankMonitoringDB;
USE WaterTankMonitoringDB;

CREATE TABLE Tower (
    tower_id INT PRIMARY KEY,
    tower_name VARCHAR(30),
    total_floors INT,
    total_flats INT
);

CREATE TABLE WaterTank (
    tank_id INT PRIMARY KEY,
    tower_id INT,
    tank_name VARCHAR(50),
    tank_type VARCHAR(30),
    capacity_liters INT,
    tank_status VARCHAR(30),
    FOREIGN KEY (tower_id) REFERENCES Tower(tower_id)
);

CREATE TABLE TankSensorReading (
    reading_id INT PRIMARY KEY,
    tank_id INT,
    reading_time DATETIME,
    water_level_percent INT,
    water_volume_liters INT,
    sensor_battery_percent INT,
    FOREIGN KEY (tank_id) REFERENCES WaterTank(tank_id)
);

CREATE TABLE Apartment (
    apartment_id INT PRIMARY KEY,
    tower_id INT,
    flat_number VARCHAR(20),
    resident_name VARCHAR(50),
    family_members INT,
    FOREIGN KEY (tower_id) REFERENCES Tower(tower_id)
);

CREATE TABLE WaterUsage (
    usage_id INT PRIMARY KEY,
    apartment_id INT,
    usage_date DATE,
    water_used_liters INT,
    usage_category VARCHAR(30),
    FOREIGN KEY (apartment_id) REFERENCES Apartment(apartment_id)
);

CREATE TABLE TankerSupplier (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(50),
    phone VARCHAR(15),
    rate_per_liter DECIMAL(10,2)
);

CREATE TABLE TankerDelivery (
    delivery_id INT PRIMARY KEY,
    supplier_id INT,
    tank_id INT,
    delivery_date DATE,
    water_quantity_liters INT,
    delivery_status VARCHAR(30),
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(30),
    FOREIGN KEY (supplier_id) REFERENCES TankerSupplier(supplier_id),
    FOREIGN KEY (tank_id) REFERENCES WaterTank(tank_id)
);

CREATE TABLE PumpActivity (
    pump_id INT PRIMARY KEY,
    tank_id INT,
    pump_start_time DATETIME,
    pump_end_time DATETIME,
    pump_status VARCHAR(30),
    power_units_used DECIMAL(10,2),
    FOREIGN KEY (tank_id) REFERENCES WaterTank(tank_id)
);

INSERT INTO Tower VALUES
(1, 'Tower A', 12, 96),
(2, 'Tower B', 10, 80),
(3, 'Tower C', 14, 112);

INSERT INTO WaterTank VALUES
(1, 1, 'A Rooftop Tank', 'Rooftop', 50000, 'Active'),
(2, 1, 'A Underground Tank', 'Underground', 100000, 'Active'),
(3, 2, 'B Rooftop Tank', 'Rooftop', 45000, 'Active'),
(4, 3, 'C Rooftop Tank', 'Rooftop', 60000, 'Active'),
(5, 3, 'C Underground Tank', 'Underground', 120000, 'Maintenance');

INSERT INTO TankSensorReading VALUES
(1, 1, '2026-04-29 06:00:00', 25, 12500, 90),
(2, 2, '2026-04-29 06:05:00', 60, 60000, 85),
(3, 3, '2026-04-29 06:10:00', 18, 8100, 75),
(4, 4, '2026-04-29 06:15:00', 72, 43200, 88),
(5, 5, '2026-04-29 06:20:00', 40, 48000, 30),
(6, 1, '2026-04-29 12:00:00', 20, 10000, 89);

INSERT INTO Apartment VALUES
(1, 1, 'A-101', 'Rahul Sharma', 4),
(2, 1, 'A-202', 'Sneha Patil', 3),
(3, 2, 'B-301', 'Aman Verma', 5),
(4, 2, 'B-404', 'Priya Mehta', 2),
(5, 3, 'C-505', 'Atharva Kedar', 4);

INSERT INTO WaterUsage VALUES
(1, 1, '2026-04-29', 650, 'Domestic'),
(2, 2, '2026-04-29', 520, 'Domestic'),
(3, 3, '2026-04-29', 780, 'Domestic'),
(4, 4, '2026-04-29', 430, 'Domestic'),
(5, 5, '2026-04-29', 700, 'Domestic'),
(6, 1, '2026-04-28', 620, 'Domestic'),
(7, 3, '2026-04-28', 810, 'Domestic');

INSERT INTO TankerSupplier VALUES
(1, 'Nagpur Water Supply', '9000011111', 0.80),
(2, 'Fresh Tanker Services', '9000022222', 0.90),
(3, 'City Aqua Tankers', '9000033333', 0.85);

INSERT INTO TankerDelivery VALUES
(1, 1, 1, '2026-04-29', 20000, 'Delivered', 16000.00, 'Paid'),
(2, 2, 3, '2026-04-29', 25000, 'Pending', 22500.00, 'Pending'),
(3, 3, 2, '2026-04-28', 30000, 'Delivered', 25500.00, 'Paid'),
(4, 1, 4, '2026-04-29', 20000, 'Delivered', 16000.00, 'Pending');

INSERT INTO PumpActivity VALUES
(1, 2, '2026-04-29 05:00:00', '2026-04-29 06:00:00', 'Completed', 12.50),
(2, 1, '2026-04-29 07:00:00', '2026-04-29 07:45:00', 'Completed', 8.20),
(3, 3, '2026-04-29 08:00:00', NULL, 'Running', 5.00),
(4, 4, '2026-04-29 09:00:00', '2026-04-29 10:00:00', 'Completed', 11.30);

-- 1. Tanks with low water level
SELECT 
    t.tower_name,
    wt.tank_name,
    wt.tank_type,
    tsr.water_level_percent,
    tsr.water_volume_liters,
    tsr.reading_time
FROM TankSensorReading tsr
JOIN WaterTank wt
ON tsr.tank_id = wt.tank_id
JOIN Tower t
ON wt.tower_id = t.tower_id
WHERE tsr.water_level_percent < 30;

-- 2. Tower-wise water consumption
SELECT 
    t.tower_name,
    SUM(wu.water_used_liters) AS total_water_used_liters
FROM WaterUsage wu
JOIN Apartment a
ON wu.apartment_id = a.apartment_id
JOIN Tower t
ON a.tower_id = t.tower_id
GROUP BY t.tower_name
ORDER BY total_water_used_liters DESC;

-- 3. Pending tanker deliveries
SELECT 
    td.delivery_id,
    ts.supplier_name,
    wt.tank_name,
    td.delivery_date,
    td.water_quantity_liters,
    td.delivery_status
FROM TankerDelivery td
JOIN TankerSupplier ts
ON td.supplier_id = ts.supplier_id
JOIN WaterTank wt
ON td.tank_id = wt.tank_id
WHERE td.delivery_status = 'Pending';

-- 4. Supplier-wise delivered water
SELECT 
    ts.supplier_name,
    SUM(td.water_quantity_liters) AS total_water_delivered
FROM TankerDelivery td
JOIN TankerSupplier ts
ON td.supplier_id = ts.supplier_id
WHERE td.delivery_status = 'Delivered'
GROUP BY ts.supplier_name
ORDER BY total_water_delivered DESC;

-- 5. Pending tanker payment
SELECT 
    ts.supplier_name,
    wt.tank_name,
    td.water_quantity_liters,
    td.total_amount,
    td.payment_status
FROM TankerDelivery td
JOIN TankerSupplier ts
ON td.supplier_id = ts.supplier_id
JOIN WaterTank wt
ON td.tank_id = wt.tank_id
WHERE td.payment_status = 'Pending';

-- 6. Low battery tank sensors
SELECT 
    wt.tank_name,
    tsr.sensor_battery_percent,
    tsr.reading_time
FROM TankSensorReading tsr
JOIN WaterTank wt
ON tsr.tank_id = wt.tank_id
WHERE tsr.sensor_battery_percent < 40;

-- 7. Running pumps
SELECT 
    wt.tank_name,
    pa.pump_start_time,
    pa.pump_status,
    pa.power_units_used
FROM PumpActivity pa
JOIN WaterTank wt
ON pa.tank_id = wt.tank_id
WHERE pa.pump_status = 'Running';

-- 8. Complete water usage report
SELECT 
    t.tower_name,
    a.flat_number,
    a.resident_name,
    wu.usage_date,
    wu.water_used_liters,
    wt.tank_name,
    tsr.water_level_percent,
    td.water_quantity_liters,
    td.delivery_status,
    td.payment_status
FROM WaterUsage wu
JOIN Apartment a
ON wu.apartment_id = a.apartment_id
JOIN Tower t
ON a.tower_id = t.tower_id
LEFT JOIN WaterTank wt
ON t.tower_id = wt.tower_id
LEFT JOIN TankSensorReading tsr
ON wt.tank_id = tsr.tank_id
LEFT JOIN TankerDelivery td
ON wt.tank_id = td.tank_id;
