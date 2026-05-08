

CREATE DATABASE LibraryReservationDB;
USE LibraryReservationDB;

CREATE TABLE Member (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(50),
    phone VARCHAR(15),
    email VARCHAR(80),
    membership_date DATE
);

CREATE TABLE Book (
    book_id INT PRIMARY KEY,
    book_title VARCHAR(100),
    author VARCHAR(80),
    category VARCHAR(50),
    total_copies INT,
    available_copies INT
);

CREATE TABLE BookIssue (
    issue_id INT PRIMARY KEY,
    member_id INT,
    book_id INT,
    issue_date DATE,
    due_date DATE,
    return_date DATE,
    issue_status VARCHAR(30),
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

CREATE TABLE Reservation (
    reservation_id INT PRIMARY KEY,
    member_id INT,
    book_id INT,
    reservation_date DATE,
    reservation_status VARCHAR(30),
    FOREIGN KEY (member_id) REFERENCES Member(member_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

CREATE TABLE Fine (
    fine_id INT PRIMARY KEY,
    issue_id INT,
    fine_amount DECIMAL(10,2),
    fine_reason VARCHAR(100),
    payment_status VARCHAR(30),
    FOREIGN KEY (issue_id) REFERENCES BookIssue(issue_id)
);

INSERT INTO Member VALUES
(1, 'Aman Verma', '9999999999', 'aman@email.com', '2025-06-01'),
(2, 'Pooja Sharma', '8888888888', 'pooja@email.com', '2025-08-10'),
(3, 'Rahul Mehta', '7777777777', 'rahul@email.com', '2025-09-15'),
(4, 'Sneha Patil', '6666666666', 'sneha@email.com', '2025-11-20'),
(5, 'Atharva Kedar', '5555555555', 'atharva@email.com', '2026-01-05');

INSERT INTO Book VALUES
(1, 'Clean Code', 'Robert C. Martin', 'Programming', 5, 3),
(2, 'Atomic Habits', 'James Clear', 'Self Help', 4, 1),
(3, 'The Alchemist', 'Paulo Coelho', 'Fiction', 6, 4),
(4, 'Database System Concepts', 'Abraham Silberschatz', 'Database', 3, 0),
(5, 'Rich Dad Poor Dad', 'Robert Kiyosaki', 'Finance', 5, 2);

INSERT INTO BookIssue VALUES
(1, 1, 1, '2026-04-01', '2026-04-15', '2026-04-20', 'Returned'),
(2, 2, 2, '2026-04-10', '2026-04-24', NULL, 'Issued'),
(3, 3, 4, '2026-04-05', '2026-04-19', NULL, 'Issued'),
(4, 4, 5, '2026-04-12', '2026-04-26', '2026-04-26', 'Returned'),
(5, 5, 3, '2026-04-18', '2026-05-02', NULL, 'Issued');

INSERT INTO Reservation VALUES
(1, 1, 4, '2026-04-21', 'Pending'),
(2, 2, 4, '2026-04-22', 'Pending'),
(3, 3, 2, '2026-04-23', 'Completed'),
(4, 4, 1, '2026-04-24', 'Cancelled'),
(5, 5, 5, '2026-04-25', 'Pending');

INSERT INTO Fine VALUES
(1, 1, 50.00, 'Late return', 'Paid'),
(2, 3, 100.00, 'Overdue book', 'Unpaid'),
(3, 2, 25.00, 'Overdue book', 'Unpaid'),
(4, 4, 0.00, 'Returned on time', 'No Fine');

-- 1. Currently issued books
SELECT 
    bi.issue_id,
    m.member_name,
    b.book_title,
    bi.issue_date,
    bi.due_date,
    bi.issue_status
FROM BookIssue bi
JOIN Member m
ON bi.member_id = m.member_id
JOIN Book b
ON bi.book_id = b.book_id
WHERE bi.issue_status = 'Issued';

-- 2. Overdue books
SELECT 
    m.member_name,
    b.book_title,
    bi.issue_date,
    bi.due_date,
    bi.return_date,
    bi.issue_status
FROM BookIssue bi
JOIN Member m
ON bi.member_id = m.member_id
JOIN Book b
ON bi.book_id = b.book_id
WHERE bi.return_date IS NULL
AND bi.due_date < '2026-04-29';

-- 3. Members with unpaid fines
SELECT 
    m.member_name,
    b.book_title,
    f.fine_amount,
    f.fine_reason,
    f.payment_status
FROM Fine f
JOIN BookIssue bi
ON f.issue_id = bi.issue_id
JOIN Member m
ON bi.member_id = m.member_id
JOIN Book b
ON bi.book_id = b.book_id
WHERE f.payment_status = 'Unpaid';

-- 4. Most reserved books
SELECT 
    b.book_title,
    COUNT(r.reservation_id) AS total_reservations
FROM Reservation r
JOIN Book b
ON r.book_id = b.book_id
GROUP BY b.book_title
ORDER BY total_reservations DESC;

-- 5. Available books right now
SELECT 
    book_title,
    author,
    category,
    available_copies
FROM Book
WHERE available_copies > 0;

-- 6. Total fine amount collected
SELECT 
    SUM(fine_amount) AS total_fine_collected
FROM Fine
WHERE payment_status = 'Paid';

-- 7. Pending reservations
SELECT 
    r.reservation_id,
    m.member_name,
    b.book_title,
    r.reservation_date,
    r.reservation_status
FROM Reservation r
JOIN Member m
ON r.member_id = m.member_id
JOIN Book b
ON r.book_id = b.book_id
WHERE r.reservation_status = 'Pending';

-- 8. Book issue count by category
SELECT 
    b.category,
    COUNT(bi.issue_id) AS total_issues
FROM BookIssue bi
JOIN Book b
ON bi.book_id = b.book_id
GROUP BY b.category
ORDER BY total_issues DESC;
