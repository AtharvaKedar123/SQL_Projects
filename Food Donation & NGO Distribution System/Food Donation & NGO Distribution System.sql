CREATE DATABASE FoodDonationDB;
USE FoodDonationDB;

CREATE TABLE Donor (
    donor_id INT PRIMARY KEY,
    donor_name VARCHAR(80),
    donor_type VARCHAR(50),
    phone VARCHAR(20),
    city VARCHAR(50)
);

CREATE TABLE NGO (
    ngo_id INT PRIMARY KEY,
    ngo_name VARCHAR(80),
    contact_person VARCHAR(50),
    phone VARCHAR(20),
    city VARCHAR(50)
);

CREATE TABLE Beneficiary (
    beneficiary_id INT PRIMARY KEY,
    beneficiary_name VARCHAR(50),
    age INT,
    location VARCHAR(100),
    beneficiary_type VARCHAR(50)
);

CREATE TABLE FoodDonation (
    donation_id INT PRIMARY KEY,
    donor_id INT,
    food_item VARCHAR(80),
    food_category VARCHAR(50),
    quantity_kg DECIMAL(10,2),
    donation_date DATE,
    expiry_date DATE,
    food_safety_status VARCHAR(30),
    donation_status VARCHAR(30),
    FOREIGN KEY (donor_id) REFERENCES Donor(donor_id)
);

CREATE TABLE PickupRequest (
    pickup_id INT PRIMARY KEY,
    donation_id INT,
    ngo_id INT,
    pickup_date DATE,
    pickup_status VARCHAR(30),
    pickup_location VARCHAR(100),
    FOREIGN KEY (donation_id) REFERENCES FoodDonation(donation_id),
    FOREIGN KEY (ngo_id) REFERENCES NGO(ngo_id)
);

CREATE TABLE DistributionRecord (
    distribution_id INT PRIMARY KEY,
    donation_id INT,
    ngo_id INT,
    beneficiary_id INT,
    distribution_date DATE,
    distributed_quantity_kg DECIMAL(10,2),
    distribution_status VARCHAR(30),
    FOREIGN KEY (donation_id) REFERENCES FoodDonation(donation_id),
    FOREIGN KEY (ngo_id) REFERENCES NGO(ngo_id),
    FOREIGN KEY (beneficiary_id) REFERENCES Beneficiary(beneficiary_id)
);

INSERT INTO Donor VALUES
(1, 'Green Bowl Restaurant', 'Restaurant', '9876543210', 'Nagpur'),
(2, 'Sunrise Event Hall', 'Event Hall', '9876543211', 'Mumbai'),
(3, 'FreshMart Supermarket', 'Supermarket', '9876543212', 'Pune'),
(4, 'Atharva Kedar', 'Individual', '9876543213', 'Nagpur'),
(5, 'Royal Caterers', 'Catering Service', '9876543214', 'Nashik');

INSERT INTO NGO VALUES
(1, 'Helping Hands NGO', 'Meera Joshi', '9000011111', 'Nagpur'),
(2, 'Food For All Foundation', 'Raj Malhotra', '9000022222', 'Mumbai'),
(3, 'Hope Meal Trust', 'Sara Khan', '9000033333', 'Pune'),
(4, 'Care Plate Mission', 'Amit Verma', '9000044444', 'Nashik');

INSERT INTO Beneficiary VALUES
(1, 'Rahul', 12, 'Nagpur Shelter Home', 'Child'),
(2, 'Anita', 65, 'Mumbai Old Age Home', 'Senior Citizen'),
(3, 'Karan', 30, 'Pune Night Shelter', 'Homeless'),
(4, 'Suman', 45, 'Nagpur Relief Camp', 'Disaster Affected'),
(5, 'Ravi', 22, 'Nashik Community Center', 'Low Income'),
(6, 'Pooja', 10, 'Pune Orphanage', 'Child');

INSERT INTO FoodDonation VALUES
(1, 1, 'Veg Rice Meals', 'Cooked Food', 25.50, '2026-04-01', '2026-04-02', 'Safe', 'Distributed'),
(2, 2, 'Chapati and Curry Packs', 'Cooked Food', 40.00, '2026-04-02', '2026-04-03', 'Safe', 'Distributed'),
(3, 3, 'Packaged Bread', 'Bakery', 15.00, '2026-04-03', '2026-04-05', 'Safe', 'Picked Up'),
(4, 4, 'Rice Bags', 'Dry Food', 30.00, '2026-04-04', '2026-06-01', 'Safe', 'Pending Pickup'),
(5, 5, 'Paneer Curry', 'Cooked Food', 18.00, '2026-04-05', '2026-04-05', 'Unsafe', 'Rejected'),
(6, 3, 'Fruit Boxes', 'Fruits', 22.00, '2026-04-06', '2026-04-07', 'Safe', 'Pending Distribution'),
(7, 1, 'Dal Khichdi', 'Cooked Food', 20.00, '2026-04-07', '2026-04-08', 'Expired', 'Rejected');

