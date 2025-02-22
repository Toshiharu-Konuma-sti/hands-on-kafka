CREATE DATABASE IF NOT EXISTS mytest;
USE mytest;

DROP TABLE IF EXISTS user;

CREATE TABLE user(
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(25) NOT NULL,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) DEFAULT CHARACTER SET=utf8mb4;

