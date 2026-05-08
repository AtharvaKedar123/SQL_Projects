

CREATE DATABASE BloodBankDB;
USE BloodBankDB;

CREATE TABLE Donor (
    donor_id INT PRIMARY KEY,
    donor_name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    blood_group VARCHAR(5),
    phone VARCHAR(15),
    city VARCHAR(50)
);

CREATE TABLE BloodGroup (
    blood_group_id INT PRIMARY KEY,
    blood_group VARCHAR(5),
    compatible_receiver VARCHAR(100)
);

CREATE TABLE Donation (
    donation_id INT PRIMARY KEY,
    donor_id INT,
    donation_date DATE,
    donation_center VARCHAR(80),
    units_donated INT,
    health_status VARCHAR(50),
    FOREIGN KEY (donor_id) REFERENCES Donor(donor_id)
);

CREATE TABLE BloodUnit (
    unit_id INT PRIMARY KEY,
    donation_id INT,
    blood_group VARCHAR(5),
    collection_date DATE,
    expiry_date DATE,
    storage_location VARCHAR(50),
    unit_status VARCHAR(30),
    FOREIGN KEY (donation_id) REFERENCES Donation(donation_id)
);

CREATE TABLE Hospital (
    hospital_id INT PRIMARY KEY,
    hospital_name VARCHAR(80),
    city VARCHAR(50),
    contact_number VARCHAR(15)
);

CREATE TABLE BloodRequest (
    request_id INT PRIMARY KEY,
    hospital_id INT,
    blood_group VARCHAR(5),
    units_required INT,
    request_date DATE,
    request_status VARCHAR(30),
    FOREIGN KEY (hospital_id) REFERENCES Hospital(hospital_id)
);

CREATE TABLE BloodIssue (
    issue_id INT PRIMARY KEY,
    request_id INT,
    unit_id INT,
    issue_date DATE,
    issued_by VARCHAR(50),
    FOREIGN KEY (request_id) REFERENCES BloodRequest(request_id),
    FOREIGN KEY (unit_id) REFERENCES BloodUnit(unit_id)
);

INSERT INTO Donor VALUES
(1, 'Rahul Sharma', 26, 'Male', 'A+', '9999999999', 'Nagpur'),
(2, 'Sneha Patil', 24, 'Female', 'O+', '8888888888', 'Pune'),
(3, 'Aman Verma', 30, 'Male', 'B+', '7777777777', 'Mumbai'),
(4, 'Priya Mehta', 28, 'Female', 'AB+', '6666666666', 'Nagpur'),
(5, 'Karan Singh', 35, 'Male', 'O-', '5555555555', 'Delhi');

INSERT INTO BloodGroup VALUES
(1, 'A+', 'A+, AB+'),
(2, 'O+', 'O+, A+, B+, AB+'),
(3, 'B+', 'B+, AB+'),
(4, 'AB+', 'AB+'),
(5, 'O-', 'All Blood Groups');

INSERT INTO Donation VALUES
(1, 1, '2026-04-01', 'Nagpur Central Blood Bank', 1, 'Eligible'),
(2, 2, '2026-04-05', 'Pune Blood Center', 1, 'Eligible'),
(3, 3, '2026-04-10', 'Mumbai Blood Bank', 1, 'Eligible'),
(4, 4, '2026-04-12', 'Nagpur Central Blood Bank', 1, 'Eligible'),
(5, 5, '2026-03-01', 'Delhi Blood Center', 1, 'Eligible'),
(6, 1, '2026-04-20', 'Nagpur Central Blood Bank', 1, 'Eligible');

INSERT INTO BloodUnit VALUES
(101, 1, 'A+', '2026-04-01', '2026-05-06', 'Freezer A1', 'Available'),
(102, 2, 'O+', '2026-04-05', '2026-05-10', 'Freezer B1', 'Issued'),
(103, 3, 'B+', '2026-04-10', '2026-05-15', 'Freezer C1', 'Available'),
(104, 4, 'AB+', '2026-04-12', '2026-05-17', 'Freezer D1', 'Available'),
(105, 5, 'O-', '2026-03-01', '2026-04-05', 'Freezer E1', 'Expired'),
(106, 6, 'A+', '2026-04-20', '2026-05-25', 'Freezer A2', 'Available');

INSERT INTO Hospital VALUES
(1, 'City Care Hospital', 'Nagpur', '9000011111'),
(2, 'LifeLine Hospital', 'Pune', '9000022222'),
(3, 'Metro Hospital', 'Mumbai', '9000033333'),
(4, 'Hope Medical Center', 'Delhi', '9000044444');

INSERT INTO BloodRequest VALUES
(1, 1, 'O+', 1, '2026-04-15', 'Fulfilled'),
(2, 2, 'A+', 2, '2026-04-20', 'Pending'),
(3, 3, 'B+', 1, '2026-04-21', 'Pending'),
(4, 4, 'O-', 1, '2026-04-22', 'Rejected'),
(5, 1, 'AB+', 1, '2026-04-23', 'Pending');

INSERT INTO BloodIssue VALUES
(1, 1, 102, '2026-04-15', 'Admin Rahul');

-- 1. Available blood units
SELECT 
    unit_id,
    blood_group,
    collection_date,
    expiry_date,
    storage_location,
    unit_status
FROM BloodUnit
WHERE unit_status = 'Available';

-- 2. Expired blood units
SELECT 
    unit_id,
    blood_group,
    collection_date,
    expiry_date,
    unit_status
FROM BloodUnit
WHERE expiry_date < '2026-04-29'
OR unit_status = 'Expired';

-- 3. Blood stock by blood group
SELECT 
    blood_group,
    COUNT(unit_id) AS available_units
FROM BloodUnit
WHERE unit_status = 'Available'
GROUP BY blood_group
ORDER BY available_units ASC;

-- 4. Donors with highest donations
SELECT 
    d.donor_name,
    d.blood_group,
    d.city,
    COUNT(do.donation_id) AS total_donations,
    SUM(do.units_donated) AS total_units_donated
FROM Donation do
JOIN Donor d
ON do.donor_id = d.donor_id
GROUP BY d.donor_name, d.blood_group, d.city
ORDER BY total_units_donated DESC;

-- 5. Pending hospital requests
SELECT 
    br.request_id,
    h.hospital_name,
    h.city,
    br.blood_group,
    br.units_required,
    br.request_date,
    br.request_status
FROM BloodRequest br
JOIN Hospital h
ON br.hospital_id = h.hospital_id
WHERE br.request_status = 'Pending';

-- 6. Blood units issued to hospitals
SELECT 
    h.hospital_name,
    h.city,
    br.blood_group,
    COUNT(bi.unit_id) AS total_units_issued
FROM BloodIssue bi
JOIN BloodRequest br
ON bi.request_id = br.request_id
JOIN Hospital h
ON br.hospital_id = h.hospital_id
GROUP BY h.hospital_name, h.city, br.blood_group;

-- 7. Blood units close to expiry
SELECT 
    unit_id,
    blood_group,
    expiry_date,
    storage_location,
    unit_status
FROM BloodUnit
WHERE unit_status = 'Available'
AND expiry_date BETWEEN '2026-04-29' AND '2026-05-10';

-- 8. Complete donation inventory report
SELECT 
    d.donor_name,
    d.blood_group,
    dn.donation_date,
    bu.unit_id,
    bu.collection_date,
    bu.expiry_date,
    bu.storage_location,
    bu.unit_status
FROM BloodUnit bu
JOIN Donation dn
ON bu.donation_id = dn.donation_id
JOIN Donor d
ON dn.donor_id = d.donor_id;
