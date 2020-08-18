DROP DATABASE IF EXISTS home_work_5_2;
CREATE DATABASE home_work_5_2;
USE home_work_5_2;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	created_at VARCHAR(50), 
	updated_at VARCHAR(50) 
);
INSERT  INTO users VALUES('20.10.2017 8:10', '20.10.2017 8:10');

ALTER TABLE users ADD (
	created_at_date DATETIME, 
	updated_at_date DATETIME
);
UPDATE users 
SET created_at_date = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i'),
	updated_at_date = STR_TO_DATE(updated_at, '%d.%m.%Y %h:%i');
ALTER TABLE users
	DROP created_at, 
	DROP updated_at,
	RENAME COLUMN created_at_date TO created_at,
	RENAME COLUMN updated_at_date TO updated_at;