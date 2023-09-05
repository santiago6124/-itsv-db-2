-- Active: 1681488495868@@127.0.0.1@3306@sakila
/*
Create a user data_analyst
Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it.
Login with this user and try to create a table. Show the result of that operation.
Try to update a title of a film. Write the update script.
With root or any admin user revoke the UPDATE permission. Write the command
Login again with data_analyst and try again the update done in step 4. Show the result.

*/
#1
CREATE USER data_analyst IDENTIFIED BY 'password';
SELECT User, Host, plugin FROM mysql.user;  #mostrar todos lo usuarios

#2

GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'%';
SHOW GRANTS FOR 'data_analyst'@'%'; # ver los permisos que le dimos

#3
#mysql -udata_analyst -ppassword; comando desde la terminal para entrar con ese usuario
use sakila;
CREATE TABLE filmFake(
	film_id INT NOT NULL AUTO_INCREMENT,
	title VARCHAR(30) NOT NULL,
	description VARCHAR(30),
	release_year YEAR NOT NULL,
	PRIMARY KEY (film_id)
);
#ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'filmFake'

#4
SELECT title, film_id FROM film order by film_id;

UPDATE film SET title = 'INTERESTELAR' WHERE film_id = 3;#film_id=3 es adaptation holes
#despues de correr la query, la film_id=3 es INTERESTELAR

#5
# sudo mysql -u root --Comando para ser root

REVOKE UPDATE ON sakila.* FROM data_analyst;
SHOW GRANTS FOR 'data_analyst'@'%'; # ver que ya no aparece UPDATE
#6
#mysql -udata_analyst -ppassword
use sakila;
UPDATE film SET title = 'OPPENHEIMER' WHERE film_id = 3;
#ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'
#ya no tenemos los permisos para hacer un update de title