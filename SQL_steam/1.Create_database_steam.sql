-- Курсовая работа: https://steamcommunity.com/

DROP DATABASE IF EXISTS steam;
CREATE DATABASE  steam;


use steam;
	

-- Таблица Создателей игр
DROP TABLE IF EXISTS  authors;
CREATE TABLE authors (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
	name VARCHAR(25) NOT NULL UNIQUE COMMENT " Автор игры",
	cash  INT UNSIGNED COMMENT " Денег у компании",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
)COMMENT "Создатели игр";

-- Таблица жанра
DROP TABLE IF EXISTS genres;
CREATE TABLE genres (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
	name VARCHAR(25) NOT NULL UNIQUE COMMENT "Жанр игры",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
)COMMENT "Жанр";

-- Таблица игр
DROP TABLE IF EXISTS games;
CREATE TABLE games (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
	name VARCHAR(100) NOT NULL UNIQUE COMMENT "Имя игры",
	author_id INT UNSIGNED NOT NULL  COMMENT "Автор игры",
	genre_id INT UNSIGNED NOT NULL COMMENT "Жанр игры",
	cost INT NOT NULL COMMENT "Цена",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Дата выпуски игры",  
  	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
)COMMENT "игры";

-- Таблица пользователей
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
	name VARCHAR(255) NOT NULL COMMENT "Имя игры",
	cash  INT UNSIGNED COMMENT " Денег у пользователей",
	user_url VARCHAR(255) NOT NULL COMMENT "url _user",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
)COMMENT "Пользователь";

-- Таблица игр пользователей
DROP TABLE IF EXISTS user_games;
CREATE TABLE user_games (
	user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
	game_id INT UNSIGNED NOT NULL COMMENT "Ссылка на игру",
	buy_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "дата покупки",
	PRIMARY KEY (game_id, user_id) COMMENT "Составной первичный ключ"
)COMMENT "Игр пользователей";

-- Таблица групп 
DROP TABLE IF EXISTS communities;
CREATE TABLE communities (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор сроки",
    name VARCHAR(255) NOT NULL UNIQUE COMMENT "Название группы",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Группы";

-- Таблица пользователей в группах
DROP TABLE IF EXISTS communities_users;
CREATE TABLE communities_users (
    community_id INT UNSIGNED NOT NULL COMMENT "Ссылка на группу",
    user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки", 
    PRIMARY KEY (community_id, user_id) COMMENT "Составной первичный ключ"
) COMMENT "Участники групп, связь между пользователями и группами";

-- Таблица дружбы
DROP TABLE IF EXISTS friendship;
CREATE TABLE friendship (
    user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на инициатора дружеских отношений",
    friend_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя приглашения дружить",
    friendship_status_id INT UNSIGNED NOT NULL COMMENT "Ссылка на статус (текущее состояние) отношений",
    confirmed_at DATETIME COMMENT "Время подтверждения приглашения",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",  
    PRIMARY KEY (user_id, friend_id) COMMENT "Составной первичный ключ"
) COMMENT "Таблица дружбы";

-- Таблица статусов дружеских отношений
DROP TABLE IF EXISTS friendship_statuses;
CREATE TABLE friendship_statuses (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
    name VARCHAR(25) NOT NULL UNIQUE COMMENT "Название статуса",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"  
) COMMENT "Статусы дружбы";

-- Таблица сообщений
CREATE TABLE messages (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на отправителя сообщения",
  to_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя сообщения",
  body TEXT NOT NULL COMMENT "Текст сообщения",
  is_important BOOLEAN COMMENT "Признак важности",
  is_delivered BOOLEAN COMMENT "Признак доставки",
  created_at DATETIME DEFAULT NOW() COMMENT "Время создания строки"
) COMMENT "Сообщения";

-- Таблица скриншот
DROP TABLE IF EXISTS screenshots;
CREATE TABLE screenshots (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
    user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на автор скрина",
	filename VARCHAR(255) NOT NULL COMMENT "Путь к файлу",
	posts TEXT NOT NULL COMMENT "Описание к скрину",
	size INT NOT NULL COMMENT "Размер файла",
    metadata JSON COMMENT "Метаданные файла",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки"
) COMMENT "Screenshoot";

-- Likes 
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на автор like",
	target_type ENUM('screenshots', 'games') NOT NULL COMMENT "В таблицу target_type",
	target_id INT UNSIGNED NOT NULL COMMENT "id в таблице target_type",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки"
)COMMENT "Likes table";

SHOW tables;
