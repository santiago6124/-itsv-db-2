-- Active: 1680704363949@@127.0.0.1@3306@sakila


/*
    1-Show title and special_features of films that are PG-13
    2-Get a list of all the different films duration.
    3-Show title, rental_rate and replacement_cost of films that have replacement_cost from 20.00 up to 24.00
    4-Show title, category and rating of films that have 'Behind the Scenes' as special_features
    5-Show first name and last name of actors that acted in 'ZOOLANDER FICTION'
    6-Show the address, city and country of the store with id 1
    7-Show pair of film titles and rating of films that have the same rating.
    8-Get all the films that are available in store id 2 and the manager first/last name of this store (the manager will appear in all the rows).
*/

USE sakila;
#1
SELECT title,special_features
FROM film 
WHERE rating = 'PG-13'
ORDER BY title
;
#2
SELECT title,length as 'Largo en minutos'
FROM film
ORDER BY length;
#3
SELECT title, rental_rate, replacement_cost
FROM film
WHERE replacement_cost 
BETWEEN 20 AND 24
ORDER BY replacement_cost;
#4
SELECT
	f.title,
	f.rating,
	c.name
FROM
	film f
JOIN film_category fc ON
	f.film_id = fc.film_id
JOIN category c ON
	fc.category_id = c.category_id
WHERE
	f.special_features LIKE '%Behind the Scenes%';

#5
SELECT a.first_name, a.last_name, f.title
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title LIKE '%ZOOLANDER FICTION%';
#6
SELECT country as 'NOMBRE PAIS', city as 'NOMBRE CIUDAD', address as 'DIRECCION'
FROM store 
JOIN address on store.address_id = address.address_id
JOIN city on address.city_id = city.city_id
JOIN country on city.country_id = country.country_id
WHERE store_id = 1;

#7
SELECT f1.title, f2.title, f1.rating
FROM film f1, film f2
WHERE f1.rating = f2.rating AND f1.film_id <> f2.film_id;

#8
SELECT s.first_name AS "Nombre", s.last_name AS "Apellido", f.title AS "Titulo de Pelicula"
FROM staff s
JOIN store st ON s.staff_id = st.store_id
JOIN inventory i ON st.store_id = i.store_id
JOIN film f ON i.film_id = f.film_id
WHERE st.store_id = 2;
