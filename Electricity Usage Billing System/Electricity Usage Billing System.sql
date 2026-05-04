-- Smart Electricity Usage Billing System
-- Single File SQL Solution

CREATE DATABASE ElectricityBillingDB;
USE ElectricityBillingDB;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    address VARCHAR(100),
    city VARCHAR(50),
    phone VARCHAR(15)
);

CREATE TABLE Meter (
    meter_id INT PRIMARY KEY,
    customer_id INT,
    meter_number VARCHAR(30),
    meter_type VARCHAR(30),
    installation_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE TariffPlan (
    tariff_id INT PRIMARY KEY,
    plan_name VARCHAR(50),
    customer_type VARCHAR(30),
    rate_per_unit DECIMAL(10,2)
);

CREATE TABLE MeterReading (
    reading_id INT PRIMARY KEY,
    meter_id INT,
    reading_month VARCHAR(20),
    previous_reading INT,
    current_reading INT,
    reading_date DATE,
    FOREIGN KEY (meter_id) REFERENCES Meter(meter_id)
);

CREATE TABLE ElectricityBill (
    bill_id INT PRIMARY KEY,
    reading_id INT,
    tariff_id INT,
    bill_amount DECIMAL(10,2),
    bill_date DATE,
    due_date DATE,
    payment_status VARCHAR(30),
    FOREIGN KEY (reading_id) REFERENCES MeterReading(reading_id),
    FOREIGN KEY (tariff_id) REFERENCES TariffPlan(tariff_id)
);

INSERT INTO Customer VALUES
(1, 'Atharva Kedar', 'Civil Lines', 'Nagpur', '9999999999'),
(2, 'Ramesh Patil', 'Dharampeth', 'Nagpur', '8888888888'),
(3, 'Sneha Sharma', 'Kothrud', 'Pune', '7777777777'),
(4, 'Amit Verma', 'Andheri', 'Mumbai', '6666666666'),
(5, 'Priya Mehta', 'Sitabuldi', 'Nagpur', '5555555555');

INSERT INTO Meter VALUES
(1, 1, 'MTR1001', 'Smart Meter', '2025-01-10'),
(2, 2, 'MTR1002', 'Smart Meter', '2025-03-15'),
(3, 3, 'MTR1003', 'Digital Meter', '2025-05-20'),
(4, 4, 'MTR1004', 'Smart Meter', '2025-07-12'),
(5, 5, 'MTR1005', 'Digital Meter', '2025-09-05');

INSERT INTO TariffPlan VALUES
(1, 'Residential Basic', 'Residential', 7.50),
(2, 'Commercial Standard', 'Commercial', 12.00),
(3, 'Industrial Power', 'Industrial', 15.00);

INSERT INTO MeterReading VALUES
(1, 1, 'April 2026', 1200, 1450, '2026-04-25'),
(2, 2, 'April 2026', 3000, 3550, '2026-04-25'),
(3, 3, 'April 2026', 850, 1000, '2026-04-25'),
(4, 4, 'April 2026', 5000, 5750, '2026-04-25'),
(5, 5, 'April 2026', 1600, 1900, '2026-04-25');

INSERT INTO ElectricityBill VALUES
(1, 1, 1, 1875.00, '2026-04-26', '2026-05-10', 'Paid'),
(2, 2, 2, 6600.00, '2026-04-26', '2026-05-10', 'Pending'),
(3, 3, 1, 1125.00, '2026-04-26', '2026-05-10', 'Paid'),
(4, 4, 2, 9000.00, '2026-04-26', '2026-05-10', 'Pending'),
(5, 5, 1, 2250.00, '2026-04-26', '2026-05-10', 'Paid');

-- 1. Units consumed by each customer
SELECT 
    c.customer_name,
    m.meter_number,
    mr.reading_month,
    mr.previous_reading,
    mr.current_reading,
    (mr.current_reading - mr.previous_reading) AS units_consumed
FROM MeterReading mr
JOIN Meter m
ON mr.meter_id = m.meter_id
JOIN Customer c
ON m.customer_id = c.customer_id;

-- 2. Customers with pending bills
SELECT 
    c.customer_name,
    c.city,
    eb.bill_amount,
    eb.due_date,
    eb.payment_status
FROM ElectricityBill eb
JOIN MeterReading mr
ON eb.reading_id = mr.reading_id
JOIN Meter m
ON mr.meter_id = m.meter_id
JOIN Customer c
ON m.customer_id = c.customer_id
WHERE eb.payment_status = 'Pending';

-- 3. Highest electricity consumers
SELECT 
    c.customer_name,
    c.city,
    (mr.current_reading - mr.previous_reading) AS units_consumed
FROM MeterReading mr
JOIN Meter m
ON mr.meter_id = m.meter_id
JOIN Customer c
ON m.customer_id = c.customer_id
ORDER BY units_consumed DESC;

-- 4. Total collected revenue
SELECT 
    SUM(bill_amount) AS total_collected_revenue
FROM ElectricityBill
WHERE payment_status = 'Paid';

-- 5. Revenue by tariff plan
SELECT 
    tp.plan_name,
    tp.customer_type,
    SUM(eb.bill_amount) AS total_revenue
FROM ElectricityBill eb
JOIN TariffPlan tp
ON eb.tariff_id = tp.tariff_id
WHERE eb.payment_status = 'Paid'
GROUP BY tp.plan_name, tp.customer_type
ORDER BY total_revenue DESC;

-- 6. Overdue bills
SELECT 
    c.customer_name,
    eb.bill_amount,
    eb.due_date,
    eb.payment_status
FROM ElectricityBill eb
JOIN MeterReading mr
ON eb.reading_id = mr.reading_id
JOIN Meter m
ON mr.meter_id = m.meter_id
JOIN Customer c
ON m.customer_id = c.customer_id
WHERE eb.payment_status = 'Pending'
AND eb.due_date < '2026-05-15';

-- 7. Average units consumed by city
SELECT 
    c.city,
    AVG(mr.current_reading - mr.previous_reading) AS average_units_consumed
FROM MeterReading mr
JOIN Meter m
ON mr.meter_id = m.meter_id
JOIN Customer c
ON m.customer_id = c.customer_id
GROUP BY c.city;

-- 8. Complete billing summary
SELECT 
    c.customer_name,
    c.city,
    m.meter_number,
    tp.plan_name,
    mr.reading_month,
    (mr.current_reading - mr.previous_reading) AS units_consumed,
    eb.bill_amount,
    eb.payment_status
FROM ElectricityBill eb
JOIN MeterReading mr
ON eb.reading_id = mr.reading_id
JOIN Meter m
ON mr.meter_id = m.meter_id
JOIN Customer c
ON m.customer_id = c.customer_id
JOIN TariffPlan tp
ON eb.tariff_id = tp.tariff_id;