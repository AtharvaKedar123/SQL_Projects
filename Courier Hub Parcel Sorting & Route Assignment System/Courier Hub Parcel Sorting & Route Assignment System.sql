CREATE DATABASE CourierHubDB;
USE CourierHubDB;

CREATE TABLE Sender (
    sender_id INT PRIMARY KEY,
    sender_name VARCHAR(50),
    phone VARCHAR(20),
    city VARCHAR(50)
);

CREATE TABLE Receiver (
    receiver_id INT PRIMARY KEY,
    receiver_name VARCHAR(50),
    phone VARCHAR(20),
    city VARCHAR(50),
    address VARCHAR(150)
);

CREATE TABLE CourierHub (
    hub_id INT PRIMARY KEY,
    hub_name VARCHAR(80),
    city VARCHAR(50),
    hub_status VARCHAR(30)
);

CREATE TABLE SortingBelt (
    belt_id INT PRIMARY KEY,
    hub_id INT,
    belt_code VARCHAR(30),
    belt_type VARCHAR(50),
    belt_status VARCHAR(30),
    FOREIGN KEY (hub_id) REFERENCES CourierHub(hub_id)
);

CREATE TABLE CourierAgent (
    agent_id INT PRIMARY KEY,
    agent_name VARCHAR(50),
    phone VARCHAR(20),
    assigned_city VARCHAR(50),
    agent_status VARCHAR(30)
);

CREATE TABLE DeliveryRoute (
    route_id INT PRIMARY KEY,
    route_name VARCHAR(80),
    start_hub_id INT,
    destination_city VARCHAR(50),
    route_status VARCHAR(30),
    FOREIGN KEY (start_hub_id) REFERENCES CourierHub(hub_id)
);

CREATE TABLE Parcel (
    parcel_id INT PRIMARY KEY,
    tracking_number VARCHAR(50),
    sender_id INT,
    receiver_id INT,
    parcel_weight_kg DECIMAL(10,2),
    parcel_type VARCHAR(50),
    priority_level VARCHAR(30),
    booking_date DATE,
    expected_delivery_date DATE,
    delivery_fee DECIMAL(10,2),
    parcel_status VARCHAR(30),
    FOREIGN KEY (sender_id) REFERENCES Sender(sender_id),
    FOREIGN KEY (receiver_id) REFERENCES Receiver(receiver_id)
);

CREATE TABLE ParcelSorting (
    sorting_id INT PRIMARY KEY,
    parcel_id INT,
    belt_id INT,
    sorting_date DATE,
    sorting_status VARCHAR(30),
    FOREIGN KEY (parcel_id) REFERENCES Parcel(parcel_id),
    FOREIGN KEY (belt_id) REFERENCES SortingBelt(belt_id)
);

CREATE TABLE RouteAssignment (
    assignment_id INT PRIMARY KEY,
    parcel_id INT,
    route_id INT,
    agent_id INT,
    assigned_date DATE,
    delivery_status VARCHAR(30),
    actual_delivery_date DATE,
    FOREIGN KEY (parcel_id) REFERENCES Parcel(parcel_id),
    FOREIGN KEY (route_id) REFERENCES DeliveryRoute(route_id),
    FOREIGN KEY (agent_id) REFERENCES CourierAgent(agent_id)
);

INSERT INTO Sender VALUES
(1, 'Atharva Kedar', '9876543210', 'Nagpur'),
(2, 'Neha Sharma', '9876543211', 'Mumbai'),
(3, 'Rohan Mehta', '9876543212', 'Pune'),
(4, 'Priya Patil', '9876543213', 'Nashik');

INSERT INTO Receiver VALUES
(1, 'Amit Verma', '9000011111', 'Mumbai', 'Andheri West, Mumbai'),
(2, 'Sneha Joshi', '9000022222', 'Pune', 'Kothrud, Pune'),
(3, 'Raj Malhotra', '9000033333', 'Nagpur', 'Dharampeth, Nagpur'),
(4, 'Meera Khan', '9000044444', 'Nashik', 'College Road, Nashik'),
(5, 'Karan Shah', '9000055555', 'Delhi', 'Karol Bagh, Delhi');

