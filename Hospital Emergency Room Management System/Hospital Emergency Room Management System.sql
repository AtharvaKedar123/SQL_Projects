

CREATE DATABASE EmergencyRoomDB;
USE EmergencyRoomDB;

CREATE TABLE Patient (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    phone VARCHAR(15),
    blood_group VARCHAR(10)
);

CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(50),
    specialization VARCHAR(50),
    phone VARCHAR(15)
);

CREATE TABLE Bed (
    bed_id INT PRIMARY KEY,
    bed_number VARCHAR(20),
    bed_type VARCHAR(30),
    is_occupied BOOLEAN
);

CREATE TABLE EmergencyCase (
    case_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    bed_id INT,
    emergency_type VARCHAR(50),
    severity_level VARCHAR(20),
    arrival_time DATETIME,
    treatment_status VARCHAR(30),
    FOREIGN KEY (patient_id) REFERENCES Patient(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id),
    FOREIGN KEY (bed_id) REFERENCES Bed(bed_id)
);

CREATE TABLE Treatment (
    treatment_id INT PRIMARY KEY,
    case_id INT,
    treatment_description VARCHAR(255),
    medicine_given VARCHAR(100),
    treatment_date DATE,
    FOREIGN KEY (case_id) REFERENCES EmergencyCase(case_id)
);

CREATE TABLE Billing (
    bill_id INT PRIMARY KEY,
    case_id INT,
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(30),
    billing_date DATE,
    FOREIGN KEY (case_id) REFERENCES EmergencyCase(case_id)
);

INSERT INTO Patient VALUES
(1, 'Arjun Mehta', 35, 'Male', '9876543210', 'B+'),
(2, 'Priya Singh', 28, 'Female', '9876500000', 'O+'),
(3, 'Ramesh Patil', 52, 'Male', '9988776655', 'A+'),
(4, 'Neha Sharma', 19, 'Female', '9090909090', 'AB+'),
(5, 'Amit Verma', 44, 'Male', '8888888888', 'O-');

INSERT INTO Doctor VALUES
(1, 'Dr. Kapoor', 'Trauma', '9000011111'),
(2, 'Dr. Iyer', 'Cardiology', '9000022222'),
(3, 'Dr. Mehta', 'Neurology', '9000033333'),
(4, 'Dr. Rao', 'General Emergency', '9000044444');

INSERT INTO Bed VALUES
(1, 'ER-01', 'ICU', TRUE),
(2, 'ER-02', 'Emergency', TRUE),
(3, 'ER-03', 'Emergency', FALSE),
(4, 'ER-04', 'Observation', TRUE),
(5, 'ER-05', 'Observation', FALSE);

INSERT INTO EmergencyCase VALUES
(1, 1, 1, 1, 'Accident Injury', 'High', '2026-04-29 08:30:00', 'Under Treatment'),
(2, 2, 2, 2, 'Chest Pain', 'Critical', '2026-04-29 09:15:00', 'Admitted'),
(3, 3, 3, 4, 'Stroke Symptoms', 'Critical', '2026-04-28 20:45:00', 'Under Treatment'),
(4, 4, 4, NULL, 'Fever and Weakness', 'Low', '2026-04-29 11:00:00', 'Discharged'),
(5, 5, 1, NULL, 'Minor Injury', 'Medium', '2026-04-29 12:20:00', 'Discharged');

INSERT INTO Treatment VALUES
(1, 1, 'Wound cleaning and fracture support provided', 'Painkiller Injection', '2026-04-29'),
(2, 2, 'ECG performed and patient shifted to emergency bed', 'Blood Thinner', '2026-04-29'),
(3, 3, 'Brain scan recommended and patient kept under observation', 'Emergency Injection', '2026-04-28'),
(4, 4, 'Basic checkup completed and medicines prescribed', 'Paracetamol', '2026-04-29'),
(5, 5, 'Bandage applied and pain relief medicine given', 'Painkiller Tablet', '2026-04-29');

INSERT INTO Billing VALUES
(1, 1, 5000.00, 'Pending', '2026-04-29'),
(2, 2, 12000.00, 'Paid', '2026-04-29'),
(3, 3, 15000.00, 'Pending', '2026-04-28'),
(4, 4, 1200.00, 'Paid', '2026-04-29'),
(5, 5, 800.00, 'Paid', '2026-04-29');

-- 1. Patients currently under treatment
SELECT 
    p.patient_name,
    p.age,
    ec.emergency_type,
    ec.severity_level,
    d.doctor_name,
    ec.treatment_status
FROM EmergencyCase ec
JOIN Patient p
ON ec.patient_id = p.patient_id
JOIN Doctor d
ON ec.doctor_id = d.doctor_id
WHERE ec.treatment_status = 'Under Treatment';

-- 2. Critical emergency cases
SELECT 
    ec.case_id,
    p.patient_name,
    ec.emergency_type,
    ec.arrival_time,
    d.doctor_name,
    ec.treatment_status
FROM EmergencyCase ec
JOIN Patient p
ON ec.patient_id = p.patient_id
JOIN Doctor d
ON ec.doctor_id = d.doctor_id
WHERE ec.severity_level = 'Critical';

-- 3. Available beds
SELECT 
    bed_id,
    bed_number,
    bed_type
FROM Bed
WHERE is_occupied = FALSE;

-- 4. Doctor case count
SELECT 
    d.doctor_name,
    d.specialization,
    COUNT(ec.case_id) AS total_cases_handled
FROM Doctor d
LEFT JOIN EmergencyCase ec
ON d.doctor_id = ec.doctor_id
GROUP BY d.doctor_name, d.specialization
ORDER BY total_cases_handled DESC;

-- 5. Total billing revenue from paid bills
SELECT 
    SUM(total_amount) AS total_revenue
FROM Billing
WHERE payment_status = 'Paid';

-- 6. Patients with pending payments
SELECT 
    p.patient_name,
    ec.emergency_type,
    b.total_amount,
    b.payment_status
FROM Billing b
JOIN EmergencyCase ec
ON b.case_id = ec.case_id
JOIN Patient p
ON ec.patient_id = p.patient_id
WHERE b.payment_status = 'Pending';

-- 7. Treatment summary for each patient
SELECT 
    p.patient_name,
    ec.emergency_type,
    t.treatment_description,
    t.medicine_given,
    t.treatment_date
FROM Treatment t
JOIN EmergencyCase ec
ON t.case_id = ec.case_id
JOIN Patient p
ON ec.patient_id = p.patient_id;

-- 8. Case count by severity level
SELECT 
    severity_level,
    COUNT(case_id) AS total_cases
FROM EmergencyCase
GROUP BY severity_level
ORDER BY total_cases DESC;
