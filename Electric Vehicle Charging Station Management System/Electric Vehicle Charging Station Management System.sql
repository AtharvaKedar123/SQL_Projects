-- Electric Vehicle Charging Station Management System
-- Single File SQL Solution

CREATE DATABASE EVChargingDB;
USE EVChargingDB;

CREATE TABLE EVUser (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(80),
    phone VARCHAR(15),
    email VARCHAR(80),
    city VARCHAR(50)
);

CREATE TABLE ElectricVehicle (
    vehicle_id INT PRIMARY KEY,
    user_id INT,
    vehicle_number VARCHAR(20),
    vehicle_model VARCHAR(80),
    battery_capacity_kwh DECIMAL(6,2),
    vehicle_type VARCHAR(40),
    FOREIGN KEY (user_id) REFERENCES EVUser(user_id)
);

CREATE TABLE ChargingStation (
    station_id INT PRIMARY KEY,
    station_name VARCHAR(100),
    city VARCHAR(50),
    location VARCHAR(120),
    total_chargers INT
);

CREATE TABLE ChargerPoint (
    charger_id INT PRIMARY KEY,
    station_id INT,
    charger_code VARCHAR(30),
    charger_type VARCHAR(40),
    power_capacity_kw DECIMAL(6,2),
    rate_per_kwh DECIMAL(10,2),
    charger_status VARCHAR(30),
    FOREIGN KEY (station_id) REFERENCES ChargingStation(station_id)
);

CREATE TABLE ChargingSession (
    session_id INT PRIMARY KEY,
    vehicle_id INT,
    charger_id INT,
    session_start DATETIME,
    session_end DATETIME,
    session_status VARCHAR(30),
    FOREIGN KEY (vehicle_id) REFERENCES ElectricVehicle(vehicle_id),
    FOREIGN KEY (charger_id) REFERENCES ChargerPoint(charger_id)
);

CREATE TABLE PowerUsage (
    usage_id INT PRIMARY KEY,
    session_id INT,
    units_consumed_kwh DECIMAL(8,2),
    charging_duration_minutes INT,
    total_cost DECIMAL(10,2),
    FOREIGN KEY (session_id) REFERENCES ChargingSession(session_id)
);

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    session_id INT,
    payment_method VARCHAR(30),
    payment_status VARCHAR(30),
    payment_amount DECIMAL(10,2),
    payment_date DATE,
    FOREIGN KEY (session_id) REFERENCES ChargingSession(session_id)
);

INSERT INTO EVUser VALUES
(1, 'Atharva Kedar', '9999999999', 'atharva@email.com', 'Nagpur'),
(2, 'Rohan Mehta', '8888888888', 'rohan@email.com', 'Pune'),
(3, 'Sneha Patil', '7777777777', 'sneha@email.com', 'Mumbai'),
(4, 'Priya Sharma', '6666666666', 'priya@email.com', 'Bangalore'),
(5, 'Aman Khan', '5555555555', 'aman@email.com', 'Hyderabad');

INSERT INTO ElectricVehicle VALUES
(1, 1, 'MH31EV1001', 'Tata Nexon EV', 40.50, 'Car'),
(2, 2, 'MH12EV2002', 'MG ZS EV', 50.30, 'Car'),
(3, 3, 'MH01EV3003', 'Ather 450X', 3.70, 'Scooter'),
(4, 4, 'KA05EV4004', 'Ola S1 Pro', 4.00, 'Scooter'),
(5, 5, 'TS09EV5005', 'Hyundai Kona Electric', 39.20, 'Car');

INSERT INTO ChargingStation VALUES
(1, 'GreenVolt Station', 'Nagpur', 'Sitabuldi Main Road', 4),
(2, 'EcoCharge Hub', 'Pune', 'Hinjewadi Phase 1', 5),
(3, 'PlugPoint Express', 'Mumbai', 'Andheri East', 6),
(4, 'RapidEV Charge', 'Bangalore', 'Indiranagar', 4);

INSERT INTO ChargerPoint VALUES
(1, 1, 'GV-C1', 'Fast Charger', 60.00, 22.00, 'Available'),
(2, 1, 'GV-C2', 'Normal Charger', 22.00, 15.00, 'Occupied'),
(3, 2, 'EC-C1', 'Fast Charger', 50.00, 20.00, 'Available'),
(4, 2, 'EC-C2', 'Ultra Fast Charger', 120.00, 30.00, 'Maintenance'),
(5, 3, 'PP-C1', 'Normal Charger', 22.00, 14.00, 'Occupied'),
(6, 3, 'PP-C2', 'Fast Charger', 60.00, 24.00, 'Available'),
(7, 4, 'RE-C1', 'Ultra Fast Charger', 150.00, 32.00, 'Available');

INSERT INTO ChargingSession VALUES
(1, 1, 2, '2026-04-29 09:00:00', '2026-04-29 10:15:00', 'Completed'),
(2, 2, 3, '2026-04-29 11:00:00', '2026-04-29 12:10:00', 'Completed'),
(3, 3, 5, '2026-04-29 13:00:00', NULL, 'Active'),
(4, 4, 1, '2026-04-28 15:00:00', '2026-04-28 15:45:00', 'Completed'),
(5, 5, 6, '2026-04-28 17:00:00', '2026-04-28 18:20:00', 'Completed'),
(6, 1, 7, '2026-04-29 18:00:00', NULL, 'Active');

INSERT INTO PowerUsage VALUES
(1, 1, 32.50, 75, 715.00),
(2, 2, 28.00, 70, 560.00),
(3, 3, 2.10, 35, 29.40),
(4, 4, 3.00, 45, 66.00),
(5, 5, 35.20, 80, 844.80),
(6, 6, 18.00, 40, 576.00);

