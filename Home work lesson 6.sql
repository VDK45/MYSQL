-- 1.Создать и заполнить таблицы лайков и постов.

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type ENUM('messages', 'users', 'posts', 'media') NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Временная таблица типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TEMPORARY TABLE target_types (
  name VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');
  
 -- Заполняем лайки
INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 100)),
    (SELECT name FROM target_types ORDER BY RAND() LIMIT 1),
    CURRENT_TIMESTAMP 
  FROM messages;
  
 SELECT * FROM likes LIMIT 10;
 
-- Создадим таблицу постов
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  media_id INT UNSIGNED,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Заполнить таблицу постов
UPDATE friendship SET friend_id = FLOOR(1 + RAND() * 100);
INSERT INTO posts 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 17)),
    (SELECT last_name FROM users ORDER BY RAND() LIMIT 1),
    (SELECT body FROM messages ORDER BY RAND() LIMIT 1),
    (SELECT id FROM media ORDER BY RAND() LIMIT 1),
    (SELECT is_important  FROM messages ORDER BY RAND() LIMIT 1),
    (SELECT is_important  FROM messages ORDER BY RAND() LIMIT 1),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP 
  FROM messages;
 
 
 -- 2.Создать все необходимые внешние ключи и диаграмму отношений.

DESC profiles;
ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
    	ON DELETE CASCADE;

    
DESC messages;
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk
    FOREIGN KEY (from_user_id) REFERENCES users(id)
    	ON DELETE CASCADE,
  ADD CONSTRAINT messages_to_user_id_fk
    FOREIGN KEY (to_user_id) REFERENCES users(id)
    	ON DELETE CASCADE;
    
DESC communities_users;
ALTER TABLE communities_users
  ADD CONSTRAINT communities_id_fk
    FOREIGN KEY (community_id) REFERENCES communities(id)
    	ON DELETE CASCADE,
  ADD CONSTRAINT communities_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
    	ON DELETE CASCADE;

 DESC friendship;   
ALTER TABLE friendship
  ADD CONSTRAINT friendship_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
    	ON DELETE CASCADE,
  ADD CONSTRAINT friendship_friend_id_fk
    FOREIGN KEY (friend_id) REFERENCES users(id)
    	ON DELETE CASCADE,
  ADD CONSTRAINT friendship_status_id_fk
    FOREIGN KEY (friendship_status_id) REFERENCES friendship_statuses(id)
    	ON DELETE CASCADE;

DESC likes;   
ALTER TABLE likes
  ADD CONSTRAINT like_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
    	ON DELETE CASCADE,
  ADD CONSTRAINT like_target_user_id_fk
    FOREIGN KEY (target_id) REFERENCES media(id)
    	ON DELETE CASCADE;  
    

    
DESC media ;     
ALTER TABLE media
  ADD CONSTRAINT media_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
    	ON DELETE CASCADE,
  ADD CONSTRAINT media_type_id_fk
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
    	ON DELETE CASCADE;  
    
DESC posts ;   
ALTER TABLE posts
  ADD CONSTRAINT post_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
    	ON DELETE CASCADE,
  ADD CONSTRAINT community_id_fk
    FOREIGN KEY (community_id) REFERENCES communities(id)
    	ON DELETE CASCADE,
  ADD CONSTRAINT post_media_id_fk
    FOREIGN KEY (media_id) REFERENCES media(id)
    	ON DELETE CASCADE;

-- 3.Определить кто больше поставил лайков (всего) - мужчины или женщины?;
SELECT 
	(SELECT 	COUNT(*) AS likes_f
	FROM likes 
		WHERE user_id IN (SELECT user_id FROM profiles WHERE gender = 'F')) AS Ж,
	(SELECT 	COUNT(*) AS likes_f
	FROM likes 
		WHERE user_id IN (SELECT user_id FROM profiles WHERE gender = 'M')) AS M;
		
		
-- 4.Вывести для каждого пользователя количество созданных сообщений, постов, загруженных медиафайлов и поставленных лайков.
SELECT CONCAT(first_name,' ', 
	last_name) AS NAME,
	(SELECT COUNT(*) FROM posts WHERE posts.user_id = users.id ) AS posts,
	(SELECT COUNT(*) FROM media WHERE media.user_id = users.id ) AS media,
	(SELECT COUNT(*) FROM messages WHERE messages.from_user_id = users.id ) AS Messages_in,
	(SELECT COUNT(*) FROM messages WHERE messages.to_user_id = users.id ) AS Messages_out,
	(SELECT COUNT(*) FROM likes WHERE likes.user_id = users.id ) AS likes
FROM users;		


-- (по желанию) Подсчитать количество лайков которые получили 10 самых молодых пользователей.

SELECT
  (SELECT CONCAT(first_name,' ', last_name) FROM users WHERE users.id = profiles.user_id) AS ФИО,
  (SELECT (YEAR(CURRENT_DATE)-YEAR(`birthday`))-(RIGHT(CURRENT_DATE,5)<RIGHT(`birthday`,5))) AS Лет,
  (SELECT COUNT(*) FROM likes WHERE likes.target_id  = profiles.user_id AND target_type = 'users') AS likes
FROM `profiles`
ORDER BY (YEAR(CURRENT_DATE)-YEAR(`birthday`))-(RIGHT(CURRENT_DATE,5)<RIGHT(`birthday`,5)) 
LIMIT 10;
		




 
    
 
 