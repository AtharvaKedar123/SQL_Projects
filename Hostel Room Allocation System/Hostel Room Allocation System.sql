

CREATE DATABASE HostelAllocationDB;
USE HostelAllocationDB;

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    branch VARCHAR(50),
    academic_year VARCHAR(20),
    phone VARCHAR(15),
    city VARCHAR(50)
);

CREATE TABLE HostelBlock (
    block_id INT PRIMARY KEY,
    block_name VARCHAR(50),
    total_floors INT,
    warden_name VARCHAR(50)
);

CREATE TABLE Room (
    room_id INT PRIMARY KEY,
    block_id INT,
    room_number VARCHAR(20),
    floor_number INT,
    room_type VARCHAR(30),
    total_beds INT,
    available_beds INT,
    room_status VARCHAR(30),
    FOREIGN KEY (block_id) REFERENCES HostelBlock(block_id)
);

CREATE TABLE BedAllocation (
    allocation_id INT PRIMARY KEY,
    student_id INT,
    room_id INT,
    bed_number VARCHAR(20),
    allocation_date DATE,
    allocation_status VARCHAR(30),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

CREATE TABLE HostelFee (
    fee_id INT PRIMARY KEY,
    student_id INT,
    semester VARCHAR(20),
    total_fee DECIMAL(10,2),
    paid_amount DECIMAL(10,2),
    payment_status VARCHAR(30),
    due_date DATE,
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

CREATE TABLE Complaint (
    complaint_id INT PRIMARY KEY,
    student_id INT,
    room_id INT,
    complaint_type VARCHAR(50),
    complaint_description VARCHAR(255),
    complaint_date DATE,
    complaint_status VARCHAR(30),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

CREATE TABLE MaintenanceRequest (
    maintenance_id INT PRIMARY KEY,
    room_id INT,
    issue_type VARCHAR(50),
    request_date DATE,
    assigned_worker VARCHAR(50),
    maintenance_status VARCHAR(30),
    FOREIGN KEY (room_id) REFERENCES Room(room_id)
);

INSERT INTO Student VALUES
(1, 'Atharva Kedar', 'CSE', 'Third Year', '9999999999', 'Nagpur'),
(2, 'Rohan Mehta', 'IT', 'Second Year', '8888888888', 'Pune'),
(3, 'Aman Verma', 'ENTC', 'First Year', '7777777777', 'Mumbai'),
(4, 'Karan Singh', 'Mechanical', 'Fourth Year', '6666666666', 'Delhi'),
(5, 'Sahil Patil', 'CSE', 'Third Year', '5555555555', 'Nashik');

INSERT INTO HostelBlock VALUES
(1, 'Block A', 4, 'Mr. Sharma'),
(2, 'Block B', 5, 'Mr. Patil'),
(3, 'Block C', 3, 'Mr. Iyer');

INSERT INTO Room VALUES
(1, 1, 'A-101', 1, 'Triple Sharing', 3, 1, 'Available'),
(2, 1, 'A-102', 1, 'Double Sharing', 2, 0, 'Full'),
(3, 2, 'B-201', 2, 'Triple Sharing', 3, 2, 'Available'),
(4, 2, 'B-202', 2, 'Single Room', 1, 0, 'Full'),
(5, 3, 'C-301', 3, 'Double Sharing', 2, 1, 'Maintenance');

INSERT INTO BedAllocation VALUES
(1, 1, 1, 'Bed-1', '2026-04-01', 'Active'),
(2, 2, 1, 'Bed-2', '2026-04-01', 'Active'),
(3, 3, 2, 'Bed-1', '2026-04-02', 'Active'),
(4, 4, 2, 'Bed-2', '2026-04-02', 'Active'),
(5, 5, 4, 'Bed-1', '2026-04-03', 'Active');

INSERT INTO HostelFee VALUES
(1, 1, 'Semester 6', 45000.00, 45000.00, 'Paid', '2026-04-15'),
(2, 2, 'Semester 4', 45000.00, 25000.00, 'Pending', '2026-04-15'),
(3, 3, 'Semester 2', 42000.00, 42000.00, 'Paid', '2026-04-15'),
(4, 4, 'Semester 8', 48000.00, 30000.00, 'Pending', '2026-04-15'),
(5, 5, 'Semester 6', 45000.00, 45000.00, 'Paid', '2026-04-15');

INSERT INTO Complaint VALUES
(1, 1, 1, 'WiFi Issue', 'Internet speed is very slow in the room', '2026-04-20', 'Resolved'),
(2, 2, 1, 'Water Issue', 'No water supply in morning hours', '2026-04-21', 'Pending'),
(3, 3, 2, 'Electricity Issue', 'Fan is not working properly', '2026-04-22', 'Pending'),
(4, 5, 4, 'Cleaning Issue', 'Room cleaning has not been done for two days', '2026-04-23', 'Resolved');

INSERT INTO MaintenanceRequest VALUES
(1, 1, 'Plumbing', '2026-04-21', 'Ramesh Worker', 'Pending'),
(2, 2, 'Electrical', '2026-04-22', 'Suresh Worker', 'In Progress'),
(3, 5, 'Painting', '2026-04-23', 'Amit Worker', 'Pending'),
(4, 4, 'Cleaning', '2026-04-24', 'Vikas Worker', 'Completed');

-- 1. Students currently allocated rooms
SELECT 
    s.student_name,
    s.branch,
    s.academic_year,
    hb.block_name,
    r.room_number,
    ba.bed_number,
    ba.allocation_status
FROM BedAllocation ba
JOIN Student s
ON ba.student_id = s.student_id
JOIN Room r
ON ba.room_id = r.room_id
JOIN HostelBlock hb
ON r.block_id = hb.block_id
WHERE ba.allocation_status = 'Active';

-- 2. Rooms with available beds
SELECT 
    hb.block_name,
    r.room_number,
    r.room_type,
    r.total_beds,
    r.available_beds,
    r.room_status
FROM Room r
JOIN HostelBlock hb
ON r.block_id = hb.block_id
WHERE r.available_beds > 0
AND r.room_status = 'Available';

-- 3. Students with pending hostel fees
SELECT 
    s.student_name,
    s.branch,
    hf.semester,
    hf.total_fee,
    hf.paid_amount,
    (hf.total_fee - hf.paid_amount) AS pending_amount,
    hf.due_date
FROM HostelFee hf
JOIN Student s
ON hf.student_id = s.student_id
WHERE hf.payment_status = 'Pending';

-- 4. Occupied beds by hostel block
SELECT 
    hb.block_name,
    COUNT(ba.allocation_id) AS occupied_beds
FROM BedAllocation ba
JOIN Room r
ON ba.room_id = r.room_id
JOIN HostelBlock hb
ON r.block_id = hb.block_id
WHERE ba.allocation_status = 'Active'
GROUP BY hb.block_name
ORDER BY occupied_beds DESC;

-- 5. Unresolved complaints
SELECT 
    c.complaint_id,
    s.student_name,
    r.room_number,
    c.complaint_type,
    c.complaint_description,
    c.complaint_date,
    c.complaint_status
FROM Complaint c
JOIN Student s
ON c.student_id = s.student_id
JOIN Room r
ON c.room_id = r.room_id
WHERE c.complaint_status = 'Pending';

-- 6. Rooms needing maintenance
SELECT 
    hb.block_name,
    r.room_number,
    mr.issue_type,
    mr.request_date,
    mr.assigned_worker,
    mr.maintenance_status
FROM MaintenanceRequest mr
JOIN Room r
ON mr.room_id = r.room_id
JOIN HostelBlock hb
ON r.block_id = hb.block_id
WHERE mr.maintenance_status IN ('Pending', 'In Progress');

-- 7. Hostel fee collection summary
SELECT 
    SUM(total_fee) AS total_expected_fee,
    SUM(paid_amount) AS total_collected_fee,
    SUM(total_fee - paid_amount) AS total_pending_fee
FROM HostelFee;

-- 8. Room occupancy percentage
SELECT 
    hb.block_name,
    r.room_number,
    r.total_beds,
    r.available_beds,
    (r.total_beds - r.available_beds) AS occupied_beds,
    ROUND(((r.total_beds - r.available_beds) * 100.0 / r.total_beds), 2) AS occupancy_percentage
FROM Room r
JOIN HostelBlock hb
ON r.block_id = hb.block_id;
