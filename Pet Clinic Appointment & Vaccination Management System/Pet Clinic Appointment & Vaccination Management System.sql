

CREATE DATABASE PetClinicDB;
USE PetClinicDB;

CREATE TABLE PetOwner (
    owner_id INT PRIMARY KEY,
    owner_name VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(80),
    city VARCHAR(50)
);

CREATE TABLE Pet (
    pet_id INT PRIMARY KEY,
    owner_id INT,
    pet_name VARCHAR(50),
    species VARCHAR(30),
    breed VARCHAR(50),
    age_years INT,
    gender VARCHAR(10),
    FOREIGN KEY (owner_id) REFERENCES PetOwner(owner_id)
);

CREATE TABLE Veterinarian (
    vet_id INT PRIMARY KEY,
    vet_name VARCHAR(50),
    specialization VARCHAR(50),
    phone VARCHAR(15),
    consultation_fee DECIMAL(10,2)
);

CREATE TABLE Appointment (
    appointment_id INT PRIMARY KEY,
    pet_id INT,
    vet_id INT,
    appointment_date DATE,
    appointment_time TIME,
    appointment_type VARCHAR(50),
    appointment_status VARCHAR(30),
    FOREIGN KEY (pet_id) REFERENCES Pet(pet_id),
    FOREIGN KEY (vet_id) REFERENCES Veterinarian(vet_id)
);

CREATE TABLE VaccinationRecord (
    vaccination_id INT PRIMARY KEY,
    pet_id INT,
    vaccine_name VARCHAR(80),
    vaccination_date DATE,
    next_due_date DATE,
    vaccination_status VARCHAR(30),
    FOREIGN KEY (pet_id) REFERENCES Pet(pet_id)
);

