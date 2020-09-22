-- Пусть задан некоторый пользователь.  Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
-- Вопрос: как выбрать именно друзей пользователя? 

SELECT 
	from_user_id, 
    to_user_id,
	COUNT(*) AS quantity
FROM vk.messages 
WHERE to_user_id = 70 -- id пользователя которому отправляли сообщения 
GROUP BY from_user_id
ORDER BY quantity DESC LIMIT 1