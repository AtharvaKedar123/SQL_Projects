
CREATE DATABASE SmartLibraryDB;
USE SmartLibraryDB;

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(80),
    department VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(80)
);

CREATE TABLE LibraryZone (
    zone_id INT PRIMARY KEY,
    zone_name VARCHAR(80),
    floor_number INT,
    zone_type VARCHAR(50)
);

CREATE TABLE Seat (
    seat_id INT PRIMARY KEY,
    zone_id INT,
    seat_number VARCHAR(20),
    seat_type VARCHAR(40),
    seat_status VARCHAR(30),
    FOREIGN KEY (zone_id) REFERENCES LibraryZone(zone_id)
);

CREATE TABLE StudyRoom (
    room_id INT PRIMARY KEY,
    zone_id INT,
    room_number VARCHAR(20),
    capacity INT,
    room_status VARCHAR(30),
    FOREIGN KEY (zone_id) REFERENCES LibraryZone(zone_id)
);

CREATE TABLE BookingSlot (
    slot_id INT PRIMARY KEY,
    slot_date DATE,
    start_time TIME,
    end_time TIME
);

CREATE TABLE SeatBooking (
    seat_booking_id INT PRIMARY KEY,
    student_id INT,
    seat_id INT,
    slot_id INT,
    booking_status VARCHAR(30),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (seat_id) REFERENCES Seat(seat_id),
    FOREIGN KEY (slot_id) REFERENCES BookingSlot(slot_id)
);

CREATE TABLE RoomBooking (
    room_booking_id INT PRIMARY KEY,
    student_id INT,
    room_id INT,
    slot_id INT,
    purpose VARCHAR(100),
    booking_status VARCHAR(30),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (room_id) REFERENCES StudyRoom(room_id),
    FOREIGN KEY (slot_id) REFERENCES BookingSlot(slot_id)
);

CREATE TABLE CheckIn (
    checkin_id INT PRIMARY KEY,
    student_id INT,
    seat_booking_id INT,
    room_booking_id INT,
    checkin_time DATETIME,
    checkout_time DATETIME,
    attendance_status VARCHAR(30),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (seat_booking_id) REFERENCES SeatBooking(seat_booking_id),
    FOREIGN KEY (room_booking_id) REFERENCES RoomBooking(room_booking_id)
);

INSERT INTO Student VALUES
(1, 'Atharva Kedar', 'Computer Science', '9999999999', 'atharva@email.com'),
(2, 'Rohan Mehta', 'Mechanical', '8888888888', 'rohan@email.com'),
(3, 'Sneha Patil', 'Electronics', '7777777777', 'sneha@email.com'),
(4, 'Priya Sharma', 'Civil', '6666666666', 'priya@email.com'),
(5, 'Aman Khan', 'IT', '5555555555', 'aman@email.com');

INSERT INTO LibraryZone VALUES
(1, 'Silent Study Zone', 1, 'Individual Study'),
(2, 'Group Discussion Zone', 2, 'Group Study'),
(3, 'Digital Learning Zone', 3, 'Computer Access');

INSERT INTO Seat VALUES
(1, 1, 'S-A1', 'Silent Seat', 'Available'),
(2, 1, 'S-A2', 'Silent Seat', 'Booked'),
(3, 1, 'S-A3', 'Silent Seat', 'Available'),
(4, 2, 'G-B1', 'Group Seat', 'Booked'),
(5, 2, 'G-B2', 'Group Seat', 'Available'),
(6, 3, 'D-C1', 'Computer Seat', 'Maintenance');

INSERT INTO StudyRoom VALUES
(1, 2, 'R-201', 6, 'Booked'),
(2, 2, 'R-202', 8, 'Available'),
(3, 3, 'R-301', 4, 'Booked'),
(4, 3, 'R-302', 5, 'Maintenance');

INSERT INTO BookingSlot VALUES
(1, '2026-04-29', '09:00:00', '11:00:00'),
(2, '2026-04-29', '11:00:00', '13:00:00'),
(3, '2026-04-29', '14:00:00', '16:00:00'),
(4, '2026-04-30', '10:00:00', '12:00:00'),
(5, '2026-04-30', '15:00:00', '17:00:00');

INSERT INTO SeatBooking VALUES
(1, 1, 2, 1, 'Checked-In'),
(2, 2, 4, 2, 'No-Show'),
(3, 3, 1, 3, 'Confirmed'),
(4, 4, 5, 4, 'Cancelled'),
(5, 5, 3, 5, 'Completed');

