-- ЗАДАНИЕ: Выведите список товаров products и разделов catalogs, который соответствует товару
-- Заменил "products"\"catalogs" на "вид"\"порода" т.к это более актуально для моей курсовой работы и не много интереснее
DROP DATABASE IF EXISTS HomeWork_7_2;
CREATE DATABASE HomeWork_7_2;
USE HomeWork_7_2;

DROP TABLE IF EXISTS kind_of_animal;
CREATE TABLE kind_of_animal (
	id SERIAL PRIMARY KEY, 
    kind_name VARCHAR(200) COMMENT 'Название вида животного'
);

DROP TABLE IF EXISTS breed;
CREATE TABLE breed (
	id SERIAL PRIMARY KEY,
	breed_name VARCHAR(200) COMMENT 'Название породы животного',
    kind_id INT UNSIGNED
);

INSERT kind_of_animal VALUES 
	(DEFAULT, "собака"),
	(DEFAULT, "кошка"),
	(DEFAULT, "парнокопытное"),
	(DEFAULT, "птица"),
	(DEFAULT, "рептилия"
);

INSERT breed VALUES 
	(DEFAULT, "Французский бульдог", 1),
	(DEFAULT, "Кокер-спаниель", 1),
	(DEFAULT, "Английский бульдог", 1),
	(DEFAULT, "Бигль", 1),
	(DEFAULT, "Пудель", 1),
	(DEFAULT, "Ротвейлер", 1),
	(DEFAULT, "Боксер", 1),
    (DEFAULT, "Абиссинская", 2),
	(DEFAULT, "Бенгальская", 2),
	(DEFAULT, "Гавана", 2),
	(DEFAULT, "Девон рекс", 2),
	(DEFAULT, "Донской сфинкс", 2),
	(DEFAULT, "Египетская мау", 2),
	(DEFAULT, "Канаани", 2),
	(DEFAULT, "Корниш рекс", 2),
	(DEFAULT, "Аддакс", 3),
	(DEFAULT, "Антилопа лошадиная", 3),
	(DEFAULT, "Антилопа саблерогая", 3),
	(DEFAULT, "Баран алтайский", 3),
	(DEFAULT, "Баран горный", 3),
	(DEFAULT, "Бегемот", 3),
	(DEFAULT, "Бегемот карликовый", 3),
	(DEFAULT, "Бизон", 3),
    (DEFAULT, "Дрозд", 4),
	(DEFAULT, "Дятел", 4),
	(DEFAULT, "Синица", 4),
	(DEFAULT, "Ласточка", 4),
	(DEFAULT, "Павлин", 4),
	(DEFAULT, "Страус", 4),
    (DEFAULT, "Аксолотль", 5),
	(DEFAULT, "Аметистовый питон", 5),
	(DEFAULT, "Анолисы", 5),
	(DEFAULT, "Африканская роющая лягушка", 5),
	(DEFAULT, "Бахромчатая черепаха", 5),
	(DEFAULT, "Белогубая квакша", 5),
	(DEFAULT, "Большой мадагаскарский геккон", 5),
	(DEFAULT, "Бородатая агама", 5
);

SELECT  
breed.breed_name AS "Порода", 
kind_of_animal.kind_name AS "Вид" 
FROM breed, kind_of_animal 
WHERE kind_of_animal.id = breed.kind_id



