

CREATE DATABASE DisasterReliefDB;
USE DisasterReliefDB;

CREATE TABLE DisasterEvent (
    event_id INT PRIMARY KEY,
    event_name VARCHAR(80),
    disaster_type VARCHAR(50),
    affected_city VARCHAR(50),
    event_date DATE,
    severity_level VARCHAR(30)
);

CREATE TABLE ReliefCamp (
    camp_id INT PRIMARY KEY,
    event_id INT,
    camp_name VARCHAR(80),
    location VARCHAR(100),
    capacity INT,
    current_occupancy INT,
    camp_status VARCHAR(30),
    FOREIGN KEY (event_id) REFERENCES DisasterEvent(event_id)
);

CREATE TABLE Victim (
    victim_id INT PRIMARY KEY,
    camp_id INT,
    victim_name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    medical_condition VARCHAR(100),
    registration_date DATE,
    FOREIGN KEY (camp_id) REFERENCES ReliefCamp(camp_id)
);

CREATE TABLE Volunteer (
    volunteer_id INT PRIMARY KEY,
    volunteer_name VARCHAR(50),
    phone VARCHAR(15),
    skill_area VARCHAR(50),
    assigned_camp_id INT,
    FOREIGN KEY (assigned_camp_id) REFERENCES ReliefCamp(camp_id)
);

CREATE TABLE SupplyItem (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(50),
    item_category VARCHAR(50),
    unit VARCHAR(20)
);

CREATE TABLE ResourceStock (
    stock_id INT PRIMARY KEY,
    camp_id INT,
    item_id INT,
    quantity_available INT,
    minimum_required INT,
    last_updated DATE,
    FOREIGN KEY (camp_id) REFERENCES ReliefCamp(camp_id),
    FOREIGN KEY (item_id) REFERENCES SupplyItem(item_id)
);

CREATE TABLE DistributionRecord (
    distribution_id INT PRIMARY KEY,
    camp_id INT,
    item_id INT,
    quantity_distributed INT,
    distribution_date DATE,
    distributed_by VARCHAR(50),
    FOREIGN KEY (camp_id) REFERENCES ReliefCamp(camp_id),
    FOREIGN KEY (item_id) REFERENCES SupplyItem(item_id)
);

INSERT INTO DisasterEvent VALUES
(1, 'Nagpur Flood Relief 2026', 'Flood', 'Nagpur', '2026-04-10', 'High'),
(2, 'Pune Fire Support 2026', 'Fire', 'Pune', '2026-04-15', 'Medium'),
(3, 'Mumbai Storm Relief 2026', 'Storm', 'Mumbai', '2026-04-18', 'Critical');

INSERT INTO ReliefCamp VALUES
(1, 1, 'Central School Relief Camp', 'Civil Lines, Nagpur', 500, 420, 'Active'),
(2, 1, 'Sports Complex Camp', 'Dharampeth, Nagpur', 300, 280, 'Active'),
(3, 2, 'Community Hall Camp', 'Kothrud, Pune', 200, 150, 'Active'),
(4, 3, 'Metro Shelter Camp', 'Andheri, Mumbai', 600, 570, 'Active');

INSERT INTO Victim VALUES
(1, 1, 'Rahul Sharma', 35, 'Male', 'None', '2026-04-11'),
(2, 1, 'Sneha Patil', 28, 'Female', 'Fever', '2026-04-11'),
(3, 2, 'Aman Verma', 42, 'Male', 'Diabetes', '2026-04-12'),
(4, 3, 'Priya Mehta', 31, 'Female', 'Minor burns', '2026-04-16'),
(5, 4, 'Karan Singh', 50, 'Male', 'Blood pressure', '2026-04-19'),
(6, 4, 'Neha Sharma', 22, 'Female', 'None', '2026-04-19');

INSERT INTO Volunteer VALUES
(1, 'Rohan Mehta', '9999999999', 'Medical Support', 1),
(2, 'Pooja Sharma', '8888888888', 'Food Distribution', 1),
(3, 'Amit Verma', '7777777777', 'Logistics', 2),
(4, 'Nisha Rao', '6666666666', 'Medical Support', 3),
(5, 'Vikas Patil', '5555555555', 'Rescue Support', 4);

