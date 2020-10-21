-- Показать общее количество обращений на ту или иную услугу
USE animals;
(SELECT diagnosis as visit, COUNT(animal_id) as animal FROM therapy GROUP BY visit)
UNION
(SELECT name, COUNT(animal_id) FROM barber GROUP BY name)
UNION
(SELECT name, COUNT(animal_id) FROM surgery GROUP BY name)

-- Показать какому владельцу принадлежат животные
USE animals;
SELECT
firstname, lastname, kind, breed, name AS nickname
FROM animal
JOIN owner ON owner.id  = animal.owner_id

-- Показать дату и причину обращения с каждым животным
USE animals;
SELECT 
animal.name, kind, breed, diagnosis AS therapy_visit, therapy.created_at, barber.name AS barber_visit, barber.created_at, surgery.name AS surgery_visit, surgery.created_at
FROM animal
JOIN  therapy ON animal.id = therapy.animal_id
JOIN barber ON barber.animal_id = animal.id
JOIN surgery ON surgery.animal_id = animal.id