CREATE TABLE TreatmentRecord (
    treatment_id INT PRIMARY KEY,
    appointment_id INT,
    diagnosis VARCHAR(100),
    treatment_given VARCHAR(255),
    medicine_prescribed VARCHAR(100),
    follow_up_date DATE,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

CREATE TABLE Billing (
    bill_id INT PRIMARY KEY,
    appointment_id INT,
    bill_date DATE,
    total_amount DECIMAL(10,2),
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    FOREIGN KEY (appointment_id) REFERENCES Appointment(appointment_id)
);

INSERT INTO PetOwner VALUES
(1, 'Rahul Sharma', '9999999999', 'rahul@email.com', 'Nagpur'),
(2, 'Sneha Patil', '8888888888', 'sneha@email.com', 'Pune'),
(3, 'Aman Verma', '7777777777', 'aman@email.com', 'Mumbai'),
(4, 'Priya Mehta', '6666666666', 'priya@email.com', 'Delhi'),
(5, 'Atharva Kedar', '5555555555', 'atharva@email.com', 'Nagpur');

INSERT INTO Pet VALUES
(1, 1, 'Bruno', 'Dog', 'Labrador', 4, 'Male'),
(2, 2, 'Milo', 'Cat', 'Persian', 3, 'Male'),
(3, 3, 'Coco', 'Dog', 'Beagle', 2, 'Female'),
(4, 4, 'Snowy', 'Rabbit', 'Angora', 1, 'Female'),
(5, 5, 'Max', 'Dog', 'German Shepherd', 5, 'Male');

INSERT INTO Veterinarian VALUES
(1, 'Dr. Anjali Rao', 'General Checkup', '9000011111', 700.00),
(2, 'Dr. Karan Mehta', 'Vaccination', '9000022222', 600.00),
(3, 'Dr. Nisha Sharma', 'Surgery', '9000033333', 1500.00),
(4, 'Dr. Rohan Iyer', 'Dermatology', '9000044444', 1000.00);

INSERT INTO Appointment VALUES
(1, 1, 1, '2026-05-01', '10:00:00', 'General Checkup', 'Upcoming'),
(2, 2, 2, '2026-05-02', '11:00:00', 'Vaccination', 'Upcoming'),
(3, 3, 4, '2026-04-25', '15:00:00', 'Skin Allergy Checkup', 'Completed'),
(4, 4, 1, '2026-04-26', '16:00:00', 'General Checkup', 'Completed'),
(5, 5, 3, '2026-04-27', '18:00:00', 'Surgery Consultation', 'Completed'),
(6, 1, 2, '2026-05-10', '12:00:00', 'Vaccination', 'Upcoming');

INSERT INTO VaccinationRecord VALUES
(1, 1, 'Rabies Vaccine', '2025-05-10', '2026-05-10', 'Due Soon'),
(2, 2, 'Feline Distemper Vaccine', '2025-05-02', '2026-05-02', 'Due Soon'),
(3, 3, 'Parvo Vaccine', '2026-01-15', '2027-01-15', 'Completed'),
(4, 5, 'Rabies Vaccine', '2025-04-01', '2026-04-01', 'Overdue'),
(5, 4, 'Rabbit Viral Vaccine', '2026-03-20', '2027-03-20', 'Completed');

INSERT INTO TreatmentRecord VALUES
(1, 3, 'Skin allergy', 'Anti-allergy injection given', 'Antihistamine syrup', '2026-05-05'),
(2, 4, 'Normal weakness', 'Basic health checkup completed', 'Vitamin drops', '2026-05-10'),
(3, 5, 'Leg injury', 'X-ray suggested and wound cleaned', 'Painkiller tablet', '2026-05-03');

INSERT INTO Billing VALUES
(1, 1, '2026-05-01', 700.00, 'UPI', 'Pending'),
(2, 2, '2026-05-02', 600.00, 'Card', 'Pending'),
(3, 3, '2026-04-25', 1000.00, 'UPI', 'Paid'),
(4, 4, '2026-04-26', 700.00, 'Cash', 'Paid'),
(5, 5, '2026-04-27', 1500.00, 'UPI', 'Paid'),
(6, 6, '2026-05-10', 600.00, 'Cash', 'Pending');

-- 1. Upcoming appointments
SELECT 
    a.appointment_id,
    po.owner_name,
    p.pet_name,
    p.species,
    v.vet_name,
    a.appointment_date,
    a.appointment_time,
    a.appointment_type,
    a.appointment_status
FROM Appointment a
JOIN Pet p
ON a.pet_id = p.pet_id
JOIN PetOwner po
ON p.owner_id = po.owner_id
JOIN Veterinarian v
ON a.vet_id = v.vet_id
WHERE a.appointment_status = 'Upcoming'
ORDER BY a.appointment_date, a.appointment_time;

-- 2. Pets with pending vaccinations
SELECT 
    po.owner_name,
    p.pet_name,
    p.species,
    vr.vaccine_name,
    vr.next_due_date,
    vr.vaccination_status
FROM VaccinationRecord vr
JOIN Pet p
ON vr.pet_id = p.pet_id
JOIN PetOwner po
ON p.owner_id = po.owner_id
WHERE vr.vaccination_status IN ('Due Soon', 'Overdue');

-- 3. Veterinarian appointment count
SELECT 
    v.vet_name,
    v.specialization,
    COUNT(a.appointment_id) AS total_appointments
FROM Appointment a
JOIN Veterinarian v
ON a.vet_id = v.vet_id
GROUP BY v.vet_name, v.specialization
ORDER BY total_appointments DESC;

-- 4. Owners with pending payments
SELECT 
    po.owner_name,
    p.pet_name,
    a.appointment_type,
    b.total_amount,
    b.payment_status
FROM Billing b
JOIN Appointment a
ON b.appointment_id = a.appointment_id
JOIN Pet p
ON a.pet_id = p.pet_id
JOIN PetOwner po
ON p.owner_id = po.owner_id
WHERE b.payment_status = 'Pending';

-- 5. Total revenue generated
SELECT 
    SUM(total_amount) AS total_revenue
FROM Billing
WHERE payment_status = 'Paid';

-- 6. Most common appointment type
SELECT 
    appointment_type,
    COUNT(appointment_id) AS total_bookings
FROM Appointment
GROUP BY appointment_type
ORDER BY total_bookings DESC;

-- 7. Complete pet medical history
SELECT 
    po.owner_name,
    p.pet_name,
    p.species,
    p.breed,
    a.appointment_date,
    a.appointment_type,
    tr.diagnosis,
    tr.treatment_given,
    tr.medicine_prescribed,
    tr.follow_up_date
FROM TreatmentRecord tr
JOIN Appointment a
ON tr.appointment_id = a.appointment_id
JOIN Pet p
ON a.pet_id = p.pet_id
JOIN PetOwner po
ON p.owner_id = po.owner_id
ORDER BY p.pet_name, a.appointment_date;

-- 8. Vaccination due in May 2026
SELECT 
    po.owner_name,
    p.pet_name,
    vr.vaccine_name,
    vr.next_due_date,
    vr.vaccination_status
FROM VaccinationRecord vr
JOIN Pet p
ON vr.pet_id = p.pet_id
JOIN PetOwner po
ON p.owner_id = po.owner_id
WHERE vr.next_due_date BETWEEN '2026-05-01' AND '2026-05-31';
