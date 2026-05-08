

CREATE DATABASE EventTicketDB;
USE EventTicketDB;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(80),
    city VARCHAR(50)
);

CREATE TABLE Venue (
    venue_id INT PRIMARY KEY,
    venue_name VARCHAR(80),
    city VARCHAR(50),
    total_capacity INT
);

CREATE TABLE Event (
    event_id INT PRIMARY KEY,
    venue_id INT,
    event_name VARCHAR(100),
    event_type VARCHAR(50),
    event_date DATE,
    event_time TIME,
    FOREIGN KEY (venue_id) REFERENCES Venue(venue_id)
);

CREATE TABLE Seat (
    seat_id INT PRIMARY KEY,
    venue_id INT,
    seat_number VARCHAR(20),
    seat_category VARCHAR(30),
    seat_price DECIMAL(10,2),
    seat_status VARCHAR(30),
    FOREIGN KEY (venue_id) REFERENCES Venue(venue_id)
);

CREATE TABLE TicketBooking (
    booking_id INT PRIMARY KEY,
    customer_id INT,
    event_id INT,
    seat_id INT,
    booking_date DATE,
    booking_status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (event_id) REFERENCES Event(event_id),
    FOREIGN KEY (seat_id) REFERENCES Seat(seat_id)
);

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    booking_id INT,
    payment_amount DECIMAL(10,2),
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    payment_date DATE,
    FOREIGN KEY (booking_id) REFERENCES TicketBooking(booking_id)
);

INSERT INTO Customer VALUES
(1, 'Rahul Sharma', '9999999999', 'rahul@email.com', 'Nagpur'),
(2, 'Sneha Patil', '8888888888', 'sneha@email.com', 'Pune'),
(3, 'Aman Verma', '7777777777', 'aman@email.com', 'Mumbai'),
(4, 'Priya Mehta', '6666666666', 'priya@email.com', 'Delhi'),
(5, 'Atharva Kedar', '5555555555', 'atharva@email.com', 'Nagpur');

INSERT INTO Venue VALUES
(1, 'Nagpur Indoor Stadium', 'Nagpur', 5000),
(2, 'Pune Tech Arena', 'Pune', 3000),
(3, 'Mumbai Open Ground', 'Mumbai', 10000);

INSERT INTO Event VALUES
(1, 1, 'Rock Night Concert', 'Concert', '2026-05-10', '19:00:00'),
(2, 2, 'AI Tech Conference', 'Conference', '2026-05-15', '10:00:00'),
(3, 3, 'Standup Comedy Fest', 'Comedy Show', '2026-05-20', '20:00:00'),
(4, 1, 'Local Cricket League Final', 'Sports', '2026-05-25', '18:00:00');

INSERT INTO Seat VALUES
(1, 1, 'A-01', 'VIP', 3000.00, 'Booked'),
(2, 1, 'A-02', 'VIP', 3000.00, 'Available'),
(3, 1, 'B-01', 'Premium', 2000.00, 'Booked'),
(4, 1, 'C-01', 'Regular', 1000.00, 'Available'),
(5, 2, 'T-01', 'Premium', 2500.00, 'Booked'),
(6, 2, 'T-02', 'Regular', 1500.00, 'Available'),
(7, 3, 'M-01', 'VIP', 3500.00, 'Booked'),
(8, 3, 'M-02', 'Economy', 800.00, 'Available'),
(9, 1, 'D-01', 'Economy', 500.00, 'Booked');

INSERT INTO TicketBooking VALUES
(1, 1, 1, 1, '2026-04-29', 'Confirmed'),
(2, 2, 1, 3, '2026-04-29', 'Confirmed'),
(3, 3, 2, 5, '2026-04-29', 'Confirmed'),
(4, 4, 3, 7, '2026-04-29', 'Pending'),
(5, 5, 4, 9, '2026-04-29', 'Confirmed');

INSERT INTO Payment VALUES
(1, 1, 3000.00, 'UPI', 'Paid', '2026-04-29'),
(2, 2, 2000.00, 'Card', 'Paid', '2026-04-29'),
(3, 3, 2500.00, 'UPI', 'Paid', '2026-04-29'),
(4, 4, 3500.00, 'Net Banking', 'Pending', NULL),
(5, 5, 500.00, 'Cash', 'Paid', '2026-04-29');

-- 1. Available seats
SELECT 
    v.venue_name,
    s.seat_number,
    s.seat_category,
    s.seat_price,
    s.seat_status
FROM Seat s
JOIN Venue v
ON s.venue_id = v.venue_id
WHERE s.seat_status = 'Available';

-- 2. Customers who booked tickets
SELECT 
    c.customer_name,
    e.event_name,
    e.event_type,
    v.venue_name,
    s.seat_number,
    s.seat_category,
    tb.booking_status
FROM TicketBooking tb
JOIN Customer c
ON tb.customer_id = c.customer_id
JOIN Event e
ON tb.event_id = e.event_id
JOIN Venue v
ON e.venue_id = v.venue_id
JOIN Seat s
ON tb.seat_id = s.seat_id;

-- 3. Event revenue
SELECT 
    e.event_name,
    e.event_type,
    SUM(p.payment_amount) AS total_revenue
FROM Payment p
JOIN TicketBooking tb
ON p.booking_id = tb.booking_id
JOIN Event e
ON tb.event_id = e.event_id
WHERE p.payment_status = 'Paid'
GROUP BY e.event_name, e.event_type
ORDER BY total_revenue DESC;

-- 4. Pending payments
SELECT 
    c.customer_name,
    e.event_name,
    s.seat_number,
    p.payment_amount,
    p.payment_status
FROM Payment p
JOIN TicketBooking tb
ON p.booking_id = tb.booking_id
JOIN Customer c
ON tb.customer_id = c.customer_id
JOIN Event e
ON tb.event_id = e.event_id
JOIN Seat s
ON tb.seat_id = s.seat_id
WHERE p.payment_status = 'Pending';

-- 5. Most booked seat category
SELECT 
    s.seat_category,
    COUNT(tb.booking_id) AS total_bookings
FROM TicketBooking tb
JOIN Seat s
ON tb.seat_id = s.seat_id
WHERE tb.booking_status = 'Confirmed'
GROUP BY s.seat_category
ORDER BY total_bookings DESC;

-- 6. Tickets sold for each event
SELECT 
    e.event_name,
    COUNT(tb.booking_id) AS tickets_sold
FROM TicketBooking tb
JOIN Event e
ON tb.event_id = e.event_id
WHERE tb.booking_status = 'Confirmed'
GROUP BY e.event_name
ORDER BY tickets_sold DESC;

-- 7. Event-wise available seats
SELECT 
    e.event_name,
    v.venue_name,
    COUNT(s.seat_id) AS available_seats
FROM Event e
JOIN Venue v
ON e.venue_id = v.venue_id
JOIN Seat s
ON v.venue_id = s.venue_id
WHERE s.seat_status = 'Available'
GROUP BY e.event_name, v.venue_name;

-- 8. Complete booking report
SELECT 
    tb.booking_id,
    c.customer_name,
    e.event_name,
    e.event_date,
    e.event_time,
    v.venue_name,
    s.seat_number,
    s.seat_category,
    p.payment_amount,
    p.payment_status
FROM TicketBooking tb
JOIN Customer c
ON tb.customer_id = c.customer_id
JOIN Event e
ON tb.event_id = e.event_id
JOIN Venue v
ON e.venue_id = v.venue_id
JOIN Seat s
ON tb.seat_id = s.seat_id
JOIN Payment p
ON tb.booking_id = p.booking_id;
