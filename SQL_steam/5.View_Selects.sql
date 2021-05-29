-- Представление Кто кому сообщение отправил
DROP VIEW IF EXISTS messages_from;
CREATE OR REPLACE VIEW  messages_from  AS 
	SELECT  
	messages.id, 
	messages.from_user_id, 
	users.name AS from_name,  
	messages.to_user_id,  
	(SELECT users.name FROM users WHERE users.id = messages.to_user_id) AS to_name
		FROM messages 
			JOIN users 
				ON messages.from_user_id = users.id  
		ORDER BY messages.id ;

CREATE OR REPLACE VIEW messages_from AS
	SELECT
	messages.id,
	messages.from_user_id,
	users_from.name AS from_name,
	messages.to_user_id,
	users_to.name AS to_name
	FROM messages
		JOIN users AS users_from
			ON messages.from_user_id = users_from.id
		JOIN users AS users_to
			ON messages.to_user_id = users_to.id
	ORDER BY messages.id;


SELECT * FROM  messages_from;
SELECT * FROM  messages;
SELECT * FROM  users;

-- Представление у кого какие игры за сколько покупал
DROP VIEW IF EXISTS users_games_cost;
CREATE OR REPLACE VIEW  users_games_cost AS SELECT  users.id, users.name , 'have',  games.name AS game, games.cost 
	FROM  users, user_games, games WHERE user_games.game_id = games.id AND users.id = user_games.user_id ;

SELECT * FROM  users_games_cost ORDER BY id ;
SELECT * FROM  user_games;
SELECT * FROM  users;
SELECT * FROM  games;

--  Запрос:
-- имя группы
-- среднее количество пользователей в группах 
-- самый бедный пользователь в группе 
-- самый богатый пользователь в группе 
-- количество пользователей в группе
-- всего пользователей в системе 
-- отношение в процентах для последних двух значений (общее количество пользователей в группе / всего пользователей в системе) * 100

SELECT DISTINCT 
	communities.name AS group_name,
	COUNT(communities_users.user_id) OVER()
		/ (SELECT COUNT(*) FROM communities) AS avg_users_in_groups,
	FIRST_VALUE(users.name) OVER (w_community ORDER BY users.cash ) AS poorest,
	FIRST_VALUE(users.name) OVER (w_community ORDER BY users.cash DESC) AS richest,
	COUNT(communities_users.user_id) OVER w_community AS users_in_group,
	(SELECT COUNT(*) FROM users) AS users_total,
	COUNT(communities_users.user_id) OVER w_community / (SELECT COUNT(*) FROM users) *100 AS '%%'
	FROM communities
      LEFT JOIN communities_users 
        ON communities_users.community_id = communities.id
       LEFT JOIN users 
        ON communities_users.user_id = users.id
	  WINDOW w_community AS (PARTITION BY communities.id);
	  
--  Добавить запись в user_games для разнообразия 
--  Если pk  не совпадает то добавится
INSERT INTO `user_games` (`user_id`, `game_id`, `buy_at`) 
	VALUES ((FLOOR(1 + RAND() * 100)), (FLOOR(1 + RAND() * 50)), NOW());

--  Запрос:
-- id
-- Имя 
-- Кол игр у каждого
-- Самая дешёвая купленая пользователем
-- Самая дорогая купленая пользователем
-- Сумма потраченая на игр у каждого

SELECT DISTINCT 
	users.id,
	users.name AS name,
	users.cash AS have_money,
	COUNT(user_games.game_id) OVER w_users AS total_games,
	FIRST_VALUE(games.cost)  OVER (PARTITION BY user_games.user_id ORDER BY games.cost) AS cheapest,
	FIRST_VALUE(games.cost)  OVER (PARTITION BY user_games.user_id ORDER BY games.cost DESC) AS expensive,
	SUM(games.cost) OVER(PARTITION BY user_games.user_id ) AS total_cost_games
	FROM users 
		LEFT JOIN  user_games 
			ON users.id = user_games.user_id 
		LEFT JOIN  games 
			ON games.id = user_games.game_id 
	WINDOW w_users AS (PARTITION BY users.id) ORDER BY users.id;

