-- Databricks notebook source
--Create schema for tables
CREATE SCHEMA IF NOT EXISTS my_joins_exercise_db;

--users table
CREATE TABLE my_joins_exercise_db.users
(user_id INTEGER PRIMARY KEY,
user_name STRING,
country STRING
);

--insert into user table
INSERT INTO my_joins_exercise_db.users
(user_id,
user_name,
country)
 VALUES
    (1, 'Nomvula', 'Johannesburg'),
    (2, 'David',   'Cape Town'),
    (3, 'Anele',   'Durban'),
    (4, 'Kabelo',  'Pretoria'),
    (5, 'Lerato',  'Port Elizabeth');

--plan table
CREATE TABLE my_joins_exercise_db.plans
(plan_id INTEGER PRIMARY KEY,
plan_name STRING,
monthly_price INTEGER
); 

--insert into plan table
INSERT INTO my_joins_exercise_db.plans
(plan_id,
plan_name,
monthly_price)
VALUES
    (10, 'Basic',    79),
    (11, 'Standard', 129),
    (12, 'Premium',  199),
    (13, 'Family',   249),
    (14, 'Mobile',   59);

--subscription table
CREATE TABLE workspace.my_joins_exercise_db.subscriptions
(subscription_id INTEGER PRIMARY KEY,
user_id INTEGER,
plan_id INTEGER,
start_date  DATE
);

INSERT INTO workspace.my_joins_exercise_db.subscriptions
(subscription_id,
user_id,
plan_id,
start_date)
VALUES
    (501, 1, 10, '2026-01-15'),
    (502, 2, 11, '2026-02-01'),
    (503, 1, 12, '2026-03-10'),
    (504, 6, 11, '2026-03-20'),  -- user 6 does NOT exist in users
    (505, 3, 13, '2026-04-05');

--show table
CREATE TABLE my_joins_exercise_db.show
(
    show_id    INTEGER,
    show_title STRING,
    genre      STRING
);

INSERT INTO my_joins_exercise_db.show
(show_id,
show_title,
genre)
VALUES
(701, 'Comedy Hour',  'Comedy'),
    (702, 'Crime Time',   'Drama'),
    (703, 'Tech Tales',   'Documentary'),
    (704, 'Cooking Lab',  'Lifestyle'),
    (706, 'Wild Earth',   'Documentary');

CREATE TABLE workspace.my_joins_exercise_db.viewing_sessions (
    session_id    INTEGER,
    user_id       INTEGER,
    show_id       INTEGER,
    watch_minutes INTEGER
);
INSERT INTO viewing_sessions VALUES
    (901, 1, 701, 45),
    (902, 2, 703, 30),
    (903, 1, 702, 60),
    (904, 7, 701, 20),  -- user 7 does NOT exist in users

    --Question 1
 SELECT
    u.user_id,
    u.user_name,
    s.subscription_id,
    s.start_date
FROM workspace.my_joins_exercise_db.users u
INNER JOIN subscriptions s 
ON u.user_id = s.user_id;

--Question 2
SELECT
    s.subscription_id,
    s.user_id,
    p.plan_name,
    p.monthly_price
FROM subscriptions s
INNER JOIN workspace.my_joins_exercise_db.plans p 
ON s.plan_id = p.plan_id;

--Question 3
SELECT
    vs.session_id,
    vs.user_id,
    sh.show_title,
    sh.genre,
    vs.watch_minutes
FROM viewing_sessions vs
INNER JOIN workspace.my_joins_exercise_db.show sh 
ON vs.show_id = sh.show_id;

--Question 4
SELECT
    u.user_name,
    u.country,
    vs.session_id,
    vs.show_id,
    vs.watch_minutes
FROM workspace.my_joins_exercise_db.users u
INNER JOIN viewing_sessions vs 
ON u.user_id = vs.user_id;

--Questionn 5
SELECT
    u.user_name,
    u.country,
    p.plan_name,
    p.monthly_price,
    s.start_date
FROM workspace.my_joins_exercise_db.users u
INNER JOIN subscriptions s ON u.user_id = s.user_id
INNER JOIN workspace.my_joins_exercise_db.plans p         ON s.plan_id  = p.plan_id;

