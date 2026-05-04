-- Smart Hotel Housekeeping & Room Service Management System
-- Single File SQL Solution

CREATE DATABASE HotelHousekeepingDB;
USE HotelHousekeepingDB;

CREATE TABLE Guest (
    guest_id INT PRIMARY KEY,
    guest_name VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(80),
    city VARCHAR(50)
);

CREATE TABLE HotelRoom (
    room_id INT PRIMARY KEY,
    room_number VARCHAR(20),
    floor_number INT,
    room_type VARCHAR(40),
    room_status VARCHAR(30),
    cleaning_status VARCHAR(30)
);

CREATE TABLE HousekeepingStaff (
    staff_id INT PRIMARY KEY,
    staff_name VARCHAR(50),
    phone VARCHAR(15),
    assigned_floor INT,
    shift_time VARCHAR(30)
);

CREATE TABLE GuestStay (
    stay_id INT PRIMARY KEY,
    guest_id INT,
    room_id INT,
    check_in_date DATE,
    check_out_date DATE,
    stay_status VARCHAR(30),
    FOREIGN KEY (guest_id) REFERENCES Guest(guest_id),
    FOREIGN KEY (room_id) REFERENCES HotelRoom(room_id)
);

CREATE TABLE ServiceRequest (
    request_id INT PRIMARY KEY,
    stay_id INT,
    staff_id INT,
    request_type VARCHAR(50),
    request_description VARCHAR(255),
    request_time DATETIME,
    priority_level VARCHAR(30),
    request_status VARCHAR(30),
    completed_time DATETIME,
    FOREIGN KEY (stay_id) REFERENCES GuestStay(stay_id),
    FOREIGN KEY (staff_id) REFERENCES HousekeepingStaff(staff_id)
);

CREATE TABLE RoomServiceOrder (
    order_id INT PRIMARY KEY,
    stay_id INT,
    order_item VARCHAR(80),
    quantity INT,
    order_amount DECIMAL(10,2),
    order_time DATETIME,
    order_status VARCHAR(30),
    FOREIGN KEY (stay_id) REFERENCES GuestStay(stay_id)
);

CREATE TABLE ServiceBill (
    bill_id INT PRIMARY KEY,
    stay_id INT,
    bill_date DATE,
    room_service_amount DECIMAL(10,2),
    extra_service_amount DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(30),
    FOREIGN KEY (stay_id) REFERENCES GuestStay(stay_id)
);

INSERT INTO Guest VALUES
(1, 'Rahul Sharma', '9999999999', 'rahul@email.com', 'Nagpur'),
(2, 'Sneha Patil', '8888888888', 'sneha@email.com', 'Pune'),
(3, 'Aman Verma', '7777777777', 'aman@email.com', 'Mumbai'),
(4, 'Priya Mehta', '6666666666', 'priya@email.com', 'Delhi'),
(5, 'Atharva Kedar', '5555555555', 'atharva@email.com', 'Nagpur');

INSERT INTO HotelRoom VALUES
(1, '101', 1, 'Deluxe', 'Occupied', 'Needs Cleaning'),
(2, '102', 1, 'Standard', 'Available', 'Clean'),
(3, '201', 2, 'Suite', 'Occupied', 'Clean'),
(4, '202', 2, 'Deluxe', 'Occupied', 'Needs Cleaning'),
(5, '301', 3, 'Premium Suite', 'Maintenance', 'Dirty');

INSERT INTO HousekeepingStaff VALUES
(1, 'Ramesh Yadav', '9000011111', 1, 'Morning'),
(2, 'Suresh Patil', '9000022222', 2, 'Morning'),
(3, 'Anjali Rao', '9000033333', 3, 'Evening'),
(4, 'Vikas Singh', '9000044444', 1, 'Evening');

INSERT INTO GuestStay VALUES
(1, 1, 1, '2026-04-27', '2026-05-01', 'Active'),
(2, 2, 3, '2026-04-28', '2026-05-02', 'Active'),
(3, 3, 4, '2026-04-29', '2026-05-03', 'Active'),
(4, 4, 2, '2026-04-20', '2026-04-25', 'Completed'),
(5, 5, 5, '2026-04-29', '2026-05-04', 'Active');

INSERT INTO ServiceRequest VALUES
(1, 1, 1, 'Room Cleaning', 'Guest requested full room cleaning', '2026-04-29 09:00:00', 'High', 'Pending', NULL),
(2, 2, 2, 'Extra Towels', 'Guest requested two extra towels', '2026-04-29 09:30:00', 'Medium', 'Completed', '2026-04-29 09:50:00'),
(3, 3, 2, 'Bathroom Cleaning', 'Bathroom cleaning requested', '2026-04-29 10:00:00', 'High', 'Pending', NULL),
(4, 1, 4, 'Laundry Pickup', 'Laundry pickup from room', '2026-04-29 11:00:00', 'Low', 'Completed', '2026-04-29 11:30:00'),
(5, 5, 3, 'AC Repair', 'AC not cooling properly', '2026-04-29 12:00:00', 'High', 'Pending', NULL);

