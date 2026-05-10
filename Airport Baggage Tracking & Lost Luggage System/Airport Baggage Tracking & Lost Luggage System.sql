CREATE DATABASE AirportBaggageDB:
USE AirportBaggageDB;

CREATE TABLE Passenger (
    passenger_id INT PRIMARY KEY,
    passenger_name VARCHAR(80),
    phone VARCHAR(15),
    email VARCHAR(80),
    passport_number VARCHAR(30)
);

CREATE TABLE Flight (
    flight_id INT PRIMARY KEY,
    flight_number VARCHAR(20),
    airline_name VARCHAR(80),
    source_city VARCHAR(50),
    destination_city VARCHAR(50),
    departure_time DATETIME,
    arrival_time DATETIME
);

CREATE TABLE Baggage (
    baggage_id INT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    baggage_tag VARCHAR(30) UNIQUE,
    baggage_weight DECIMAL(5,2),
    baggage_status VARCHAR(30),
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flight(flight_id)
);

CREATE TABLE Checkpoint (
    checkpoint_id INT PRIMARY KEY,
    checkpoint_name VARCHAR(80),
    checkpoint_location VARCHAR(80)
);

CREATE TABLE BaggageScan (
    scan_id INT PRIMARY KEY,
    baggage_id INT,
    checkpoint_id INT,
    scan_time DATETIME,
    scan_status VARCHAR(40),
    FOREIGN KEY (baggage_id) REFERENCES Baggage(baggage_id),
    FOREIGN KEY (checkpoint_id) REFERENCES Checkpoint(checkpoint_id)
);

CREATE TABLE LostLuggageComplaint (
    complaint_id INT PRIMARY KEY,
    baggage_id INT,
    complaint_date DATE,
    complaint_description VARCHAR(255),
    complaint_status VARCHAR(40),
    FOREIGN KEY (baggage_id) REFERENCES Baggage(baggage_id)
);

CREATE TABLE RecoveryRecord (
    recovery_id INT PRIMARY KEY,
    complaint_id INT,
    recovered_date DATE,
    recovery_location VARCHAR(80),
    recovery_status VARCHAR(40),
    delivered_to_passenger VARCHAR(10),
    FOREIGN KEY (complaint_id) REFERENCES LostLuggageComplaint(complaint_id)
);

INSERT INTO Passenger VALUES
(1, 'Aarav Mehta', '9876543210', 'aarav@email.com', 'P1234567'),
(2, 'Sneha Sharma', '9123456780', 'sneha@email.com', 'P2345678'),
(3, 'Rahul Verma', '9988776655', 'rahul@email.com', 'P3456789'),
(4, 'Priya Nair', '9090909090', 'priya@email.com', 'P4567890'),
(5, 'Karan Malhotra', '8080808080', 'karan@email.com', 'P5678901');

INSERT INTO Flight VALUES
(1, 'AI-402', 'Air India', 'Mumbai', 'Delhi', '2026-04-29 08:00:00', '2026-04-29 10:00:00'),
(2, '6E-215', 'IndiGo', 'Nagpur', 'Bangalore', '2026-04-29 09:30:00', '2026-04-29 11:45:00'),
(3, 'UK-811', 'Vistara', 'Pune', 'Hyderabad', '2026-04-29 12:00:00', '2026-04-29 13:30:00');

INSERT INTO Baggage VALUES
(1, 1, 1, 'BAG-AI402-101', 18.50, 'Delivered'),
(2, 2, 1, 'BAG-AI402-102', 21.00, 'Missing'),
(3, 3, 2, 'BAG-6E215-201', 15.75, 'Delivered'),
(4, 4, 2, 'BAG-6E215-202', 19.20, 'Recovered'),
(5, 5, 3, 'BAG-UK811-301', 23.40, 'Delayed'),
(6, 1, 3, 'BAG-UK811-302', 17.80, 'Loaded');

INSERT INTO Checkpoint VALUES
(1, 'Check-in Counter', 'Terminal 1'),
(2, 'Security Scan', 'Terminal 1'),
(3, 'Loading Area', 'Runway Zone'),
(4, 'Aircraft Loaded', 'Aircraft Bay'),
(5, 'Arrival Belt', 'Arrival Terminal'),
(6, 'Baggage Claim', 'Exit Area');

INSERT INTO BaggageScan VALUES
(1, 1, 1, '2026-04-29 07:00:00', 'Checked In'),
(2, 1, 2, '2026-04-29 07:15:00', 'Security Cleared'),
(3, 1, 3, '2026-04-29 07:40:00', 'Sent for Loading'),
(4, 1, 6, '2026-04-29 10:20:00', 'Delivered'),

(5, 2, 1, '2026-04-29 07:05:00', 'Checked In'),
(6, 2, 2, '2026-04-29 07:25:00', 'Security Cleared'),
(7, 2, 3, '2026-04-29 07:50:00', 'Sent for Loading'),

(8, 3, 1, '2026-04-29 08:30:00', 'Checked In'),
(9, 3, 2, '2026-04-29 08:50:00', 'Security Cleared'),
(10, 3, 6, '2026-04-29 12:00:00', 'Delivered'),