INSERT INTO SupplyItem VALUES
(1, 'Food Packet', 'Food', 'Packets'),
(2, 'Water Bottle', 'Water', 'Bottles'),
(3, 'Blanket', 'Shelter', 'Pieces'),
(4, 'Medicine Kit', 'Medical', 'Kits'),
(5, 'Sanitary Kit', 'Hygiene', 'Kits');

INSERT INTO ResourceStock VALUES
(1, 1, 1, 120, 300, '2026-04-29'),
(2, 1, 2, 500, 400, '2026-04-29'),
(3, 1, 4, 50, 100, '2026-04-29'),
(4, 2, 1, 80, 200, '2026-04-29'),
(5, 2, 3, 250, 150, '2026-04-29'),
(6, 3, 4, 30, 80, '2026-04-29'),
(7, 4, 1, 200, 500, '2026-04-29'),
(8, 4, 5, 60, 120, '2026-04-29');

INSERT INTO DistributionRecord VALUES
(1, 1, 1, 200, '2026-04-20', 'Pooja Sharma'),
(2, 1, 2, 300, '2026-04-20', 'Rohan Mehta'),
(3, 2, 3, 100, '2026-04-21', 'Amit Verma'),
(4, 3, 4, 40, '2026-04-22', 'Nisha Rao'),
(5, 4, 1, 350, '2026-04-23', 'Vikas Patil');

-- 1. Camps needing urgent supplies
SELECT 
    rc.camp_name,
    rc.location,
    si.item_name,
    rs.quantity_available,
    rs.minimum_required,
    (rs.minimum_required - rs.quantity_available) AS shortage_quantity
FROM ResourceStock rs
JOIN ReliefCamp rc
ON rs.camp_id = rc.camp_id
JOIN SupplyItem si
ON rs.item_id = si.item_id
WHERE rs.quantity_available < rs.minimum_required
ORDER BY shortage_quantity DESC;

-- 2. Victim count by camp
SELECT 
    rc.camp_name,
    rc.location,
    COUNT(v.victim_id) AS total_registered_victims,
    rc.current_occupancy
FROM ReliefCamp rc
LEFT JOIN Victim v
ON rc.camp_id = v.camp_id
GROUP BY rc.camp_name, rc.location, rc.current_occupancy
ORDER BY rc.current_occupancy DESC;

-- 3. Low stock supplies
SELECT 
    rc.camp_name,
    si.item_name,
    si.item_category,
    rs.quantity_available,
    rs.minimum_required
FROM ResourceStock rs
JOIN ReliefCamp rc
ON rs.camp_id = rc.camp_id
JOIN SupplyItem si
ON rs.item_id = si.item_id
WHERE rs.quantity_available < rs.minimum_required;

-- 4. Volunteers assigned to each camp
SELECT 
    rc.camp_name,
    v.volunteer_name,
    v.phone,
    v.skill_area
FROM Volunteer v
JOIN ReliefCamp rc
ON v.assigned_camp_id = rc.camp_id
ORDER BY rc.camp_name;

-- 5. Total items distributed by item
SELECT 
    si.item_name,
    si.item_category,
    SUM(dr.quantity_distributed) AS total_distributed
FROM DistributionRecord dr
JOIN SupplyItem si
ON dr.item_id = si.item_id
GROUP BY si.item_name, si.item_category
ORDER BY total_distributed DESC;

-- 6. Disaster event resource usage
SELECT 
    de.event_name,
    de.disaster_type,
    de.severity_level,
    SUM(dr.quantity_distributed) AS total_resources_distributed
FROM DistributionRecord dr
JOIN ReliefCamp rc
ON dr.camp_id = rc.camp_id
JOIN DisasterEvent de
ON rc.event_id = de.event_id
GROUP BY de.event_name, de.disaster_type, de.severity_level
ORDER BY total_resources_distributed DESC;

-- 7. Camps near full capacity
SELECT 
    camp_name,
    location,
    capacity,
    current_occupancy,
    ROUND((current_occupancy * 100.0 / capacity), 2) AS occupancy_percentage
FROM ReliefCamp
WHERE current_occupancy >= capacity * 0.80
ORDER BY occupancy_percentage DESC;

-- 8. Victims with medical conditions
SELECT 
    v.victim_name,
    v.age,
    v.gender,
    v.medical_condition,
    rc.camp_name
FROM Victim v
JOIN ReliefCamp rc
ON v.camp_id = rc.camp_id
WHERE v.medical_condition <> 'None';
