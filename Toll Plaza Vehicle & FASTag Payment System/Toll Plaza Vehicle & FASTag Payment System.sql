CREATE DATABASE SmartTollPlazaDB;
USE SmartTollPlazaDB;

CREATE TABLE VehicleCategory (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50),
    toll_amount DECIMAL(10,2)
);

CREATE TABLE Vehicle (
    vehicle_id INT PRIMARY KEY,
    vehicle_number VARCHAR(30),
    owner_name VARCHAR(50),
    category_id INT,
    city VARCHAR(50),
    FOREIGN KEY (category_id) REFERENCES VehicleCategory(category_id)
);

CREATE TABLE FASTagAccount (
    fastag_id INT PRIMARY KEY,
    vehicle_id INT,
    tag_number VARCHAR(50),
    balance DECIMAL(10,2),
    account_status VARCHAR(30),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id)
);

CREATE TABLE TollBooth (
    booth_id INT PRIMARY KEY,
    booth_name VARCHAR(50),
    booth_location VARCHAR(80),
    booth_status VARCHAR(30)
);

CREATE TABLE TollLane (
    lane_id INT PRIMARY KEY,
    booth_id INT,
    lane_number VARCHAR(20),
    lane_type VARCHAR(30),
    lane_status VARCHAR(30),
    FOREIGN KEY (booth_id) REFERENCES TollBooth(booth_id)
);

CREATE TABLE TollTransaction (
    transaction_id INT PRIMARY KEY,
    vehicle_id INT,
    fastag_id INT,
    lane_id INT,
    transaction_date DATE,
    transaction_time VARCHAR(20),
    toll_amount DECIMAL(10,2),
    payment_status VARCHAR(30),
    failure_reason VARCHAR(100),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id),
    FOREIGN KEY (fastag_id) REFERENCES FASTagAccount(fastag_id),
    FOREIGN KEY (lane_id) REFERENCES TollLane(lane_id)
);

INSERT INTO VehicleCategory VALUES
(1, 'Car', 120.00),
(2, 'Bus', 250.00),
(3, 'Truck', 300.00),
(4, 'Two Wheeler', 60.00),
(5, 'Heavy Container', 450.00);

INSERT INTO Vehicle VALUES
(1, 'MH31AB1234', 'Atharva Kedar', 1, 'Nagpur'),
(2, 'MH12CD5678', 'Neha Sharma', 1, 'Pune'),
(3, 'MH01EF9090', 'Rohan Mehta', 2, 'Mumbai'),
(4, 'MH40GH4444', 'Priya Patil', 3, 'Nagpur'),
(5, 'MH15JK7777', 'Amit Verma', 5, 'Nashik'),
(6, 'MH31LM2222', 'Sneha Joshi', 4, 'Nagpur');

INSERT INTO FASTagAccount VALUES
(1, 1, 'TAG-MH31AB1234', 850.00, 'Active'),
(2, 2, 'TAG-MH12CD5678', 90.00, 'Active'),
(3, 3, 'TAG-MH01EF9090', 600.00, 'Active'),
(4, 4, 'TAG-MH40GH4444', 150.00, 'Active'),
(5, 5, 'TAG-MH15JK7777', 200.00, 'Active'),
(6, 6, 'TAG-MH31LM2222', 40.00, 'Active');

INSERT INTO TollBooth VALUES
(1, 'Nagpur East Toll Booth', 'Nagpur-Amravati Highway', 'Active'),
(2, 'Pune Express Toll Booth', 'Mumbai-Pune Expressway', 'Active'),
(3, 'Nashik Cargo Toll Booth', 'Nashik Industrial Road', 'Active');

INSERT INTO TollLane VALUES
(1, 1, 'Lane-1', 'FASTag', 'Active'),
(2, 1, 'Lane-2', 'FASTag', 'Active'),
(3, 2, 'Lane-1', 'FASTag', 'Active'),
(4, 2, 'Lane-2', 'Cash Backup', 'Active'),
(5, 3, 'Lane-1', 'FASTag', 'Active');

