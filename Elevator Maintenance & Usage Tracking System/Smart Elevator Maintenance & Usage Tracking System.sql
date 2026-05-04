CREATE DATABASE ElevatorMaintenanceDB;
USE ElevatorMaintenanceDB;

CREATE TABLE Elevator (
    elevator_id INT PRIMARY KEY,
    elevator_code VARCHAR(30),
    elevator_type VARCHAR(50),
    max_capacity INT,
    current_status VARCHAR(30)
);

CREATE TABLE Floor (
    floor_id INT PRIMARY KEY,
    floor_number INT,
    floor_name VARCHAR(50)
);

CREATE TABLE Technician (
    technician_id INT PRIMARY KEY,
    technician_name VARCHAR(50),
    specialization VARCHAR(50),
    phone VARCHAR(20)
);

CREATE TABLE ElevatorUsageLog (
    usage_id INT PRIMARY KEY,
    elevator_id INT,
    from_floor_id INT,
    to_floor_id INT,
    usage_date DATE,
    passenger_count INT,
    trip_duration_minutes INT,
    FOREIGN KEY (elevator_id) REFERENCES Elevator(elevator_id),
    FOREIGN KEY (from_floor_id) REFERENCES Floor(floor_id),
    FOREIGN KEY (to_floor_id) REFERENCES Floor(floor_id)
);

CREATE TABLE Breakdown (
    breakdown_id INT PRIMARY KEY,
    elevator_id INT,
    breakdown_date DATE,
    issue_description VARCHAR(255),
    severity VARCHAR(30),
    repair_status VARCHAR(30),
    FOREIGN KEY (elevator_id) REFERENCES Elevator(elevator_id)
);

CREATE TABLE MaintenanceSchedule (
    maintenance_id INT PRIMARY KEY,
    elevator_id INT,
    technician_id INT,
    scheduled_date DATE,
    maintenance_type VARCHAR(50),
    maintenance_status VARCHAR(30),
    cost DECIMAL(10,2),
    FOREIGN KEY (elevator_id) REFERENCES Elevator(elevator_id),
    FOREIGN KEY (technician_id) REFERENCES Technician(technician_id)
);

INSERT INTO Elevator VALUES
(1, 'LIFT-A1', 'Passenger', 10, 'Active'),
(2, 'LIFT-B1', 'Passenger', 12, 'Under Repair'),
(3, 'LIFT-C1', 'Service', 15, 'Active'),
(4, 'LIFT-D1', 'VIP', 8, 'Active');

INSERT INTO Floor VALUES
(1, 0, 'Ground Floor'),
(2, 1, 'First Floor'),
(3, 2, 'Second Floor'),
(4, 3, 'Third Floor'),
(5, 4, 'Fourth Floor'),
(6, 5, 'Fifth Floor');

INSERT INTO Technician VALUES
(1, 'Raj Malhotra', 'Electrical Repair', '9876543210'),
(2, 'Amit Verma', 'Mechanical Repair', '9876543211'),
(3, 'Sneha Joshi', 'Lift Safety Inspection', '9876543212');

INSERT INTO ElevatorUsageLog VALUES
(1, 1, 1, 5, '2026-04-01', 6, 3),
(2, 1, 5, 1, '2026-04-01', 4, 3),
(3, 2, 1, 6, '2026-04-02', 8, 4),
(4, 3, 2, 5, '2026-04-02', 5, 5),
(5, 1, 1, 4, '2026-04-03', 7, 3),
(6, 4, 1, 6, '2026-04-04', 3, 2),
(7, 2, 6, 1, '2026-04-05', 9, 4),
(8, 3, 1, 3, '2026-04-06', 10, 6);

INSERT INTO Breakdown VALUES
(1, 2, '2026-04-05', 'Door sensor not responding', 'High', 'In Progress'),
(2, 1, '2026-04-07', 'Unusual vibration during movement', 'Medium', 'Resolved'),
(3, 2, '2026-04-09', 'Emergency button malfunction', 'High', 'Pending'),
(4, 3, '2026-04-10', 'Slow movement issue', 'Low', 'Resolved');

