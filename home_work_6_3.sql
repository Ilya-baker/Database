-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
-- Вопрос: выведены 10 самых молодых пользователей и количество их лайков. Пытался вывести сумму лайков через WITH ROLLUP, но он не работает после ORDER BY. Как можно это решить?

SELECT 
    to_users_id,
    (SELECT birthday FROM profiles WHERE profiles.user_id = likes.to_users_id) AS birthday,
    sum(likes.to_users_id) AS sum_likes
FROM vk.likes
GROUP BY to_users_id
ORDER BY birthday DESC LIMIT 10










