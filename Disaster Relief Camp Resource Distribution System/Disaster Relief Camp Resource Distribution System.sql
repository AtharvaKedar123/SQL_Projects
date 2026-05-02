-- Disaster Relief Camp Resource Distribution System
-- Single File SQL Solution

CREATE DATABASE DisasterReliefDB;
USE DisasterReliefDB;

CREATE TABLE ReliefCamp (
    camp_id INT PRIMARY KEY,
    camp_name VARCHAR(100),
    city VARCHAR(50),
    location VARCHAR(120),
    capacity INT,
    current_victims INT
);

CREATE TABLE Victim (
    victim_id INT PRIMARY KEY,
    camp_id INT,
    victim_name VARCHAR(80),
    age INT,
    gender VARCHAR(20),
    phone VARCHAR(15),
    priority_level VARCHAR(30),
    FOREIGN KEY (camp_id) REFERENCES ReliefCamp(camp_id)
);

CREATE TABLE Volunteer (
    volunteer_id INT PRIMARY KEY,
    volunteer_name VARCHAR(80),
    phone VARCHAR(15),
    assigned_camp_id INT,
    role_type VARCHAR(50),
    FOREIGN KEY (assigned_camp_id) REFERENCES ReliefCamp(camp_id)
);

CREATE TABLE ResourceCategory (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(60),
    description VARCHAR(150)
);

CREATE TABLE DonationStock (
    donation_id INT PRIMARY KEY,
    category_id INT,
    item_name VARCHAR(80),
    donated_by VARCHAR(80),
    quantity_received INT,
    quantity_available INT,
    donation_date DATE,
    expiry_date DATE,
    stock_status VARCHAR(30),
    FOREIGN KEY (category_id) REFERENCES ResourceCategory(category_id)
);

CREATE TABLE CampInventory (
    inventory_id INT PRIMARY KEY,
    camp_id INT,
    donation_id INT,
    quantity_assigned INT,
    quantity_remaining INT,
    minimum_required INT,
    inventory_status VARCHAR(30),
    FOREIGN KEY (camp_id) REFERENCES ReliefCamp(camp_id),
    FOREIGN KEY (donation_id) REFERENCES DonationStock(donation_id)
);

CREATE TABLE DistributionRecord (
    distribution_id INT PRIMARY KEY,
    victim_id INT,
    volunteer_id INT,
    inventory_id INT,
    distribution_date DATE,
    quantity_distributed INT,
    distribution_status VARCHAR(30),
    FOREIGN KEY (victim_id) REFERENCES Victim(victim_id),
    FOREIGN KEY (volunteer_id) REFERENCES Volunteer(volunteer_id),
    FOREIGN KEY (inventory_id) REFERENCES CampInventory(inventory_id)
);

CREATE TABLE MedicalSupply (
    medical_id INT PRIMARY KEY,
    donation_id INT,
    medicine_type VARCHAR(60),
    storage_condition VARCHAR(80),
    dosage_info VARCHAR(100),
    FOREIGN KEY (donation_id) REFERENCES DonationStock(donation_id)
);

CREATE TABLE FoodPacket (
    food_packet_id INT PRIMARY KEY,
    donation_id INT,
    meal_type VARCHAR(50),
    calories INT,
    suitable_for VARCHAR(80),
    FOREIGN KEY (donation_id) REFERENCES DonationStock(donation_id)
);

CREATE TABLE LowStockAlert (
    alert_id INT PRIMARY KEY,
    camp_id INT,
    inventory_id INT,
    alert_message VARCHAR(150),
    alert_date DATE,
    alert_status VARCHAR(30),
    FOREIGN KEY (camp_id) REFERENCES ReliefCamp(camp_id),
    FOREIGN KEY (inventory_id) REFERENCES CampInventory(inventory_id)
);

INSERT INTO ReliefCamp VALUES
(1, 'Central Relief Camp', 'Nagpur', 'Sitabuldi Ground', 500, 320),
(2, 'River Side Safety Camp', 'Pune', 'Mula River School', 400, 280),
(3, 'Emergency Shelter Camp', 'Mumbai', 'Andheri Sports Complex', 600, 450),
(4, 'Hill Area Relief Camp', 'Nashik', 'Trimbak Road Hall', 300, 210);

