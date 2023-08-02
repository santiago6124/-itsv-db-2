-- Active: 1681488495868@@127.0.0.1@3306@sakila

use sakila;

/*
 Create a view named list_of_customers, it should contain the following columns:
 customer id
 customer full name,
 address
 zip code
 phone
 city
 country
 status (when active column is 1 show it as 'active', otherwise is 'inactive')
 store id
 */

CREATE OR REPLACE VIEW list_of_costumers AS
	SELECT c.customer_id, CONCAT(c.first_name,'',c.last_name) as 'Full Name', a.phone as 'Telefono', a.address as 'Direccion 1', a.address2 as 'Direccion 2', a.postal_code as 'ZIP CODE', ci.city as 'Ciudad', co.country as 'Pais', c.active as 'Activo', c.store_id as 'N° Tienda'
	FROM customer c JOIN address a on c.address_id = a.address_id JOIN city ci on a.city_id = ci.city_id JOIN country co on ci.country_id = co.country_id;
    

#Create a view named film_details, it should contain the following columns: film id, title, description, category, price, length, rating, actors - as a string of all the actors separated by comma. Hint use GROUP_CONCAT
CREATE OR REPLACE VIEW
film_details AS
	SELECT f.film_id, f.title, f.description, c.name, f.length, f.rating, f.replacement_cost, group_concat( concat(a.first_name,' ',a.last_name)) AS 'Actores'
	FROM film f  INNER JOIN film_category USING(film_id) INNER JOIN category c USING(category_id) INNER JOIN film_actor USING(film_id) INNER JOIN actor a USING(actor_id) GROUP BY f.film_id, c.name;

#Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.
CREATE OR REPLACE VIEW sales_by_film_category AS
	SELECT c.name as 'Categoria', count(r.rental_id) as 'Rentas Totales' FROM film JOIN film_category USING (film_id) JOIN category c USING (category_id) JOIN inventory USING (film_id) JOIN rental r USING (inventory_id) group by c.name;
    

#Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.
CREATE OR REPLACE VIEW actor_information AS
	SELECT a.actor_id, a.first_name as 'Nombre', a.last_name as 'Apellido', count(film_id) as 'Peliculas que Participo'
	FROM actor a JOIN film_actor USING (actor_id) JOIN film USING (film_id) GROUP BY a.actor_id ORDER BY a.actor_id;

#5
#La vista "actor_info" devuelve información sobre los actores, incluyendo su ID, nombre, apellido y una lista de películas en las que actuaron. Las películas se presentan ordenadas por categoría, y dentro de cada categoría se muestran los nombres de las películas en las que el actor participó.


#6
#Las vistas materializadas son como "fotos" de los resultados de consultas complejas que se guardan en una tabla de la base de datos. En lugar de calcular los resultados cada vez que se consulta la vista, la base de datos los almacena previamente para poder acceder a ellos rápidamente. Esto mejora el rendimiento y reduce la carga en el servidor.