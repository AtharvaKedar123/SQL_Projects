-- Smart Ambulance Dispatch & Response Tracking System
-- Single File SQL Solution

CREATE DATABASE AmbulanceDispatchDB;
USE AmbulanceDispatchDB;

CREATE TABLE Patient (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    phone VARCHAR(15),
    condition_type VARCHAR(80)
);

CREATE TABLE Hospital (
    hospital_id INT PRIMARY KEY,
    hospital_name VARCHAR(80),
    city_zone VARCHAR(50),
    emergency_capacity INT
);

CREATE TABLE Driver (
    driver_id INT PRIMARY KEY,
    driver_name VARCHAR(50),
    phone VARCHAR(15),
    license_number VARCHAR(50),
    shift_time VARCHAR(30)
);

CREATE TABLE Ambulance (
    ambulance_id INT PRIMARY KEY,
    ambulance_number VARCHAR(30),
    ambulance_type VARCHAR(50),
    current_zone VARCHAR(50),
    ambulance_status VARCHAR(30),
    driver_id INT,
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);

CREATE TABLE EmergencyCall (
    call_id INT PRIMARY KEY,
    patient_id INT,
    call_time DATETIME,
    pickup_location VARCHAR(150),
    pickup_zone VARCHAR(50),
    emergency_level VARCHAR(30),
    call_status VARCHAR(30),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id)
);

CREATE TABLE DispatchRecord (
    dispatch_id INT PRIMARY KEY,
    call_id INT,
    ambulance_id INT,
    hospital_id INT,
    dispatch_time DATETIME,
    arrival_time DATETIME,
    hospital_reach_time DATETIME,
    dispatch_status VARCHAR(30),
    FOREIGN KEY (call_id) REFERENCES EmergencyCall(call_id),
    FOREIGN KEY (ambulance_id) REFERENCES Ambulance(ambulance_id),
    FOREIGN KEY (hospital_id) REFERENCES Hospital(hospital_id)
);

INSERT INTO Patient VALUES
(1, 'Rahul Sharma', 45, 'Male', '9999999999', 'Chest Pain'),
(2, 'Sneha Patil', 28, 'Female', '8888888888', 'Road Accident'),
(3, 'Aman Verma', 60, 'Male', '7777777777', 'Stroke Symptoms'),
(4, 'Priya Mehta', 32, 'Female', '6666666666', 'Pregnancy Emergency'),
(5, 'Atharva Kedar', 23, 'Male', '5555555555', 'High Fever');

INSERT INTO Hospital VALUES
(1, 'City Care Hospital', 'Central Zone', 20),
(2, 'LifeLine Hospital', 'West Zone', 15),
(3, 'Metro Emergency Hospital', 'South Zone', 25),
(4, 'Hope Medical Center', 'North Zone', 10);

INSERT INTO Driver VALUES
(1, 'Ramesh Yadav', '9000011111', 'DL-AMB-1001', 'Morning'),
(2, 'Suresh Patil', '9000022222', 'DL-AMB-1002', 'Morning'),
(3, 'Amit Verma', '9000033333', 'DL-AMB-1003', 'Evening'),
(4, 'Vikas Rao', '9000044444', 'DL-AMB-1004', 'Night');

INSERT INTO Ambulance VALUES
(1, 'AMB-101', 'Basic Life Support', 'Central Zone', 'Available', 1),
(2, 'AMB-102', 'Advanced Life Support', 'West Zone', 'On Duty', 2),
(3, 'AMB-103', 'Advanced Life Support', 'South Zone', 'Available', 3),
(4, 'AMB-104', 'Basic Life Support', 'North Zone', 'Maintenance', 4),
(5, 'AMB-105', 'Cardiac Ambulance', 'Central Zone', 'On Duty', 1);

INSERT INTO EmergencyCall VALUES
(1, 1, '2026-04-29 08:00:00', 'Civil Lines, Nagpur', 'Central Zone', 'Critical', 'Assigned'),
(2, 2, '2026-04-29 08:10:00', 'Dharampeth Road, Nagpur', 'West Zone', 'High', 'Assigned'),
(3, 3, '2026-04-29 08:30:00', 'Manish Nagar, Nagpur', 'South Zone', 'Critical', 'Completed'),
(4, 4, '2026-04-29 09:00:00', 'Sadar, Nagpur', 'North Zone', 'High', 'Pending'),
(5, 5, '2026-04-29 09:30:00', 'Sitabuldi, Nagpur', 'Central Zone', 'Medium', 'Completed');

