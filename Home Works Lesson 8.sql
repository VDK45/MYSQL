-- 1. Определить кто больше поставил лайков (всего) - мужчины или женщины?
SELECT gender, COUNT(*) AS total  
	FROM profiles JOIN likes ON profiles.user_id = likes.user_id GROUP BY gender ORDER BY total DESC LIMIT 1;


-- CHECK
SELECT 
	(SELECT 	COUNT(*) AS likes_f
	FROM likes 
		WHERE user_id IN (SELECT user_id FROM profiles WHERE gender = 'F')) AS Женщины,
	(SELECT 	COUNT(*) AS likes_f
	FROM likes 
		WHERE user_id IN (SELECT user_id FROM profiles WHERE gender = 'M')) AS Мужчины;


-- 2. Вывести для каждого пользователя количество созданных сообщений, постов, загруженных медиафайлов и поставленных лайков.
SELECT  users.id, CONCAT(users.first_name, ' ', users.last_name) AS NAME, COUNT(DISTINCT messages.body) AS TOTAL_MESSAGES, 
	COUNT(DISTINCT posts.body) AS TOTAL_POSTS, COUNT(DISTINCT media.filename) AS TOTAL_MEDIA, COUNT(DISTINCT likes.id) AS TOTAL_LIKES
	FROM users LEFT JOIN messages 
	    	ON users.id = messages.from_user_id 
	    LEFT JOIN posts 
	    	ON users.id = posts.user_id 
	    LEFT JOIN media 
	    	ON users.id = media.user_id 
	    LEFT JOIN likes 
	    	ON users.id = likes.user_id 
	GROUP BY users.id 
	ORDER BY id;
	
-- Check
SELECT *  FROM messages WHERE from_user_id = 6;
SELECT COUNT(messages.from_user_id) AS TOTAL_MESSAGES FROM messages WHERE from_user_id = 7;
 
SELECT *  FROM posts;
SELECT *  FROM posts WHERE user_id = 23;
SELECT COUNT(posts.user_id) AS TOTAL_POSTS FROM posts WHERE user_id = 7;

SELECT *  FROM media WHERE user_id = 6;
SELECT COUNT(media.user_id) AS TOTAL_MEDIA FROM media WHERE user_id = 6;

SELECT *  FROM likes WHERE user_id = 6;
SELECT COUNT(likes.user_id) AS TOTAL_LIKES FROM likes WHERE user_id = 6;



-- 3. (по желанию) Подсчитать количество лайков которые получили 10 самых молодых пользователей.
SELECT users.id AS users_id, CONCAT(users.first_name, ' ', users.last_name) AS name,  (SELECT (YEAR(CURRENT_DATE)-YEAR(profiles.birthday))-(RIGHT(CURRENT_DATE,5)<RIGHT(profiles.birthday,5))) AS age,
	COUNT(likes.id) AS TOTAL_LIKES
	FROM users LEFT JOIN likes 
		ON likes.target_id = users.id AND likes.target_type = 'users' 
	LEFT JOIN profiles
		ON profiles.user_id = users.id
	GROUP BY  age, name, users_id 
	ORDER BY age LIMIT 10;

-- CHECK	
SELECT
  (SELECT CONCAT(first_name,' ', last_name) FROM users WHERE users.id = profiles.user_id) AS ФИО,
  (SELECT (YEAR(CURRENT_DATE)-YEAR(`birthday`))-(RIGHT(CURRENT_DATE,5)<RIGHT(`birthday`,5))) AS Лет,
  (SELECT COUNT(*) FROM likes WHERE likes.target_id  = profiles.user_id AND target_type = 'users') AS likes
FROM `profiles`
ORDER BY (YEAR(CURRENT_DATE)-YEAR(`birthday`))-(RIGHT(CURRENT_DATE,5)<RIGHT(`birthday`,5)) 
LIMIT 10;
