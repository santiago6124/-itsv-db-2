-- Active: 1681488495868@@127.0.0.1@3306@sakila
use sakila;

/*



    Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.

    Write a query that shows the film title, language and rating. Rating shall be shown as the full text described here: https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case.

    Write a search query that shows all the films (title and release year) an actor was part of. Assume the actor comes from a text box introduced by hand from a web page. Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.

    Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not. There should be returned column with two possible values 'Yes' and 'No'.

    Investigate CAST and CONVERT functions. Explain the differences if any, write examples based on sakila DB.

    Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function. Explain what they do. Which ones are not in MySql and write usage examples.
*/
#1
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS CustomerName,
    a.address AS CustomerAddress,
    ct.city AS CustomerCity
FROM customer AS c
JOIN store AS s ON c.store_id = s.store_id
JOIN address AS a ON s.address_id = a.address_id
JOIN city AS ct ON a.city_id = ct.city_id
JOIN country AS co ON ct.country_id = co.country_id
WHERE co.country = 'Argentina';
#2

SELECT
    f.title,
    l.name AS language,
    f.rating,
    CASE
        WHEN f.rating = 'G' THEN 'All ages admitted'
        WHEN f.rating = 'PG' THEN 'Some material may not be suitable for children'
        WHEN f.rating = 'PG-13' THEN 'Some material may be inappropriate for children under 13'
        WHEN f.rating = 'R' THEN 'Under 17 requires accompanying parent or adult guardian'
        WHEN f.rating = 'NC-17' THEN 'No one 17 and under admitted'
    END AS 'Rating Text'
FROM film AS f
INNER JOIN language AS l ON f.language_id = l.language_id;

#3

SELECT
    CONCAT(ac.first_name, ' ', ac.last_name) AS actor,
    f.title AS film,
    f.release_year AS release_year
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
INNER JOIN actor ac ON fa.actor_id = ac.actor_id
WHERE CONCAT(ac.first_name, ' ', ac.last_name) LIKE CONCAT('%', UPPER(TRIM('KIRSTEN AKROYD')), '%');

#4

SELECT
    f.title,
    r.rental_date,
    c.first_name AS customer_name,
    CASE
        WHEN r.return_date IS NOT NULL THEN 'Yes'
        ELSE 'No'
    END AS 'Returned'
FROM rental r
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN customer c ON r.customer_id = c.customer_id
WHERE MONTH(r.rental_date) = 5 OR MONTH(r.rental_date) = 6
ORDER BY r.rental_date;

#5
/*
Función CAST: La función CAST se usa para convertir un valor de un tipo de datos a otro tipo específico. 
Es especialmente útil cuando querés cambiar el tipo de datos de una columna o expresión en una consulta.

Función CONVERT: Por otro lado, la función CONVERT también se usa para la conversión de tipos de datos, pero ofrece una funcionalidad más. 
Además de cambiar tipos, CONVERT permite la conversión de conjuntos de caracteres, por lo que puedes ajustar el juego de caracteres de los datos. 
Esta función es útil cuando necesitas cambiar los dos, el tipo de datos y el juego de caracteres.

Diferencias clave:
La principal diferencia radica en la capacidad de CONVERT para manejar la conversión de conjuntos de caracteres. 
Podés cambiar la representación de los caracteres en una columna usando esta función. Por otro lado, CAST se usa exclusivamente para cambiar el tipo de datos de un valor.
*/

#Ejemplos de CAST
#Supongamos que queremos la duracion de las rentas en horas y no en minutos
SELECT title, CAST(rental_duration / 60.0 AS DECIMAL(5,2)) AS duration_in_hours
FROM film;
#Ejemplos CONVERT
#Mostrar fecha en dia mes año
SELECT payment_id,
       CONVERT(payment_date, CHAR) AS original_date,
       DATE_FORMAT(payment_date, '%W, %M %e %Y') AS custom_date_format
FROM payment;
#Mostrar el id de los clientes, convertir el mail a mayúsculas y mostrar la fecha de la última actualización en dia mes año:
SELECT customer_id,
       CONVERT(UPPER(email) USING utf8) AS formatted_email,
       DATE_FORMAT(last_update, '%d-%m-%Y') AS custom_last_update_format
FROM customer;

#6
/*
Estas funciones, como NVL, ISNULL, IFNULL y COALESCE, permiten devolver un valor alternativo cuando una expresión es NULL en una consulta SQL.

Diferencias entre ellas:
Cada función se usa en diferentes sistemas de administración de bases de datos (DBMS). Por ejemplo, en MySQL, solo estan IFNULL y COALESCE, 
NVL e ISNULL no están disponibles.

Ejemplos de uso:

IFNULL:
Supongamos que queremos mostrar información sobre las direcciones, pero si la dirección 2 es null, queremos mostrar un valor alternativo:
*/
SELECT address_id, address, IFNULL(address2, "No tiene direccion") AS direccion_alternativa
FROM address;

#COALESCE:
#Si queremos mostrar lo mismo pero usando la función COALESCE:

SELECT address_id, address, COALESCE(address2, "No tiene direccion") AS direccion_alternativa
FROM address;



