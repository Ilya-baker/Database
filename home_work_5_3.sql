DROP DATABASE IF EXISTS home_work_5_3;
CREATE DATABASE home_work_5_3;
USE home_work_5_3;

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED, -- запасы на складе
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP -- дата регистрации
);

INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES
    (1, 1, 0),
    (1, 2, 19),
    (1, 3, 1),
    (2, 4, 138),
    (2, 5, 0),
    (1, 6, 94),
    (1, 7, 4);
   
SELECT * FROM storehouses_products
  ORDER BY CASE WHEN value = 0 THEN 123456789 ELSE value END