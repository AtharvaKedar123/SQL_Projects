CREATE DATABASE MuseumArtifactDB;
USE MuseumArtifactDB;

CREATE TABLE Exhibit (
    exhibit_id INT PRIMARY KEY,
    exhibit_name VARCHAR(80),
    exhibit_theme VARCHAR(80),
    floor_number INT,
    exhibit_status VARCHAR(30)
);

CREATE TABLE Artifact (
    artifact_id INT PRIMARY KEY,
    artifact_name VARCHAR(100),
    exhibit_id INT,
    origin_country VARCHAR(50),
    estimated_year INT,
    artifact_condition VARCHAR(30),
    display_status VARCHAR(30),
    FOREIGN KEY (exhibit_id) REFERENCES Exhibit(exhibit_id)
);

CREATE TABLE Visitor (
    visitor_id INT PRIMARY KEY,
    visitor_name VARCHAR(50),
    city VARCHAR(50),
    visit_date DATE
);

CREATE TABLE Guide (
    guide_id INT PRIMARY KEY,
    guide_name VARCHAR(50),
    language_known VARCHAR(50),
    experience_years INT
);

CREATE TABLE TourBooking (
    booking_id INT PRIMARY KEY,
    visitor_id INT,
    guide_id INT,
    exhibit_id INT,
    tour_date DATE,
    tour_status VARCHAR(30),
    FOREIGN KEY (visitor_id) REFERENCES Visitor(visitor_id),
    FOREIGN KEY (guide_id) REFERENCES Guide(guide_id),
    FOREIGN KEY (exhibit_id) REFERENCES Exhibit(exhibit_id)
);

CREATE TABLE Ticket (
    ticket_id INT PRIMARY KEY,
    visitor_id INT,
    ticket_type VARCHAR(40),
    ticket_price DECIMAL(10,2),
    payment_status VARCHAR(30),
    FOREIGN KEY (visitor_id) REFERENCES Visitor(visitor_id)
);

CREATE TABLE ExhibitVisit (
    visit_id INT PRIMARY KEY,
    visitor_id INT,
    exhibit_id INT,
    visit_time_minutes INT,
    visit_date DATE,
    FOREIGN KEY (visitor_id) REFERENCES Visitor(visitor_id),
    FOREIGN KEY (exhibit_id) REFERENCES Exhibit(exhibit_id)
);

CREATE TABLE ArtifactMaintenance (
    maintenance_id INT PRIMARY KEY,
    artifact_id INT,
    maintenance_type VARCHAR(80),
    maintenance_date DATE,
    maintenance_status VARCHAR(30),
    cost DECIMAL(10,2),
    FOREIGN KEY (artifact_id) REFERENCES Artifact(artifact_id)
);

INSERT INTO Exhibit VALUES
(1, 'Ancient India Gallery', 'Indian History', 1, 'Open'),
(2, 'Egyptian Civilization', 'Ancient Egypt', 2, 'Open'),
(3, 'Warrior Weapons Hall', 'Military History', 1, 'Open'),
(4, 'Royal Art Collection', 'Paintings and Sculptures', 3, 'Under Renovation'),
(5, 'Science Innovation Zone', 'Science and Technology', 2, 'Open');

INSERT INTO Artifact VALUES
(1, 'Mauryan Coin Collection', 1, 'India', -250, 'Good', 'Displayed'),
(2, 'Bronze Nataraja Statue', 1, 'India', 1100, 'Excellent', 'Displayed'),
(3, 'Mini Pharaoh Mask', 2, 'Egypt', -1200, 'Needs Care', 'Displayed'),
(4, 'Ancient Sword', 3, 'India', 1600, 'Damaged', 'Stored'),
(5, 'Royal Oil Painting', 4, 'France', 1750, 'Needs Care', 'Displayed'),
(6, 'Early Telescope Model', 5, 'Germany', 1890, 'Good', 'Displayed'),
(7, 'Battle Shield', 3, 'India', 1550, 'Good', 'Displayed');

INSERT INTO Visitor VALUES
(1, 'Atharva Kedar', 'Nagpur', '2026-04-01'),
(2, 'Neha Sharma', 'Mumbai', '2026-04-01'),
(3, 'Rohan Mehta', 'Pune', '2026-04-02'),
(4, 'Priya Patil', 'Nagpur', '2026-04-03'),
(5, 'Amit Verma', 'Nashik', '2026-04-04');

INSERT INTO Guide VALUES
(1, 'Meera Joshi', 'English', 5),
(2, 'Raj Malhotra', 'Hindi', 7),
(3, 'Sara Khan', 'English', 4);