(11, 4, 1, '2026-04-29 08:35:00', 'Checked In'),
(12, 4, 3, '2026-04-29 09:10:00', 'Sent for Loading'),
(13, 4, 5, '2026-04-29 12:05:00', 'Found at Arrival Belt'),

(14, 5, 1, '2026-04-29 11:00:00', 'Checked In'),
(15, 5, 2, '2026-04-29 11:20:00', 'Security Cleared'),

(16, 6, 1, '2026-04-29 11:10:00', 'Checked In'),
(17, 6, 4, '2026-04-29 11:50:00', 'Loaded into Aircraft');

INSERT INTO LostLuggageComplaint VALUES
(1, 2, '2026-04-29', 'Passenger did not receive baggage at claim area.', 'Open'),
(2, 4, '2026-04-29', 'Baggage delayed but later located.', 'Resolved'),
(3, 5, '2026-04-29', 'Baggage not available on arrival belt.', 'Under Investigation');

INSERT INTO RecoveryRecord VALUES
(1, 2, '2026-04-29', 'Arrival Belt Section B', 'Recovered', 'Yes'),
(2, 3, NULL, 'Not Found Yet', 'Pending', 'No');

-- 1. Show all baggage with passenger and flight details
SELECT 
    b.baggage_id,
    b.baggage_tag,
    p.passenger_name,
    f.flight_number,
    f.airline_name,
    f.source_city,
    f.destination_city,
    b.baggage_weight,
    b.baggage_status
FROM Baggage b
JOIN Passenger p
ON b.passenger_id = p.passenger_id
JOIN Flight f
ON b.flight_id = f.flight_id;

-- 2. Show currently missing baggage
SELECT 
    b.baggage_tag,
    p.passenger_name,
    p.phone,
    f.flight_number,
    b.baggage_status
FROM Baggage b
JOIN Passenger p
ON b.passenger_id = p.passenger_id
JOIN Flight f
ON b.flight_id = f.flight_id
WHERE b.baggage_status = 'Missing';

-- 3. Show lost luggage complaints
SELECT 
    llc.complaint_id,
    p.passenger_name,
    b.baggage_tag,
    f.flight_number,
    llc.complaint_date,
    llc.complaint_description,
    llc.complaint_status
FROM LostLuggageComplaint llc
JOIN Baggage b
ON llc.baggage_id = b.baggage_id
JOIN Passenger p
ON b.passenger_id = p.passenger_id
JOIN Flight f
ON b.flight_id = f.flight_id;

-- 4. Last scanned checkpoint of each baggage
SELECT 
    b.baggage_tag,
    c.checkpoint_name,
    c.checkpoint_location,
    bs.scan_time,
    bs.scan_status
FROM BaggageScan bs
JOIN Baggage b
ON bs.baggage_id = b.baggage_id
JOIN Checkpoint c
ON bs.checkpoint_id = c.checkpoint_id
WHERE bs.scan_time = (
    SELECT MAX(bs2.scan_time)
    FROM BaggageScan bs2
    WHERE bs2.baggage_id = bs.baggage_id
);

-- 5. Count baggage by status
SELECT 
    baggage_status,
    COUNT(*) AS total_bags
FROM Baggage
GROUP BY baggage_status
ORDER BY total_bags DESC;

-- 6. Flights with highest lost luggage complaints
SELECT 
    f.flight_number,
    f.airline_name,
    COUNT(llc.complaint_id) AS total_complaints
FROM LostLuggageComplaint llc
JOIN Baggage b
ON llc.baggage_id = b.baggage_id
JOIN Flight f
ON b.flight_id = f.flight_id
GROUP BY f.flight_number, f.airline_name
ORDER BY total_complaints DESC;

-- 7. Successfully delivered baggage
SELECT 
    b.baggage_tag,
    p.passenger_name,
    f.flight_number,
    b.baggage_status
FROM Baggage b
JOIN Passenger p
ON b.passenger_id = p.passenger_id
JOIN Flight f
ON b.flight_id = f.flight_id
WHERE b.baggage_status = 'Delivered';

-- 8. Recovered lost luggage details
SELECT 
    rr.recovery_id,
    p.passenger_name,
    b.baggage_tag,
    rr.recovered_date,
    rr.recovery_location,
    rr.recovery_status,
    rr.delivered_to_passenger
FROM RecoveryRecord rr
JOIN LostLuggageComplaint llc
ON rr.complaint_id = llc.complaint_id
JOIN Baggage b
ON llc.baggage_id = b.baggage_id
JOIN Passenger p
ON b.passenger_id = p.passenger_id
WHERE rr.recovery_status = 'Recovered';

-- 9. Pending recovery luggage
SELECT 
    p.passenger_name,
    b.baggage_tag,
    llc.complaint_status,
    rr.recovery_status,
    rr.delivered_to_passenger
FROM RecoveryRecord rr
JOIN LostLuggageComplaint llc
ON rr.complaint_id = llc.complaint_id
JOIN Baggage b
ON llc.baggage_id = b.baggage_id
JOIN Passenger p
ON b.passenger_id = p.passenger_id
WHERE rr.recovery_status = 'Pending';

-- 10. Update baggage status after recovery
UPDATE Baggage
SET baggage_status = 'Recovered'
WHERE baggage_id = 2;
