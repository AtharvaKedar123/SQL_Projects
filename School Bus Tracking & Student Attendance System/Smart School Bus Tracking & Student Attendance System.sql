

CREATE DATABASE SchoolBusTrackingDB;
USE SchoolBusTrackingDB;

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    class_name VARCHAR(20),
    section VARCHAR(10),
    parent_name VARCHAR(50),
    parent_phone VARCHAR(15)
);

CREATE TABLE Driver (
    driver_id INT PRIMARY KEY,
    driver_name VARCHAR(50),
    phone VARCHAR(15),
    license_number VARCHAR(50)
);

CREATE TABLE Bus (
    bus_id INT PRIMARY KEY,
    bus_number VARCHAR(30),
    capacity INT,
    driver_id INT,
    bus_status VARCHAR(30),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);

CREATE TABLE BusRoute (
    route_id INT PRIMARY KEY,
    route_name VARCHAR(50),
    start_location VARCHAR(80),
    end_location VARCHAR(80),
    estimated_time_minutes INT
);

CREATE TABLE PickupPoint (
    point_id INT PRIMARY KEY,
    route_id INT,
    point_name VARCHAR(80),
    pickup_time TIME,
    drop_time TIME,
    stop_order INT,
    FOREIGN KEY (route_id) REFERENCES BusRoute(route_id)
);

CREATE TABLE StudentRouteAssignment (
    assignment_id INT PRIMARY KEY,
    student_id INT,
    bus_id INT,
    route_id INT,
    point_id INT,
    assignment_status VARCHAR(30),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (bus_id) REFERENCES Bus(bus_id),
    FOREIGN KEY (route_id) REFERENCES BusRoute(route_id),
    FOREIGN KEY (point_id) REFERENCES PickupPoint(point_id)
);

CREATE TABLE BusTrip (
    trip_id INT PRIMARY KEY,
    bus_id INT,
    route_id INT,
    trip_date DATE,
    trip_type VARCHAR(30),
    start_time TIME,
    end_time TIME,
    trip_status VARCHAR(30),
    delay_minutes INT,
    FOREIGN KEY (bus_id) REFERENCES Bus(bus_id),
    FOREIGN KEY (route_id) REFERENCES BusRoute(route_id)
);