INSERT INTO RoomServiceOrder VALUES
(1, 1, 'Veg Sandwich', 2, 300.00, '2026-04-29 08:30:00', 'Delivered'),
(2, 2, 'Masala Tea', 3, 180.00, '2026-04-29 09:00:00', 'Delivered'),
(3, 3, 'Paneer Meal', 1, 450.00, '2026-04-29 13:00:00', 'Preparing'),
(4, 1, 'Coffee', 2, 200.00, '2026-04-29 16:00:00', 'Delivered'),
(5, 5, 'Breakfast Combo', 1, 350.00, '2026-04-29 09:15:00', 'Pending');

INSERT INTO ServiceBill VALUES
(1, 1, '2026-04-29', 500.00, 250.00, 750.00, 'Pending'),
(2, 2, '2026-04-29', 180.00, 0.00, 180.00, 'Paid'),
(3, 3, '2026-04-29', 450.00, 0.00, 450.00, 'Pending'),
(4, 4, '2026-04-25', 0.00, 0.00, 0.00, 'Paid'),
(5, 5, '2026-04-29', 350.00, 500.00, 850.00, 'Pending');

-- 1. Rooms that need cleaning
SELECT 
    room_number,
    floor_number,
    room_type,
    room_status,
    cleaning_status
FROM HotelRoom
WHERE cleaning_status IN ('Needs Cleaning', 'Dirty');

-- 2. Pending guest service requests
SELECT 
    sr.request_id,
    g.guest_name,
    hr.room_number,
    sr.request_type,
    sr.priority_level,
    sr.request_time,
    sr.request_status
FROM ServiceRequest sr
JOIN GuestStay gs
ON sr.stay_id = gs.stay_id
JOIN Guest g
ON gs.guest_id = g.guest_id
JOIN HotelRoom hr
ON gs.room_id = hr.room_id
WHERE sr.request_status = 'Pending'
ORDER BY sr.priority_level DESC, sr.request_time;

-- 3. Staff task performance
SELECT 
    hs.staff_name,
    hs.assigned_floor,
    COUNT(sr.request_id) AS total_tasks_handled
FROM ServiceRequest sr
JOIN HousekeepingStaff hs
ON sr.staff_id = hs.staff_id
GROUP BY hs.staff_name, hs.assigned_floor
ORDER BY total_tasks_handled DESC;

-- 4. Currently occupied rooms
SELECT 
    g.guest_name,
    hr.room_number,
    hr.room_type,
    gs.check_in_date,
    gs.check_out_date,
    gs.stay_status
FROM GuestStay gs
JOIN Guest g
ON gs.guest_id = g.guest_id
JOIN HotelRoom hr
ON gs.room_id = hr.room_id
WHERE gs.stay_status = 'Active'
AND hr.room_status = 'Occupied';

-- 5. Room service revenue from delivered orders
SELECT 
    SUM(order_amount) AS room_service_revenue
FROM RoomServiceOrder
WHERE order_status = 'Delivered';

-- 6. Most requested service type
SELECT 
    request_type,
    COUNT(request_id) AS total_requests
FROM ServiceRequest
GROUP BY request_type
ORDER BY total_requests DESC;

-- 7. Guests with pending bills
SELECT 
    g.guest_name,
    hr.room_number,
    sb.total_amount,
    sb.payment_status
FROM ServiceBill sb
JOIN GuestStay gs
ON sb.stay_id = gs.stay_id
JOIN Guest g
ON gs.guest_id = g.guest_id
JOIN HotelRoom hr
ON gs.room_id = hr.room_id
WHERE sb.payment_status = 'Pending';

-- 8. Complete guest service report
SELECT 
    g.guest_name,
    hr.room_number,
    sr.request_type,
    sr.priority_level,
    sr.request_status,
    hs.staff_name,
    rso.order_item,
    rso.order_status,
    sb.total_amount,
    sb.payment_status
FROM GuestStay gs
JOIN Guest g
ON gs.guest_id = g.guest_id
JOIN HotelRoom hr
ON gs.room_id = hr.room_id
LEFT JOIN ServiceRequest sr
ON gs.stay_id = sr.stay_id
LEFT JOIN HousekeepingStaff hs
ON sr.staff_id = hs.staff_id
LEFT JOIN RoomServiceOrder rso
ON gs.stay_id = rso.stay_id
LEFT JOIN ServiceBill sb
ON gs.stay_id = sb.stay_id;