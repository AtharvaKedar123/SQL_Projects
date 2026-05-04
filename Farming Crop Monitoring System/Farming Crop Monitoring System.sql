-- Smart Farming Crop Monitoring System
-- Single File SQL Solution

CREATE DATABASE SmartFarmingDB;
USE SmartFarmingDB;

CREATE TABLE Farmer (
    farmer_id INT PRIMARY KEY,
    farmer_name VARCHAR(50),
    phone VARCHAR(15),
    village VARCHAR(50),
    district VARCHAR(50)
);

CREATE TABLE FarmField (
    field_id INT PRIMARY KEY,
    farmer_id INT,
    field_name VARCHAR(50),
    field_area_acres DECIMAL(6,2),
    soil_type VARCHAR(50),
    location VARCHAR(100),
    FOREIGN KEY (farmer_id) REFERENCES Farmer(farmer_id)
);

CREATE TABLE Crop (
    crop_id INT PRIMARY KEY,
    field_id INT,
    crop_name VARCHAR(50),
    crop_season VARCHAR(30),
    sowing_date DATE,
    expected_harvest_date DATE,
    growth_stage VARCHAR(50),
    FOREIGN KEY (field_id) REFERENCES FarmField(field_id)
);

CREATE TABLE SensorReading (
    reading_id INT PRIMARY KEY,
    field_id INT,
    reading_time DATETIME,
    soil_moisture_percent INT,
    temperature_celsius DECIMAL(5,2),
    humidity_percent INT,
    soil_ph DECIMAL(4,2),
    FOREIGN KEY (field_id) REFERENCES FarmField(field_id)
);

CREATE TABLE IrrigationSchedule (
    irrigation_id INT PRIMARY KEY,
    field_id INT,
    irrigation_date DATE,
    irrigation_time TIME,
    water_used_liters INT,
    irrigation_status VARCHAR(30),
    FOREIGN KEY (field_id) REFERENCES FarmField(field_id)
);

CREATE TABLE FertilizerUsage (
    fertilizer_id INT PRIMARY KEY,
    field_id INT,
    fertilizer_name VARCHAR(50),
    fertilizer_type VARCHAR(50),
    quantity_kg DECIMAL(8,2),
    usage_date DATE,
    FOREIGN KEY (field_id) REFERENCES FarmField(field_id)
);

CREATE TABLE CropHealth (
    health_id INT PRIMARY KEY,
    crop_id INT,
    check_date DATE,
    health_status VARCHAR(30),
    disease_detected VARCHAR(80),
    action_required VARCHAR(150),
    FOREIGN KEY (crop_id) REFERENCES Crop(crop_id)
);

INSERT INTO Farmer VALUES
(1, 'Ramesh Patil', '9999999999', 'Saoner', 'Nagpur'),
(2, 'Suresh Yadav', '8888888888', 'Kalmeshwar', 'Nagpur'),
(3, 'Amit Verma', '7777777777', 'Hingna', 'Nagpur');

INSERT INTO FarmField VALUES
(1, 1, 'Field A', 3.50, 'Black Soil', 'Near River Side'),
(2, 1, 'Field B', 2.00, 'Clay Soil', 'Behind Farm House'),
(3, 2, 'Field C', 4.25, 'Sandy Soil', 'Village Border'),
(4, 3, 'Field D', 5.00, 'Loamy Soil', 'Main Road Farm');

INSERT INTO Crop VALUES
(1, 1, 'Cotton', 'Kharif', '2026-06-10', '2026-11-20', 'Vegetative'),
(2, 2, 'Soybean', 'Kharif', '2026-06-15', '2026-10-15', 'Flowering'),
(3, 3, 'Wheat', 'Rabi', '2026-11-01', '2027-03-15', 'Seedling'),
(4, 4, 'Tomato', 'Annual', '2026-04-01', '2026-07-20', 'Fruiting');

INSERT INTO SensorReading VALUES
(1, 1, '2026-04-29 06:00:00', 28, 34.50, 45, 6.80),
(2, 2, '2026-04-29 06:10:00', 18, 36.00, 40, 5.20),
(3, 3, '2026-04-29 06:20:00', 42, 32.00, 50, 7.10),
(4, 4, '2026-04-29 06:30:00', 22, 35.50, 48, 8.30),
(5, 1, '2026-04-29 12:00:00', 25, 38.00, 38, 6.70);

