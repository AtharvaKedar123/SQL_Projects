-- Online Exam Proctoring Violation Tracker
-- Single File SQL Solution

CREATE DATABASE ExamProctoringDB;
USE ExamProctoringDB;

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    email VARCHAR(80),
    department VARCHAR(50),
    semester INT
);

CREATE TABLE Exam (
    exam_id INT PRIMARY KEY,
    exam_name VARCHAR(80),
    subject_name VARCHAR(80),
    exam_date DATE,
    duration_minutes INT
);

CREATE TABLE ExamSession (
    session_id INT PRIMARY KEY,
    student_id INT,
    exam_id INT,
    login_time DATETIME,
    logout_time DATETIME,
    session_status VARCHAR(30),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (exam_id) REFERENCES Exam(exam_id)
);

CREATE TABLE ViolationType (
    violation_type_id INT PRIMARY KEY,
    violation_name VARCHAR(80),
    severity_level VARCHAR(30),
    risk_points INT
);

CREATE TABLE ViolationLog (
    violation_id INT PRIMARY KEY,
    session_id INT,
    violation_type_id INT,
    violation_time DATETIME,
    action_taken VARCHAR(100),
    FOREIGN KEY (session_id) REFERENCES ExamSession(session_id),
    FOREIGN KEY (violation_type_id) REFERENCES ViolationType(violation_type_id)
);

CREATE TABLE ProctoringResult (
    result_id INT PRIMARY KEY,
    session_id INT,
    total_violations INT,
    final_risk_score INT,
    result_status VARCHAR(30),
    remarks VARCHAR(255),
    FOREIGN KEY (session_id) REFERENCES ExamSession(session_id)
);

INSERT INTO Student VALUES
(1, 'Atharva Kedar', 'atharva@email.com', 'CSE', 6),
(2, 'Riya Sharma', 'riya@email.com', 'IT', 6),
(3, 'Aman Verma', 'aman@email.com', 'ENTC', 4),
(4, 'Sneha Patil', 'sneha@email.com', 'CSE', 6),
(5, 'Rohan Mehta', 'rohan@email.com', 'Mechanical', 8);

INSERT INTO Exam VALUES
(1, 'Mid Semester Exam', 'Database Management System', '2026-04-20', 90),
(2, 'Final Practical Exam', 'Python Programming', '2026-04-22', 120),
(3, 'Internal Test', 'Computer Networks', '2026-04-25', 60);

INSERT INTO ExamSession VALUES
(1, 1, 1, '2026-04-20 10:00:00', '2026-04-20 11:30:00', 'Completed'),
(2, 2, 1, '2026-04-20 10:00:00', '2026-04-20 11:25:00', 'Flagged'),
(3, 3, 2, '2026-04-22 09:00:00', '2026-04-22 11:00:00', 'Completed'),
(4, 4, 2, '2026-04-22 09:00:00', '2026-04-22 10:50:00', 'Flagged'),
(5, 5, 3, '2026-04-25 14:00:00', '2026-04-25 15:00:00', 'Completed');

INSERT INTO ViolationType VALUES
(1, 'Tab Switch Detected', 'Medium', 10),
(2, 'Face Not Detected', 'High', 20),
(3, 'Multiple Faces Detected', 'Critical', 30),
(4, 'Microphone Noise', 'Low', 5),
(5, 'Copy Paste Attempt', 'High', 20),
(6, 'Mobile Phone Detected', 'Critical', 30),
(7, 'Suspicious Eye Movement', 'Medium', 10);

INSERT INTO ViolationLog VALUES
(1, 2, 1, '2026-04-20 10:20:00', 'Warning displayed'),
(2, 2, 5, '2026-04-20 10:45:00', 'Copy paste blocked'),
(3, 4, 2, '2026-04-22 09:15:00', 'Warning displayed'),
(4, 4, 3, '2026-04-22 09:40:00', 'Session flagged'),
(5, 4, 6, '2026-04-22 10:10:00', 'Proctor alerted'),
(6, 1, 4, '2026-04-20 10:30:00', 'Noise warning'),
(7, 5, 7, '2026-04-25 14:20:00', 'Eye movement warning');

