DROP DATABASE IF EXISTS imdb;
CREATE DATABASE imdb;

USE imdb;

CREATE TABLE film(
	film_id INT NOT NULL AUTO_INCREMENT,
	title VARCHAR(30) NOT NULL,
	description VARCHAR(30),
	release_year YEAR NOT NULL,
	PRIMARY KEY (film_id)
);

CREATE TABLE actor(
	actor_id INT NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	PRIMARY KEY (actor_id)
);

CREATE TABLE film_actor(
	actor_id INT NOT NULL,
	film_id INT NOT NULL
);

ALTER TABLE film ADD
	last_update VARCHAR(255) NOT NULL;
	
ALTER TABLE actor ADD
	last_update VARCHAR(255) NOT NULL;
	
ALTER TABLE film_actor ADD 
	FOREIGN KEY (`actor_id`) REFERENCES actor(`actor_id`);
ALTER TABLE film_actor ADD
	FOREIGN KEY (`film_id`) REFERENCES film(`film_id`);
	
INSERT INTO actor VALUES (1, "Christian", "Bale", "Batman");
INSERT INTO actor VALUES (2, "Viggo", "Mortensen", "El señor de los anillos, El retorno del Rey");
INSERT INTO actor VALUES (3, "Pedro", "Pascal", "The Last Of Us");

INSERT INTO film VALUES (1, "El señor de los anillos", "Pelicula de Fantasía", 2003, "Pelicula");
INSERT INTO film VALUES (2, "Batman", "Pelicula de Accion", 2022, "Pelicula");
INSERT INTO film VALUES (3, "The Last Of Us", "Serie acción", 2023, "Serie");

INSERT INTO film_actor VALUES (1, 2);
INSERT INTO film_actor VALUES (2, 1);
INSERT INTO film_actor VALUES (3, 3);