INSERT INTO Victim VALUES
(1, 1, 'Aarav Sharma', 34, 'Male', '9000011111', 'High'),
(2, 1, 'Sneha Patil', 28, 'Female', '9000022222', 'Medium'),
(3, 2, 'Rahul Mehta', 45, 'Male', '9000033333', 'High'),
(4, 2, 'Priya Nair', 31, 'Female', '9000044444', 'Low'),
(5, 3, 'Aman Khan', 52, 'Male', '9000055555', 'High'),
(6, 3, 'Kavya Joshi', 24, 'Female', '9000066666', 'Medium'),
(7, 4, 'Rohan Verma', 39, 'Male', '9000077777', 'Medium');

INSERT INTO Volunteer VALUES
(1, 'Vikas Yadav', '9111111111', 1, 'Food Distributor'),
(2, 'Neha Kulkarni', '9222222222', 1, 'Medical Helper'),
(3, 'Suresh Pawar', '9333333333', 2, 'Inventory Manager'),
(4, 'Fatima Sheikh', '9444444444', 3, 'Food Distributor'),
(5, 'Karan Malhotra', '9555555555', 4, 'Medical Helper');

INSERT INTO ResourceCategory VALUES
(1, 'Food', 'Ready-to-eat meals and food packets'),
(2, 'Medical', 'Medicines, first-aid kits, and health supplies'),
(3, 'Clothing', 'Blankets, clothes, and warm wear'),
(4, 'Water', 'Drinking water bottles and cans'),
(5, 'Sanitation', 'Hygiene kits and sanitation supplies');

INSERT INTO DonationStock VALUES
(1, 1, 'Rice Meal Packet', 'Helping Hands NGO', 1000, 700, '2026-04-25', '2026-05-05', 'Available'),
(2, 1, 'Dry Food Kit', 'FoodCare Trust', 800, 520, '2026-04-26', '2026-06-01', 'Available'),
(3, 2, 'First Aid Kit', 'City Hospital', 300, 180, '2026-04-25', '2027-04-25', 'Available'),
(4, 2, 'Paracetamol Tablets', 'MediHelp Foundation', 500, 260, '2026-04-27', '2027-01-15', 'Available'),
(5, 3, 'Blanket Set', 'WarmLife NGO', 400, 150, '2026-04-24', NULL, 'Available'),
(6, 4, 'Water Bottle Pack', 'AquaSafe Donors', 1200, 300, '2026-04-28', '2026-07-01', 'Low Stock'),
(7, 5, 'Hygiene Kit', 'CleanCare Group', 350, 90, '2026-04-26', '2026-12-01', 'Low Stock');

INSERT INTO CampInventory VALUES
(1, 1, 1, 300, 80, 100, 'Low Stock'),
(2, 1, 3, 100, 65, 50, 'Available'),
(3, 2, 2, 250, 140, 80, 'Available'),
(4, 2, 6, 300, 60, 120, 'Low Stock'),
(5, 3, 4, 200, 130, 70, 'Available'),
(6, 3, 5, 180, 40, 60, 'Low Stock'),
(7, 4, 7, 100, 25, 40, 'Low Stock');

INSERT INTO DistributionRecord VALUES
(1, 1, 1, 1, '2026-04-29', 2, 'Distributed'),
(2, 2, 2, 2, '2026-04-29', 1, 'Distributed'),
(3, 3, 3, 3, '2026-04-29', 3, 'Distributed'),
(4, 4, 3, 4, '2026-04-29', 2, 'Distributed'),
(5, 5, 4, 5, '2026-04-28', 1, 'Distributed'),
(6, 6, 4, 6, '2026-04-28', 2, 'Distributed'),
(7, 7, 5, 7, '2026-04-29', 1, 'Pending');

INSERT INTO MedicalSupply VALUES
(1, 3, 'First Aid', 'Room Temperature', 'Use for minor injuries'),
(2, 4, 'Fever Medicine', 'Dry Storage', 'One tablet after food');

INSERT INTO FoodPacket VALUES
(1, 1, 'Lunch/Dinner', 650, 'Adults and children'),
(2, 2, 'Dry Meal Kit', 900, 'Family use');

INSERT INTO LowStockAlert VALUES
(1, 1, 1, 'Rice Meal Packet stock is below minimum requirement.', '2026-04-29', 'Open'),
(2, 2, 4, 'Water Bottle Pack stock is below minimum requirement.', '2026-04-29', 'Open'),
(3, 3, 6, 'Blanket Set stock is below minimum requirement.', '2026-04-29', 'Open'),
(4, 4, 7, 'Hygiene Kit stock is below minimum requirement.', '2026-04-29', 'Open');

