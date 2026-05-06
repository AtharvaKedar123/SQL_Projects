-- Restaurant Table Reservation & Queue Management System
-- Single File SQL Solution

CREATE DATABASE RestaurantReservationDB;
USE RestaurantReservationDB;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(80),
    city VARCHAR(50)
);

CREATE TABLE RestaurantTable (
    table_id INT PRIMARY KEY,
    table_number VARCHAR(20),
    table_type VARCHAR(30),
    seating_capacity INT,
    table_status VARCHAR(30)
);

CREATE TABLE Reservation (
    reservation_id INT PRIMARY KEY,
    customer_id INT,
    table_id INT,
    reservation_date DATE,
    reservation_time TIME,
    number_of_guests INT,
    reservation_status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (table_id) REFERENCES RestaurantTable(table_id)
);

CREATE TABLE WaitingQueue (
    queue_id INT PRIMARY KEY,
    customer_id INT,
    queue_date DATE,
    arrival_time TIME,
    party_size INT,
    queue_position INT,
    queue_status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE DiningSession (
    session_id INT PRIMARY KEY,
    customer_id INT,
    table_id INT,
    session_date DATE,
    start_time TIME,
    end_time TIME,
    session_status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (table_id) REFERENCES RestaurantTable(table_id)
);

CREATE TABLE Bill (
    bill_id INT PRIMARY KEY,
    session_id INT,
    bill_date DATE,
    food_amount DECIMAL(10,2),
    service_charge DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(30),
    payment_method VARCHAR(30),
    FOREIGN KEY (session_id) REFERENCES DiningSession(session_id)
);

INSERT INTO Customer VALUES
(1, 'Rahul Sharma', '9999999999', 'rahul@email.com', 'Nagpur'),
(2, 'Sneha Patil', '8888888888', 'sneha@email.com', 'Pune'),
(3, 'Aman Verma', '7777777777', 'aman@email.com', 'Mumbai'),
(4, 'Priya Mehta', '6666666666', 'priya@email.com', 'Delhi'),
(5, 'Atharva Kedar', '5555555555', 'atharva@email.com', 'Nagpur');

INSERT INTO RestaurantTable VALUES
(1, 'T-01', 'Two-Seater', 2, 'Available'),
(2, 'T-02', 'Four-Seater', 4, 'Occupied'),
(3, 'T-03', 'Family Table', 6, 'Reserved'),
(4, 'T-04', 'VIP Table', 8, 'Available'),
(5, 'T-05', 'Four-Seater', 4, 'Occupied'),
(6, 'T-06', 'Two-Seater', 2, 'Available');

INSERT INTO Reservation VALUES
(1, 1, 3, '2026-04-29', '19:00:00', 5, 'Confirmed'),
(2, 2, 4, '2026-04-29', '20:00:00', 6, 'Confirmed'),
(3, 3, 1, '2026-04-30', '18:30:00', 2, 'Pending'),
(4, 4, 6, '2026-04-29', '21:00:00', 2, 'Cancelled'),
(5, 5, 2, '2026-04-29', '19:30:00', 4, 'Completed');

INSERT INTO WaitingQueue VALUES
(1, 3, '2026-04-29', '19:10:00', 3, 1, 'Waiting'),
(2, 4, '2026-04-29', '19:20:00', 2, 2, 'Waiting'),
(3, 5, '2026-04-29', '19:30:00', 4, 3, 'Seated'),
(4, 2, '2026-04-29', '20:00:00', 5, 4, 'Cancelled');

INSERT INTO DiningSession VALUES
(1, 5, 2, '2026-04-29', '19:30:00', NULL, 'Active'),
(2, 1, 5, '2026-04-29', '18:00:00', '19:15:00', 'Completed'),
(3, 2, 1, '2026-04-28', '20:00:00', '21:10:00', 'Completed'),
(4, 3, 4, '2026-04-28', '21:00:00', '22:30:00', 'Completed'),
(5, 4, 6, '2026-04-29', '20:15:00', NULL, 'Active');

INSERT INTO Bill VALUES
(1, 2, '2026-04-29', 2500.00, 250.00, 2750.00, 'Paid', 'UPI'),
(2, 3, '2026-04-28', 1800.00, 180.00, 1980.00, 'Paid', 'Card'),
(3, 4, '2026-04-28', 4200.00, 420.00, 4620.00, 'Paid', 'Cash'),
(4, 1, '2026-04-29', 3000.00, 300.00, 3300.00, 'Pending', 'UPI'),
(5, 5, '2026-04-29', 1200.00, 120.00, 1320.00, 'Pending', 'Cash');

-- 1. Available tables
SELECT 
    table_number,
    table_type,
    seating_capacity,
    table_status
FROM RestaurantTable
WHERE table_status = 'Available';

-- 2. Confirmed reservations today
SELECT 
    r.reservation_id,
    c.customer_name,
    rt.table_number,
    rt.table_type,
    r.reservation_time,
    r.number_of_guests,
    r.reservation_status
FROM Reservation r
JOIN Customer c
ON r.customer_id = c.customer_id
JOIN RestaurantTable rt
ON r.table_id = rt.table_id
WHERE r.reservation_date = '2026-04-29'
AND r.reservation_status = 'Confirmed';

-- 3. Customers currently waiting in queue
SELECT 
    wq.queue_position,
    c.customer_name,
    c.phone,
    wq.arrival_time,
    wq.party_size,
    wq.queue_status
FROM WaitingQueue wq
JOIN Customer c
ON wq.customer_id = c.customer_id
WHERE wq.queue_status = 'Waiting'
ORDER BY wq.queue_position;

-- 4. Currently occupied tables
SELECT 
    ds.session_id,
    c.customer_name,
    rt.table_number,
    rt.table_type,
    ds.start_time,
    ds.session_status
FROM DiningSession ds
JOIN Customer c
ON ds.customer_id = c.customer_id
JOIN RestaurantTable rt
ON ds.table_id = rt.table_id
WHERE ds.session_status = 'Active';

-- 5. Total revenue generated from paid bills
SELECT 
    SUM(total_amount) AS total_revenue
FROM Bill
WHERE payment_status = 'Paid';

-- 6. Most used table type
SELECT 
    rt.table_type,
    COUNT(ds.session_id) AS total_sessions
FROM DiningSession ds
JOIN RestaurantTable rt
ON ds.table_id = rt.table_id
GROUP BY rt.table_type
ORDER BY total_sessions DESC;

-- 7. Pending payments
SELECT 
    c.customer_name,
    rt.table_number,
    b.total_amount,
    b.payment_status,
    b.payment_method
FROM Bill b
JOIN DiningSession ds
ON b.session_id = ds.session_id
JOIN Customer c
ON ds.customer_id = c.customer_id
JOIN RestaurantTable rt
ON ds.table_id = rt.table_id
WHERE b.payment_status = 'Pending';

-- 8. Average dining duration for completed sessions
SELECT 
    c.customer_name,
    rt.table_number,
    ds.start_time,
    ds.end_time,
    TIMESTAMPDIFF(MINUTE, ds.start_time, ds.end_time) AS dining_duration_minutes
FROM DiningSession ds
JOIN Customer c
ON ds.customer_id = c.customer_id
JOIN RestaurantTable rt
ON ds.table_id = rt.table_id
WHERE ds.session_status = 'Completed';