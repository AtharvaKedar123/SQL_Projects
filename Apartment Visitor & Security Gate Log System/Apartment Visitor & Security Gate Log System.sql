-- Apartment Visitor & Security Gate Log System
-- Single File SQL Solution

CREATE DATABASE ApartmentGateLogDB;
USE ApartmentGateLogDB;

CREATE TABLE Flat (
    flat_id INT PRIMARY KEY,
    tower_name VARCHAR(30),
    flat_number VARCHAR(20),
    floor_number INT,
    flat_type VARCHAR(30)
);

CREATE TABLE Resident (
    resident_id INT PRIMARY KEY,
    flat_id INT,
    resident_name VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(80),
    resident_type VARCHAR(30),
    FOREIGN KEY (flat_id) REFERENCES Flat(flat_id)
);

CREATE TABLE Visitor (
    visitor_id INT PRIMARY KEY,
    visitor_name VARCHAR(50),
    phone VARCHAR(15),
    visitor_type VARCHAR(30),
    id_proof_type VARCHAR(30),
    id_proof_number VARCHAR(50)
);

CREATE TABLE SecurityGuard (
    guard_id INT PRIMARY KEY,
    guard_name VARCHAR(50),
    phone VARCHAR(15),
    shift_time VARCHAR(30),
    gate_number VARCHAR(20)
);

CREATE TABLE VisitorEntryRequest (
    request_id INT PRIMARY KEY,
    visitor_id INT,
    resident_id INT,
    guard_id INT,
    visit_purpose VARCHAR(100),
    request_time DATETIME,
    approval_status VARCHAR(30),
    FOREIGN KEY (visitor_id) REFERENCES Visitor(visitor_id),
    FOREIGN KEY (resident_id) REFERENCES Resident(resident_id),
    FOREIGN KEY (guard_id) REFERENCES SecurityGuard(guard_id)
);

CREATE TABLE VehicleEntry (
    vehicle_entry_id INT PRIMARY KEY,
    visitor_id INT,
    vehicle_number VARCHAR(20),
    vehicle_type VARCHAR(30),
    parking_slot VARCHAR(20),
    FOREIGN KEY (visitor_id) REFERENCES Visitor(visitor_id)
);

CREATE TABLE GateLog (
    log_id INT PRIMARY KEY,
    request_id INT,
    entry_time DATETIME,
    exit_time DATETIME,
    log_status VARCHAR(30),
    remarks VARCHAR(255),
    FOREIGN KEY (request_id) REFERENCES VisitorEntryRequest(request_id)
);

INSERT INTO Flat VALUES
(1, 'Tower A', 'A-101', 1, '2BHK'),
(2, 'Tower A', 'A-202', 2, '3BHK'),
(3, 'Tower B', 'B-301', 3, '2BHK'),
(4, 'Tower B', 'B-404', 4, '4BHK'),
(5, 'Tower C', 'C-505', 5, '3BHK');

INSERT INTO Resident VALUES
(1, 1, 'Rahul Sharma', '9999999999', 'rahul@email.com', 'Owner'),
(2, 2, 'Sneha Patil', '8888888888', 'sneha@email.com', 'Tenant'),
(3, 3, 'Aman Verma', '7777777777', 'aman@email.com', 'Owner'),
(4, 4, 'Priya Mehta', '6666666666', 'priya@email.com', 'Owner'),
(5, 5, 'Atharva Kedar', '5555555555', 'atharva@email.com', 'Tenant');

INSERT INTO Visitor VALUES
(1, 'Rohan Mehta', '9000011111', 'Guest', 'Aadhaar', 'XXXX-1111'),
(2, 'Delivery Agent 1', '9000022222', 'Delivery', 'Company ID', 'DEL-1001'),
(3, 'Electrician Worker', '9000033333', 'Service Worker', 'Aadhaar', 'XXXX-3333'),
(4, 'Cab Driver', '9000044444', 'Cab', 'Driving License', 'DL-4444'),
(5, 'Karan Singh', '9000055555', 'Guest', 'PAN', 'PAN-5555'),
(6, 'Courier Agent', '9000066666', 'Delivery', 'Company ID', 'COR-6666');

INSERT INTO SecurityGuard VALUES
(1, 'Suresh Yadav', '8000011111', 'Morning', 'Gate 1'),
(2, 'Ramesh Patil', '8000022222', 'Evening', 'Gate 1'),
(3, 'Amit Verma', '8000033333', 'Night', 'Gate 2');

