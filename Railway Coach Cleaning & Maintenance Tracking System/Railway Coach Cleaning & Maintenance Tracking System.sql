-- Railway Coach Cleaning & Maintenance Tracking System
-- Single File SQL Solution

CREATE DATABASE RailwayCoachMaintenanceDB;
USE RailwayCoachMaintenanceDB;

CREATE TABLE Train (
    train_id INT PRIMARY KEY,
    train_number VARCHAR(20),
    train_name VARCHAR(100),
    source_station VARCHAR(80),
    destination_station VARCHAR(80)
);

CREATE TABLE Coach (
    coach_id INT PRIMARY KEY,
    train_id INT,
    coach_number VARCHAR(20),
    coach_type VARCHAR(40),
    coach_status VARCHAR(30),
    FOREIGN KEY (train_id) REFERENCES Train(train_id)
);

CREATE TABLE CleaningStaff (
    cleaning_staff_id INT PRIMARY KEY,
    staff_name VARCHAR(80),
    phone VARCHAR(15),
    shift_time VARCHAR(30)
);

CREATE TABLE MaintenanceStaff (
    maintenance_staff_id INT PRIMARY KEY,
    staff_name VARCHAR(80),
    phone VARCHAR(15),
    specialization VARCHAR(60)
);

CREATE TABLE CleaningSchedule (
    cleaning_id INT PRIMARY KEY,
    coach_id INT,
    cleaning_staff_id INT,
    cleaning_date DATE,
    cleaning_time TIME,
    cleaning_type VARCHAR(50),
    cleaning_status VARCHAR(30),
    FOREIGN KEY (coach_id) REFERENCES Coach(coach_id),
    FOREIGN KEY (cleaning_staff_id) REFERENCES CleaningStaff(cleaning_staff_id)
);

CREATE TABLE MaintenanceIssue (
    issue_id INT PRIMARY KEY,
    coach_id INT,
    issue_type VARCHAR(80),
    issue_description VARCHAR(200),
    priority_level VARCHAR(30),
    issue_status VARCHAR(30),
    reported_date DATE,
    FOREIGN KEY (coach_id) REFERENCES Coach(coach_id)
);

CREATE TABLE InspectionRecord (
    inspection_id INT PRIMARY KEY,
    coach_id INT,
    inspected_by VARCHAR(80),
    inspection_date DATE,
    inspection_status VARCHAR(30),
    remarks VARCHAR(200),
    FOREIGN KEY (coach_id) REFERENCES Coach(coach_id)
);

CREATE TABLE RepairDetail (
    repair_id INT PRIMARY KEY,
    issue_id INT,
    maintenance_staff_id INT,
    repair_date DATE,
    repair_status VARCHAR(30),
    repair_cost DECIMAL(10,2),
    repair_remarks VARCHAR(200),
    FOREIGN KEY (issue_id) REFERENCES MaintenanceIssue(issue_id),
    FOREIGN KEY (maintenance_staff_id) REFERENCES MaintenanceStaff(maintenance_staff_id)
);

INSERT INTO Train VALUES
(1, '12101', 'Vidarbha Express', 'Mumbai', 'Nagpur'),
(2, '12289', 'Duronto Express', 'Nagpur', 'Mumbai'),
(3, '12627', 'Karnataka Express', 'Bangalore', 'Delhi'),
(4, '12951', 'Mumbai Rajdhani', 'Mumbai', 'Delhi');

INSERT INTO Coach VALUES
(1, 1, 'S1', 'Sleeper', 'Needs Cleaning'),
(2, 1, 'S2', 'Sleeper', 'Cleaned'),
(3, 1, 'A1', 'AC 2 Tier', 'Maintenance Required'),
(4, 2, 'B1', 'AC 3 Tier', 'Cleaned'),
(5, 2, 'S1', 'Sleeper', 'Needs Cleaning'),
(6, 3, 'C1', 'Chair Car', 'Maintenance Required'),
(7, 4, 'A2', 'AC 2 Tier', 'Cleaned');