INSERT INTO IrrigationSchedule VALUES
(1, 1, '2026-04-29', '07:00:00', 1200, 'Completed'),
(2, 2, '2026-04-29', '08:00:00', 900, 'Pending'),
(3, 4, '2026-04-29', '09:00:00', 1500, 'Pending'),
(4, 3, '2026-04-30', '07:30:00', 1000, 'Scheduled');

INSERT INTO FertilizerUsage VALUES
(1, 1, 'Urea', 'Nitrogen', 50.00, '2026-04-20'),
(2, 2, 'DAP', 'Phosphorus', 35.00, '2026-04-21'),
(3, 3, 'Potash', 'Potassium', 40.00, '2026-04-22'),
(4, 4, 'Organic Compost', 'Organic', 100.00, '2026-04-23');

INSERT INTO CropHealth VALUES
(1, 1, '2026-04-29', 'Healthy', 'None', 'No action required'),
(2, 2, '2026-04-29', 'Unhealthy', 'Leaf Spot', 'Apply recommended fungicide'),
(3, 3, '2026-04-29', 'Healthy', 'None', 'Monitor weekly'),
(4, 4, '2026-04-29', 'Unhealthy', 'Nutrient Deficiency', 'Apply organic fertilizer');

-- 1. Fields needing irrigation
SELECT 
    ff.field_name,
    ff.soil_type,
    sr.soil_moisture_percent,
    sr.reading_time
FROM SensorReading sr
JOIN FarmField ff
ON sr.field_id = ff.field_id
WHERE sr.soil_moisture_percent < 30;

-- 2. Unhealthy crops
SELECT 
    c.crop_name,
    ff.field_name,
    ch.health_status,
    ch.disease_detected,
    ch.action_required
FROM CropHealth ch
JOIN Crop c
ON ch.crop_id = c.crop_id
JOIN FarmField ff
ON c.field_id = ff.field_id
WHERE ch.health_status = 'Unhealthy';

-- 3. Latest low soil moisture fields
SELECT 
    ff.field_name,
    f.farmer_name,
    sr.soil_moisture_percent,
    sr.temperature_celsius,
    sr.humidity_percent
FROM SensorReading sr
JOIN FarmField ff
ON sr.field_id = ff.field_id
JOIN Farmer f
ON ff.farmer_id = f.farmer_id
WHERE sr.soil_moisture_percent < 30;

-- 4. Total fertilizer used by field
SELECT 
    ff.field_name,
    SUM(fu.quantity_kg) AS total_fertilizer_used_kg
FROM FertilizerUsage fu
JOIN FarmField ff
ON fu.field_id = ff.field_id
GROUP BY ff.field_name
ORDER BY total_fertilizer_used_kg DESC;

-- 5. Crop grown in each field
SELECT 
    f.farmer_name,
    ff.field_name,
    ff.field_area_acres,
    c.crop_name,
    c.crop_season,
    c.growth_stage
FROM Crop c
JOIN FarmField ff
ON c.field_id = ff.field_id
JOIN Farmer f
ON ff.farmer_id = f.farmer_id;

-- 6. Fields with abnormal pH levels
SELECT 
    ff.field_name,
    sr.soil_ph,
    sr.reading_time
FROM SensorReading sr
JOIN FarmField ff
ON sr.field_id = ff.field_id
WHERE sr.soil_ph < 5.50
OR sr.soil_ph > 8.00;

-- 7. Pending irrigation schedules
SELECT 
    ff.field_name,
    isch.irrigation_date,
    isch.irrigation_time,
    isch.water_used_liters,
    isch.irrigation_status
FROM IrrigationSchedule isch
JOIN FarmField ff
ON isch.field_id = ff.field_id
WHERE isch.irrigation_status = 'Pending';

-- 8. Complete crop monitoring report
SELECT 
    f.farmer_name,
    ff.field_name,
    c.crop_name,
    c.growth_stage,
    sr.soil_moisture_percent,
    sr.temperature_celsius,
    sr.humidity_percent,
    sr.soil_ph,
    ch.health_status,
    ch.action_required
FROM Crop c
JOIN FarmField ff
ON c.field_id = ff.field_id
JOIN Farmer f
ON ff.farmer_id = f.farmer_id
JOIN SensorReading sr
ON ff.field_id = sr.field_id
JOIN CropHealth ch
ON c.crop_id = ch.crop_id;