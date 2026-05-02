CREATE DATABASE SmartClassroomDB;
USE SmartClassroomDB;

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    department VARCHAR(50),
    semester INT,
    email VARCHAR(80)
);

CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY,
    faculty_name VARCHAR(50),
    department VARCHAR(50),
    specialization VARCHAR(50)
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(80),
    department VARCHAR(50),
    semester INT
);

CREATE TABLE Classroom (
    classroom_id INT PRIMARY KEY,
    room_number VARCHAR(20),
    building_name VARCHAR(50),
    capacity INT,
    classroom_type VARCHAR(40),
    room_status VARCHAR(30)
);

CREATE TABLE ClassSchedule (
    schedule_id INT PRIMARY KEY,
    course_id INT,
    faculty_id INT,
    classroom_id INT,
    class_date DATE,
    start_time VARCHAR(20),
    end_time VARCHAR(20),
    class_status VARCHAR(30),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id),
    FOREIGN KEY (classroom_id) REFERENCES Classroom(classroom_id)
);

CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY,
    student_id INT,
    schedule_id INT,
    attendance_status VARCHAR(20),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (schedule_id) REFERENCES ClassSchedule(schedule_id)
);

CREATE TABLE Resource (
    resource_id INT PRIMARY KEY,
    classroom_id INT,
    resource_name VARCHAR(50),
    resource_type VARCHAR(50),
    resource_status VARCHAR(30),
    FOREIGN KEY (classroom_id) REFERENCES Classroom(classroom_id)
);

CREATE TABLE ResourceBooking (
    booking_id INT PRIMARY KEY,
    resource_id INT,
    faculty_id INT,
    booking_date DATE,
    booking_status VARCHAR(30),
    purpose VARCHAR(100),
    FOREIGN KEY (resource_id) REFERENCES Resource(resource_id),
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id)
);

CREATE TABLE LabBooking (
    lab_booking_id INT PRIMARY KEY,
    classroom_id INT,
    faculty_id INT,
    booking_date DATE,
    time_slot VARCHAR(30),
    lab_booking_status VARCHAR(30),
    purpose VARCHAR(100),
    FOREIGN KEY (classroom_id) REFERENCES Classroom(classroom_id),
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id)
);

INSERT INTO Student VALUES
(1, 'Atharva Kedar', 'Computer Science', 5, 'atharva@email.com'),
(2, 'Neha Sharma', 'Computer Science', 5, 'neha@email.com'),
(3, 'Rohan Mehta', 'Information Technology', 5, 'rohan@email.com'),
(4, 'Priya Patil', 'Computer Science', 5, 'priya@email.com'),
(5, 'Amit Verma', 'Information Technology', 5, 'amit@email.com');

INSERT INTO Faculty VALUES
(1, 'Dr. Meera Joshi', 'Computer Science', 'Database Systems'),
(2, 'Prof. Raj Malhotra', 'Computer Science', 'Artificial Intelligence'),
(3, 'Dr. Sara Khan', 'Information Technology', 'Computer Networks');

INSERT INTO Course VALUES
(1, 'Database Management System', 'Computer Science', 5),
(2, 'Artificial Intelligence', 'Computer Science', 5),
(3, 'Computer Networks', 'Information Technology', 5),
(4, 'Operating Systems', 'Computer Science', 5);

INSERT INTO Classroom VALUES
(1, 'A-101', 'Main Block', 60, 'Smart Classroom', 'Available'),
(2, 'A-102', 'Main Block', 55, 'Smart Classroom', 'Available'),
(3, 'LAB-201', 'Tech Block', 40, 'Computer Lab', 'Available'),
(4, 'LAB-202', 'Tech Block', 35, 'Computer Lab', 'Under Maintenance');

INSERT INTO ClassSchedule VALUES
(1, 1, 1, 1, '2026-04-01', '09:00', '10:00', 'Completed'),
(2, 2, 2, 2, '2026-04-01', '10:00', '11:00', 'Completed'),
(3, 3, 3, 3, '2026-04-02', '11:00', '12:00', 'Completed'),
(4, 4, 1, 1, '2026-04-03', '12:00', '13:00', 'Scheduled'),
(5, 1, 1, 3, '2026-04-04', '14:00', '15:00', 'Completed');

INSERT INTO Attendance VALUES
(1, 1, 1, 'Present'),
(2, 2, 1, 'Present'),
(3, 3, 1, 'Absent'),
(4, 4, 1, 'Present'),
(5, 5, 1, 'Absent'),
(6, 1, 2, 'Present'),
(7, 2, 2, 'Absent'),
(8, 3, 2, 'Present'),
(9, 4, 2, 'Present'),
(10, 5, 2, 'Present'),
(11, 1, 3, 'Absent'),
(12, 2, 3, 'Present'),
(13, 3, 3, 'Present'),
(14, 4, 3, 'Absent'),
(15, 5, 3, 'Present'),
(16, 1, 5, 'Present'),
(17, 2, 5, 'Present'),
(18, 3, 5, 'Absent'),
(19, 4, 5, 'Present'),
(20, 5, 5, 'Present');

