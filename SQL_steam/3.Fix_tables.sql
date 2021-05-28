-- Таблица пользователей 
SELECT * FROM users ;
DESC users;
-- Убираем денег у случайных
UPDATE users SET cash = 0 WHERE id = FLOOR(1 + RAND() * 100);
SELECT * FROM users WHERE cash = 0;      
-- Создать url для пользователей 
UPDATE users SET user_url = (CONCAT('https://steamcommunity.com/id/', name, (FLOOR(1 + RAND() * 1000)))); 
-- Приводим в порядок временные метки
UPDATE users SET updated_at = NOW() WHERE updated_at < created_at;    


-- Таблица игр пользователей 
SELECT * FROM user_games;
DESC user_games;
-- Добавить ещё 
INSERT INTO `user_games` (`user_id`, `game_id`, `buy_at`) values ((FLOOR(1 + RAND() * 100)), (FLOOR(1 + RAND() * 50)), NOW());  
 -- Добавить внешний ключ
 ALTER TABLE user_games
  ADD CONSTRAINT games_user_id_from_users_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT game_id_from_games_id_fk 
    FOREIGN KEY (game_id) REFERENCES games(id)
   		ON DELETE CASCADE;


 
-- таблица screenshots
SELECT * FROM screenshots ;
DESC screenshots;
-- Добавить scr_ в начале имени файла
UPDATE screenshots SET filename =CONCAT( 'scr_' , filename);
-- Заполняем метаданные
UPDATE screenshots SET metadata = CONCAT('{"owner":"', 
  (SELECT CONCAT(users.name, ' ', filename) FROM users WHERE id = user_id),
  '"}');  
 -- Добавить столбец url
 ALTER TABLE screenshots ADD url VARCHAR(255) NOT NULL ;
-- Создать url для screenshots
UPDATE screenshots SET url = (CONCAT('https://steamcommunity.com/screenshots/', filename, FLOOR(1 + RAND() * 100)));  
-- Добавить внешний ключ
 ALTER TABLE screenshots
  ADD CONSTRAINT screenshots_user_id_from_users_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
   		ON DELETE CASCADE;


-- таблица messages
 SELECT * FROM messages LIMIT 20;
DESC messages;
-- Добавить внешний ключ
ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id)
   ON DELETE CASCADE;


-- таблица likes
SELECT * FROM likes;
DESC likes;
-- Установить значение target_type.games не более 50
UPDATE likes SET target_id = FLOOR(1 + RAND() * 50) WHERE target_type = 'games';   
-- Добавить внешний ключ
 ALTER TABLE likes
  ADD CONSTRAINT likes_user_id_from_users_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
   		ON DELETE CASCADE;


-- таблица genres
SELECT * FROM genres LIMIT 20;
DESC genres;
-- Удалить updated_at
ALTER TABLE genres DROP COLUMN updated_at;


-- таблица games
SELECT * FROM games ;
DESC games;
-- Установить цены не выше 100$
UPDATE games SET cost = FLOOR(0 + RAND() * 100) WHERE cost > 100; 
-- Добавить _game в имя
UPDATE games SET games.name = CONCAT(games.name, '_game');
-- Добавить внешний ключ
ALTER TABLE games
  ADD CONSTRAINT author_id_from_authors_id_fk 
    FOREIGN KEY (author_id) REFERENCES authors(id),
  ADD CONSTRAINT genre_id_from_genres_id_fk 
    FOREIGN KEY (genre_id) REFERENCES genres(id)
   ON DELETE CASCADE;


-- таблица friendship_statuses
SELECT * FROM friendship_statuses LIMIT 20;
DESC friendship_statuses;
-- Удалить updated_at
ALTER TABLE friendship_statuses DROP COLUMN updated_at;


-- таблица friendship
SELECT * FROM friendship;
DESC friendship;
-- Приводим в порядок временные метки
UPDATE users SET updated_at = NOW() WHERE updated_at < created_at;   
-- Добавить внешний ключ
ALTER TABLE friendship
  ADD CONSTRAINT friendship_user_id_from_users_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT friend_id_from_users_id_fk 
    FOREIGN KEY (friend_id) REFERENCES users(id),
    ADD CONSTRAINT friendship_status_id_from_friendship_statuses_id_fk 
    FOREIGN KEY (friendship_status_id) REFERENCES friendship_statuses(id)
   ON DELETE CASCADE;


-- таблица communities_users
SELECT * FROM communities_users;
DESC communities_users;
-- Добавить столбец updated_at
ALTER TABLE communities_users ADD  COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
-- Убрать певичный ключ и вернуть значение NULL для user_id
ALTER TABLE communities_users DROP PRIMARY KEY;
ALTER TABLE communities_users MODIFY user_id INT UNSIGNED NULL DEFAULT NULL;
-- Удалить пользователей из одной группы 
UPDATE communities_users SET communities_users.user_id = NULL WHERE community_id = 3;
-- добавить table id PK
ALTER TABLE communities_users ADD COLUMN id int(10) UNSIGNED PRIMARY KEY  AUTO_INCREMENT;
-- Добавить внешний ключ
ALTER TABLE communities_users
  ADD CONSTRAINT community_id_from_communities_id_fk 
    FOREIGN KEY (community_id) REFERENCES communities(id),
  ADD CONSTRAINT user_id_from_users_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
   ON DELETE CASCADE;


-- таблица
SELECT * FROM communities;
DESC communities;
-- Добавить в конце имя (_group)
UPDATE communities SET communities.name = CONCAT(communities.name, '_group');
-- Приводим в порядок временные метки
UPDATE users SET updated_at = NOW() WHERE updated_at < created_at;    



-- таблица
SELECT * FROM authors LIMIT 20;
DESC authors;
UPDATE users SET updated_at = NOW() WHERE updated_at < created_at; 

-- IDX
DESC users; 
CREATE INDEX users_name_idx ON users(name);   
CREATE UNIQUE INDEX users_url_uq ON users(user_url);  
SHOW INDEX FROM users;


DESC games; 
CREATE INDEX games_genre_idx ON games(genre_id);  
CREATE INDEX games_author_idx ON games(author_id);  
