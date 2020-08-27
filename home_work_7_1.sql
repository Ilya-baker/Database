-- ЗАДАНИЕ: Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине
DROP DATABASE IF EXISTS HomeWork_7_1;
CREATE DATABASE HomeWork_7_1;
USE HomeWork_7_1;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  users_name VARCHAR(200) COMMENT 'Имя покупателя',
  birthday DATE COMMENT 'Дата рождения',
  created DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated DATETIME DEFAULT CURRENT_TIMESTAMP 
);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY index_user(user_id)
) COMMENT 'Заказы';

INSERT INTO users VALUES
  (DEFAULT, 'mihsa', '1967-01-01', NOW(), NOW()),
  (DEFAULT, 'anna', '1984-01-01', NOW(), NOW()),
  (DEFAULT, 'roma', '1992-01-01', NOW(), NOW()),
  (DEFAULT, 'dima', '1978-01-01', NOW(), NOW()),
  (DEFAULT, 'masha', '1997-01-01', NOW(), NOW()),
  (DEFAULT, 'ivan', '1985-01-01', NOW(), NOW()),
  (DEFAULT, 'ilya', '1974-01-01', NOW(), NOW()),
  (DEFAULT, 'gleb', '1991-01-01', NOW(), NOW()),
  (DEFAULT, 'vera', '1987-01-01', NOW(), NOW()),
  (DEFAULT, 'ura', '1982-01-01', NOW(), NOW()),
  (DEFAULT, 'sveta', '1999-01-01', NOW(), NOW()),
  (DEFAULT, 'lena', '1988-01-01', NOW(), NOW()),
  (DEFAULT, 'artemiy', '1990-01-01', NOW(), NOW()),
  (DEFAULT, 'fedr', '1980-01-01', NOW(), NOW()),
  (DEFAULT, 'larisa', '1994-01-01', NOW(), NOW());
  
INSERT INTO orders VALUES
  (DEFAULT, 9, DEFAULT, DEFAULT),
  (DEFAULT, 9, DEFAULT, DEFAULT),
  (DEFAULT, 8, DEFAULT, DEFAULT),
  (DEFAULT, 15, DEFAULT, DEFAULT),
  (DEFAULT, 4, DEFAULT, DEFAULT);
  
SELECT users.users_name AS "Заказчики"
FROM users 
INNER JOIN orders AS o ON (o.user_id = users.id)
GROUP BY users.users_name