INSERT INTO PickupRequest VALUES
(1, 1, 1, '2026-04-01', 'Completed', 'Green Bowl Restaurant, Nagpur'),
(2, 2, 2, '2026-04-02', 'Completed', 'Sunrise Event Hall, Mumbai'),
(3, 3, 3, '2026-04-03', 'Completed', 'FreshMart Supermarket, Pune'),
(4, 4, 1, '2026-04-04', 'Pending', 'Atharva House, Nagpur'),
(5, 6, 3, '2026-04-06', 'Completed', 'FreshMart Supermarket, Pune');

INSERT INTO DistributionRecord VALUES
(1, 1, 1, 1, '2026-04-01', 10.00, 'Distributed'),
(2, 1, 1, 4, '2026-04-01', 15.50, 'Distributed'),
(3, 2, 2, 2, '2026-04-02', 20.00, 'Distributed'),
(4, 2, 2, 3, '2026-04-02', 20.00, 'Distributed'),
(5, 3, 3, 6, '2026-04-04', 8.00, 'Distributed'),
(6, 6, 3, 3, '2026-04-06', 10.00, 'Pending');

-- 1. Donors who donated the most food
SELECT 
    d.donor_name,
    d.donor_type,
    SUM(fd.quantity_kg) AS total_donated_kg
FROM FoodDonation fd
JOIN Donor d
ON fd.donor_id = d.donor_id
GROUP BY d.donor_name, d.donor_type
ORDER BY total_donated_kg DESC;

-- 2. NGOs that distributed the most food
SELECT 
    n.ngo_name,
    SUM(dr.distributed_quantity_kg) AS total_distributed_kg
FROM DistributionRecord dr
JOIN NGO n
ON dr.ngo_id = n.ngo_id
WHERE dr.distribution_status = 'Distributed'
GROUP BY n.ngo_name
ORDER BY total_distributed_kg DESC;

-- 3. Unsafe or expired food items
SELECT 
    food_item,
    food_category,
    quantity_kg,
    expiry_date,
    food_safety_status,
    donation_status
FROM FoodDonation
WHERE food_safety_status IN ('Unsafe', 'Expired');

-- 4. Pending pickup requests
SELECT 
    pr.pickup_id,
    d.donor_name,
    fd.food_item,
    fd.quantity_kg,
    n.ngo_name,
    pr.pickup_date,
    pr.pickup_status
FROM PickupRequest pr
JOIN FoodDonation fd
ON pr.donation_id = fd.donation_id
JOIN Donor d
ON fd.donor_id = d.donor_id
JOIN NGO n
ON pr.ngo_id = n.ngo_id
WHERE pr.pickup_status = 'Pending';

-- 5. Total beneficiaries who received food
SELECT 
    COUNT(DISTINCT beneficiary_id) AS total_beneficiaries_served
FROM DistributionRecord
WHERE distribution_status = 'Distributed';

-- 6. Total quantity of food donated
SELECT 
    SUM(quantity_kg) AS total_food_donated_kg
FROM FoodDonation;

-- 7. Donations still not distributed
SELECT 
    fd.donation_id,
    d.donor_name,
    fd.food_item,
    fd.quantity_kg,
    fd.donation_status
FROM FoodDonation fd
JOIN Donor d
ON fd.donor_id = d.donor_id
WHERE fd.donation_status IN ('Picked Up', 'Pending Pickup', 'Pending Distribution');

-- 8. Most donated food category
SELECT 
    food_category,
    SUM(quantity_kg) AS total_quantity_kg
FROM FoodDonation
GROUP BY food_category
ORDER BY total_quantity_kg DESC;

-- 9. Distribution details with beneficiaries
SELECT 
    n.ngo_name,
    b.beneficiary_name,
    b.beneficiary_type,
    fd.food_item,
    dr.distributed_quantity_kg,
    dr.distribution_status
FROM DistributionRecord dr
JOIN NGO n
ON dr.ngo_id = n.ngo_id
JOIN Beneficiary b
ON dr.beneficiary_id = b.beneficiary_id
JOIN FoodDonation fd
ON dr.donation_id = fd.donation_id;

-- 10. Rejected donations
SELECT 
    d.donor_name,
    fd.food_item,
    fd.food_safety_status,
    fd.donation_status,
    fd.expiry_date
FROM FoodDonation fd
JOIN Donor d
ON fd.donor_id = d.donor_id
WHERE fd.donation_status = 'Rejected';