CREATE TABLE BusAttendance (
    attendance_id INT PRIMARY KEY,
    trip_id INT,
    student_id INT,
    boarding_time TIME,
    drop_time TIME,
    attendance_status VARCHAR(30),
    FOREIGN KEY (trip_id) REFERENCES BusTrip(trip_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

INSERT INTO Student VALUES
(1, 'Rahul Sharma', '8th', 'A', 'Mr. Sharma', '9999999999'),
(2, 'Sneha Patil', '7th', 'B', 'Mrs. Patil', '8888888888'),
(3, 'Aman Verma', '9th', 'A', 'Mr. Verma', '7777777777'),
(4, 'Priya Mehta', '6th', 'C', 'Mrs. Mehta', '6666666666'),
(5, 'Atharva Kedar', '10th', 'A', 'Mr. Kedar', '5555555555');

INSERT INTO Driver VALUES
(1, 'Ramesh Yadav', '9000011111', 'DL-BUS-1001'),
(2, 'Suresh Patil', '9000022222', 'DL-BUS-1002'),
(3, 'Amit Verma', '9000033333', 'DL-BUS-1003');

INSERT INTO Bus VALUES
(1, 'BUS-101', 40, 1, 'On Route'),
(2, 'BUS-102', 35, 2, 'Available'),
(3, 'BUS-103', 45, 3, 'On Route');

INSERT INTO BusRoute VALUES
(1, 'Route A', 'Civil Lines', 'School Campus', 45),
(2, 'Route B', 'Dharampeth', 'School Campus', 50),
(3, 'Route C', 'Manish Nagar', 'School Campus', 60);

INSERT INTO PickupPoint VALUES
(1, 1, 'Civil Lines Square', '07:10:00', '15:30:00', 1),
(2, 1, 'Sadar Bus Stop', '07:20:00', '15:20:00', 2),
(3, 2, 'Dharampeth Market', '07:15:00', '15:25:00', 1),
(4, 2, 'Law College Square', '07:25:00', '15:15:00', 2),
(5, 3, 'Manish Nagar Gate', '07:05:00', '15:35:00', 1);

INSERT INTO StudentRouteAssignment VALUES
(1, 1, 1, 1, 1, 'Active'),
(2, 2, 1, 1, 2, 'Active'),
(3, 3, 2, 2, 3, 'Active'),
(4, 4, 2, 2, 4, 'Active'),
(5, 5, 3, 3, 5, 'Active');

INSERT INTO BusTrip VALUES
(1, 1, 1, '2026-04-29', 'Morning Pickup', '07:00:00', '07:55:00', 'Completed', 10),
(2, 2, 2, '2026-04-29', 'Morning Pickup', '07:05:00', NULL, 'On Route', 0),
(3, 3, 3, '2026-04-29', 'Morning Pickup', '07:00:00', NULL, 'On Route', 15),
(4, 1, 1, '2026-04-28', 'Evening Drop', '15:00:00', '15:50:00', 'Completed', 0);

INSERT INTO BusAttendance VALUES
(1, 1, 1, '07:12:00', NULL, 'Boarded'),
(2, 1, 2, NULL, NULL, 'Absent'),
(3, 2, 3, '07:16:00', NULL, 'Boarded'),
(4, 2, 4, NULL, NULL, 'Absent'),
(5, 3, 5, '07:08:00', NULL, 'Boarded');

-- 1. Students who boarded the bus today
SELECT 
    s.student_name,
    s.class_name,
    s.section,
    b.bus_number,
    br.route_name,
    ba.boarding_time,
    ba.attendance_status
FROM BusAttendance ba
JOIN Student s
ON ba.student_id = s.student_id
JOIN BusTrip bt
ON ba.trip_id = bt.trip_id
JOIN Bus b
ON bt.bus_id = b.bus_id
JOIN BusRoute br
ON bt.route_id = br.route_id
WHERE bt.trip_date = '2026-04-29'
AND ba.attendance_status = 'Boarded';

-- 2. Students absent during pickup
SELECT 
    s.student_name,
    s.class_name,
    s.section,
    s.parent_name,
    s.parent_phone,
    bt.trip_date,
    br.route_name
FROM BusAttendance ba
JOIN Student s
ON ba.student_id = s.student_id
JOIN BusTrip bt
ON ba.trip_id = bt.trip_id
JOIN BusRoute br
ON bt.route_id = br.route_id
WHERE bt.trip_date = '2026-04-29'
AND ba.attendance_status = 'Absent';

-- 3. Buses currently on route
SELECT 
    b.bus_number,
    d.driver_name,
    d.phone,
    br.route_name,
    bt.trip_type,
    bt.trip_status
FROM BusTrip bt
JOIN Bus b
ON bt.bus_id = b.bus_id
JOIN Driver d
ON b.driver_id = d.driver_id
JOIN BusRoute br
ON bt.route_id = br.route_id
WHERE bt.trip_status = 'On Route';

-- 4. Route-wise student count
SELECT 
    br.route_name,
    COUNT(sra.student_id) AS total_students
FROM StudentRouteAssignment sra
JOIN BusRoute br
ON sra.route_id = br.route_id
WHERE sra.assignment_status = 'Active'
GROUP BY br.route_name
ORDER BY total_students DESC;

-- 5. Delayed bus trips
SELECT 
    b.bus_number,
    br.route_name,
    bt.trip_date,
    bt.trip_type,
    bt.delay_minutes,
    bt.trip_status
FROM BusTrip bt
JOIN Bus b
ON bt.bus_id = b.bus_id
JOIN BusRoute br
ON bt.route_id = br.route_id
WHERE bt.delay_minutes > 0;

-- 6. Complete bus attendance report
SELECT 
    bt.trip_date,
    bt.trip_type,
    b.bus_number,
    br.route_name,
    s.student_name,
    s.class_name,
    pp.point_name,
    ba.boarding_time,
    ba.drop_time,
    ba.attendance_status
FROM BusAttendance ba
JOIN BusTrip bt
ON ba.trip_id = bt.trip_id
JOIN Bus b
ON bt.bus_id = b.bus_id
JOIN BusRoute br
ON bt.route_id = br.route_id
JOIN Student s
ON ba.student_id = s.student_id
JOIN StudentRouteAssignment sra
ON s.student_id = sra.student_id
JOIN PickupPoint pp
ON sra.point_id = pp.point_id
ORDER BY bt.trip_date, b.bus_number, pp.stop_order;

-- 7. Bus capacity utilization
SELECT 
    b.bus_number,
    b.capacity,
    COUNT(sra.student_id) AS assigned_students,
    ROUND((COUNT(sra.student_id) * 100.0 / b.capacity), 2) AS capacity_used_percent
FROM Bus b
LEFT JOIN StudentRouteAssignment sra
ON b.bus_id = sra.bus_id
GROUP BY b.bus_number, b.capacity;

-- 8. Pickup point-wise students
SELECT 
    br.route_name,
    pp.point_name,
    pp.pickup_time,
    COUNT(sra.student_id) AS total_students
FROM StudentRouteAssignment sra
JOIN PickupPoint pp
ON sra.point_id = pp.point_id
JOIN BusRoute br
ON pp.route_id = br.route_id
GROUP BY br.route_name, pp.point_name, pp.pickup_time
ORDER BY br.route_name, pp.pickup_time;
