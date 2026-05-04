-- Gym Membership & Fitness Progress Tracker
-- Single File SQL Solution

CREATE DATABASE GymTrackerDB;
USE GymTrackerDB;

CREATE TABLE Member (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    phone VARCHAR(15),
    join_date DATE,
    fitness_goal VARCHAR(80)
);

CREATE TABLE Trainer (
    trainer_id INT PRIMARY KEY,
    trainer_name VARCHAR(50),
    specialization VARCHAR(50),
    phone VARCHAR(15)
);

CREATE TABLE MembershipPlan (
    plan_id INT PRIMARY KEY,
    plan_name VARCHAR(50),
    duration_months INT,
    price DECIMAL(10,2)
);

CREATE TABLE MemberSubscription (
    subscription_id INT PRIMARY KEY,
    member_id INT,
    plan_id INT,
    start_date DATE,
    end_date DATE,
    payment_status VARCHAR(30),
    subscription_status VARCHAR(30),
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (plan_id) REFERENCES MembershipPlan(plan_id)
);

CREATE TABLE WorkoutSession (
    session_id INT PRIMARY KEY,
    member_id INT,
    trainer_id INT,
    session_date DATE,
    workout_type VARCHAR(50),
    duration_minutes INT,
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (trainer_id) REFERENCES Trainer(trainer_id)
);

CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY,
    member_id INT,
    attendance_date DATE,
    check_in_time TIME,
    check_out_time TIME,
    status VARCHAR(30),
    FOREIGN KEY (member_id) REFERENCES Member(member_id)
);

CREATE TABLE FitnessProgress (
    progress_id INT PRIMARY KEY,
    member_id INT,
    record_date DATE,
    weight_kg DECIMAL(5,2),
    body_fat_percent DECIMAL(5,2),
    muscle_mass_kg DECIMAL(5,2),
    FOREIGN KEY (member_id) REFERENCES Member(member_id)
);

INSERT INTO Member VALUES
(1, 'Atharva Kedar', 22, 'Male', '9999999999', '2026-01-10', 'Muscle Gain'),
(2, 'Nisha Sharma', 25, 'Female', '8888888888', '2026-02-15', 'Weight Loss'),
(3, 'Rohan Mehta', 28, 'Male', '7777777777', '2026-03-01', 'Strength Training'),
(4, 'Priya Patil', 24, 'Female', '6666666666', '2026-03-20', 'General Fitness'),
(5, 'Aman Verma', 30, 'Male', '5555555555', '2026-04-01', 'Fat Loss');

INSERT INTO Trainer VALUES
(1, 'Rohit Yadav', 'Strength Training', '9000011111'),
(2, 'Anjali Rao', 'Weight Loss', '9000022222'),
(3, 'Karan Singh', 'CrossFit', '9000033333');

INSERT INTO MembershipPlan VALUES
(1, 'Monthly', 1, 1500.00),
(2, 'Quarterly', 3, 4000.00),
(3, 'Half-Yearly', 6, 7500.00),
(4, 'Yearly', 12, 12000.00);

INSERT INTO MemberSubscription VALUES
(1, 1, 4, '2026-01-10', '2027-01-10', 'Paid', 'Active'),
(2, 2, 2, '2026-02-15', '2026-05-15', 'Paid', 'Active'),
(3, 3, 1, '2026-03-01', '2026-04-01', 'Paid', 'Expired'),
(4, 4, 3, '2026-03-20', '2026-09-20', 'Pending', 'Active'),
(5, 5, 1, '2026-04-01', '2026-05-01', 'Paid', 'Active');

INSERT INTO WorkoutSession VALUES
(1, 1, 1, '2026-04-20', 'Chest Workout', 60),
(2, 2, 2, '2026-04-20', 'Cardio', 45),
(3, 3, 1, '2026-04-21', 'Leg Workout', 60),
(4, 4, 3, '2026-04-21', 'CrossFit', 50),
(5, 5, 2, '2026-04-22', 'HIIT', 40),
(6, 1, 1, '2026-04-23', 'Back Workout', 60),
(7, 2, 2, '2026-04-24', 'Cardio', 45);

