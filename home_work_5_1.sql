DROP DATABASE IF EXISTS home_work_5_1;
CREATE DATABASE home_work_5_1;
USE home_work_5_1;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	created_at datetime, 
	updated_at datetime
);
INSERT  into users values (now(), now());