

CREATE DATABASE MentalWellnessDB;
USE MentalWellnessDB;

CREATE TABLE WellnessUser (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    city VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(80)
);

CREATE TABLE Counselor (
    counselor_id INT PRIMARY KEY,
    counselor_name VARCHAR(50),
    specialization VARCHAR(80),
    experience_years INT,
    phone VARCHAR(15),
    consultation_fee DECIMAL(10,2)
);

CREATE TABLE SessionBooking (
    booking_id INT PRIMARY KEY,
    user_id INT,
    counselor_id INT,
    session_date DATE,
    session_time TIME,
    session_mode VARCHAR(30),
    session_status VARCHAR(30),
    FOREIGN KEY (user_id) REFERENCES WellnessUser(user_id),
    FOREIGN KEY (counselor_id) REFERENCES Counselor(counselor_id)
);

CREATE TABLE SessionPayment (
    payment_id INT PRIMARY KEY,
    booking_id INT,
    payment_amount DECIMAL(10,2),
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    payment_date DATE,
    FOREIGN KEY (booking_id) REFERENCES SessionBooking(booking_id)
);

CREATE TABLE SessionFeedback (
    feedback_id INT PRIMARY KEY,
    booking_id INT,
    rating INT,
    feedback_comment VARCHAR(255),
    feedback_date DATE,
    FOREIGN KEY (booking_id) REFERENCES SessionBooking(booking_id)
);

INSERT INTO WellnessUser VALUES
(1, 'Rahul Sharma', 24, 'Male', 'Nagpur', '9999999999', 'rahul@email.com'),
(2, 'Sneha Patil', 27, 'Female', 'Pune', '8888888888', 'sneha@email.com'),
(3, 'Aman Verma', 22, 'Male', 'Mumbai', '7777777777', 'aman@email.com'),
(4, 'Priya Mehta', 29, 'Female', 'Delhi', '6666666666', 'priya@email.com'),
(5, 'Atharva Kedar', 23, 'Male', 'Nagpur', '5555555555', 'atharva@email.com');

INSERT INTO Counselor VALUES
(1, 'Dr. Anjali Rao', 'Stress Management', 8, '9000011111', 1200.00),
(2, 'Dr. Karan Mehta', 'Anxiety Support', 10, '9000022222', 1500.00),
(3, 'Dr. Nisha Sharma', 'Career Counseling', 6, '9000033333', 1000.00),
(4, 'Dr. Rohan Iyer', 'Relationship Counseling', 9, '9000044444', 1400.00),
(5, 'Dr. Meera Singh', 'Mindfulness Coaching', 7, '9000055555', 1100.00);

INSERT INTO SessionBooking VALUES
(1, 1, 1, '2026-05-01', '10:00:00', 'Online', 'Upcoming'),
(2, 2, 2, '2026-05-02', '11:00:00', 'Offline', 'Upcoming'),
(3, 3, 3, '2026-04-25', '15:00:00', 'Online', 'Completed'),
(4, 4, 4, '2026-04-26', '16:00:00', 'Offline', 'Completed'),
(5, 5, 5, '2026-04-27', '18:00:00', 'Online', 'Completed'),
(6, 1, 2, '2026-05-03', '12:00:00', 'Online', 'Upcoming');

INSERT INTO SessionPayment VALUES
(1, 1, 1200.00, 'UPI', 'Paid', '2026-04-29'),
(2, 2, 1500.00, 'Card', 'Pending', NULL),
(3, 3, 1000.00, 'UPI', 'Paid', '2026-04-25'),
(4, 4, 1400.00, 'Cash', 'Paid', '2026-04-26'),
(5, 5, 1100.00, 'UPI', 'Paid', '2026-04-27'),
(6, 6, 1500.00, 'Net Banking', 'Pending', NULL);

INSERT INTO SessionFeedback VALUES
(1, 3, 5, 'Very helpful career guidance', '2026-04-25'),
(2, 4, 4, 'Good session and practical advice', '2026-04-26'),
(3, 5, 5, 'Calming and useful mindfulness tips', '2026-04-27');

-- 1. Upcoming sessions
SELECT 
    sb.booking_id,
    wu.user_name,
    c.counselor_name,
    c.specialization,
    sb.session_date,
    sb.session_time,
    sb.session_mode,
    sb.session_status
FROM SessionBooking sb
JOIN WellnessUser wu
ON sb.user_id = wu.user_id
JOIN Counselor c
ON sb.counselor_id = c.counselor_id
WHERE sb.session_status = 'Upcoming'
ORDER BY sb.session_date, sb.session_time;

-- 2. Counselors with most bookings
SELECT 
    c.counselor_name,
    c.specialization,
    COUNT(sb.booking_id) AS total_bookings
FROM SessionBooking sb
JOIN Counselor c
ON sb.counselor_id = c.counselor_id
GROUP BY c.counselor_name, c.specialization
ORDER BY total_bookings DESC;

-- 3. Users with pending payments
SELECT 
    wu.user_name,
    c.counselor_name,
    sb.session_date,
    sp.payment_amount,
    sp.payment_status
FROM SessionPayment sp
JOIN SessionBooking sb
ON sp.booking_id = sb.booking_id
JOIN WellnessUser wu
ON sb.user_id = wu.user_id
JOIN Counselor c
ON sb.counselor_id = c.counselor_id
WHERE sp.payment_status = 'Pending';

-- 4. Counselor feedback rating
SELECT 
    c.counselor_name,
    c.specialization,
    AVG(sf.rating) AS average_rating
FROM SessionFeedback sf
JOIN SessionBooking sb
ON sf.booking_id = sb.booking_id
JOIN Counselor c
ON sb.counselor_id = c.counselor_id
GROUP BY c.counselor_name, c.specialization
ORDER BY average_rating DESC;

-- 5. Total revenue generated
SELECT 
    SUM(payment_amount) AS total_revenue
FROM SessionPayment
WHERE payment_status = 'Paid';

-- 6. Preferred session mode
SELECT 
    session_mode,
    COUNT(booking_id) AS total_sessions
FROM SessionBooking
GROUP BY session_mode
ORDER BY total_sessions DESC;

-- 7. Completed sessions with feedback
SELECT 
    wu.user_name,
    c.counselor_name,
    c.specialization,
    sb.session_date,
    sf.rating,
    sf.feedback_comment
FROM SessionFeedback sf
JOIN SessionBooking sb
ON sf.booking_id = sb.booking_id
JOIN WellnessUser wu
ON sb.user_id = wu.user_id
JOIN Counselor c
ON sb.counselor_id = c.counselor_id;

-- 8. Counselor revenue report
SELECT 
    c.counselor_name,
    c.specialization,
    SUM(sp.payment_amount) AS revenue_generated
FROM SessionPayment sp
JOIN SessionBooking sb
ON sp.booking_id = sb.booking_id
JOIN Counselor c
ON sb.counselor_id = c.counselor_id
WHERE sp.payment_status = 'Paid'
GROUP BY c.counselor_name, c.specialization
ORDER BY revenue_generated DESC;
