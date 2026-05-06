
CREATE DATABASE StreamingPlatformDB;
USE StreamingPlatformDB;

CREATE TABLE UserAccount (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(50),
    email VARCHAR(80),
    city VARCHAR(50),
    join_date DATE
);

CREATE TABLE SubscriptionPlan (
    plan_id INT PRIMARY KEY,
    plan_name VARCHAR(50),
    monthly_price DECIMAL(10,2),
    video_quality VARCHAR(30)
);

CREATE TABLE UserSubscription (
    subscription_id INT PRIMARY KEY,
    user_id INT,
    plan_id INT,
    start_date DATE,
    end_date DATE,
    payment_status VARCHAR(30),
    subscription_status VARCHAR(30),
    FOREIGN KEY (user_id) REFERENCES UserAccount(user_id),
    FOREIGN KEY (plan_id) REFERENCES SubscriptionPlan(plan_id)
);

CREATE TABLE Movie (
    movie_id INT PRIMARY KEY,
    movie_title VARCHAR(100),
    genre VARCHAR(50),
    release_year INT,
    duration_minutes INT,
    language VARCHAR(50)
);

CREATE TABLE WatchHistory (
    history_id INT PRIMARY KEY,
    user_id INT,
    movie_id INT,
    watch_date DATE,
    watch_minutes INT,
    FOREIGN KEY (user_id) REFERENCES UserAccount(user_id),
    FOREIGN KEY (movie_id) REFERENCES Movie(movie_id)
);

CREATE TABLE Rating (
    rating_id INT PRIMARY KEY,
    user_id INT,
    movie_id INT,
    rating_value INT,
    review VARCHAR(255),
    rating_date DATE,
    FOREIGN KEY (user_id) REFERENCES UserAccount(user_id),
    FOREIGN KEY (movie_id) REFERENCES Movie(movie_id)
);

INSERT INTO UserAccount VALUES
(1, 'Atharva Kedar', 'atharva@email.com', 'Nagpur', '2026-01-10'),
(2, 'Neha Sharma', 'neha@email.com', 'Mumbai', '2026-02-15'),
(3, 'Rohan Mehta', 'rohan@email.com', 'Pune', '2026-03-01'),
(4, 'Priya Patil', 'priya@email.com', 'Nagpur', '2026-03-20');

INSERT INTO SubscriptionPlan VALUES
(1, 'Basic', 199.00, 'HD'),
(2, 'Standard', 399.00, 'Full HD'),
(3, 'Premium', 599.00, '4K');

INSERT INTO UserSubscription VALUES
(1, 1, 3, '2026-04-01', '2026-04-30', 'Paid', 'Active'),
(2, 2, 2, '2026-04-01', '2026-04-30', 'Paid', 'Active'),
(3, 3, 1, '2026-04-01', '2026-04-30', 'Pending', 'Active'),
(4, 4, 2, '2026-03-01', '2026-03-31', 'Paid', 'Expired');

INSERT INTO Movie VALUES
(1, 'Shadow City', 'Thriller', 2024, 130, 'English'),
(2, 'Galaxy War', 'Sci-Fi', 2025, 150, 'English'),
(3, 'Love in Mumbai', 'Romance', 2023, 125, 'Hindi'),
(4, 'Code Hunter', 'Action', 2026, 140, 'English'),
(5, 'Dark Forest', 'Horror', 2024, 110, 'Hindi');

INSERT INTO WatchHistory VALUES
(1, 1, 1, '2026-04-10', 130),
(2, 1, 2, '2026-04-12', 120),
(3, 2, 3, '2026-04-11', 125),
(4, 3, 2, '2026-04-13', 150),
(5, 4, 5, '2026-03-25', 90),
(6, 2, 1, '2026-04-15', 100),
(7, 1, 4, '2026-04-20', 140);

INSERT INTO Rating VALUES
(1, 1, 1, 5, 'Amazing thriller movie', '2026-04-10'),
(2, 1, 2, 4, 'Great visuals and story', '2026-04-12'),
(3, 2, 3, 4, 'Emotional and beautiful', '2026-04-11'),
(4, 3, 2, 5, 'Best sci-fi movie', '2026-04-13'),
(5, 4, 5, 3, 'Decent horror movie', '2026-03-25');

-- 1. Most watched movies
SELECT 
    m.movie_title,
    COUNT(wh.history_id) AS total_views
FROM WatchHistory wh
JOIN Movie m
ON wh.movie_id = m.movie_id
GROUP BY m.movie_title
ORDER BY total_views DESC;

-- 2. Users with highest watch time
SELECT 
    u.user_name,
    SUM(wh.watch_minutes) AS total_watch_minutes
FROM WatchHistory wh
JOIN UserAccount u
ON wh.user_id = u.user_id
GROUP BY u.user_name
ORDER BY total_watch_minutes DESC;

-- 3. Highest rated movies
SELECT 
    m.movie_title,
    AVG(r.rating_value) AS average_rating
FROM Rating r
JOIN Movie m
ON r.movie_id = m.movie_id
GROUP BY m.movie_title
ORDER BY average_rating DESC;

-- 4. Subscription revenue
SELECT 
    SUM(sp.monthly_price) AS total_subscription_revenue
FROM UserSubscription us
JOIN SubscriptionPlan sp
ON us.plan_id = sp.plan_id
WHERE us.payment_status = 'Paid';

-- 5. Active subscribers
SELECT 
    u.user_name,
    sp.plan_name,
    sp.monthly_price,
    us.start_date,
    us.end_date
FROM UserSubscription us
JOIN UserAccount u
ON us.user_id = u.user_id
JOIN SubscriptionPlan sp
ON us.plan_id = sp.plan_id
WHERE us.subscription_status = 'Active';

-- 6. Popular genre by watch count
SELECT 
    m.genre,
    COUNT(wh.history_id) AS total_views
FROM WatchHistory wh
JOIN Movie m
ON wh.movie_id = m.movie_id
GROUP BY m.genre
ORDER BY total_views DESC;

-- 7. Users with pending subscription payment
SELECT 
    u.user_name,
    sp.plan_name,
    us.payment_status,
    us.subscription_status
FROM UserSubscription us
JOIN UserAccount u
ON us.user_id = u.user_id
JOIN SubscriptionPlan sp
ON us.plan_id = sp.plan_id
WHERE us.payment_status = 'Pending';

-- 8. Movie reviews
SELECT 
    u.user_name,
    m.movie_title,
    r.rating_value,
    r.review,
    r.rating_date
FROM Rating r
JOIN UserAccount u
ON r.user_id = u.user_id
JOIN Movie m
ON r.movie_id = m.movie_id;