INSERT INTO RoomBooking VALUES
(1, 1, 1, 2, 'Project Discussion', 'Checked-In'),
(2, 2, 3, 3, 'Exam Preparation', 'Confirmed'),
(3, 3, 2, 4, 'Group Assignment', 'Completed'),
(4, 4, 1, 5, 'Research Meeting', 'No-Show');

INSERT INTO CheckIn VALUES
(1, 1, 1, NULL, '2026-04-29 09:05:00', '2026-04-29 11:00:00', 'Present'),
(2, 1, NULL, 1, '2026-04-29 11:05:00', '2026-04-29 13:00:00', 'Present'),
(3, 5, 5, NULL, '2026-04-30 15:02:00', '2026-04-30 17:00:00', 'Present'),
(4, 2, 2, NULL, NULL, NULL, 'No-Show'),
(5, 4, NULL, 4, NULL, NULL, 'No-Show');

-- 1. Show all seats with zone details
SELECT 
    s.seat_id,
    s.seat_number,
    s.seat_type,
    s.seat_status,
    lz.zone_name,
    lz.floor_number
FROM Seat s
JOIN LibraryZone lz
ON s.zone_id = lz.zone_id;

-- 2. Show currently available seats
SELECT 
    s.seat_number,
    s.seat_type,
    lz.zone_name,
    lz.floor_number
FROM Seat s
JOIN LibraryZone lz
ON s.zone_id = lz.zone_id
WHERE s.seat_status = 'Available';

-- 3. Show study rooms booked today
SELECT 
    rb.room_booking_id,
    sr.room_number,
    sr.capacity,
    st.student_name,
    bs.slot_date,
    bs.start_time,
    bs.end_time,
    rb.purpose,
    rb.booking_status
FROM RoomBooking rb
JOIN StudyRoom sr
ON rb.room_id = sr.room_id
JOIN Student st
ON rb.student_id = st.student_id
JOIN BookingSlot bs
ON rb.slot_id = bs.slot_id
WHERE bs.slot_date = '2026-04-29'
  AND rb.booking_status IN ('Checked-In', 'Confirmed');

-- 4. Students with highest number of bookings
SELECT 
    st.student_name,
    COUNT(sb.seat_booking_id) + COUNT(rb.room_booking_id) AS total_bookings
FROM Student st
LEFT JOIN SeatBooking sb
ON st.student_id = sb.student_id
LEFT JOIN RoomBooking rb
ON st.student_id = rb.student_id
GROUP BY st.student_name
ORDER BY total_bookings DESC;

-- 5. No-show bookings
SELECT 
    st.student_name,
    'Seat Booking' AS booking_type,
    sb.seat_booking_id AS booking_id,
    bs.slot_date,
    bs.start_time,
    bs.end_time,
    sb.booking_status
FROM SeatBooking sb
JOIN Student st
ON sb.student_id = st.student_id
JOIN BookingSlot bs
ON sb.slot_id = bs.slot_id
WHERE sb.booking_status = 'No-Show'

UNION ALL

SELECT 
    st.student_name,
    'Room Booking' AS booking_type,
    rb.room_booking_id AS booking_id,
    bs.slot_date,
    bs.start_time,
    bs.end_time,
    rb.booking_status
FROM RoomBooking rb
JOIN Student st
ON rb.student_id = st.student_id
JOIN BookingSlot bs
ON rb.slot_id = bs.slot_id
WHERE rb.booking_status = 'No-Show';

-- 6. Count available seats in each zone
SELECT 
    lz.zone_name,
    COUNT(s.seat_id) AS available_seats
FROM Seat s
JOIN LibraryZone lz
ON s.zone_id = lz.zone_id
WHERE s.seat_status = 'Available'
GROUP BY lz.zone_name;

-- 7. Most used study rooms
SELECT 
    sr.room_number,
    COUNT(rb.room_booking_id) AS total_bookings
FROM RoomBooking rb
JOIN StudyRoom sr
ON rb.room_id = sr.room_id
GROUP BY sr.room_number
ORDER BY total_bookings DESC;

-- 8. Successfully checked-in students
SELECT 
    c.checkin_id,
    st.student_name,
    c.checkin_time,
    c.checkout_time,
    c.attendance_status
FROM CheckIn c
JOIN Student st
ON c.student_id = st.student_id
WHERE c.attendance_status = 'Present';

-- 9. Room availability status
SELECT 
    sr.room_number,
    sr.capacity,
    lz.zone_name,
    sr.room_status
FROM StudyRoom sr
JOIN LibraryZone lz
ON sr.zone_id = lz.zone_id
ORDER BY sr.room_status;

-- 10. Update a seat after cancellation
UPDATE Seat
SET seat_status = 'Available'
WHERE seat_id = 4;
