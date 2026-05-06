-- Vehicle Service Center Management System
-- Single File SQL Solution

CREATE DATABASE VehicleServiceDB;
USE VehicleServiceDB;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(80),
    city VARCHAR(50)
);

CREATE TABLE Vehicle (
    vehicle_id INT PRIMARY KEY,
    customer_id INT,
    vehicle_number VARCHAR(20),
    vehicle_type VARCHAR(30),
    brand VARCHAR(50),
    model VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Mechanic (
    mechanic_id INT PRIMARY KEY,
    mechanic_name VARCHAR(50),
    specialization VARCHAR(50),
    phone VARCHAR(15)
);

CREATE TABLE ServiceBooking (
    booking_id INT PRIMARY KEY,
    vehicle_id INT,
    booking_date DATE,
    service_type VARCHAR(80),
    service_status VARCHAR(30),
    estimated_cost DECIMAL(10,2),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id)
);

CREATE TABLE ServiceJob (
    job_id INT PRIMARY KEY,
    booking_id INT,
    mechanic_id INT,
    job_description VARCHAR(255),
    start_time DATETIME,
    end_time DATETIME,
    job_status VARCHAR(30),
    labor_cost DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES ServiceBooking(booking_id),
    FOREIGN KEY (mechanic_id) REFERENCES Mechanic(mechanic_id)
);

CREATE TABLE SparePart (
    part_id INT PRIMARY KEY,
    part_name VARCHAR(80),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    stock_quantity INT
);

CREATE TABLE ServicePartUsed (
    usage_id INT PRIMARY KEY,
    job_id INT,
    part_id INT,
    quantity_used INT,
    total_part_cost DECIMAL(10,2),
    FOREIGN KEY (job_id) REFERENCES ServiceJob(job_id),
    FOREIGN KEY (part_id) REFERENCES SparePart(part_id)
);

CREATE TABLE Bill (
    bill_id INT PRIMARY KEY,
    booking_id INT,
    bill_date DATE,
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(30),
    payment_method VARCHAR(30),
    FOREIGN KEY (booking_id) REFERENCES ServiceBooking(booking_id)
);

INSERT INTO Customer VALUES
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

INSERT INTO Mechanic VALUES
(1, 'Ramesh Yadav', 'Engine Repair', '9000011111'),
(2, 'Suresh Patil', 'Bike Service', '9000022222'),
(3, 'Amit Singh', 'Electrical Work', '9000033333'),
(4, 'Vikas Rao', 'General Service', '9000044444');

INSERT INTO ServiceBooking VALUES
(1, 1, '2026-04-20', 'Oil Change', 'Completed', 2500.00),
(2, 2, '2026-04-21', 'Full Bike Service', 'Under Service', 1800.00),
(3, 3, '2026-04-22', 'Brake Service', 'Completed', 3500.00),
(4, 4, '2026-04-23', 'Engine Repair', 'Under Service', 12000.00),
(5, 5, '2026-04-24', 'Tyre Replacement', 'Completed', 4000.00);

INSERT INTO ServiceJob VALUES
(1, 1, 4, 'Engine oil replaced and basic inspection completed', '2026-04-20 10:00:00', '2026-04-20 12:00:00', 'Completed', 800.00),
(2, 2, 2, 'Complete bike service and cleaning', '2026-04-21 11:00:00', NULL, 'In Progress', 1000.00),
(3, 3, 1, 'Brake pads inspected and replaced', '2026-04-22 09:30:00', '2026-04-22 13:00:00', 'Completed', 1200.00),
(4, 4, 1, 'Engine noise diagnosis and repair started', '2026-04-23 10:30:00', NULL, 'In Progress', 5000.00),
(5, 5, 2, 'Rear tyre replaced and chain checked', '2026-04-24 14:00:00', '2026-04-24 16:00:00', 'Completed', 700.00);

INSERT INTO SparePart VALUES
(1, 'Engine Oil', 'Lubricant', 1200.00, 40),
(2, 'Brake Pad', 'Braking System', 1500.00, 25),
(3, 'Air Filter', 'Filter', 500.00, 50),
(4, 'Bike Tyre', 'Tyre', 2500.00, 15),
(5, 'Spark Plug', 'Engine Part', 300.00, 60);

INSERT INTO ServicePartUsed VALUES
(1, 1, 1, 1, 1200.00),
(2, 3, 2, 1, 1500.00),
(3, 2, 3, 1, 500.00),
(4, 5, 4, 1, 2500.00),
(5, 4, 5, 2, 600.00);

INSERT INTO Bill VALUES
(1, 1, '2026-04-20', 2500.00, 'Paid', 'UPI'),
(2, 2, '2026-04-21', 1800.00, 'Pending', 'Cash'),
(3, 3, '2026-04-22', 3500.00, 'Paid', 'Card'),
(4, 4, '2026-04-23', 12000.00, 'Pending', 'UPI'),
(5, 5, '2026-04-24', 4000.00, 'Paid', 'Cash');

-- 1. Vehicles currently under service
SELECT 
    c.customer_name,
    v.vehicle_number,
    v.vehicle_type,
    v.brand,
    v.model,
    sb.service_type,
    sb.service_status
FROM ServiceBooking sb
JOIN Vehicle v
ON sb.vehicle_id = v.vehicle_id
JOIN Customer c
ON v.customer_id = c.customer_id
WHERE sb.service_status = 'Under Service';

-- 2. Mechanic workload
SELECT 
    m.mechanic_name,
    m.specialization,
    COUNT(sj.job_id) AS total_jobs_handled
FROM ServiceJob sj
JOIN Mechanic m
ON sj.mechanic_id = m.mechanic_id
GROUP BY m.mechanic_name, m.specialization
ORDER BY total_jobs_handled DESC;

-- 3. Most used spare parts
SELECT 
    sp.part_name,
    sp.category,
    SUM(spu.quantity_used) AS total_quantity_used
FROM ServicePartUsed spu
JOIN SparePart sp
ON spu.part_id = sp.part_id
GROUP BY sp.part_name, sp.category
ORDER BY total_quantity_used DESC;

-- 4. Customers with pending payments
SELECT 
    c.customer_name,
    v.vehicle_number,
    sb.service_type,
    b.total_amount,
    b.payment_status
FROM Bill b
JOIN ServiceBooking sb
ON b.booking_id = sb.booking_id
JOIN Vehicle v
ON sb.vehicle_id = v.vehicle_id
JOIN Customer c
ON v.customer_id = c.customer_id
WHERE b.payment_status = 'Pending';

-- 5. Total revenue generated
SELECT 
    SUM(total_amount) AS total_revenue
FROM Bill
WHERE payment_status = 'Paid';

-- 6. Most common service type
SELECT 
    service_type,
    COUNT(booking_id) AS total_bookings
FROM ServiceBooking
GROUP BY service_type
ORDER BY total_bookings DESC;

-- 7. Low stock spare parts
SELECT 
    part_name,
    category,
    stock_quantity
FROM SparePart
WHERE stock_quantity < 20;

-- 8. Complete service summary
SELECT 
    c.customer_name,
    v.vehicle_number,
    v.brand,
    v.model,
    sb.service_type,
    m.mechanic_name,
    sj.job_status,
    b.total_amount,
    b.payment_status
FROM ServiceBooking sb
JOIN Vehicle v
ON sb.vehicle_id = v.vehicle_id
JOIN Customer c
ON v.customer_id = c.customer_id
JOIN ServiceJob sj
ON sb.booking_id = sj.booking_id
JOIN Mechanic m
ON sj.mechanic_id = m.mechanic_id
JOIN Bill b
ON sb.booking_id = b.booking_id;