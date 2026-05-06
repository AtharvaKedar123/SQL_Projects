CREATE DATABASE SolarPanelMonitoringDB;
USE SolarPanelMonitoringDB;

CREATE TABLE SolarSite (
    site_id INT PRIMARY KEY,
    site_name VARCHAR(80),
    city VARCHAR(50),
    installation_date DATE,
    site_status VARCHAR(30)
);

CREATE TABLE Inverter (
    inverter_id INT PRIMARY KEY,
    site_id INT,
    inverter_code VARCHAR(40),
    capacity_kw DECIMAL(10,2),
    inverter_status VARCHAR(30),
    FOREIGN KEY (site_id) REFERENCES SolarSite(site_id)
);

CREATE TABLE SolarPanel (
    panel_id INT PRIMARY KEY,
    site_id INT,
    inverter_id INT,
    panel_code VARCHAR(40),
    panel_type VARCHAR(50),
    capacity_kw DECIMAL(10,2),
    panel_status VARCHAR(30),
    FOREIGN KEY (site_id) REFERENCES SolarSite(site_id),
    FOREIGN KEY (inverter_id) REFERENCES Inverter(inverter_id)
);

CREATE TABLE Technician (
    technician_id INT PRIMARY KEY,
    technician_name VARCHAR(50),
    specialization VARCHAR(50),
    phone VARCHAR(20)
);

CREATE TABLE EnergyGeneration (
    generation_id INT PRIMARY KEY,
    panel_id INT,
    generation_date DATE,
    energy_generated_kwh DECIMAL(10,2),
    sunlight_hours DECIMAL(10,2),
    efficiency_percent DECIMAL(10,2),
    FOREIGN KEY (panel_id) REFERENCES SolarPanel(panel_id)
);

CREATE TABLE FaultLog (
    fault_id INT PRIMARY KEY,
    panel_id INT,
    fault_date DATE,
    fault_type VARCHAR(80),
    severity VARCHAR(30),
    fault_status VARCHAR(30),
    FOREIGN KEY (panel_id) REFERENCES SolarPanel(panel_id)
);

CREATE TABLE MaintenanceTask (
    maintenance_id INT PRIMARY KEY,
    panel_id INT,
    technician_id INT,
    maintenance_date DATE,
    maintenance_type VARCHAR(80),
    maintenance_status VARCHAR(30),
    maintenance_cost DECIMAL(10,2),
    FOREIGN KEY (panel_id) REFERENCES SolarPanel(panel_id),
    FOREIGN KEY (technician_id) REFERENCES Technician(technician_id)
);

INSERT INTO SolarSite VALUES
(1, 'Nagpur Solar Farm', 'Nagpur', '2024-01-15', 'Active'),
(2, 'Pune Rooftop Plant', 'Pune', '2024-06-10', 'Active'),
(3, 'Mumbai Industrial Solar Plant', 'Mumbai', '2025-02-20', 'Active'),
(4, 'Nashik Agro Solar Site', 'Nashik', '2025-09-05', 'Maintenance');

INSERT INTO Inverter VALUES
(1, 1, 'INV-NG-01', 100.00, 'Working'),
(2, 1, 'INV-NG-02', 120.00, 'Working'),
(3, 2, 'INV-PN-01', 80.00, 'Working'),
(4, 3, 'INV-MU-01', 150.00, 'Working'),
(5, 4, 'INV-NS-01', 90.00, 'Faulty');

INSERT INTO SolarPanel VALUES
(1, 1, 1, 'PNL-NG-001', 'Monocrystalline', 5.00, 'Working'),
(2, 1, 1, 'PNL-NG-002', 'Monocrystalline', 5.00, 'Working'),
(3, 1, 2, 'PNL-NG-003', 'Polycrystalline', 4.50, 'Faulty'),
(4, 2, 3, 'PNL-PN-001', 'Monocrystalline', 5.50, 'Working'),
(5, 2, 3, 'PNL-PN-002', 'Thin Film', 3.50, 'Working'),
(6, 3, 4, 'PNL-MU-001', 'Monocrystalline', 6.00, 'Working'),
(7, 4, 5, 'PNL-NS-001', 'Polycrystalline', 4.00, 'Under Maintenance');

INSERT INTO Technician VALUES
(1, 'Ravi Patil', 'Panel Cleaning', '9000011111'),
(2, 'Sneha Joshi', 'Inverter Repair', '9000022222'),
(3, 'Amit Verma', 'Electrical Fault Repair', '9000033333');

INSERT INTO EnergyGeneration VALUES
(1, 1, '2026-04-01', 24.50, 6.50, 82.00),
(2, 2, '2026-04-01', 23.80, 6.50, 80.00),
(3, 3, '2026-04-01', 12.40, 6.50, 45.00),
(4, 4, '2026-04-01', 27.20, 7.00, 85.00),
(5, 5, '2026-04-01', 16.50, 7.00, 78.00),
(6, 6, '2026-04-01', 30.40, 6.80, 88.00),
(7, 7, '2026-04-01', 10.20, 6.00, 40.00),
(8, 1, '2026-04-02', 25.10, 6.70, 84.00),
(9, 2, '2026-04-02', 24.20, 6.70, 81.00),
(10, 4, '2026-04-02', 28.00, 7.20, 87.00),
(11, 6, '2026-04-02', 31.10, 7.00, 89.00);