INSERT INTO CourierHub VALUES
(1, 'Nagpur Central Hub', 'Nagpur', 'Active'),
(2, 'Mumbai Express Hub', 'Mumbai', 'Active'),
(3, 'Pune Sorting Hub', 'Pune', 'Active'),
(4, 'Nashik Regional Hub', 'Nashik', 'Active');

INSERT INTO SortingBelt VALUES
(1, 1, 'Belt-NG-01', 'Small Parcel Belt', 'Active'),
(2, 1, 'Belt-NG-02', 'Heavy Parcel Belt', 'Active'),
(3, 2, 'Belt-MU-01', 'Express Parcel Belt', 'Active'),
(4, 3, 'Belt-PN-01', 'Standard Parcel Belt', 'Under Maintenance'),
(5, 4, 'Belt-NS-01', 'Fragile Parcel Belt', 'Active');

INSERT INTO CourierAgent VALUES
(1, 'Ravi Patil', '8000011111', 'Mumbai', 'Active'),
(2, 'Kunal Mehta', '8000022222', 'Pune', 'Active'),
(3, 'Farhan Khan', '8000033333', 'Nagpur', 'Active'),
(4, 'Pooja Sharma', '8000044444', 'Nashik', 'Active'),
(5, 'Deepak Yadav', '8000055555', 'Delhi', 'Inactive');

INSERT INTO DeliveryRoute VALUES
(1, 'Nagpur to Mumbai Express', 1, 'Mumbai', 'Active'),
(2, 'Mumbai to Pune Local', 2, 'Pune', 'Active'),
(3, 'Pune to Nagpur Return', 3, 'Nagpur', 'Active'),
(4, 'Nagpur to Nashik Standard', 1, 'Nashik', 'Active'),
(5, 'Nagpur to Delhi Long Route', 1, 'Delhi', 'Active');

INSERT INTO Parcel VALUES
(1, 'TRK1001', 1, 1, 2.50, 'Electronics', 'High', '2026-04-01', '2026-04-04', 250.00, 'Delivered'),
(2, 'TRK1002', 2, 2, 1.20, 'Documents', 'High', '2026-04-01', '2026-04-02', 120.00, 'Delivered'),
(3, 'TRK1003', 3, 3, 5.80, 'Clothing', 'Normal', '2026-04-02', '2026-04-06', 180.00, 'In Transit'),
(4, 'TRK1004', 4, 4, 3.00, 'Fragile Item', 'High', '2026-04-03', '2026-04-05', 300.00, 'Delayed'),
(5, 'TRK1005', 1, 5, 7.50, 'Machinery Part', 'Normal', '2026-04-04', '2026-04-09', 500.00, 'In Transit'),
(6, 'TRK1006', 2, 1, 0.80, 'Documents', 'Normal', '2026-04-05', '2026-04-07', 100.00, 'Pending'),
(7, 'TRK1007', 3, 2, 4.00, 'Books', 'Normal', '2026-04-06', '2026-04-10', 160.00, 'Delivered');

INSERT INTO ParcelSorting VALUES
(1, 1, 1, '2026-04-01', 'Sorted'),
(2, 2, 3, '2026-04-01', 'Sorted'),
(3, 3, 4, '2026-04-02', 'Pending'),
(4, 4, 5, '2026-04-03', 'Sorted'),
(5, 5, 2, '2026-04-04', 'Sorted'),
(6, 6, 1, '2026-04-05', 'Pending'),
(7, 7, 3, '2026-04-06', 'Sorted');

INSERT INTO RouteAssignment VALUES
(1, 1, 1, 1, '2026-04-01', 'Delivered', '2026-04-04'),
(2, 2, 2, 2, '2026-04-01', 'Delivered', '2026-04-02'),
(3, 3, 3, 3, '2026-04-02', 'In Transit', NULL),
(4, 4, 4, 4, '2026-04-03', 'Delayed', NULL),
(5, 5, 5, 5, '2026-04-04', 'In Transit', NULL),
(6, 6, 1, 1, '2026-04-05', 'Pending', NULL),
(7, 7, 2, 2, '2026-04-06', 'Delivered', '2026-04-09');