INSERT INTO MaintenanceSchedule VALUES
(1, 1, 1, '2026-04-08', 'Sensor Check', 'Completed', 2500.00),
(2, 2, 2, '2026-04-10', 'Door Motor Repair', 'In Progress', 7000.00),
(3, 3, 3, '2026-04-12', 'Safety Inspection', 'Completed', 3000.00),
(4, 4, 3, '2026-04-18', 'Routine Inspection', 'Scheduled', 2000.00),
(5, 2, 1, '2026-04-20', 'Emergency System Repair', 'Scheduled', 4500.00);

-- 1. Most used elevators
SELECT 
    e.elevator_code,
    e.elevator_type,
    COUNT(ul.usage_id) AS total_trips,
    SUM(ul.passenger_count) AS total_passengers
FROM ElevatorUsageLog ul
JOIN Elevator e
ON ul.elevator_id = e.elevator_id
GROUP BY e.elevator_code, e.elevator_type
ORDER BY total_trips DESC;

-- 2. Elevators with highest breakdown count
SELECT 
    e.elevator_code,
    COUNT(b.breakdown_id) AS total_breakdowns
FROM Breakdown b
JOIN Elevator e
ON b.elevator_id = e.elevator_id
GROUP BY e.elevator_code
ORDER BY total_breakdowns DESC;

-- 3. Technicians who handled most maintenance tasks
SELECT 
    t.technician_name,
    t.specialization,
    COUNT(ms.maintenance_id) AS total_tasks
FROM MaintenanceSchedule ms
JOIN Technician t
ON ms.technician_id = t.technician_id
GROUP BY t.technician_name, t.specialization
ORDER BY total_tasks DESC;

-- 4. Total maintenance cost
SELECT 
    SUM(cost) AS total_maintenance_cost
FROM MaintenanceSchedule;

-- 5. Elevators currently under repair
SELECT 
    elevator_code,
    elevator_type,
    current_status
FROM Elevator
WHERE current_status = 'Under Repair';

-- 6. Floors with highest elevator traffic
SELECT 
    f.floor_name,
    f.floor_number,
    COUNT(ul.usage_id) AS total_visits
FROM ElevatorUsageLog ul
JOIN Floor f
ON ul.to_floor_id = f.floor_id
GROUP BY f.floor_name, f.floor_number
ORDER BY total_visits DESC;

-- 7. Upcoming scheduled maintenance
SELECT 
    e.elevator_code,
    t.technician_name,
    ms.maintenance_type,
    ms.scheduled_date,
    ms.maintenance_status
FROM MaintenanceSchedule ms
JOIN Elevator e
ON ms.elevator_id = e.elevator_id
JOIN Technician t
ON ms.technician_id = t.technician_id
WHERE ms.maintenance_status = 'Scheduled';

-- 8. Average maintenance cost per elevator
SELECT 
    e.elevator_code,
    AVG(ms.cost) AS average_maintenance_cost
FROM MaintenanceSchedule ms
JOIN Elevator e
ON ms.elevator_id = e.elevator_id
GROUP BY e.elevator_code
ORDER BY average_maintenance_cost DESC;

-- 9. Pending and in-progress breakdowns
SELECT 
    e.elevator_code,
    b.issue_description,
    b.severity,
    b.repair_status,
    b.breakdown_date
FROM Breakdown b
JOIN Elevator e
ON b.elevator_id = e.elevator_id
WHERE b.repair_status IN ('Pending', 'In Progress');

-- 10. Elevator total usage time
SELECT 
    e.elevator_code,
    SUM(ul.trip_duration_minutes) AS total_usage_minutes
FROM ElevatorUsageLog ul
JOIN Elevator e
ON ul.elevator_id = e.elevator_id
GROUP BY e.elevator_code
ORDER BY total_usage_minutes DESC;