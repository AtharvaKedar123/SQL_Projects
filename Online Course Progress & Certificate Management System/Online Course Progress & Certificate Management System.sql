CREATE DATABASE OnlineCourseDB;
USE OnlineCourseDB;

CREATE TABLE Learner (
    learner_id INT PRIMARY KEY,
    learner_name VARCHAR(50),
    email VARCHAR(80),
    city VARCHAR(50),
    join_date DATE
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(80),
    category VARCHAR(50),
    course_fee DECIMAL(10,2),
    difficulty_level VARCHAR(30)
);

CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY,
    learner_id INT,
    course_id INT,
    enrollment_date DATE,
    enrollment_status VARCHAR(30),
    FOREIGN KEY (learner_id) REFERENCES Learner(learner_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Module (
    module_id INT PRIMARY KEY,
    course_id INT,
    module_title VARCHAR(100),
    module_order INT,
    duration_minutes INT,
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE ModuleProgress (
    progress_id INT PRIMARY KEY,
    learner_id INT,
    module_id INT,
    progress_status VARCHAR(30),
    completion_date DATE,
    FOREIGN KEY (learner_id) REFERENCES Learner(learner_id),
    FOREIGN KEY (module_id) REFERENCES Module(module_id)
);

CREATE TABLE QuizScore (
    quiz_id INT PRIMARY KEY,
    learner_id INT,
    course_id INT,
    quiz_title VARCHAR(80),
    score INT,
    max_score INT,
    attempt_date DATE,
    FOREIGN KEY (learner_id) REFERENCES Learner(learner_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    learner_id INT,
    course_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    payment_status VARCHAR(30),
    FOREIGN KEY (learner_id) REFERENCES Learner(learner_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

CREATE TABLE Certificate (
    certificate_id INT PRIMARY KEY,
    learner_id INT,
    course_id INT,
    issue_date DATE,
    certificate_status VARCHAR(30),
    certificate_code VARCHAR(50),
    FOREIGN KEY (learner_id) REFERENCES Learner(learner_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

INSERT INTO Learner VALUES
(1, 'Atharva Kedar', 'atharva@email.com', 'Nagpur', '2026-01-10'),
(2, 'Neha Sharma', 'neha@email.com', 'Mumbai', '2026-01-15'),
(3, 'Rohan Mehta', 'rohan@email.com', 'Pune', '2026-02-01'),
(4, 'Priya Patil', 'priya@email.com', 'Nagpur', '2026-02-20'),
(5, 'Amit Verma', 'amit@email.com', 'Nashik', '2026-03-05');

INSERT INTO Course VALUES
(1, 'SQL Mastery Bootcamp', 'Database', 1999.00, 'Beginner'),
(2, 'Python for Data Science', 'Programming', 2499.00, 'Intermediate'),
(3, 'Power BI Dashboard Design', 'Analytics', 1499.00, 'Beginner'),
(4, 'Java Backend Development', 'Backend', 2999.00, 'Advanced');

INSERT INTO Enrollment VALUES
(1, 1, 1, '2026-04-01', 'Active'),
(2, 2, 1, '2026-04-01', 'Active'),
(3, 3, 2, '2026-04-02', 'Active'),
(4, 4, 3, '2026-04-03', 'Completed'),
(5, 5, 4, '2026-04-04', 'Active'),
(6, 1, 3, '2026-04-05', 'Completed');

INSERT INTO Module VALUES
(1, 1, 'SQL Basics', 1, 60),
(2, 1, 'Joins and Relationships', 2, 90),
(3, 1, 'Subqueries and Views', 3, 80),
(4, 2, 'Python Basics Revision', 1, 70),
(5, 2, 'Pandas and NumPy', 2, 100),
(6, 3, 'Power BI Visuals', 1, 75),
(7, 3, 'Dashboard Storytelling', 2, 90),
(8, 4, 'Spring Boot REST APIs', 1, 120);

INSERT INTO ModuleProgress VALUES
(1, 1, 1, 'Completed', '2026-04-03'),
(2, 1, 2, 'Completed', '2026-04-05'),
(3, 1, 3, 'In Progress', NULL),
(4, 2, 1, 'Completed', '2026-04-04'),
(5, 2, 2, 'In Progress', NULL),
(6, 3, 4, 'Completed', '2026-04-06'),
(7, 3, 5, 'In Progress', NULL),
(8, 4, 6, 'Completed', '2026-04-05'),
(9, 4, 7, 'Completed', '2026-04-07'),
(10, 5, 8, 'In Progress', NULL),
(11, 1, 6, 'Completed', '2026-04-06'),
(12, 1, 7, 'Completed', '2026-04-08');

INSERT INTO QuizScore VALUES
(1, 1, 1, 'SQL Basics Quiz', 85, 100, '2026-04-03'),
(2, 1, 1, 'Joins Quiz', 78, 100, '2026-04-05'),
(3, 2, 1, 'SQL Basics Quiz', 88, 100, '2026-04-04'),
(4, 3, 2, 'Python Basics Quiz', 80, 100, '2026-04-06'),
(5, 4, 3, 'Power BI Visuals Quiz', 92, 100, '2026-04-05'),
(6, 1, 3, 'Dashboard Quiz', 95, 100, '2026-04-08'),
(7, 5, 4, 'Spring Boot Quiz', 60, 100, '2026-04-09');

INSERT INTO Payment VALUES
(1, 1, 1, 1999.00, '2026-04-01', 'Paid'),
(2, 2, 1, 1999.00, '2026-04-01', 'Pending'),
(3, 3, 2, 2499.00, '2026-04-02', 'Paid'),
(4, 4, 3, 1499.00, '2026-04-03', 'Paid'),
(5, 5, 4, 2999.00, '2026-04-04', 'Pending'),
(6, 1, 3, 1499.00, '2026-04-05', 'Paid');

INSERT INTO Certificate VALUES
(1, 4, 3, '2026-04-08', 'Issued', 'CERT-PBI-1001'),
(2, 1, 3, '2026-04-09', 'Issued', 'CERT-PBI-1002'),
(3, 1, 1, NULL, 'Pending', 'CERT-SQL-1003');

-- 1. Learners who completed a course
SELECT 
    l.learner_name,
    c.course_name,
    e.enrollment_status
FROM Enrollment e
JOIN Learner l
ON e.learner_id = l.learner_id
JOIN Course c
ON e.course_id = c.course_id
WHERE e.enrollment_status = 'Completed';

-- 2. Learners eligible for certificates
SELECT 
    l.learner_name,
    c.course_name,
    COUNT(m.module_id) AS total_modules,
    SUM(CASE WHEN mp.progress_status = 'Completed' THEN 1 ELSE 0 END) AS completed_modules,
    p.payment_status
FROM Enrollment e
JOIN Learner l
ON e.learner_id = l.learner_id
JOIN Course c
ON e.course_id = c.course_id
JOIN Module m
ON c.course_id = m.course_id
LEFT JOIN ModuleProgress mp
ON m.module_id = mp.module_id
AND e.learner_id = mp.learner_id
JOIN Payment p
ON e.learner_id = p.learner_id
AND e.course_id = p.course_id
GROUP BY l.learner_name, c.course_name, p.payment_status
HAVING total_modules = completed_modules
AND p.payment_status = 'Paid';

-- 3. Course with most enrollments
SELECT 
    c.course_name,
    c.category,
    COUNT(e.enrollment_id) AS total_enrollments
FROM Enrollment e
JOIN Course c
ON e.course_id = c.course_id
GROUP BY c.course_name, c.category
ORDER BY total_enrollments DESC;

-- 4. Learners with pending payments
SELECT 
    l.learner_name,
    c.course_name,
    p.amount,
    p.payment_status
FROM Payment p
JOIN Learner l
ON p.learner_id = l.learner_id
JOIN Course c
ON p.course_id = c.course_id
WHERE p.payment_status = 'Pending';

-- 5. Average quiz score per course
SELECT 
    c.course_name,
    ROUND(AVG(qs.score * 100.0 / qs.max_score), 2) AS average_score_percentage
FROM QuizScore qs
JOIN Course c
ON qs.course_id = c.course_id
GROUP BY c.course_name
ORDER BY average_score_percentage DESC;

-- 6. Modules completed the most
SELECT 
    m.module_title,
    c.course_name,
    COUNT(mp.progress_id) AS completed_count
FROM ModuleProgress mp
JOIN Module m
ON mp.module_id = m.module_id
JOIN Course c
ON m.course_id = c.course_id
WHERE mp.progress_status = 'Completed'
GROUP BY m.module_title, c.course_name
ORDER BY completed_count DESC;

-- 7. Total revenue generated
SELECT 
    SUM(amount) AS total_revenue
FROM Payment
WHERE payment_status = 'Paid';

-- 8. Learners with low progress
SELECT 
    l.learner_name,
    c.course_name,
    COUNT(m.module_id) AS total_modules,
    SUM(CASE WHEN mp.progress_status = 'Completed' THEN 1 ELSE 0 END) AS completed_modules,
    ROUND(
        SUM(CASE WHEN mp.progress_status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(m.module_id),
        2
    ) AS progress_percentage
FROM Enrollment e
JOIN Learner l
ON e.learner_id = l.learner_id
JOIN Course c
ON e.course_id = c.course_id
JOIN Module m
ON c.course_id = m.course_id
LEFT JOIN ModuleProgress mp
ON m.module_id = mp.module_id
AND e.learner_id = mp.learner_id
GROUP BY l.learner_name, c.course_name
HAVING progress_percentage < 60
ORDER BY progress_percentage ASC;

-- 9. Certificate status details
SELECT 
    l.learner_name,
    c.course_name,
    cert.certificate_status,
    cert.certificate_code,
    cert.issue_date
FROM Certificate cert
JOIN Learner l
ON cert.learner_id = l.learner_id
JOIN Course c
ON cert.course_id = c.course_id;

-- 10. Learner course progress summary
SELECT 
    l.learner_name,
    c.course_name,
    COUNT(m.module_id) AS total_modules,
    SUM(CASE WHEN mp.progress_status = 'Completed' THEN 1 ELSE 0 END) AS completed_modules,
    ROUND(
        SUM(CASE WHEN mp.progress_status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(m.module_id),
        2
    ) AS progress_percentage
FROM Enrollment e
JOIN Learner l
ON e.learner_id = l.learner_id
JOIN Course c
ON e.course_id = c.course_id
JOIN Module m
ON c.course_id = m.course_id
LEFT JOIN ModuleProgress mp
ON m.module_id = mp.module_id
AND e.learner_id = mp.learner_id
GROUP BY l.learner_name, c.course_name
ORDER BY progress_percentage DESC;