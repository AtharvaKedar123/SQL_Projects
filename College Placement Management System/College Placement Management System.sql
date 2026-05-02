-- College Placement Management System
-- Single File SQL Solution

CREATE DATABASE PlacementDB;
USE PlacementDB;

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    branch VARCHAR(50),
    cgpa DECIMAL(3,2),
    graduation_year INT,
    email VARCHAR(80)
);

CREATE TABLE Company (
    company_id INT PRIMARY KEY,
    company_name VARCHAR(80),
    industry VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE JobRole (
    role_id INT PRIMARY KEY,
    company_id INT,
    role_name VARCHAR(80),
    package_lpa DECIMAL(5,2),
    eligibility_cgpa DECIMAL(3,2),
    FOREIGN KEY (company_id) REFERENCES Company(company_id)
);

CREATE TABLE Application (
    application_id INT PRIMARY KEY,
    student_id INT,
    role_id INT,
    application_date DATE,
    application_status VARCHAR(30),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (role_id) REFERENCES JobRole(role_id)
);

CREATE TABLE InterviewRound (
    round_id INT PRIMARY KEY,
    application_id INT,
    round_name VARCHAR(50),
    round_date DATE,
    result VARCHAR(30),
    FOREIGN KEY (application_id) REFERENCES Application(application_id)
);

CREATE TABLE SelectionResult (
    result_id INT PRIMARY KEY,
    application_id INT,
    final_status VARCHAR(30),
    offer_date DATE,
    joining_location VARCHAR(50),
    FOREIGN KEY (application_id) REFERENCES Application(application_id)
);

INSERT INTO Student VALUES
(1, 'Atharva Kedar', 'CSE', 8.40, 2026, 'atharva@email.com'),
(2, 'Riya Sharma', 'IT', 9.10, 2026, 'riya@email.com'),
(3, 'Aman Verma', 'ENTC', 7.80, 2026, 'aman@email.com'),
(4, 'Neha Patil', 'CSE', 8.90, 2026, 'neha@email.com'),
(5, 'Rohan Mehta', 'Mechanical', 7.20, 2026, 'rohan@email.com');

INSERT INTO Company VALUES
(1, 'Infosys', 'IT Services', 'Bangalore'),
(2, 'TCS', 'Consulting', 'Pune'),
(3, 'Wipro', 'IT Services', 'Hyderabad'),
(4, 'Capgemini', 'Technology Consulting', 'Mumbai'),
(5, 'TechNova', 'Product Based', 'Bangalore');

INSERT INTO JobRole VALUES
(1, 1, 'Backend Developer', 6.50, 7.00),
(2, 2, 'Data Analyst', 5.80, 7.50),
(3, 3, 'Software Engineer', 6.00, 7.00),
(4, 4, 'Cloud Engineer', 7.20, 8.00),
(5, 5, 'Full Stack Developer', 12.00, 8.50);

INSERT INTO Application VALUES
(1, 1, 1, '2026-04-01', 'Selected'),
(2, 2, 5, '2026-04-02', 'Selected'),
(3, 3, 3, '2026-04-03', 'In Progress'),
(4, 4, 4, '2026-04-04', 'Rejected'),
(5, 5, 2, '2026-04-05', 'In Progress'),
(6, 1, 5, '2026-04-06', 'Rejected');

INSERT INTO InterviewRound VALUES
(1, 1, 'Aptitude Round', '2026-04-10', 'Cleared'),
(2, 1, 'Technical Round', '2026-04-12', 'Cleared'),
(3, 1, 'HR Round', '2026-04-14', 'Cleared'),
(4, 2, 'Coding Round', '2026-04-11', 'Cleared'),
(5, 2, 'Technical Round', '2026-04-13', 'Cleared'),
(6, 2, 'HR Round', '2026-04-15', 'Cleared'),
(7, 3, 'Aptitude Round', '2026-04-12', 'Cleared'),
(8, 3, 'Technical Round', '2026-04-16', 'Pending'),
(9, 4, 'Technical Round', '2026-04-13', 'Rejected'),
(10, 5, 'Aptitude Round', '2026-04-14', 'Cleared');

INSERT INTO SelectionResult VALUES
(1, 1, 'Selected', '2026-04-20', 'Bangalore'),
(2, 2, 'Selected', '2026-04-22', 'Bangalore'),
(3, 3, 'Pending', NULL, NULL),
(4, 4, 'Rejected', NULL, NULL),
(5, 5, 'Pending', NULL, NULL),
(6, 6, 'Rejected', NULL, NULL);

-- 1. Selected students
SELECT 
    s.student_name,
    s.branch,
    c.company_name,
    jr.role_name,
    jr.package_lpa,
    sr.offer_date,
    sr.joining_location
FROM SelectionResult sr
JOIN Application a
ON sr.application_id = a.application_id
JOIN Student s
ON a.student_id = s.student_id
JOIN JobRole jr
ON a.role_id = jr.role_id
JOIN Company c
ON jr.company_id = c.company_id
WHERE sr.final_status = 'Selected';

-- 2. Companies that hired the most students
SELECT 
    c.company_name,
    COUNT(sr.result_id) AS total_selected_students
FROM SelectionResult sr
JOIN Application a
ON sr.application_id = a.application_id
JOIN JobRole jr
ON a.role_id = jr.role_id
JOIN Company c
ON jr.company_id = c.company_id
WHERE sr.final_status = 'Selected'
GROUP BY c.company_name
ORDER BY total_selected_students DESC;

-- 3. Students still in interview process
SELECT 
    s.student_name,
    c.company_name,
    jr.role_name,
    a.application_status
FROM Application a
JOIN Student s
ON a.student_id = s.student_id
JOIN JobRole jr
ON a.role_id = jr.role_id
JOIN Company c
ON jr.company_id = c.company_id
WHERE a.application_status = 'In Progress';

-- 4. Highest package offered
SELECT 
    c.company_name,
    jr.role_name,
    jr.package_lpa
FROM JobRole jr
JOIN Company c
ON jr.company_id = c.company_id
ORDER BY jr.package_lpa DESC
LIMIT 1;

-- 5. Number of students applied for each company
SELECT 
    c.company_name,
    COUNT(a.application_id) AS total_applications
FROM Application a
JOIN JobRole jr
ON a.role_id = jr.role_id
JOIN Company c
ON jr.company_id = c.company_id
GROUP BY c.company_name
ORDER BY total_applications DESC;

-- 6. Selected students by branch
SELECT 
    s.branch,
    COUNT(sr.result_id) AS selected_count
FROM SelectionResult sr
JOIN Application a
ON sr.application_id = a.application_id
JOIN Student s
ON a.student_id = s.student_id
WHERE sr.final_status = 'Selected'
GROUP BY s.branch
ORDER BY selected_count DESC;

-- 7. Interview round result details
SELECT 
    s.student_name,
    c.company_name,
    jr.role_name,
    ir.round_name,
    ir.round_date,
    ir.result
FROM InterviewRound ir
JOIN Application a
ON ir.application_id = a.application_id
JOIN Student s
ON a.student_id = s.student_id
JOIN JobRole jr
ON a.role_id = jr.role_id
JOIN Company c
ON jr.company_id = c.company_id;

-- 8. Eligible students for each job role based on CGPA
SELECT 
    s.student_name,
    s.branch,
    s.cgpa,
    c.company_name,
    jr.role_name,
    jr.eligibility_cgpa
FROM Student s
JOIN JobRole jr
ON s.cgpa >= jr.eligibility_cgpa
JOIN Company c
ON jr.company_id = c.company_id
ORDER BY c.company_name, jr.role_name;