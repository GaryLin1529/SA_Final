DROP DATABASE IF EXISTS violation_system;

CREATE DATABASE violation_system;

USE violation_system;

 -- 違規處理子系統
CREATE TABLE violations (
    violation_id INT AUTO_INCREMENT PRIMARY KEY,
    violation_time DATETIME NOT NULL,
    location VARCHAR(255) NOT NULL,
    camera_id VARCHAR(50) NOT NULL,
    image_path VARCHAR(255),
    status ENUM('pending', 'processed') DEFAULT 'pending',
    remarks TEXT
);

-- 創建車輛資料表
CREATE TABLE vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    plate_number VARCHAR(20) UNIQUE NOT NULL,
    owner_name VARCHAR(100) NOT NULL,
    owner_address VARCHAR(255),
    vehicle_type VARCHAR(50),
    registration_date DATE
);

-- 創建 AI 辨識結果表
CREATE TABLE ai_recognition (
    ai_id INT AUTO_INCREMENT PRIMARY KEY,
    violation_id INT NOT NULL,
    result VARCHAR(50) NOT NULL,
    confidence DECIMAL(5, 2) NOT NULL,
    timestamp DATETIME NOT NULL,
    FOREIGN KEY (violation_id) REFERENCES violations(violation_id)
);

ALTER TABLE violations MODIFY COLUMN image_path LONGBLOB;