-- id группы
-- Имя группы
-- Количество игр у группы
-- id пользователя 
-- Имя пользователя 
-- Количество игр у пользователя

SELECT DISTINCT 
	communities_users.community_id AS group_id,
	communities.name AS group_name,
	COUNT(user_games.game_id) OVER(PARTITION BY communities_users.community_id) AS group_have_games,
	communities_users.user_id ,
	users.name AS user_name,
	COUNT(user_games.game_id)  OVER(PARTITION BY user_games.user_id) AS user_have_games
	FROM communities_users
		  LEFT JOIN communities 
		 	ON communities.id = communities_users.community_id
		  LEFT JOIN users 
		  	ON users.id = communities_users.user_id 
		  LEFT JOIN user_games 
			ON communities_users.user_id =  user_games.user_id order by communities_users.community_id ; 


-- Запрос:
-- Определить сколько лайков поставили дя скринов и игр
-- Сколько лайков у каждой игры 
-- Сколько лайков у каждого скрина
		
SELECT DISTINCT 
	target_type AS like_type ,
	COUNT(target_type) OVER(PARTITION BY  target_type ) AS total_likes,
	screenshots.filename AS screenshots_name,
	games.name AS name_of_game,
	COUNT(target_id) OVER(PARTITION BY  target_id) AS count_likes
	FROM likes 
		LEFT JOIN screenshots 
			ON likes.target_type = 'screenshots ' AND likes.target_id = screenshots.id 
		LEFT JOIN games 
			ON likes.target_type = 'games ' AND likes.target_id = games.id 
	ORDER BY likes.target_type DESC;

SELECT * FROM likes  ;
SELECT * FROM screenshots ;


-- Add more friendship 
INSERT INTO `friendship` (`user_id`, `friend_id`, `friendship_status_id`, `confirmed_at`, `created_at`, `updated_at`)
	VALUES ((FLOOR(1 + RAND() * 100)), (FLOOR(1 + RAND() * 100)), (FLOOR(1 + RAND() * 3)), NOW(), NOW(), NOW() );

-- Запрос
-- У кого сколько друзей (подтверженных)
--  имена друзей 
-- Сколько лет дружбе
 SELECT DISTINCT 
 	f.user_id,
 	u.name,
 	COUNT(f.friend_id) OVER w_u_id AS total_friends,
 	f.friend_id ,
 	(SELECT name FROM users  where f.friend_id = users.id) AS  friend_name,
 	(YEAR(CURRENT_DATE)-YEAR(f.confirmed_at))  AS years_friend
 	FROM users u 
 		LEFT JOIN friendship f 
 			ON f.user_id = u.id WHERE f.friendship_status_id = 3
 	WINDOW w_u_id AS (PARTITION BY  f.user_id )
 	ORDER BY total_friends DESC ;
 
 SELECT DISTINCT 
 	friendship.user_id,
 	user_name.name  AS name,
 	COUNT(friendship.friend_id) OVER  (PARTITION BY  friendship.user_id ) AS total_friends,
 	friendship.friend_id ,
 	friend_name.name AS  name_friend,
 	(YEAR(CURRENT_DATE)-YEAR(friendship.confirmed_at))  AS years_friend
 	FROM  friendship
 		JOIN users AS user_name
 			ON friendship.user_id = user_name.id AND friendship.friendship_status_id = 3
 		JOIN users AS friend_name
 			ON friendship.friend_id = friend_name.id AND friendship.friendship_status_id = 3
 	ORDER BY total_friends DESC ;
 
SELECT * FROM friendship f ;
SELECT * FROM users u ;



-- Transaction
START TRANSACTION;
    UPDATE users SET users.cash = users.cash - 85 WHERE users.id = 2;
    UPDATE authors SET authors.cash = authors.cash + 85 WHERE authors.id = 2;
    INSERT INTO user_games (`user_id`, `game_id`, `buy_at`) VALUES (2, 6, NOW());
COMMIT;

SELECT cash  FROM authors WHERE authors.id  = 2;
SELECT *  FROM user_games WHERE user_id  = 2;