INSERT INTO CleaningStaff VALUES
(1, 'Ramesh Yadav', '9000011111', 'Morning'),
(2, 'Suresh Pawar', '9000022222', 'Evening'),
(3, 'Neha Sharma', '9000033333', 'Night'),
(4, 'Amit Verma', '9000044444', 'Morning');

INSERT INTO MaintenanceStaff VALUES
(1, 'Vikas Thakur', '9111111111', 'Electrical'),
(2, 'Imran Khan', '9222222222', 'AC Repair'),
(3, 'Karan Patil', '9333333333', 'Plumbing'),
(4, 'Rohit Mehta', '9444444444', 'Mechanical');

INSERT INTO CleaningSchedule VALUES
(1, 1, 1, '2026-04-29', '08:00:00', 'Deep Cleaning', 'Pending'),
(2, 2, 2, '2026-04-29', '09:00:00', 'Regular Cleaning', 'Completed'),
(3, 4, 3, '2026-04-28', '22:00:00', 'Deep Cleaning', 'Completed'),
(4, 5, 4, '2026-04-29', '10:00:00', 'Regular Cleaning', 'Pending'),
(5, 7, 1, '2026-04-28', '07:30:00', 'Sanitization', 'Completed');

INSERT INTO MaintenanceIssue VALUES
(1, 3, 'AC Failure', 'AC cooling is not working properly.', 'High', 'Open', '2026-04-29'),
(2, 6, 'Broken Seat', 'Seat number 34 is damaged.', 'Medium', 'In Progress', '2026-04-29'),
(3, 3, 'Water Leakage', 'Water leakage near washroom.', 'High', 'Open', '2026-04-28'),
(4, 5, 'Door Issue', 'Coach door is not closing smoothly.', 'Medium', 'Resolved', '2026-04-27'),
(5, 7, 'Electrical Fault', 'Charging socket not working.', 'Low', 'Resolved', '2026-04-26');

INSERT INTO InspectionRecord VALUES
(1, 1, 'Inspector Arun', '2026-04-29', 'Failed', 'Coach requires cleaning before departure.'),
(2, 2, 'Inspector Arun', '2026-04-29', 'Passed', 'Coach is clean and ready.'),
(3, 3, 'Inspector Meera', '2026-04-29', 'Failed', 'AC and leakage issue found.'),
(4, 4, 'Inspector Kunal', '2026-04-28', 'Passed', 'Coach condition is good.'),
(5, 6, 'Inspector Meera', '2026-04-29', 'Failed', 'Broken seat found.'),
(6, 7, 'Inspector Kunal', '2026-04-28', 'Passed', 'Electrical issue resolved.');

INSERT INTO RepairDetail VALUES
(1, 1, 2, '2026-04-29', 'Pending', 0.00, 'AC technician assigned.'),
(2, 2, 4, '2026-04-29', 'In Progress', 1500.00, 'Seat replacement started.'),
(3, 3, 3, '2026-04-29', 'Pending', 0.00, 'Plumber inspection required.'),
(4, 4, 4, '2026-04-28', 'Completed', 2200.00, 'Door alignment fixed.'),
(5, 5, 1, '2026-04-27', 'Completed', 800.00, 'Charging socket repaired.');

-- 1. Show all trains with coaches
SELECT 
    t.train_number,
    t.train_name,
    c.coach_number,
    c.coach_type,
    c.coach_status
FROM Train t
JOIN Coach c
ON t.train_id = c.train_id;

-- 2. Coaches pending cleaning
SELECT 
    t.train_name,
    c.coach_number,
    c.coach_type,
    cs.cleaning_date,
    cs.cleaning_time,
    cs.cleaning_type,
    cs.cleaning_status
FROM CleaningSchedule cs
JOIN Coach c
ON cs.coach_id = c.coach_id
JOIN Train t
ON c.train_id = t.train_id
WHERE cs.cleaning_status = 'Pending';