INSERT INTO TollTransaction VALUES
(1, 1, 1, 1, '2026-04-01', '09:15', 120.00, 'Paid', NULL),
(2, 2, 2, 1, '2026-04-01', '10:20', 120.00, 'Failed', 'Insufficient FASTag Balance'),
(3, 3, 3, 3, '2026-04-02', '11:10', 250.00, 'Paid', NULL),
(4, 4, 4, 2, '2026-04-02', '12:45', 300.00, 'Failed', 'Insufficient FASTag Balance'),
(5, 5, 5, 5, '2026-04-03', '14:30', 450.00, 'Unpaid', 'FASTag Not Charged'),
(6, 1, 1, 2, '2026-04-03', '16:00', 120.00, 'Paid', NULL),
(7, 6, 6, 1, '2026-04-04', '18:40', 60.00, 'Failed', 'Insufficient FASTag Balance'),
(8, 3, 3, 4, '2026-04-05', '08:50', 250.00, 'Paid', NULL),
(9, 1, 1, 1, '2026-04-06', '19:25', 120.00, 'Paid', NULL);

-- 1. Most used vehicle category
SELECT 
    vc.category_name,
    COUNT(tt.transaction_id) AS total_vehicle_passes
FROM TollTransaction tt
JOIN Vehicle v
ON tt.vehicle_id = v.vehicle_id
JOIN VehicleCategory vc
ON v.category_id = vc.category_id
GROUP BY vc.category_name
ORDER BY total_vehicle_passes DESC;

-- 2. Toll booth revenue collection
SELECT 
    tb.booth_name,
    SUM(tt.toll_amount) AS total_revenue
FROM TollTransaction tt
JOIN TollLane tl
ON tt.lane_id = tl.lane_id
JOIN TollBooth tb
ON tl.booth_id = tb.booth_id
WHERE tt.payment_status = 'Paid'
GROUP BY tb.booth_name
ORDER BY total_revenue DESC;

-- 3. Vehicles with unpaid tolls
SELECT 
    v.vehicle_number,
    v.owner_name,
    tt.toll_amount,
    tt.payment_status,
    tt.failure_reason
FROM TollTransaction tt
JOIN Vehicle v
ON tt.vehicle_id = v.vehicle_id
WHERE tt.payment_status = 'Unpaid';

-- 4. FASTag accounts with low balance
SELECT 
    v.vehicle_number,
    v.owner_name,
    fa.tag_number,
    fa.balance
FROM FASTagAccount fa
JOIN Vehicle v
ON fa.vehicle_id = v.vehicle_id
WHERE fa.balance < 100;

-- 5. Total collected toll revenue
SELECT 
    SUM(toll_amount) AS total_collected_revenue
FROM TollTransaction
WHERE payment_status = 'Paid';

-- 6. Most used toll lane
SELECT 
    tl.lane_number,
    tb.booth_name,
    COUNT(tt.transaction_id) AS total_usage
FROM TollTransaction tt
JOIN TollLane tl
ON tt.lane_id = tl.lane_id
JOIN TollBooth tb
ON tl.booth_id = tb.booth_id
GROUP BY tl.lane_number, tb.booth_name
ORDER BY total_usage DESC;

-- 7. Vehicles passing most frequently
SELECT 
    v.vehicle_number,
    v.owner_name,
    COUNT(tt.transaction_id) AS total_passes
FROM TollTransaction tt
JOIN Vehicle v
ON tt.vehicle_id = v.vehicle_id
GROUP BY v.vehicle_number, v.owner_name
ORDER BY total_passes DESC;

-- 8. Failed transactions due to insufficient balance
SELECT 
    v.vehicle_number,
    v.owner_name,
    fa.balance,
    tt.toll_amount,
    tt.transaction_date,
    tt.failure_reason
FROM TollTransaction tt
JOIN Vehicle v
ON tt.vehicle_id = v.vehicle_id
JOIN FASTagAccount fa
ON tt.fastag_id = fa.fastag_id
WHERE tt.failure_reason = 'Insufficient FASTag Balance';

-- 9. Toll revenue by vehicle category
SELECT 
    vc.category_name,
    SUM(tt.toll_amount) AS total_revenue
FROM TollTransaction tt
JOIN Vehicle v
ON tt.vehicle_id = v.vehicle_id
JOIN VehicleCategory vc
ON v.category_id = vc.category_id
WHERE tt.payment_status = 'Paid'
GROUP BY vc.category_name
ORDER BY total_revenue DESC;

-- 10. Daily toll transaction summary
SELECT 
    transaction_date,
    COUNT(transaction_id) AS total_transactions,
    SUM(CASE WHEN payment_status = 'Paid' THEN toll_amount ELSE 0 END) AS paid_revenue,
    SUM(CASE WHEN payment_status <> 'Paid' THEN toll_amount ELSE 0 END) AS unpaid_or_failed_amount
FROM TollTransaction
GROUP BY transaction_date
ORDER BY transaction_date;