-- 1. Courier hubs handling most parcels
SELECT 
    ch.hub_name,
    ch.city,
    COUNT(ps.sorting_id) AS total_parcels_handled
FROM ParcelSorting ps
JOIN SortingBelt sb
ON ps.belt_id = sb.belt_id
JOIN CourierHub ch
ON sb.hub_id = ch.hub_id
GROUP BY ch.hub_name, ch.city
ORDER BY total_parcels_handled DESC;

-- 2. Sorting belts processing most parcels
SELECT 
    sb.belt_code,
    sb.belt_type,
    ch.hub_name,
    COUNT(ps.sorting_id) AS total_processed
FROM ParcelSorting ps
JOIN SortingBelt sb
ON ps.belt_id = sb.belt_id
JOIN CourierHub ch
ON sb.hub_id = ch.hub_id
GROUP BY sb.belt_code, sb.belt_type, ch.hub_name
ORDER BY total_processed DESC;

-- 3. Courier agents who delivered most parcels
SELECT 
    ca.agent_name,
    ca.assigned_city,
    COUNT(ra.assignment_id) AS total_delivered
FROM RouteAssignment ra
JOIN CourierAgent ca
ON ra.agent_id = ca.agent_id
WHERE ra.delivery_status = 'Delivered'
GROUP BY ca.agent_name, ca.assigned_city
ORDER BY total_delivered DESC;

-- 4. Delayed parcels
SELECT 
    p.tracking_number,
    s.sender_name,
    r.receiver_name,
    r.city AS destination_city,
    p.expected_delivery_date,
    p.parcel_status
FROM Parcel p
JOIN Sender s
ON p.sender_id = s.sender_id
JOIN Receiver r
ON p.receiver_id = r.receiver_id
WHERE p.parcel_status = 'Delayed';

-- 5. Routes with highest parcel load
SELECT 
    dr.route_name,
    dr.destination_city,
    COUNT(ra.parcel_id) AS total_parcels_assigned
FROM RouteAssignment ra
JOIN DeliveryRoute dr
ON ra.route_id = dr.route_id
GROUP BY dr.route_name, dr.destination_city
ORDER BY total_parcels_assigned DESC;

-- 6. Parcel status summary
SELECT 
    parcel_status,
    COUNT(parcel_id) AS total_parcels
FROM Parcel
GROUP BY parcel_status
ORDER BY total_parcels DESC;

-- 7. High priority parcels
SELECT 
    tracking_number,
    parcel_type,
    parcel_weight_kg,
    expected_delivery_date,
    parcel_status
FROM Parcel
WHERE priority_level = 'High';

-- 8. Total delivery fee collected
SELECT 
    SUM(delivery_fee) AS total_delivery_fee
FROM Parcel
WHERE parcel_status = 'Delivered';

-- 9. Pending sorting parcels
SELECT 
    p.tracking_number,
    sb.belt_code,
    ch.hub_name,
    ps.sorting_status
FROM ParcelSorting ps
JOIN Parcel p
ON ps.parcel_id = p.parcel_id
JOIN SortingBelt sb
ON ps.belt_id = sb.belt_id
JOIN CourierHub ch
ON sb.hub_id = ch.hub_id
WHERE ps.sorting_status = 'Pending';

-- 10. Parcel full tracking details
SELECT 
    p.tracking_number,
    s.sender_name,
    r.receiver_name,
    r.city AS destination_city,
    dr.route_name,
    ca.agent_name,
    ra.delivery_status,
    ra.actual_delivery_date
FROM Parcel p
JOIN Sender s
ON p.sender_id = s.sender_id
JOIN Receiver r
ON p.receiver_id = r.receiver_id
JOIN RouteAssignment ra
ON p.parcel_id = ra.parcel_id
JOIN DeliveryRoute dr
ON ra.route_id = dr.route_id
JOIN CourierAgent ca
ON ra.agent_id = ca.agent_id
ORDER BY p.tracking_number;