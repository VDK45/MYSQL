-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
SELECT users.id, users.name, users.birthday_at FROM users JOIN orders ON users.id = orders.user_id;
SELECT u.id, u.name, u.birthday_at FROM users AS u JOIN orders AS o ON u.id = o.user_id;
SELECT u.id, u.name, u.birthday_at FROM users  u JOIN orders  o ON u.id = o.user_id;


-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
SELECT  products.id, products.name, catalogs.name FROM catalogs JOIN products  ON catalogs.id = products.catalog_id;
SELECT  p.id, p.name, c.name FROM catalogs AS c JOIN products AS p ON c.id = p.catalog_id;
SELECT  p.id, p.name, c.name FROM catalogs c JOIN products p ON c.id = p.catalog_id;

SELECT  p.id, p.name, c.name FROM catalogs c LEFT JOIN products p ON c.id = p.catalog_id;
SELECT  p.id, p.name, c.name FROM catalogs c RIGHT JOIN products p ON c.id = p.catalog_id;


-- 3 (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.
create database airport;
show databases;
use airport;

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(255) COMMENT 'От куда',
  `to` VARCHAR(255) COMMENT 'До куда',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Вылеты';

INSERT INTO flights (`from`, `to`) VALUES
  ('moscow', 'omsk'),
  ('novgorod', 'kazan'),
  ('irkutsk', 'moscow'),
  ('omsk', 'irkutsk'),
  ('moscow', 'kazan');


DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  label VARCHAR(255) COMMENT 'Имя по англиский',
  name VARCHAR(255) COMMENT 'Имя по русский',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Перевод городов';

INSERT INTO cities (`label`, `name`) VALUES
  ('moscow', 'Москва'),
  ('irkutsk', 'Иркутск'),
  ('novgorod', 'Новгород'),
  ('omsk', 'Омск'),
  ('kazan', 'Казань');

SELECT * FROM flights LIMIT 10;

SELECT * FROM cities LIMIT 10

SELECT
	flights.id AS flight_id,
	(SELECT cities.name FROM cities WHERE cities.label = `from`) AS `from`,
	(SELECT cities.name FROM cities WHERE cities.label = `to`) AS `to`
FROM
	flights
ORDER BY
	flight_id;

SELECT
	id AS Рейсы,
	(SELECT name FROM cities WHERE label = `from`) AS От_города,
	(SELECT name FROM cities WHERE label = `to`) AS До_города
FROM
	flights
ORDER BY
	Рейсы;