-- 1. Show all relief camps with capacity and victim count
SELECT 
    camp_name,
    city,
    location,
    capacity,
    current_victims
FROM ReliefCamp;

-- 2. Camps with low resource stock
SELECT 
    rc.camp_name,
    rc.city,
    ds.item_name,
    ci.quantity_remaining,
    ci.minimum_required,
    ci.inventory_status
FROM CampInventory ci
JOIN ReliefCamp rc
ON ci.camp_id = rc.camp_id
JOIN DonationStock ds
ON ci.donation_id = ds.donation_id
WHERE ci.quantity_remaining < ci.minimum_required;

-- 3. Victims who received resources
SELECT 
    v.victim_name,
    rc.camp_name,
    ds.item_name,
    dr.quantity_distributed,
    dr.distribution_date,
    dr.distribution_status
FROM DistributionRecord dr
JOIN Victim v
ON dr.victim_id = v.victim_id
JOIN ReliefCamp rc
ON v.camp_id = rc.camp_id
JOIN CampInventory ci
ON dr.inventory_id = ci.inventory_id
JOIN DonationStock ds
ON ci.donation_id = ds.donation_id
WHERE dr.distribution_status = 'Distributed';

-- 4. Volunteers who distributed the most items
SELECT 
    vol.volunteer_name,
    vol.role_type,
    SUM(dr.quantity_distributed) AS total_items_distributed
FROM DistributionRecord dr
JOIN Volunteer vol
ON dr.volunteer_id = vol.volunteer_id
WHERE dr.distribution_status = 'Distributed'
GROUP BY vol.volunteer_name, vol.role_type
ORDER BY total_items_distributed DESC;

-- 5. Camp with highest number of victims
SELECT 
    camp_name,
    city,
    current_victims
FROM ReliefCamp
ORDER BY current_victims DESC;

-- 6. Available donation stock
SELECT 
    ds.item_name,
    rc.category_name,
    ds.quantity_received,
    ds.quantity_available,
    ds.stock_status
FROM DonationStock ds
JOIN ResourceCategory rc
ON ds.category_id = rc.category_id
WHERE ds.quantity_available > 0;

-- 7. Food and medical stock availability
SELECT 
    rc.category_name,
    ds.item_name,
    ds.quantity_available,
    ds.expiry_date,
    ds.stock_status
FROM DonationStock ds
JOIN ResourceCategory rc
ON ds.category_id = rc.category_id
WHERE rc.category_name IN ('Food', 'Medical');

-- 8. Most distributed resources
SELECT 
    ds.item_name,
    rc.category_name,
    SUM(dr.quantity_distributed) AS total_distributed
FROM DistributionRecord dr
JOIN CampInventory ci
ON dr.inventory_id = ci.inventory_id
JOIN DonationStock ds
ON ci.donation_id = ds.donation_id
JOIN ResourceCategory rc
ON ds.category_id = rc.category_id
WHERE dr.distribution_status = 'Distributed'
GROUP BY ds.item_name, rc.category_name
ORDER BY total_distributed DESC;

-- 9. Show all low-stock alerts
SELECT 
    lsa.alert_id,
    rc.camp_name,
    ds.item_name,
    lsa.alert_message,
    lsa.alert_date,
    lsa.alert_status
FROM LowStockAlert lsa
JOIN ReliefCamp rc
ON lsa.camp_id = rc.camp_id
JOIN CampInventory ci
ON lsa.inventory_id = ci.inventory_id
JOIN DonationStock ds
ON ci.donation_id = ds.donation_id;

-- 10. Pending distributions
SELECT 
    dr.distribution_id,
    v.victim_name,
    vol.volunteer_name,
    ds.item_name,
    dr.quantity_distributed,
    dr.distribution_status
FROM DistributionRecord dr
JOIN Victim v
ON dr.victim_id = v.victim_id
JOIN Volunteer vol
ON dr.volunteer_id = vol.volunteer_id
JOIN CampInventory ci
ON dr.inventory_id = ci.inventory_id
JOIN DonationStock ds
ON ci.donation_id = ds.donation_id
WHERE dr.distribution_status = 'Pending';

-- 11. High-priority victims
SELECT 
    victim_name,
    age,
    gender,
    phone,
    priority_level
FROM Victim
WHERE priority_level = 'High';

-- 12. Update camp inventory after distribution
UPDATE CampInventory
SET quantity_remaining = quantity_remaining - 2
WHERE inventory_id = 1;