--Question 6
SELECT
    u.user_id,
    u.user_name,
    s.subscription_id,
    s.start_date
FROM workspace.my_joins_exercise_db.users u
LEFT JOIN subscriptions s 
ON u.user_id = s.user_id;

--Question 7
SELECT
    p.plan_id,
    p.plan_name,
    s.subscription_id,
    s.user_id
FROM workspace.my_joins_exercise_db.plans p
LEFT JOIN subscriptions s 
ON p.plan_id = s.plan_id;

--Question 8
SELECT
    sh.show_id,
    sh.show_title,
    vs.session_id,
    vs.watch_minutes
FROM workspace.my_joins_exercise_db.show sh
LEFT JOIN viewing_sessions vs
    ON sh.show_id = vs.show_id;

--Question 9
SELECT
    vs.session_id,
    vs.show_id,
    vs.watch_minutes,
    u.user_id,
    u.user_name
FROM viewing_sessions vs
LEFT JOIN workspace.my_joins_exercise_db.users u
    ON vs.user_id = u.user_id;

--Question 10
SELECT
    u.user_name,
    u.country,
    p.plan_name,
    p.monthly_price
FROM workspace.my_joins_exercise_db.users u
LEFT JOIN subscriptions s
    ON u.user_id = s.user_id
LEFT JOIN workspace.my_joins_exercise_db.plans p
    ON s.plan_id = p.plan_id;

--Question 11
SELECT
    u.user_id,
    u.user_name,
    s.subscription_id,
    s.start_date
FROM workspace.my_joins_exercise_db.users u
FULL OUTER JOIN subscriptions s 
ON u.user_id = s.user_id;

--Question 12
SELECT
    p.plan_id,
    p.plan_name,
    s.subscription_id,
    s.user_id
FROM workspace.my_joins_exercise_db.plans p
FULL OUTER JOIN subscriptions s 
ON p.plan_id = s.plan_id;

--Question 13
SELECT
    sh.show_id,
    sh.show_title,
    vs.session_id,
    vs.watch_minutes
FROM workspace.my_joins_exercise_db.show sh
FULL OUTER JOIN viewing_sessions vs 
ON sh.show_id = vs.show_id;

--Question 14
SELECT
    u.user_id,
    u.user_name,
    vs.session_id,
    vs.show_id,
    vs.watch_minutes
FROM workspace.my_joins_exercise_db.users u
FULL OUTER JOIN viewing_sessions vs 
ON u.user_id = vs.user_id;

--Question 15
SELECT
    COALESCE(u.user_id, s.user_id) AS user_id,
    u.user_name,
    s.subscription_id,
    COALESCE(p.plan_id, s.plan_id) AS plan_id,
    p.plan_name
FROM workspace.my_joins_exercise_db.users u
FULL OUTER JOIN subscriptions s
    ON u.user_id = s.user_id
FULL OUTER JOIN workspace.my_joins_exercise_db.plans p
    ON s.plan_id = p.plan_id;

--Bonus 1
SELECT
    u.user_id,
    u.user_name
FROM workspace.my_joins_exercise_db.users u
LEFT JOIN subscriptions s ON u.user_id = s.user_id
WHERE s.subscription_id IS NULL;

--Bonus 2
SELECT
    s.subscription_id,
    s.user_id,
    s.start_date
FROM subscriptions s
LEFT JOIN workspace.my_joins_exercise_db.users u ON s.user_id = u.user_id
WHERE u.user_id IS NULL;

--Bonus 3
SELECT
    sh.show_id,
    sh.show_title
FROM workspace.my_joins_exercise_db.show sh
LEFT JOIN viewing_sessions vs ON sh.show_id = vs.show_id
WHERE vs.session_id IS NULL;

--Bonus 4
SELECT
    vs.session_id,
    vs.user_id,
    vs.show_id,
    vs.watch_minutes
FROM viewing_sessions vs
LEFT JOIN workspace.my_joins_exercise_db.show sh ON vs.show_id = sh.show_id
WHERE sh.show_id IS NULL;

--Bonus 5
SELECT
    p.plan_id,
    p.plan_name
FROM workspace.my_joins_exercise_db.plans p
LEFT JOIN subscriptions s ON p.plan_id = s.plan_id
WHERE s.subscription_id IS NULL;