INSERT INTO TourBooking VALUES
(1, 1, 1, 1, '2026-04-01', 'Completed'),
(2, 2, 2, 2, '2026-04-01', 'Completed'),
(3, 3, 1, 3, '2026-04-02', 'Completed'),
(4, 4, 3, 5, '2026-04-03', 'Scheduled'),
(5, 5, 2, 1, '2026-04-04', 'Cancelled');

INSERT INTO Ticket VALUES
(1, 1, 'Adult', 250.00, 'Paid'),
(2, 2, 'Adult', 250.00, 'Paid'),
(3, 3, 'Student', 120.00, 'Paid'),
(4, 4, 'Adult', 250.00, 'Pending'),
(5, 5, 'Senior Citizen', 100.00, 'Paid');

INSERT INTO ExhibitVisit VALUES
(1, 1, 1, 45, '2026-04-01'),
(2, 1, 3, 30, '2026-04-01'),
(3, 2, 2, 50, '2026-04-01'),
(4, 3, 3, 40, '2026-04-02'),
(5, 4, 5, 35, '2026-04-03'),
(6, 5, 1, 25, '2026-04-04'),
(7, 2, 1, 30, '2026-04-01'),
(8, 3, 5, 20, '2026-04-02');

INSERT INTO ArtifactMaintenance VALUES
(1, 3, 'Humidity Protection Treatment', '2026-04-05', 'Pending', 4000.00),
(2, 4, 'Rust Removal and Restoration', '2026-04-06', 'In Progress', 7000.00),
(3, 5, 'Frame Repair and Cleaning', '2026-04-10', 'Pending', 3500.00),
(4, 1, 'Routine Cleaning', '2026-04-02', 'Completed', 1000.00),
(5, 6, 'Glass Case Inspection', '2026-04-08', 'Completed', 1500.00);

-- 1. Most visited exhibits
SELECT 
    e.exhibit_name,
    e.exhibit_theme,
    COUNT(ev.visit_id) AS total_visits
FROM ExhibitVisit ev
JOIN Exhibit e
ON ev.exhibit_id = e.exhibit_id
GROUP BY e.exhibit_name, e.exhibit_theme
ORDER BY total_visits DESC;

-- 2. Artifacts needing maintenance
SELECT 
    artifact_name,
    artifact_condition,
    display_status
FROM Artifact
WHERE artifact_condition IN ('Needs Care', 'Damaged');

-- 3. Guides who handled most tours
SELECT 
    g.guide_name,
    g.language_known,
    COUNT(tb.booking_id) AS total_tours
FROM TourBooking tb
JOIN Guide g
ON tb.guide_id = g.guide_id
WHERE tb.tour_status IN ('Completed', 'Scheduled')
GROUP BY g.guide_name, g.language_known
ORDER BY total_tours DESC;

-- 4. Total paid ticket revenue
SELECT 
    SUM(ticket_price) AS total_ticket_revenue
FROM Ticket
WHERE payment_status = 'Paid';

-- 5. Visitors who booked guided tours
SELECT 
    v.visitor_name,
    v.city,
    e.exhibit_name,
    g.guide_name,
    tb.tour_date,
    tb.tour_status
FROM TourBooking tb
JOIN Visitor v
ON tb.visitor_id = v.visitor_id
JOIN Exhibit e
ON tb.exhibit_id = e.exhibit_id
JOIN Guide g
ON tb.guide_id = g.guide_id;

-- 6. Oldest artifacts
SELECT 
    artifact_name,
    origin_country,
    estimated_year
FROM Artifact
ORDER BY estimated_year ASC;

-- 7. Exhibits with highest number of artifacts
SELECT 
    e.exhibit_name,
    COUNT(a.artifact_id) AS total_artifacts
FROM Artifact a
JOIN Exhibit e
ON a.exhibit_id = e.exhibit_id
GROUP BY e.exhibit_name
ORDER BY total_artifacts DESC;

-- 8. Pending maintenance tasks
SELECT 
    a.artifact_name,
    am.maintenance_type,
    am.maintenance_date,
    am.maintenance_status,
    am.cost
FROM ArtifactMaintenance am
JOIN Artifact a
ON am.artifact_id = a.artifact_id
WHERE am.maintenance_status = 'Pending';

-- 9. Visitor total time spent in museum exhibits
SELECT 
    v.visitor_name,
    SUM(ev.visit_time_minutes) AS total_time_minutes
FROM ExhibitVisit ev
JOIN Visitor v
ON ev.visitor_id = v.visitor_id
GROUP BY v.visitor_name
ORDER BY total_time_minutes DESC;

-- 10. Maintenance cost by artifact
SELECT 
    a.artifact_name,
    SUM(am.cost) AS total_maintenance_cost
FROM ArtifactMaintenance am
JOIN Artifact a
ON am.artifact_id = a.artifact_id
GROUP BY a.artifact_name
ORDER BY total_maintenance_cost DESC;