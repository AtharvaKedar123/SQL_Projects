

CREATE DATABASE ParkingViolationDB;
USE ParkingViolationDB;

CREATE TABLE Owner (
    owner_id INT PRIMARY KEY,
    owner_name VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(80),
    city VARCHAR(50)
);

CREATE TABLE Vehicle (
    vehicle_id INT PRIMARY KEY,
    owner_id INT,
    vehicle_number VARCHAR(20),
    vehicle_type VARCHAR(30),
    brand VARCHAR(50),
    model VARCHAR(50),
    FOREIGN KEY (owner_id) REFERENCES Owner(owner_id)
);

CREATE TABLE ParkingZone (
    zone_id INT PRIMARY KEY,
    zone_name VARCHAR(50),
    location_description VARCHAR(100),
    zone_type VARCHAR(40)
);

CREATE TABLE TrafficOfficer (
    officer_id INT PRIMARY KEY,
    officer_name VARCHAR(50),
    badge_number VARCHAR(30),
    assigned_area VARCHAR(50)
);

CREATE TABLE ViolationType (
    violation_type_id INT PRIMARY KEY,
    violation_name VARCHAR(80),
    fine_amount DECIMAL(10,2),
    severity_level VARCHAR(30)
);

CREATE TABLE ParkingViolation (
    violation_id INT PRIMARY KEY,
    vehicle_id INT,
    zone_id INT,
    officer_id INT,
    violation_type_id INT,
    violation_time DATETIME,
    violation_status VARCHAR(30),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id),
    FOREIGN KEY (zone_id) REFERENCES ParkingZone(zone_id),
    FOREIGN KEY (officer_id) REFERENCES TrafficOfficer(officer_id),
    FOREIGN KEY (violation_type_id) REFERENCES ViolationType(violation_type_id)
);

CREATE TABLE FinePayment (
    payment_id INT PRIMARY KEY,
    violation_id INT,
    fine_amount DECIMAL(10,2),
    payment_status VARCHAR(30),
    payment_method VARCHAR(30),
    payment_date DATE,
    FOREIGN KEY (violation_id) REFERENCES ParkingViolation(violation_id)
);

INSERT INTO Owner VALUES
(1, 'Rahul Sharma', '9999999999', 'rahul@email.com', 'Nagpur'),
(2, 'Sneha Patil', '8888888888', 'sneha@email.com', 'Pune'),
(3, 'Aman Verma', '7777777777', 'aman@email.com', 'Mumbai'),
(4, 'Priya Mehta', '6666666666', 'priya@email.com', 'Delhi'),
(5, 'Atharva Kedar', '5555555555', 'atharva@email.com', 'Nagpur');

INSERT INTO Vehicle VALUES
(1, 1, 'MH31AB1234', 'Car', 'Hyundai', 'i20'),
(2, 2, 'MH12XY5678', 'Bike', 'Honda', 'Activa'),
(3, 3, 'MH01PQ1111', 'Car', 'Maruti', 'Swift'),
(4, 4, 'DL10CD2222', 'Car', 'Tata', 'Nexon'),
(5, 5, 'MH31AK9999', 'Bike', 'Yamaha', 'FZ');

INSERT INTO ParkingZone VALUES
(1, 'Central Market Zone', 'Near main market road', 'No Parking'),
(2, 'Hospital Emergency Lane', 'Outside City Hospital', 'Emergency Lane'),
(3, 'Mall Paid Parking', 'Basement parking area', 'Paid Parking'),
(4, 'Residential Reserved Zone', 'Apartment visitor parking', 'Reserved'),
(5, 'Bus Stop Area', 'Near public bus stop', 'No Parking');

INSERT INTO TrafficOfficer VALUES
(1, 'Inspector Ramesh Yadav', 'BADGE-101', 'Central Zone'),
(2, 'Officer Suresh Patil', 'BADGE-102', 'West Zone'),
(3, 'Officer Anjali Rao', 'BADGE-103', 'South Zone');

INSERT INTO ViolationType VALUES
(1, 'No Parking Violation', 500.00, 'Medium'),
(2, 'Emergency Lane Parking', 2000.00, 'Critical'),
(3, 'Expired Paid Parking', 300.00, 'Low'),
(4, 'Reserved Area Parking', 1000.00, 'High'),
(5, 'Bus Stop Blocking', 1500.00, 'High');