INSERT INTO DispatchRecord VALUES
(1, 1, 5, 1, '2026-04-29 08:03:00', '2026-04-29 08:15:00', '2026-04-29 08:35:00', 'Completed'),
(2, 2, 2, 2, '2026-04-29 08:12:00', '2026-04-29 08:30:00', '2026-04-29 08:50:00', 'Completed'),
(3, 3, 3, 3, '2026-04-29 08:33:00', '2026-04-29 08:47:00', '2026-04-29 09:10:00', 'Completed'),
(4, 5, 1, 1, '2026-04-29 09:35:00', '2026-04-29 09:50:00', '2026-04-29 10:05:00', 'Completed');

-- 1. Available ambulances
SELECT 
    ambulance_number,
    ambulance_type,
    current_zone,
    ambulance_status
FROM Ambulance
WHERE ambulance_status = 'Available';

-- 2. Pending emergency calls
SELECT 
    ec.call_id,
    p.patient_name,
    p.condition_type,
    ec.pickup_location,
    ec.emergency_level,
    ec.call_status
FROM EmergencyCall ec
JOIN Patient p
ON ec.patient_id = p.patient_id
WHERE ec.call_status = 'Pending';

-- 3. Ambulance case count
SELECT 
    a.ambulance_number,
    a.ambulance_type,
    COUNT(dr.dispatch_id) AS total_cases_handled
FROM DispatchRecord dr
JOIN Ambulance a
ON dr.ambulance_id = a.ambulance_id
GROUP BY a.ambulance_number, a.ambulance_type
ORDER BY total_cases_handled DESC;

-- 4. Delayed response cases above 15 minutes
SELECT 
    dr.dispatch_id,
    p.patient_name,
    ec.emergency_level,
    a.ambulance_number,
    TIMESTAMPDIFF(MINUTE, dr.dispatch_time, dr.arrival_time) AS response_minutes
FROM DispatchRecord dr
JOIN EmergencyCall ec
ON dr.call_id = ec.call_id
JOIN Patient p
ON ec.patient_id = p.patient_id
JOIN Ambulance a
ON dr.ambulance_id = a.ambulance_id
WHERE TIMESTAMPDIFF(MINUTE, dr.dispatch_time, dr.arrival_time) > 15;

-- 5. Hospital emergency patient count
SELECT 
    h.hospital_name,
    h.city_zone,
    COUNT(dr.dispatch_id) AS total_patients_received
FROM DispatchRecord dr
JOIN Hospital h
ON dr.hospital_id = h.hospital_id
GROUP BY h.hospital_name, h.city_zone
ORDER BY total_patients_received DESC;

-- 6. Average ambulance response time
SELECT 
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, dispatch_time, arrival_time)), 2) AS average_response_minutes
FROM DispatchRecord;

-- 7. Critical emergency cases
SELECT 
    ec.call_id,
    p.patient_name,
    p.condition_type,
    ec.pickup_zone,
    ec.emergency_level,
    ec.call_status
FROM EmergencyCall ec
JOIN Patient p
ON ec.patient_id = p.patient_id
WHERE ec.emergency_level = 'Critical';

-- 8. Complete ambulance dispatch report
SELECT 
    dr.dispatch_id,
    p.patient_name,
    p.condition_type,
    ec.pickup_location,
    a.ambulance_number,
    d.driver_name,
    h.hospital_name,
    dr.dispatch_time,
    dr.arrival_time,
    dr.hospital_reach_time,
    dr.dispatch_status
FROM DispatchRecord dr
JOIN EmergencyCall ec
ON dr.call_id = ec.call_id
JOIN Patient p
ON ec.patient_id = p.patient_id
JOIN Ambulance a
ON dr.ambulance_id = a.ambulance_id
JOIN Driver d
ON a.driver_id = d.driver_id
JOIN Hospital h
ON dr.hospital_id = h.hospital_id;