-- 3. Coaches with maintenance issues
SELECT 
    t.train_name,
    c.coach_number,
    c.coach_type,
    mi.issue_type,
    mi.priority_level,
    mi.issue_status,
    mi.reported_date
FROM MaintenanceIssue mi
JOIN Coach c
ON mi.coach_id = c.coach_id
JOIN Train t
ON c.train_id = t.train_id;

-- 4. Open maintenance issues
SELECT 
    t.train_name,
    c.coach_number,
    mi.issue_type,
    mi.issue_description,
    mi.priority_level,
    mi.issue_status
FROM MaintenanceIssue mi
JOIN Coach c
ON mi.coach_id = c.coach_id
JOIN Train t
ON c.train_id = t.train_id
WHERE mi.issue_status IN ('Open', 'In Progress');

-- 5. Coaches that passed inspection
SELECT 
    t.train_name,
    c.coach_number,
    c.coach_type,
    ir.inspected_by,
    ir.inspection_date,
    ir.inspection_status
FROM InspectionRecord ir
JOIN Coach c
ON ir.coach_id = c.coach_id
JOIN Train t
ON c.train_id = t.train_id
WHERE ir.inspection_status = 'Passed';

-- 6. Cleaning staff performance
SELECT 
    csf.staff_name,
    COUNT(cs.cleaning_id) AS completed_cleaning_tasks
FROM CleaningSchedule cs
JOIN CleaningStaff csf
ON cs.cleaning_staff_id = csf.cleaning_staff_id
WHERE cs.cleaning_status = 'Completed'
GROUP BY csf.staff_name
ORDER BY completed_cleaning_tasks DESC;

-- 7. Total repair cost
SELECT 
    SUM(repair_cost) AS total_repair_cost
FROM RepairDetail
WHERE repair_status = 'Completed';

-- 8. Train-wise repair cost
SELECT 
    t.train_name,
    t.train_number,
    SUM(rd.repair_cost) AS total_repair_cost
FROM RepairDetail rd
JOIN MaintenanceIssue mi
ON rd.issue_id = mi.issue_id
JOIN Coach c
ON mi.coach_id = c.coach_id
JOIN Train t
ON c.train_id = t.train_id
GROUP BY t.train_name, t.train_number
ORDER BY total_repair_cost DESC;

-- 9. Maintenance staff workload
SELECT 
    ms.staff_name,
    ms.specialization,
    COUNT(rd.repair_id) AS total_repairs_assigned
FROM RepairDetail rd
JOIN MaintenanceStaff ms
ON rd.maintenance_staff_id = ms.maintenance_staff_id
GROUP BY ms.staff_name, ms.specialization
ORDER BY total_repairs_assigned DESC;

-- 10. High priority maintenance issues
SELECT 
    t.train_name,
    c.coach_number,
    mi.issue_type,
    mi.issue_description,
    mi.priority_level,
    mi.issue_status
FROM MaintenanceIssue mi
JOIN Coach c
ON mi.coach_id = c.coach_id
JOIN Train t
ON c.train_id = t.train_id
WHERE mi.priority_level = 'High';

-- 11. Full repair report
SELECT 
    rd.repair_id,
    t.train_name,
    c.coach_number,
    mi.issue_type,
    ms.staff_name,
    rd.repair_date,
    rd.repair_status,
    rd.repair_cost,
    rd.repair_remarks
FROM RepairDetail rd
JOIN MaintenanceIssue mi
ON rd.issue_id = mi.issue_id
JOIN Coach c
ON mi.coach_id = c.coach_id
JOIN Train t
ON c.train_id = t.train_id
JOIN MaintenanceStaff ms
ON rd.maintenance_staff_id = ms.maintenance_staff_id;

-- 12. Update cleaning status after task completion
UPDATE CleaningSchedule
SET cleaning_status = 'Completed'
WHERE cleaning_id = 1;