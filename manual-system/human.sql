-- Drop the database if it exists
DROP DATABASE IF EXISTS human;

-- Create the database
CREATE DATABASE human;

-- Select the database
USE human;

-- Create the humantable with id and name columns
CREATE TABLE humantable (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Create the manual_recognition table
CREATE TABLE manual_recognition (
    manual_recognition_id INT AUTO_INCREMENT PRIMARY KEY,
    id INT,
    manual_recognize_plate VARCHAR(100),
    manual_recognize_timestamp DATETIME,
    FOREIGN KEY (id) REFERENCES humantable(id)
);

-- Insert a record into humantable
INSERT INTO humantable (id, name) 
VALUES (1, 'Ying');

-- Create the violations table
CREATE TABLE violations (
    violation_id INT AUTO_INCREMENT PRIMARY KEY,
    violation_time DATETIME NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    location VARCHAR(255) NOT NULL,
    camera_id VARCHAR(50) NOT NULL,
    image_path VARCHAR(255),
    status ENUM('pending', 'processed') DEFAULT 'pending',
    remarks TEXT,
    license_plate VARCHAR(20) NOT NULL,
    driver_name VARCHAR(100),
    driver_birth_date DATE,
    speed_limit INT,
    actual_speed INT,
    fine_amount DECIMAL(10, 2),
    violation_type VARCHAR(100),
    violation_code VARCHAR(50),
    officer_stamp VARCHAR(255),
    issue_date DATE,
    payment_status ENUM('pending', 'paid', 'overdue') DEFAULT 'pending',
    violation_location VARCHAR(255),
    violation_description VARCHAR(255),
    gender ENUM('Male', 'Female') DEFAULT NULL,
    recognition VARCHAR(255)
);


-- Update the image path for the first violation (if needed)
UPDATE violations
SET image_path = '/static/images/violation1.jpg'
WHERE violation_id = 1;

-- Create the speed_violation_tickets table
CREATE TABLE speed_violation_tickets (
    ticket_id VARCHAR(20) PRIMARY KEY,
    plate_number VARCHAR(20) NOT NULL,
    driver_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female') DEFAULT NULL,
    violation_time DATETIME NOT NULL,
    violation_location VARCHAR(255) NOT NULL,
    actual_speed INT NOT NULL,
    speed_limit INT NOT NULL,
    fine_amount INT NOT NULL,
    violation_details TEXT,
    notified ENUM('Yes', 'No') DEFAULT 'No',
    officer_name VARCHAR(100),
    reporting_unit VARCHAR(100)
);

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

CREATE TABLE failed_cases(
	id INT AUTO_INCREMENT PRIMARY KEY,
    image_path VARCHAR(255),
    status VARCHAR(255)
    
);