INSERT INTO FaultLog VALUES
(1, 3, '2026-04-01', 'Low energy output', 'High', 'Unresolved'),
(2, 7, '2026-04-01', 'Panel wiring issue', 'Medium', 'In Progress'),
(3, 5, '2026-04-02', 'Dust accumulation', 'Low', 'Resolved'),
(4, 3, '2026-04-03', 'Possible cell damage', 'High', 'Unresolved');

INSERT INTO MaintenanceTask VALUES
(1, 5, 1, '2026-04-02', 'Panel Cleaning', 'Completed', 1200.00),
(2, 3, 3, '2026-04-04', 'Cell Damage Inspection', 'Pending', 3500.00),
(3, 7, 2, '2026-04-05', 'Wiring Repair', 'In Progress', 2800.00),
(4, 1, 1, '2026-04-06', 'Routine Cleaning', 'Scheduled', 1000.00),
(5, 6, 3, '2026-04-07', 'Electrical Safety Check', 'Scheduled', 1500.00);

-- 1. Solar panels generating the most energy
SELECT 
    sp.panel_code,
    ss.site_name,
    SUM(eg.energy_generated_kwh) AS total_energy_generated
FROM EnergyGeneration eg
JOIN SolarPanel sp
ON eg.panel_id = sp.panel_id
JOIN SolarSite ss
ON sp.site_id = ss.site_id
GROUP BY sp.panel_code, ss.site_name
ORDER BY total_energy_generated DESC;

-- 2. Site producing highest total power
SELECT 
    ss.site_name,
    ss.city,
    SUM(eg.energy_generated_kwh) AS total_site_generation
FROM EnergyGeneration eg
JOIN SolarPanel sp
ON eg.panel_id = sp.panel_id
JOIN SolarSite ss
ON sp.site_id = ss.site_id
GROUP BY ss.site_name, ss.city
ORDER BY total_site_generation DESC;

-- 3. Faulty or under-maintenance panels
SELECT 
    sp.panel_code,
    ss.site_name,
    sp.panel_type,
    sp.panel_status
FROM SolarPanel sp
JOIN SolarSite ss
ON sp.site_id = ss.site_id
WHERE sp.panel_status IN ('Faulty', 'Under Maintenance');

-- 4. Inverter-wise energy output
SELECT 
    i.inverter_code,
    ss.site_name,
    SUM(eg.energy_generated_kwh) AS total_inverter_output
FROM EnergyGeneration eg
JOIN SolarPanel sp
ON eg.panel_id = sp.panel_id
JOIN Inverter i
ON sp.inverter_id = i.inverter_id
JOIN SolarSite ss
ON i.site_id = ss.site_id
GROUP BY i.inverter_code, ss.site_name
ORDER BY total_inverter_output DESC;

-- 5. Total energy generated
SELECT 
    SUM(energy_generated_kwh) AS total_energy_generated_kwh
FROM EnergyGeneration;

-- 6. Technicians handling most maintenance tasks
SELECT 
    t.technician_name,
    t.specialization,
    COUNT(mt.maintenance_id) AS total_tasks
FROM MaintenanceTask mt
JOIN Technician t
ON mt.technician_id = t.technician_id
GROUP BY t.technician_name, t.specialization
ORDER BY total_tasks DESC;

-- 7. Unresolved faults
SELECT 
    sp.panel_code,
    fl.fault_type,
    fl.severity,
    fl.fault_status,
    fl.fault_date
FROM FaultLog fl
JOIN SolarPanel sp
ON fl.panel_id = sp.panel_id
WHERE fl.fault_status = 'Unresolved';

-- 8. Average daily generation per panel
SELECT 
    sp.panel_code,
    ROUND(AVG(eg.energy_generated_kwh), 2) AS average_daily_generation
FROM EnergyGeneration eg
JOIN SolarPanel sp
ON eg.panel_id = sp.panel_id
GROUP BY sp.panel_code
ORDER BY average_daily_generation DESC;

-- 9. Low efficiency generation records
SELECT 
    sp.panel_code,
    eg.generation_date,
    eg.energy_generated_kwh,
    eg.efficiency_percent
FROM EnergyGeneration eg
JOIN SolarPanel sp
ON eg.panel_id = sp.panel_id
WHERE eg.efficiency_percent < 60;

-- 10. Maintenance cost by panel
SELECT 
    sp.panel_code,
    SUM(mt.maintenance_cost) AS total_maintenance_cost
FROM MaintenanceTask mt
JOIN SolarPanel sp
ON mt.panel_id = sp.panel_id
GROUP BY sp.panel_code
ORDER BY total_maintenance_cost DESC;