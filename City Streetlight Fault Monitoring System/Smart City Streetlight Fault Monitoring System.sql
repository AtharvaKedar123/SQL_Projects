CREATE DATABASE SmartStreetlightDB;
USE SmartStreetlightDB;

CREATE TABLE Zone (
    zone_id INT PRIMARY KEY,
    zone_name VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE Streetlight (
    light_id INT PRIMARY KEY,
    pole_number VARCHAR(30),
    zone_id INT,
    installation_date DATE,
    light_type VARCHAR(50),
    light_status VARCHAR(30),
    FOREIGN KEY (zone_id) REFERENCES Zone(zone_id)
);

CREATE TABLE SensorReading (
    reading_id INT PRIMARY KEY,
    light_id INT,
    reading_date DATE,
    light_intensity DECIMAL(10,2),
    power_consumption_watts DECIMAL(10,2),
    operational_status VARCHAR(30),
    FOREIGN KEY (light_id) REFERENCES Streetlight(light_id)
);

CREATE TABLE Technician (
    technician_id INT PRIMARY KEY,
    technician_name VARCHAR(50),
    specialization VARCHAR(50),
    phone VARCHAR(20)
);

CREATE TABLE FaultLog (
    fault_id INT PRIMARY KEY,
    light_id INT,
    fault_date DATE,
    fault_type VARCHAR(80),
    severity VARCHAR(30),
    fault_status VARCHAR(30),
    FOREIGN KEY (light_id) REFERENCES Streetlight(light_id)
);

CREATE TABLE RepairRecord (
    repair_id INT PRIMARY KEY,
    fault_id INT,
    technician_id INT,
    repair_date DATE,
    repair_status VARCHAR(30),
    repair_cost DECIMAL(10,2),
    FOREIGN KEY (fault_id) REFERENCES FaultLog(fault_id),
    FOREIGN KEY (technician_id) REFERENCES Technician(technician_id)
);

INSERT INTO Zone VALUES
(1, 'Central Zone', 'Nagpur'),
(2, 'East Zone', 'Nagpur'),
(3, 'West Zone', 'Nagpur'),
(4, 'North Zone', 'Nagpur');

INSERT INTO Streetlight VALUES
(1, 'NG-1001', 1, '2024-01-10', 'LED', 'Active'),
(2, 'NG-1002', 1, '2024-02-15', 'LED', 'Faulty'),
(3, 'NG-2001', 2, '2024-03-20', 'Halogen', 'Active'),
(4, 'NG-3001', 3, '2024-04-05', 'LED', 'Inactive'),
(5, 'NG-4001', 4, '2024-05-12', 'Solar', 'Active'),
(6, 'NG-2002', 2, '2024-06-18', 'LED', 'Faulty');

INSERT INTO SensorReading VALUES
(1, 1, '2026-04-01', 85.00, 120.00, 'Working'),
(2, 2, '2026-04-01', 0.00, 0.00, 'Not Working'),
(3, 3, '2026-04-01', 70.00, 150.00, 'Working'),
(4, 4, '2026-04-01', 0.00, 10.00, 'Inactive'),
(5, 5, '2026-04-01', 90.00, 80.00, 'Working'),
(6, 6, '2026-04-01', 20.00, 60.00, 'Faulty');

INSERT INTO Technician VALUES
(1, 'Ravi Patil', 'Electrical Repair', '9000011111'),
(2, 'Sneha Joshi', 'Lighting Systems', '9000022222'),
(3, 'Amit Verma', 'Wiring Specialist', '9000033333');

INSERT INTO FaultLog VALUES
(1, 2, '2026-04-01', 'Bulb Failure', 'High', 'Unresolved'),
(2, 6, '2026-04-01', 'Wiring Issue', 'Medium', 'In Progress'),
(3, 4, '2026-04-02', 'Power Supply Issue', 'Low', 'Resolved');

INSERT INTO RepairRecord VALUES
(1, 3, 1, '2026-04-02', 'Completed', 1500.00),
(2, 2, 3, '2026-04-03', 'In Progress', 2000.00),
(3, 1, 2, '2026-04-04', 'Pending', 2500.00);

-- 1. Faulty streetlights
SELECT 
    pole_number,
    light_type,
    light_status
FROM Streetlight
WHERE light_status = 'Faulty';

-- 2. Zones with highest faults
SELECT 
    z.zone_name,
    COUNT(fl.fault_id) AS total_faults
FROM FaultLog fl
JOIN Streetlight sl ON fl.light_id = sl.light_id
JOIN Zone z ON sl.zone_id = z.zone_id
GROUP BY z.zone_name
ORDER BY total_faults DESC;

-- 3. Technicians handling most repairs
SELECT 
    t.technician_name,
    COUNT(rr.repair_id) AS total_repairs
FROM RepairRecord rr
JOIN Technician t ON rr.technician_id = t.technician_id
GROUP BY t.technician_name
ORDER BY total_repairs DESC;

-- 4. Total power consumption
SELECT 
    SUM(power_consumption_watts) AS total_power_usage
FROM SensorReading;

-- 5. Unresolved faults
SELECT 
    sl.pole_number,
    fl.fault_type,
    fl.severity
FROM FaultLog fl
JOIN Streetlight sl ON fl.light_id = sl.light_id
WHERE fl.fault_status = 'Unresolved';

-- 6. Streetlights consuming most power
SELECT 
    sl.pole_number,
    SUM(sr.power_consumption_watts) AS total_power
FROM SensorReading sr
JOIN Streetlight sl ON sr.light_id = sl.light_id
GROUP BY sl.pole_number
ORDER BY total_power DESC;

-- 7. Average power usage per zone
SELECT 
    z.zone_name,
    AVG(sr.power_consumption_watts) AS avg_power
FROM SensorReading sr
JOIN Streetlight sl ON sr.light_id = sl.light_id
JOIN Zone z ON sl.zone_id = z.zone_id
GROUP BY z.zone_name;

-- 8. Inactive streetlights
SELECT 
    pole_number,
    zone_id,
    light_type
FROM Streetlight
WHERE light_status = 'Inactive';

-- 9. Faults with repair status
SELECT 
    sl.pole_number,
    fl.fault_type,
    fl.fault_status,
    rr.repair_status
FROM FaultLog fl
LEFT JOIN RepairRecord rr ON fl.fault_id = rr.fault_id
JOIN Streetlight sl ON fl.light_id = sl.light_id;

-- 10. Repair cost summary
SELECT 
    SUM(repair_cost) AS total_repair_cost
FROM RepairRecord;