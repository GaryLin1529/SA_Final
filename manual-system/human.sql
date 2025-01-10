DROP DATABASE IF EXISTS human;

CREATE DATABASE human;

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
    violation_time DATETIME NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    location VARCHAR(255) NOT NULL,
    camera_id VARCHAR(50) NOT NULL,
    image_path VARCHAR(255),
    status ENUM('pending', 'processed') DEFAULT 'pending',
    license_plate VARCHAR(20) NOT NULL,
    violation_type VARCHAR(100),
    recognition VARCHAR(255),
    violation_description VARCHAR(255),
    status_print VARCHAR(255),
    archive VARCHAR(255)
);

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


CREATE TABLE violations_information(
	id INT auto_increment PRIMARY KEY,
    license_plate VARCHAR(255),
    location VARCHAR(255),
    speed INT(10),
    fee INT(10),
    speed_limit INT(10)
);

-- Insert sample data into violations_information
INSERT INTO violations_information (license_plate, location, speed, fee, speed_limit) VALUES
('AFF0666', 'Downtown Road', 80, 500, 60),
('ALN7567', 'Main Highway', 95, 700, 80),
('QWE7890', 'Broadway Street', 75, 300, 50),
('APP6961', 'Sunset Boulevard', 100, 1000, 80),
('ZXC1230', 'Ocean Avenue', 85, 600, 70);