INSERT INTO Payment VALUES
(1, 1, 'UPI', 'Paid', 715.00, '2026-04-29'),
(2, 2, 'Card', 'Paid', 560.00, '2026-04-29'),
(3, 3, 'Wallet', 'Pending', 29.40, '2026-04-29'),
(4, 4, 'UPI', 'Paid', 66.00, '2026-04-28'),
(5, 5, 'Card', 'Paid', 844.80, '2026-04-28'),
(6, 6, 'Wallet', 'Pending', 576.00, '2026-04-29');

-- 1. Show all EV users with their vehicles
SELECT 
    eu.user_name,
    eu.city,
    ev.vehicle_number,
    ev.vehicle_model,
    ev.vehicle_type,
    ev.battery_capacity_kwh
FROM EVUser eu
JOIN ElectricVehicle ev
ON eu.user_id = ev.user_id;

-- 2. Show charger availability with station details
SELECT 
    cs.station_name,
    cs.city,
    cp.charger_code,
    cp.charger_type,
    cp.power_capacity_kw,
    cp.rate_per_kwh,
    cp.charger_status
FROM ChargerPoint cp
JOIN ChargingStation cs
ON cp.station_id = cs.station_id
ORDER BY cp.charger_status;

-- 3. Show currently available chargers
SELECT 
    cs.station_name,
    cs.location,
    cp.charger_code,
    cp.charger_type,
    cp.power_capacity_kw,
    cp.rate_per_kwh
FROM ChargerPoint cp
JOIN ChargingStation cs
ON cp.station_id = cs.station_id
WHERE cp.charger_status = 'Available';

-- 4. Show active charging sessions
SELECT 
    csn.session_id,
    eu.user_name,
    ev.vehicle_number,
    ev.vehicle_model,
    st.station_name,
    cp.charger_code,
    csn.session_start,
    csn.session_status
FROM ChargingSession csn
JOIN ElectricVehicle ev
ON csn.vehicle_id = ev.vehicle_id
JOIN EVUser eu
ON ev.user_id = eu.user_id
JOIN ChargerPoint cp
ON csn.charger_id = cp.charger_id
JOIN ChargingStation st
ON cp.station_id = st.station_id
WHERE csn.session_status = 'Active';

-- 5. Total revenue generated from paid charging sessions
SELECT 
    SUM(payment_amount) AS total_revenue
FROM Payment
WHERE payment_status = 'Paid';

-- 6. Revenue by charging station
SELECT 
    st.station_name,
    st.city,
    SUM(p.payment_amount) AS station_revenue
FROM Payment p
JOIN ChargingSession csn
ON p.session_id = csn.session_id
JOIN ChargerPoint cp
ON csn.charger_id = cp.charger_id
JOIN ChargingStation st
ON cp.station_id = st.station_id
WHERE p.payment_status = 'Paid'
GROUP BY st.station_name, st.city
ORDER BY station_revenue DESC;

-- 7. Total power consumed by each vehicle
SELECT 
    ev.vehicle_number,
    ev.vehicle_model,
    eu.user_name,
    SUM(pu.units_consumed_kwh) AS total_power_consumed
FROM PowerUsage pu
JOIN ChargingSession csn
ON pu.session_id = csn.session_id
JOIN ElectricVehicle ev
ON csn.vehicle_id = ev.vehicle_id
JOIN EVUser eu
ON ev.user_id = eu.user_id
GROUP BY ev.vehicle_number, ev.vehicle_model, eu.user_name
ORDER BY total_power_consumed DESC;

-- 8. Users who charged vehicles the most
SELECT 
    eu.user_name,
    COUNT(csn.session_id) AS total_charging_sessions
FROM ChargingSession csn
JOIN ElectricVehicle ev
ON csn.vehicle_id = ev.vehicle_id
JOIN EVUser eu
ON ev.user_id = eu.user_id
GROUP BY eu.user_name
ORDER BY total_charging_sessions DESC;

-- 9. Pending payments
SELECT 
    p.payment_id,
    eu.user_name,
    ev.vehicle_number,
    p.payment_method,
    p.payment_status,
    p.payment_amount,
    p.payment_date
FROM Payment p
JOIN ChargingSession csn
ON p.session_id = csn.session_id
JOIN ElectricVehicle ev
ON csn.vehicle_id = ev.vehicle_id
JOIN EVUser eu
ON ev.user_id = eu.user_id
WHERE p.payment_status = 'Pending';

-- 10. Charger status count
SELECT 
    charger_status,
    COUNT(charger_id) AS total_chargers
FROM ChargerPoint
GROUP BY charger_status;

-- 11. Completed charging session report
SELECT 
    csn.session_id,
    eu.user_name,
    ev.vehicle_model,
    st.station_name,
    cp.charger_type,
    pu.units_consumed_kwh,
    pu.charging_duration_minutes,
    pu.total_cost,
    p.payment_status
FROM ChargingSession csn
JOIN ElectricVehicle ev
ON csn.vehicle_id = ev.vehicle_id
JOIN EVUser eu
ON ev.user_id = eu.user_id
JOIN ChargerPoint cp
ON csn.charger_id = cp.charger_id
JOIN ChargingStation st
ON cp.station_id = st.station_id
JOIN PowerUsage pu
ON csn.session_id = pu.session_id
JOIN Payment p
ON csn.session_id = p.session_id
WHERE csn.session_status = 'Completed';

-- 12. Update charger status after session completed
UPDATE ChargerPoint
SET charger_status = 'Available'
WHERE charger_id = 2;