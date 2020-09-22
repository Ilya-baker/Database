-- Пусть задан некоторый пользователь.  Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
SELECT 
	from_user_id, 
    to_user_id,
	COUNT(*) AS quantity
FROM messages 
WHERE to_user_id = 70 
GROUP BY from_user_id
ORDER BY quantity DESC 