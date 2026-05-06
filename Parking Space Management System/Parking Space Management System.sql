CREATE DATABASE SmartParkingDB;
USE SmartParkingDB;

CREATE TABLE ParkingZone (
    zone_id INT PRIMARY KEY,
    zone_name VARCHAR(50),
    total_slots INT
);

CREATE TABLE ParkingSlot (
    slot_id INT PRIMARY KEY,
    zone_id INT,
    slot_number VARCHAR(20),
    slot_type VARCHAR(30),
    is_available BOOLEAN,
    FOREIGN KEY (zone_id) REFERENCES ParkingZone(zone_id)
);

CREATE TABLE Vehicle (
    vehicle_id INT PRIMARY KEY,
    vehicle_number VARCHAR(20),
    vehicle_type VARCHAR(30),
    owner_name VARCHAR(50),
    owner_phone VARCHAR(15)
);

CREATE TABLE ParkingBooking (
    booking_id INT PRIMARY KEY,
    vehicle_id INT,
    slot_id INT,
    entry_time DATETIME,
    exit_time DATETIME,
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(30),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id),
    FOREIGN KEY (slot_id) REFERENCES ParkingSlot(slot_id)
);

INSERT INTO ParkingZone VALUES
(1, 'Basement A', 50),
(2, 'Open Ground', 80),
(3, 'VIP Zone', 20),
(4, 'Two Wheeler Zone', 100);

INSERT INTO ParkingSlot VALUES
(101, 1, 'A-01', 'Car', FALSE),
(102, 1, 'A-02', 'Car', TRUE),
(103, 1, 'A-03', 'Car', TRUE),
(201, 2, 'G-01', 'Car', FALSE),
(202, 2, 'G-02', 'Car', TRUE),
(301, 3, 'V-01', 'VIP Car', FALSE),
(401, 4, 'B-01', 'Bike', TRUE),
(402, 4, 'B-02', 'Bike', FALSE);

INSERT INTO Vehicle VALUES
(1, 'MH31AB1234', 'Car', 'Rahul Sharma', '9876543210'),
(2, 'MH31XY9876', 'Bike', 'Amit Verma', '9988776655'),
(3, 'MH12PQ5555', 'Car', 'Priya Deshmukh', '9090909090'),
(4, 'MH40VIP7777', 'VIP Car', 'Rohan Mehta', '8888888888');

INSERT INTO ParkingBooking VALUES
(1, 1, 101, '2026-04-29 09:00:00', '2026-04-29 12:00:00', 150.00, 'Paid'),
(2, 2, 402, '2026-04-29 10:15:00', NULL, 0.00, 'Pending'),
(3, 3, 201, '2026-04-29 08:30:00', '2026-04-29 11:30:00', 150.00, 'Paid'),
(4, 4, 301, '2026-04-29 13:00:00', NULL, 0.00, 'Pending');