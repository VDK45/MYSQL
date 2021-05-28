-- Добавить архивную базу update_logs
DROP TABLE IF EXISTS update_logs;
CREATE TABLE update_logs (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	created_at datetime DEFAULT CURRENT_TIMESTAMP,
	table_name VARCHAR(50) NOT NULL,
	name_value VARCHAR(25) NOT null,
	cash_value INT UNSIGNED
) ENGINE = ARCHIVE;


-- Создать TRIGGER UPDATE ON users для записи в update_logs когда есть изменение в users
DROP TRIGGER IF EXISTS log_update_users;
delimiter //
CREATE TRIGGER log_update_users AFTER UPDATE ON users
FOR EACH ROW
BEGIN
	INSERT INTO update_logs (id, created_at, table_name, name_value, cash_value)
	VALUES (NULL, NOW(), 'users',  NEW.name, NEW.cash);
END //
delimiter ;

-- check
select * from update_logs;
select * from users where id = 2;
UPDATE users SET cash = 5000 where id = 2; 
select * from users where id = 2;
select * from update_logs;

-- TRIGGER UPDATE ON authors для записи в update_logs когда есть изменение в authors
DROP TRIGGER IF EXISTS log_update_authors;
delimiter //
CREATE TRIGGER log_update_authors AFTER UPDATE ON authors
FOR EACH ROW
BEGIN
	INSERT INTO update_logs (id, created_at, table_name, name_value, cash_value)
	VALUES (NULL, NOW(), 'authors',  NEW.name, NEW.cash);
END //
delimiter ;

-- check
select * from update_logs;
select * from authors where id = 2;
UPDATE authors SET cash = 50000 where id = 2; 
select * from authors where id = 2;
select * from update_logs;

-- Добавить архивную базу add_logs
DROP TABLE IF EXISTS add_logs;
CREATE TABLE add_logs (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	created_at datetime DEFAULT CURRENT_TIMESTAMP,
	table_name VARCHAR(50) NOT NULL,
	name_value VARCHAR(25) NOT null,
	cash_value INT UNSIGNED
) ENGINE = ARCHIVE;


-- TRIGGER ADD ON users Фиксировать новых пользователей в add_logs
DROP TRIGGER IF EXISTS log_add_users;
delimiter //
CREATE TRIGGER log_add_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO add_logs (id, created_at, table_name, name_value, cash_value)
	VALUES (NULL, NOW(), 'users',  NEW.name, NEW.cash);
END //
delimiter ;

-- check
select * from add_logs;
INSERT INTO `users` (`id`, `name`, `cash`, `user_url`, `created_at`, `updated_at`) VALUES (NULL, 'VDK45', '6950', '', '2019-08-04 07:50:04', '2016-12-08 03:55:27');
select * from add_logs;

-- TRIGGER add ON authors Фиксировать новых авторов в add_logs
DROP TRIGGER IF EXISTS log_add_authors;
delimiter //
CREATE TRIGGER log_add_authors AFTER INSERT ON authors
FOR EACH ROW
BEGIN
	INSERT INTO add_logs (id, created_at, table_name, name_value, cash_value)
	VALUES (NULL, NOW(), 'authors',  NEW.name, NEW.cash);
END //
delimiter ;

-- check
select * from add_logs;
INSERT INTO `authors` (`id`, `name`, `cash`, `created_at`, `updated_at`) VALUES (NULL, 'DENDY', '40786', '2018-07-11 16:50:10', '2019-12-15 09:51:04');
select * from authors ;
select * from add_logs;

-- Создание триггера для обработки target_id

DROP FUNCTION IF EXISTS is_row_exists;
DELIMITER //

CREATE FUNCTION is_row_exists (target_id INT, target_type VARCHAR(50))
RETURNS BOOLEAN READS SQL DATA

BEGIN
  CASE target_type
    WHEN 'games' THEN
      RETURN EXISTS(SELECT 1 FROM games WHERE id = target_id);
    WHEN 'screenshots' THEN
      RETURN EXISTS(SELECT 1 FROM screenshots WHERE id = target_id);
    ELSE 
      RETURN FALSE;
  END CASE;
END//

DELIMITER ;


-- check
SELECT is_row_exists(50, 'games');
SELECT is_row_exists(51, 'games');
SELECT is_row_exists(200, 'screenshots');
SELECT is_row_exists(201, 'screenshots');


-- Создадим триггер для проверки валидности target_id и target_type_id
DROP TRIGGER IF EXISTS likes_validation;
DELIMITER //

CREATE TRIGGER likes_validation BEFORE INSERT ON likes

FOR EACH ROW BEGIN
  IF NOT is_row_exists(NEW.target_id, NEW.target_type) THEN
    SIGNAL SQLSTATE "45000"
    SET MESSAGE_TEXT = "Error adding like! Target table doesn't contain row id provided!";
  END IF;
END//

DELIMITER ;

SELECT * FROM likes;
-- добавится
INSERT INTO likes (user_id, target_type, target_id) VALUES (34, 'games', 50);
-- не добавится
INSERT INTO likes (user_id, target_type, target_id) VALUES (34, 'games', 51);