INSERT INTO ProctoringResult VALUES
(1, 1, 1, 5, 'Clean', 'Minor noise detected'),
(2, 2, 2, 30, 'Review Required', 'Tab switch and copy paste attempt detected'),
(3, 3, 0, 0, 'Clean', 'No suspicious activity'),
(4, 4, 3, 80, 'Disqualified', 'Critical violations detected'),
(5, 5, 1, 10, 'Clean', 'Minor suspicious eye movement');

-- 1. Students with highest risk score
SELECT 
    s.student_name,
    e.exam_name,
    e.subject_name,
    pr.final_risk_score,
    pr.result_status,
    pr.remarks
FROM ProctoringResult pr
JOIN ExamSession es
ON pr.session_id = es.session_id
JOIN Student s
ON es.student_id = s.student_id
JOIN Exam e
ON es.exam_id = e.exam_id
ORDER BY pr.final_risk_score DESC;

-- 2. Most common violations
SELECT 
    vt.violation_name,
    vt.severity_level,
    COUNT(vl.violation_id) AS total_occurrences
FROM ViolationLog vl
JOIN ViolationType vt
ON vl.violation_type_id = vt.violation_type_id
GROUP BY vt.violation_name, vt.severity_level
ORDER BY total_occurrences DESC;

-- 3. Flagged exam sessions
SELECT 
    es.session_id,
    s.student_name,
    e.exam_name,
    e.subject_name,
    es.session_status,
    pr.final_risk_score,
    pr.result_status
FROM ExamSession es
JOIN Student s
ON es.student_id = s.student_id
JOIN Exam e
ON es.exam_id = e.exam_id
JOIN ProctoringResult pr
ON es.session_id = pr.session_id
WHERE es.session_status = 'Flagged'
OR pr.result_status IN ('Review Required', 'Disqualified');

-- 4. Students with no violations
SELECT 
    s.student_name,
    e.exam_name,
    e.subject_name,
    pr.total_violations,
    pr.result_status
FROM ProctoringResult pr
JOIN ExamSession es
ON pr.session_id = es.session_id
JOIN Student s
ON es.student_id = s.student_id
JOIN Exam e
ON es.exam_id = e.exam_id
WHERE pr.total_violations = 0;

-- 5. High and critical severity violations
SELECT 
    s.student_name,
    e.exam_name,
    vt.violation_name,
    vt.severity_level,
    vl.violation_time,
    vl.action_taken
FROM ViolationLog vl
JOIN ViolationType vt
ON vl.violation_type_id = vt.violation_type_id
JOIN ExamSession es
ON vl.session_id = es.session_id
JOIN Student s
ON es.student_id = s.student_id
JOIN Exam e
ON es.exam_id = e.exam_id
WHERE vt.severity_level IN ('High', 'Critical');

-- 6. Exams with most suspicious activity
SELECT 
    e.exam_name,
    e.subject_name,
    COUNT(vl.violation_id) AS total_violations,
    SUM(vt.risk_points) AS total_risk_points
FROM ViolationLog vl
JOIN ViolationType vt
ON vl.violation_type_id = vt.violation_type_id
JOIN ExamSession es
ON vl.session_id = es.session_id
JOIN Exam e
ON es.exam_id = e.exam_id
GROUP BY e.exam_name, e.subject_name
ORDER BY total_violations DESC, total_risk_points DESC;

-- 7. Student-wise violation history
SELECT 
    s.student_name,
    e.exam_name,
    vt.violation_name,
    vt.severity_level,
    vt.risk_points,
    vl.violation_time,
    vl.action_taken
FROM ViolationLog vl
JOIN ViolationType vt
ON vl.violation_type_id = vt.violation_type_id
JOIN ExamSession es
ON vl.session_id = es.session_id
JOIN Student s
ON es.student_id = s.student_id
JOIN Exam e
ON es.exam_id = e.exam_id
ORDER BY s.student_name, vl.violation_time;

-- 8. Average risk score by exam
SELECT 
    e.exam_name,
    e.subject_name,
    AVG(pr.final_risk_score) AS average_risk_score
FROM ProctoringResult pr
JOIN ExamSession es
ON pr.session_id = es.session_id
JOIN Exam e
ON es.exam_id = e.exam_id
GROUP BY e.exam_name, e.subject_name;