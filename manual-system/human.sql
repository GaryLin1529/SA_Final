DROP DATABASE IF EXISTS human;

CREATE DATABASE human CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


USE human;

-- Create the userlogin table
CREATE TABLE userlogin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert a sample user into userlogin
INSERT INTO userlogin (username, email, password_hash) 
VALUES ('root', 'root@gmail.com', '1234');

CREATE TABLE ai_results(
	ai_results_id INT AUTO_INCREMENT PRIMARY KEY,
    image_name VARCHAR(255),
    image_path VARCHAR(255),
    license_plate VARCHAR(255),
    recognition VARCHAR(255)
);

-- Create the violations table
CREATE TABLE violations (
    violation_id INT AUTO_INCREMENT PRIMARY KEY,
    image_name VARCHAR(255),
    license_plate VARCHAR(255),
    violation_time VARCHAR(255),
    location VARCHAR(255) NOT NULL,
    camera_id VARCHAR(50) NOT NULL,
    image_path VARCHAR(255),
    status ENUM('pending', 'processed') DEFAULT 'pending',
    violation_type VARCHAR(100),
    speed_limit INT,
    car_speed INT,
    coordinates VARCHAR(255),
    recognition VARCHAR(255),
    violation_description VARCHAR(255),
    status_print VARCHAR(255),
    archive VARCHAR(255),
    fee INT
);
INSERT INTO violations (
    image_name, 
    violation_time, 
    location, 
    camera_id, 
    image_path, 
    status, 
    violation_type,
    speed_limit,
    car_speed,
    coordinates,
    violation_description,
    status_print,
    fee
) VALUES
('A01', '2024/1/10 12:00 AM', '台北市中正區信義路二段23號', 'ID004', 'manual-system/static/images/A01.png', 'pending', 'Speeding', '50', '70', '25.035202348798737, 121.52559153744765', 'Vehicle exceeded speed limit', 'not-printed','155'),
('A02', '2024/1/10 12:01 AM', '台北市大安區信義路三段23號', 'ID005', 'manual-system/static/images/A02.png', 'pending', 'Speeding', '50', '75', '25.033909150131706, 121.53400604908703', 'Vehicle crossed on red light', 'not-printed','150'),
('A03', '2024/1/10 12:02 AM', '台北市大安區信義路四段1-106號', 'ID006', 'manual-system/static/images/A03.png', 'pending', 'Speeding', '50', '65', '25.033784303543637, 121.54423799511962', 'Vehicle parked in a no-parking zone', 'not-printed', '160'),
('A04', '2024/1/10 12:03 AM', '台北市信義區信義路五段23號', 'ID007', 'manual-system/static/images/A04.png', 'pending', 'Speeding', '60', '80', '25.03343022963543, 121.56882062395569', 'Driver observed without a seatbelt','not-printed','200');


-- Create the manual_recognition table
CREATE TABLE manual_recognition (
    manual_recognition_id INT AUTO_INCREMENT PRIMARY KEY,
    id INT,
    manual_recognize_plate VARCHAR(100),
    manual_recognize_timestamp DATETIME
);


-- Create the failed_cases table
CREATE TABLE failed_cases(
    id INT AUTO_INCREMENT PRIMARY KEY,
    image_path VARCHAR(255),
    status VARCHAR(255)
);

-- Create the car_information table
CREATE TABLE car_information (
    id INT AUTO_INCREMENT PRIMARY KEY,       -- Unique identifier for each record
    license_plate VARCHAR(20) NOT NULL,     -- License plate number
    driver_name VARCHAR(100),               -- Driver's name
    gender ENUM('Male', 'Female'),          -- Gender of the driver
    birth_date DATE                         -- Driver's birth date
);

-- Insert sample data into car_information
INSERT INTO car_information (license_plate, driver_name, gender, birth_date) VALUES
('AFF0666', 'Donny Huang', 'Male', '1985-06-15'),
('ALN7567', 'Lily Chen', 'Female', '1990-03-22'),
('QWE7890', 'Kevin Lin', 'Male', '1978-09-11'),
('APP6961', 'Emily Wu', 'Female', '1995-12-05'),
('ZXC1230', 'Jason Wang', 'Male', '1988-01-18'),
('JKL4561', 'Jessica Liu', 'Female', '1992-07-10'),
('MNB0987', 'William Zhang', 'Male', '1980-11-30'),
('POI6789', 'Sarah Lee', 'Female', '1999-05-14'),
('LKH5678', 'Eric Xu', 'Male', '1983-08-08'),
('UYT4321', 'Sophia Sun', 'Female', '1997-04-28'),
('BGR-5851', 'Sophia Sun', 'Female', '1997-04-28');