INSERT INTO Resource VALUES
(1, 1, 'Smart Board', 'Teaching Device', 'Working'),
(2, 1, 'Projector', 'Display Device', 'Working'),
(3, 2, 'Projector', 'Display Device', 'Working'),
(4, 2, 'Audio System', 'Sound Device', 'Faulty'),
(5, 3, 'Python Lab PCs', 'Computer System', 'Working'),
(6, 4, 'Network Lab Router Kit', 'Networking Equipment', 'Under Maintenance');

INSERT INTO ResourceBooking VALUES
(1, 1, 1, '2026-04-01', 'Approved', 'DBMS smart board lecture'),
(2, 2, 2, '2026-04-01', 'Approved', 'AI presentation'),
(3, 5, 3, '2026-04-02', 'Approved', 'Networking lab practice'),
(4, 4, 2, '2026-04-03', 'Pending', 'AI seminar audio setup'),
(5, 6, 3, '2026-04-04', 'Rejected', 'Router lab session');

INSERT INTO LabBooking VALUES
(1, 3, 1, '2026-04-04', '14:00-16:00', 'Approved', 'SQL practical session'),
(2, 4, 3, '2026-04-05', '10:00-12:00', 'Pending', 'Network configuration lab'),
(3, 3, 2, '2026-04-06', '12:00-14:00', 'Approved', 'AI model demo'),
(4, 4, 1, '2026-04-07', '09:00-11:00', 'Pending', 'OS lab practice');

-- 1. Students with low attendance
SELECT 
    s.student_name,
    COUNT(a.attendance_id) AS total_classes,
    SUM(CASE WHEN a.attendance_status = 'Present' THEN 1 ELSE 0 END) AS attended_classes,
    ROUND(
        SUM(CASE WHEN a.attendance_status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.attendance_id),
        2
    ) AS attendance_percentage
FROM Attendance a
JOIN Student s
ON a.student_id = s.student_id
GROUP BY s.student_name
HAVING attendance_percentage < 75
ORDER BY attendance_percentage ASC;

-- 2. Most used classrooms
SELECT 
    c.room_number,
    c.building_name,
    c.classroom_type,
    COUNT(cs.schedule_id) AS total_classes
FROM ClassSchedule cs
JOIN Classroom c
ON cs.classroom_id = c.classroom_id
GROUP BY c.room_number, c.building_name, c.classroom_type
ORDER BY total_classes DESC;

-- 3. Faculty teaching most classes
SELECT 
    f.faculty_name,
    f.department,
    COUNT(cs.schedule_id) AS total_classes
FROM ClassSchedule cs
JOIN Faculty f
ON cs.faculty_id = f.faculty_id
GROUP BY f.faculty_name, f.department
ORDER BY total_classes DESC;

-- 4. Most booked resources
SELECT 
    r.resource_name,
    r.resource_type,
    COUNT(rb.booking_id) AS total_bookings
FROM ResourceBooking rb
JOIN Resource r
ON rb.resource_id = r.resource_id
GROUP BY r.resource_name, r.resource_type
ORDER BY total_bookings DESC;

-- 5. Pending lab bookings
SELECT 
    lb.lab_booking_id,
    c.room_number,
    c.classroom_type,
    f.faculty_name,
    lb.booking_date,
    lb.time_slot,
    lb.purpose
FROM LabBooking lb
JOIN Classroom c
ON lb.classroom_id = c.classroom_id
JOIN Faculty f
ON lb.faculty_id = f.faculty_id
WHERE lb.lab_booking_status = 'Pending';

-- 6. Attendance percentage of each student
SELECT 
    s.student_name,
    s.department,
    COUNT(a.attendance_id) AS total_classes,
    SUM(CASE WHEN a.attendance_status = 'Present' THEN 1 ELSE 0 END) AS attended_classes,
    ROUND(
        SUM(CASE WHEN a.attendance_status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.attendance_id),
        2
    ) AS attendance_percentage
FROM Attendance a
JOIN Student s
ON a.student_id = s.student_id
GROUP BY s.student_name, s.department
ORDER BY attendance_percentage DESC;

-- 7. Courses with highest attendance
SELECT 
    co.course_name,
    COUNT(a.attendance_id) AS total_records,
    SUM(CASE WHEN a.attendance_status = 'Present' THEN 1 ELSE 0 END) AS present_count
FROM Attendance a
JOIN ClassSchedule cs
ON a.schedule_id = cs.schedule_id
JOIN Course co
ON cs.course_id = co.course_id
GROUP BY co.course_name
ORDER BY present_count DESC;

-- 8. Smart classrooms with working resources
SELECT 
    c.room_number,
    c.building_name,
    r.resource_name,
    r.resource_status
FROM Classroom c
JOIN Resource r
ON c.classroom_id = r.classroom_id
WHERE c.classroom_type = 'Smart Classroom'
AND r.resource_status = 'Working';

-- 9. Faulty or maintenance resources
SELECT 
    c.room_number,
    r.resource_name,
    r.resource_type,
    r.resource_status
FROM Resource r
JOIN Classroom c
ON r.classroom_id = c.classroom_id
WHERE r.resource_status IN ('Faulty', 'Under Maintenance');

-- 10. Faculty resource booking summary
SELECT 
    f.faculty_name,
    COUNT(rb.booking_id) AS total_resource_bookings
FROM ResourceBooking rb
JOIN Faculty f
ON rb.faculty_id = f.faculty_id
GROUP BY f.faculty_name
ORDER BY total_resource_bookings DESC;