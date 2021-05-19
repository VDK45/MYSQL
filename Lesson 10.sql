-- 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и добавить необходимые индексы.

--  Индекс на фамилию пользователя
CREATE INDEX users_last_name_idx ON users(last_name);

--  Индекс на имя медия файла
CREATE INDEX media_filename_idx ON media(filename);

--  Индекс на группы
CREATE INDEX communities_idx ON communities(name);

-- Уникальный индекс на столбец электронной почты
CREATE UNIQUE INDEX users_email_uq ON users(email);

-- Уникальный индекс на столбец телефона
CREATE UNIQUE INDEX users_phone_uq ON users(phone);

-- Составной индекс на имя и фамилию пользователя
CREATE INDEX users_first_name_last_name_idx ON users(first_name, last_name);

--  Составной индекс на user_id  и friend_id
CREATE INDEX user_id_friend_id_idx ON friendship(user_id, friend_id);

--  Составной индекс на user_id  и  birthday 
CREATE INDEX user_id_birthday_idx ON profiles(user_id, birthday);

--  Составной индекс на лайки и пользователей 
CREATE INDEX likes_target_id_users_id_idx ON likes(target_id, user_id);

--  Составной индекс на пользователей в группах
CREATE INDEX users_communities_idx ON communities_users(user_id, community_id);


-- #среднее количество пользователей в группах (сумма количестива пользователей во всех группах делённая на количество групп)
-- kkсамый молодой пользователь в группе (желательно вывести имя и фамилию)
-- самый старший пользователь в группе (желательно вывести имя и фамилию)
-- #количество пользователей в группе
-- #всего пользователей в системе (количество пользователей в таблице users)
-- #отношение в процентах для последних двух значений (общее количество пользователей в группе / всего пользователей в системе) * 100

SELECT DISTINCT communities.name,
	(COUNT(communities_users.user_id) OVER w_communities_name) AS in_one_group,
	(COUNT(communities_users.user_id) OVER w_communities_name) / (MAX(communities.id) OVER()) AS average,
	COUNT(users.id) OVER() AS total_users_in_groups,
	((COUNT(communities_users.user_id) OVER(PARTITION BY communities.name)) / COUNT(users.id) OVER()) * 100 as "%%",
	MAX(profiles.birthday) OVER w_communities_users_community_id AS youngest,
	MIN(profiles.birthday) OVER w_communities_users_community_id  AS oldest
	FROM communities
      JOIN communities_users 
          ON communities.id = communities_users.community_id
      JOIN users 
          ON users.id = communities_users.user_id
      JOIN profiles
          ON profiles.user_id = users.id
      WINDOW w_communities_users_community_id AS (PARTITION BY communities_users.community_id),
      w_communities_name AS (PARTITION BY communities.name);
         
-- Check
SELECT COUNT(id) from communities;
SELECT COUNT(user_id) from communities_users;
SELECT COUNT(user_id) from communities_users WHERE community_id = 7;