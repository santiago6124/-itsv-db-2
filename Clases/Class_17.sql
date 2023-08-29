-- Active: 1681488495868@@127.0.0.1@3306@sakila
/*


    Create two or three queries using address table in sakila db:
        include postal_code in where (try with in/not it operator)
        eventually join the table with city/country tables.
        measure execution time.
        Then create an index for postal_code on address table.
        measure execution time again and compare with the previous ones.
        Explain the results

    Run queries using actor table, searching for first and last name columns independently. Explain the differences and why is that happening?

    Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST. Explain the results.
*/

#1---------------------------------------------------------------------------------------
--Usando in
SELECT a.address, a.postal_code, ci.city, co.country
FROM address AS a
JOIN city AS ci ON a.city_id = ci.city_id
JOIN country AS co ON ci.country_id = co.country_id
WHERE a.postal_code IN ('35200', '17886', '83579');
#12ms
-- Usando Not In
SELECT a.address, a.postal_code, ci.city, co.country
FROM address AS a
JOIN city AS ci ON a.city_id = ci.city_id
JOIN country AS co ON ci.country_id = co.country_id
WHERE a.postal_code NOT IN ('35200', '17886', '83579');
#5ms
CREATE INDEX PostalCode ON address(postal_code);
#Primera query despues del index =4ms, la segunda = 4ms
#Explicacion: El index crea una lista, que le permite a la base de datos,
#que cuando quiera hacer algun calculo con ese campo, en vez de ir uno por uno devuelta, directamente va al index, funciona como el indice de un libro


#2---------------------------------------------------------------------------------------------
SELECT first_name
FROM actor
ORDER BY first_name;
#12ms

SELECT last_name
FROM actor
ORDER BY last_name;
#4ms
#la diferencia en el tiempo de ejecucion reside en que, existe
#precargado en sakila, un index para "last_name" y no para "first_name"

SHOW INDEX FROM actor; #la query para mostrar los index existentes

#3------------------------------------------------------------------------------

SELECT description
FROM film
WHERE description LIKE "%Character%"
ORDER BY description;
# 80ms

#para usar match y against, si o si hay que tener un index llamado "Fulltext"
CREATE FULLTEXT INDEX FullText_idx ON film(description);

SELECT description
FROM film
WHERE MATCH(description) AGAINST("Character")
ORDER BY description;
# 13ms
#una vez runeada la query con el index ya hecho, se ve que es sustancialmente mas rapida la ejecucion