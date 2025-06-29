create database project
use project

--- SQL Table Creation (DDL): 

CREATE TABLE Trainee (
    trainee_id INT PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(10),
    email VARCHAR(100),
    background VARCHAR(100)
);

select * from Trainee

CREATE TABLE Trainer (
    trainer_id INT PRIMARY KEY,
    name VARCHAR(100),
    specialty VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100)
);


CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    title VARCHAR(100),
    category VARCHAR(100),
    duration_hours INT,
    level VARCHAR(50)
);

CREATE TABLE Schedule (
    schedule_id INT PRIMARY KEY,
    course_id INT,
    trainer_id INT,
    start_date DATE,
    end_date DATE,
    time_slot VARCHAR(50),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (trainer_id) REFERENCES Trainer(trainer_id)
);

CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY,
    trainee_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (trainee_id) REFERENCES Trainee(trainee_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

---  Data Insertion (DML):

INSERT INTO Trainee (trainee_id, name, gender, email, background)
VALUES
(1, 'Aisha Al-Harthy', 'Female', 'isha@example.com ', 'Engineering '),
(2, 'Sultan Al-Farsi', 'Male', 'sultan@example.com ', 'Business '),
(3, 'Mariam Al-Saadi', 'Female', ' mariam@example.com', 'Marketing '),
(4, 'Omar Al-Balushi', 'Male', 'omar@example.com', 'Computer Science'),
(5, 'Fatma Al-Hinai', 'Female', 'fatma@example.com', 'Data Science');

select * from Trainee

INSERT INTO Trainer (trainer_id, name, specialty, phone, email) 
VALUES
(1, 'Khalid Al-Maawali ', 'Databases', '+968 91234567', 'halid@example.com'),
(2, 'Noura Al-Kindi', 'Web Development', '+968 92345678 ', 'noura@example.com'),
(3, 'Salim Al-Harthy', 'Data Science', '+968 93456789', ' salim@example.com');

select * from Trainer

INSERT INTO Course (course_id, title, category, duration_hours, level) 
VALUES
(1, 'Database Fundamentals', 'Databases', 20, 'Beginner'),
(2, 'Web Development Basics', 'Web', 30, 'Beginner'),
(3, 'Data Science Introduction', 'Data Science', 25, 'Intermediate'),
(4, 'Advanced SQL Queries', 'Databases', 15 , 'Advanced ');

select * from Course

INSERT INTO Schedule (schedule_id, course_id, trainer_id, start_date, end_date, time_slot)
VALUES
(1, 1, 1, '2025-07-01', '2025-07-10 ', 'Morning'),
(2, 2, 2, '2025-07-05', '2025-07-20', 'Evening'),
(3, 3, 3, '2025-07-10', '2025-07-25', 'Weekend'),
(4, 4, 1, '2025-07-15', '2025-07-22', 'Morning ');

select * from Schedule

INSERT INTO Enrollment (enrollment_id, trainee_id, course_id, enrollment_date)
VALUES
(1, 1, 1, '2025-06-01'),
(2, 2, 1, '2025-06-02'),
(3, 3, 2, '2025-06-03'),
(4, 4, 3, '2025-06-04'),
(5, 5, 3, '2025-06-05'),
(6, 1, 4, '2025-06-06');

select * from Enrollment

---  SQL Query Instructions:
--1# Trainee Perspective 

--1. Show all available courses (title, level, category)

SELECT title, level, category
FROM Course;

--2. View beginner-level Data Science courses, it must be empti 

SELECT title, level, category
FROM Course
WHERE level = 'Beginner' and category = 'Data Science';


SELECT title, level, category
FROM Course
WHERE level = 'Beginner';

--3. Show courses the trainee(1) is enrolled in:

SELECT c.title
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
WHERE e.trainee_id = 1;

-- 4. View schedule (start_date, time_slot) for trainee's enrolled courses
SELECT s.start_date, s.time_slot
FROM Enrollment e
JOIN Schedule s ON e.course_id = s.course_id
WHERE e.trainee_id = 1;

--5. Count how many courses the trainee(1) is enrolled in

SELECT COUNT(*) AS course_count
FROM Enrollment
WHERE trainee_id = 1;



--6. Fanction to Show course titles, trainer names, and time slots the trainee is attending:

SELECT c.title, t.name AS trainer_name, s.time_slot
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
JOIN Schedule s ON c.course_id = s.course_id
JOIN Trainer t ON s.trainer_id = t.trainer_id
WHERE e.trainee_id = 1;

-- 2# Trainer Perspective

-- 1. List all courses the trainer is assigned to (trainer_id = 1)

SELECT DISTINCT c.title
FROM Schedule s
JOIN Course c ON s.course_id = c.course_id
WHERE s.trainer_id = 1;

-- 2. Show upcoming sessions (future sessions for trainer)

SELECT start_date, end_date, time_slot
FROM Schedule
WHERE trainer_id = 1 AND start_date > CONVERT(DATE, GETDATE());

--3. See how many trainees are enrolled in each of your courses

SELECT c.title, COUNT(e.trainee_id) AS total_trainees
FROM Schedule s
JOIN Course c ON s.course_id = c.course_id
LEFT JOIN Enrollment e ON c.course_id = e.course_id
WHERE s.trainer_id = 1
GROUP BY c.title;

-- 4. List names and emails of trainees in each of your courses

SELECT t.name, t.email, c.title
FROM Schedule s
JOIN Course c ON s.course_id = c.course_id
JOIN Enrollment e ON c.course_id = e.course_id
JOIN Trainee t ON e.trainee_id = t.trainee_id
WHERE s.trainer_id = 1;

-- 5. Show the trainer's contact info and assigned courses

SELECT tr.phone, tr.email, c.title
FROM Trainer tr
JOIN Schedule s ON tr.trainer_id = s.trainer_id
JOIN Course c ON s.course_id = c.course_id
WHERE tr.trainer_id = 1;

-- 6. Count the number of courses the trainer teaches

SELECT COUNT(DISTINCT course_id) AS course_count
FROM Schedule
WHERE trainer_id = 1;

--3# Admin Perspective:
--1. Add a new course
INSERT INTO Course (course_id, title, category, duration_hours, level)
VALUES (5, 'Data Basics', 'Data Science', 25, 'Beginner');

-- 2. Create a new schedule for a trainer
INSERT INTO Schedule (schedule_id, course_id, trainer_id, start_date, end_date, time_slot)
VALUES (5, 5, 3, '2025-08-01', '2025-08-15', 'Evening');

-- 3. View all trainee enrollments with course title and schedule info
SELECT t.name, c.title, s.start_date, s.time_slot
FROM Enrollment e
JOIN Trainee t ON e.trainee_id = t.trainee_id
JOIN Course c ON e.course_id = c.course_id
JOIN Schedule s ON c.course_id = s.course_id;

-- 4. Show how many courses each trainer is assigned to
SELECT tr.name, COUNT(DISTINCT s.course_id) AS total_courses
FROM Trainer tr
JOIN Schedule s ON tr.trainer_id = s.trainer_id
GROUP BY tr.name;

-- 5. List all trainees enrolled in "Data Basics"
SELECT t.name, t.email
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
JOIN Trainee t ON e.trainee_id = t.trainee_id
WHERE c.title = 'Data Basics';

-- 6. Identify the course with the highest number of enrollments
SELECT TOP 1 c.title, COUNT(*) AS enrollment_count
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
GROUP BY c.title
ORDER BY enrollment_count DESC;

-- 7. Display all schedules sorted by start date
SELECT *
FROM Schedule
ORDER BY start_date ASC;