INSERT INTO VisitorEntryRequest VALUES
(1, 1, 1, 1, 'Personal Visit', '2026-04-29 10:00:00', 'Approved'),
(2, 2, 2, 1, 'Food Delivery', '2026-04-29 10:15:00', 'Approved'),
(3, 3, 3, 2, 'Electrical Repair', '2026-04-29 11:00:00', 'Pending'),
(4, 4, 4, 2, 'Cab Pickup', '2026-04-29 11:30:00', 'Rejected'),
(5, 5, 5, 1, 'Personal Visit', '2026-04-29 12:00:00', 'Approved'),
(6, 6, 1, 3, 'Courier Delivery', '2026-04-29 13:00:00', 'Approved');

INSERT INTO VehicleEntry VALUES
(1, 1, 'MH31AB1234', 'Car', 'V-01'),
(2, 4, 'MH31CD5678', 'Cab', 'Visitor Parking'),
(3, 5, 'MH12XY9999', 'Bike', 'V-02');

INSERT INTO GateLog VALUES
(1, 1, '2026-04-29 10:05:00', NULL, 'Inside', 'Guest entered after approval'),
(2, 2, '2026-04-29 10:20:00', '2026-04-29 10:35:00', 'Exited', 'Food delivered'),
(3, 5, '2026-04-29 12:05:00', NULL, 'Inside', 'Guest currently inside'),
(4, 6, '2026-04-29 13:05:00', '2026-04-29 13:20:00', 'Exited', 'Courier delivered');

-- 1. Visitors currently inside
SELECT 
    v.visitor_name,
    v.visitor_type,
    r.resident_name,
    f.tower_name,
    f.flat_number,
    gl.entry_time,
    gl.log_status
FROM GateLog gl
JOIN VisitorEntryRequest ver
ON gl.request_id = ver.request_id
JOIN Visitor v
ON ver.visitor_id = v.visitor_id
JOIN Resident r
ON ver.resident_id = r.resident_id
JOIN Flat f
ON r.flat_id = f.flat_id
WHERE gl.exit_time IS NULL
AND gl.log_status = 'Inside';

-- 2. Visitors waiting for approval
SELECT 
    ver.request_id,
    v.visitor_name,
    v.visitor_type,
    r.resident_name,
    f.tower_name,
    f.flat_number,
    ver.visit_purpose,
    ver.request_time,
    ver.approval_status
FROM VisitorEntryRequest ver
JOIN Visitor v
ON ver.visitor_id = v.visitor_id
JOIN Resident r
ON ver.resident_id = r.resident_id
JOIN Flat f
ON r.flat_id = f.flat_id
WHERE ver.approval_status = 'Pending';

-- 3. Resident-wise visitor count
SELECT 
    r.resident_name,
    f.tower_name,
    f.flat_number,
    COUNT(ver.request_id) AS total_visitors
FROM VisitorEntryRequest ver
JOIN Resident r
ON ver.resident_id = r.resident_id
JOIN Flat f
ON r.flat_id = f.flat_id
GROUP BY r.resident_name, f.tower_name, f.flat_number
ORDER BY total_visitors DESC;

-- 4. Guard-wise entry handling count
SELECT 
    sg.guard_name,
    sg.shift_time,
    sg.gate_number,
    COUNT(ver.request_id) AS total_requests_handled
FROM VisitorEntryRequest ver
JOIN SecurityGuard sg
ON ver.guard_id = sg.guard_id
GROUP BY sg.guard_name, sg.shift_time, sg.gate_number
ORDER BY total_requests_handled DESC;

-- 5. Vehicle entries
SELECT 
    v.visitor_name,
    v.visitor_type,
    ve.vehicle_number,
    ve.vehicle_type,
    ve.parking_slot
FROM VehicleEntry ve
JOIN Visitor v
ON ve.visitor_id = v.visitor_id;

-- 6. Complete gate activity report
SELECT 
    gl.log_id,
    v.visitor_name,
    v.visitor_type,
    r.resident_name,
    f.tower_name,
    f.flat_number,
    ver.visit_purpose,
    ver.approval_status,
    gl.entry_time,
    gl.exit_time,
    gl.log_status,
    gl.remarks
FROM GateLog gl
JOIN VisitorEntryRequest ver
ON gl.request_id = ver.request_id
JOIN Visitor v
ON ver.visitor_id = v.visitor_id
JOIN Resident r
ON ver.resident_id = r.resident_id
JOIN Flat f
ON r.flat_id = f.flat_id
ORDER BY gl.entry_time;

-- 7. Rejected visitor requests
SELECT 
    v.visitor_name,
    v.visitor_type,
    r.resident_name,
    ver.visit_purpose,
    ver.request_time,
    ver.approval_status
FROM VisitorEntryRequest ver
JOIN Visitor v
ON ver.visitor_id = v.visitor_id
JOIN Resident r
ON ver.resident_id = r.resident_id
WHERE ver.approval_status = 'Rejected';

-- 8. Visitor type summary
SELECT 
    visitor_type,
    COUNT(visitor_id) AS total_visitors
FROM Visitor
GROUP BY visitor_type
ORDER BY total_visitors DESC;