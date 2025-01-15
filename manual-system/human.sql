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
    fee INT,
	longitude DECIMAL(18, 15),
	latitude DECIMAL(18, 15),
    reason VARCHAR(255)
);
INSERT INTO `violations` (`image_name`, `violation_time`, `location`, `camera_id`, `image_path`, `status`, `violation_type`, `speed_limit`, `car_speed`, `coordinates`, `violation_description`, `status_print`, `fee`, `longitude`, `latitude`,`reason`) VALUES
('A01', '2024/1/10 12:00 AM', '台北市中正區信義路二段23號', 'ID004', 'manual-system/static/images/A01.png', 'pending', 'Speeding', '50', '70', '25.035202348798737, 121.52559153744765', '違規超速', 'not-printed', '155', 25.035075899999999, 121.523038075376604,''),
('A02', '2024/1/10 12:01 AM', '台北市大安區信義路三段23號', 'ID005', 'manual-system/static/images/A02.png', 'pending', 'Speeding', '50', '75', '25.033909150131706, 121.53400604908703', '違規超速', 'not-printed', '150', 25.033781999999999, 121.531559875376544,'無法辨識原因:假資料'),
('A03', '2024/1/10 12:02 AM', '台北市大安區信義路四段1-106號', 'ID006', 'manual-system/static/images/A03.png', 'pending', 'Speeding', '50', '65', '25.033784303543637, 121.54423799511962', '違規超速', 'not-printed', '160', 25.033719999999999, 121.541663075376476,''),
('A04', '2024/1/10 12:03 AM', '台北市信義區信義路五段23號', 'ID007', 'manual-system/static/images/A04.png', 'pending', 'Speeding', '60', '80', '25.03343022963543, 121.56882062395569', '違規超速', 'not-printed', '200', 25.033313000000000, 121.566234975376446,'無法辨識原因:多車牌');


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
    gender ENUM('男', '女'),          -- Gender of the driver
    birth_date DATE,
    address VARCHAR(50) -- Driver's birth date
);

-- Insert sample data into car_information
INSERT INTO car_information (license_plate, driver_name, gender, birth_date, address) VALUES
('AFF0666', '劉阿豪', '男', '1985-06-15', '桃園市八德區永福路段8號'),
('BGR-5851', '劉土豪', '男', '1997-04-28', '桃園市缺德路87號'),
('QWE7890', '林建宏', '男', '1978-09-11', '桃園市八德區和平路8巷5號'),
('APP6961', '吳小華', '女', '1995-12-05', '桃園市八德區中山路12號'),
('ZXC1230', '王大仁', '男', '1988-01-18', '桃園市八德區復興路25號'),
('JKL4561', '劉雅婷', '女', '1992-07-10', '桃園市八德區信義路38號'),
('MNB0987', '張文傑', '男', '1980-11-30', '桃園市八德區文化路68巷9號'),
('POI6789', '李淑華', '女', '1999-05-14', '桃園市八德區成功路7號'),
('LKH5678', '許志明', '男', '1983-08-08', '桃園市八德區光復路23巷4弄6號'),
('UYT4321', '孫莉莉', '女', '1997-04-28', '桃園市八德區忠孝路22號');