INSERT INTO ParkingViolation VALUES
(1, 1, 1, 1, 1, '2026-04-29 09:00:00', 'Fine Generated'),
(2, 2, 5, 1, 5, '2026-04-29 10:15:00', 'Fine Generated'),
(3, 3, 3, 2, 3, '2026-04-29 11:00:00', 'Paid'),
(4, 4, 2, 3, 2, '2026-04-29 12:30:00', 'Fine Generated'),
(5, 5, 4, 2, 4, '2026-04-29 13:00:00', 'Paid'),
(6, 1, 5, 1, 1, '2026-04-30 09:30:00', 'Fine Generated');

INSERT INTO FinePayment VALUES
(1, 1, 500.00, 'Unpaid', NULL, NULL),
(2, 2, 1500.00, 'Unpaid', NULL, NULL),
(3, 3, 300.00, 'Paid', 'UPI', '2026-04-29'),
(4, 4, 2000.00, 'Unpaid', NULL, NULL),
(5, 5, 1000.00, 'Paid', 'Card', '2026-04-29'),
(6, 6, 500.00, 'Unpaid', NULL, NULL);

-- 1. Unpaid fines
SELECT 
    fp.payment_id,
    o.owner_name,
    v.vehicle_number,
    vt.violation_name,
    fp.fine_amount,
    fp.payment_status
FROM FinePayment fp
JOIN ParkingViolation pv
ON fp.violation_id = pv.violation_id
JOIN Vehicle v
ON pv.vehicle_id = v.vehicle_id
JOIN Owner o
ON v.owner_id = o.owner_id
JOIN ViolationType vt
ON pv.violation_type_id = vt.violation_type_id
WHERE fp.payment_status = 'Unpaid';

-- 2. Vehicles with repeated violations
SELECT 
    v.vehicle_number,
    o.owner_name,
    COUNT(pv.violation_id) AS total_violations
FROM ParkingViolation pv
JOIN Vehicle v
ON pv.vehicle_id = v.vehicle_id
JOIN Owner o
ON v.owner_id = o.owner_id
GROUP BY v.vehicle_number, o.owner_name
HAVING COUNT(pv.violation_id) > 1;

-- 3. Parking zone with most violations
SELECT 
    pz.zone_name,
    pz.zone_type,
    COUNT(pv.violation_id) AS total_violations
FROM ParkingViolation pv
JOIN ParkingZone pz
ON pv.zone_id = pz.zone_id
GROUP BY pz.zone_name, pz.zone_type
ORDER BY total_violations DESC;

-- 4. Most common violation type
SELECT 
    vt.violation_name,
    vt.severity_level,
    COUNT(pv.violation_id) AS occurrence_count
FROM ParkingViolation pv
JOIN ViolationType vt
ON pv.violation_type_id = vt.violation_type_id
GROUP BY vt.violation_name, vt.severity_level
ORDER BY occurrence_count DESC;

-- 5. Total fine revenue collected
SELECT 
    SUM(fine_amount) AS total_fine_revenue
FROM FinePayment
WHERE payment_status = 'Paid';

-- 6. Officer-wise violation count
SELECT 
    tof.officer_name,
    tof.badge_number,
    tof.assigned_area,
    COUNT(pv.violation_id) AS total_reported_violations
FROM ParkingViolation pv
JOIN TrafficOfficer tof
ON pv.officer_id = tof.officer_id
GROUP BY tof.officer_name, tof.badge_number, tof.assigned_area
ORDER BY total_reported_violations DESC;

-- 7. Critical and high severity violations
SELECT 
    o.owner_name,
    v.vehicle_number,
    pz.zone_name,
    vt.violation_name,
    vt.severity_level,
    pv.violation_time
FROM ParkingViolation pv
JOIN Vehicle v
ON pv.vehicle_id = v.vehicle_id
JOIN Owner o
ON v.owner_id = o.owner_id
JOIN ParkingZone pz
ON pv.zone_id = pz.zone_id
JOIN ViolationType vt
ON pv.violation_type_id = vt.violation_type_id
WHERE vt.severity_level IN ('High', 'Critical');

-- 8. Complete parking violation report
SELECT 
    pv.violation_id,
    o.owner_name,
    v.vehicle_number,
    v.vehicle_type,
    pz.zone_name,
    vt.violation_name,
    vt.fine_amount,
    tof.officer_name,
    pv.violation_time,
    fp.payment_status
FROM ParkingViolation pv
JOIN Vehicle v
ON pv.vehicle_id = v.vehicle_id
JOIN Owner o
ON v.owner_id = o.owner_id
JOIN ParkingZone pz
ON pv.zone_id = pz.zone_id
JOIN ViolationType vt
ON pv.violation_type_id = vt.violation_type_id
JOIN TrafficOfficer tof
ON pv.officer_id = tof.officer_id
JOIN FinePayment fp
ON pv.violation_id = fp.violation_id;