INSERT INTO Attendance VALUES
(1, 1, '2026-04-20', '07:00:00', '08:00:00', 'Present'),
(2, 2, '2026-04-20', '08:00:00', '08:45:00', 'Present'),
(3, 3, '2026-04-21', '07:30:00', '08:30:00', 'Present'),
(4, 4, '2026-04-21', '09:00:00', '09:50:00', 'Present'),
(5, 5, '2026-04-22', '06:30:00', '07:10:00', 'Present'),
(6, 1, '2026-04-23', '07:00:00', '08:00:00', 'Present'),
(7, 2, '2026-04-24', '08:00:00', '08:45:00', 'Present'),
(8, 3, '2026-04-24', NULL, NULL, 'Absent');

INSERT INTO FitnessProgress VALUES
(1, 1, '2026-04-01', 74.50, 18.20, 32.00),
(2, 1, '2026-04-29', 72.00, 16.80, 34.00),
(3, 2, '2026-04-01', 68.00, 28.50, 24.00),
(4, 2, '2026-04-29', 65.50, 26.20, 25.00),
(5, 3, '2026-04-01', 80.00, 20.00, 35.00),
(6, 3, '2026-04-29', 81.50, 19.00, 36.50),
(7, 5, '2026-04-01', 90.00, 30.00, 33.00),
(8, 5, '2026-04-29', 86.00, 27.50, 34.00);

-- 1. Active members
SELECT 
    m.member_name,
    mp.plan_name,
    ms.start_date,
    ms.end_date,
    ms.payment_status,
    ms.subscription_status
FROM MemberSubscription ms
JOIN Member m
ON ms.member_id = m.member_id
JOIN MembershipPlan mp
ON ms.plan_id = mp.plan_id
WHERE ms.subscription_status = 'Active';

-- 2. Trainer workload
SELECT 
    t.trainer_name,
    t.specialization,
    COUNT(ws.session_id) AS total_sessions
FROM WorkoutSession ws
JOIN Trainer t
ON ws.trainer_id = t.trainer_id
GROUP BY t.trainer_name, t.specialization
ORDER BY total_sessions DESC;

-- 3. Regular members by attendance count
SELECT 
    m.member_name,
    COUNT(a.attendance_id) AS total_present_days
FROM Attendance a
JOIN Member m
ON a.member_id = m.member_id
WHERE a.status = 'Present'
GROUP BY m.member_name
ORDER BY total_present_days DESC;

-- 4. Fitness progress comparison
SELECT 
    m.member_name,
    MIN(fp.weight_kg) AS lowest_weight,
    MAX(fp.weight_kg) AS highest_weight,
    MIN(fp.body_fat_percent) AS lowest_body_fat,
    MAX(fp.body_fat_percent) AS highest_body_fat,
    MAX(fp.muscle_mass_kg) AS highest_muscle_mass
FROM FitnessProgress fp
JOIN Member m
ON fp.member_id = m.member_id
GROUP BY m.member_name;

-- 5. Membership revenue from paid subscriptions
SELECT 
    SUM(mp.price) AS total_membership_revenue
FROM MemberSubscription ms
JOIN MembershipPlan mp
ON ms.plan_id = mp.plan_id
WHERE ms.payment_status = 'Paid';

-- 6. Most popular workout types
SELECT 
    workout_type,
    COUNT(session_id) AS total_sessions
FROM WorkoutSession
GROUP BY workout_type
ORDER BY total_sessions DESC;

-- 7. Members with expired memberships
SELECT 
    m.member_name,
    mp.plan_name,
    ms.end_date,
    ms.subscription_status
FROM MemberSubscription ms
JOIN Member m
ON ms.member_id = m.member_id
JOIN MembershipPlan mp
ON ms.plan_id = mp.plan_id
WHERE ms.subscription_status = 'Expired';

-- 8. Members with pending payments
SELECT 
    m.member_name,
    mp.plan_name,
    mp.price,
    ms.payment_status
FROM MemberSubscription ms
JOIN Member m
ON ms.member_id = m.member_id
JOIN MembershipPlan mp
ON ms.plan_id = mp.plan_id
WHERE ms.payment_status = 'Pending';