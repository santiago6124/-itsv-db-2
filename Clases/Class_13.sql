-- Active: 1681488495868@@127.0.0.1@3306@sakila

use sakila;

/*
 Add a new customer
 To store 1
 For address use an existing address. The one that has the  biggest address_id in 'United States'
 Add a rental
 Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
 Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
 Select any staff_id from Store 2.
 Update film year based on the rating
 For example if rating is 'G' release date will be '2001'
 You can choose the mapping between rating and year.
 Write as many statements are needed.
 Return a film
 Write the necessary statements and queries for the following steps.
 Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
 Use the id to return the film.
 Try to delete a film
 Check what happens, describe what to do.
 Write all the necessary delete statements to entirely remove the film from the DB.
 Rent a film
 Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
 Add a rental entry
 Add a payment entry
 Use sub-queries for everything, except for the inventory id that can be used directly in the queries.
 Once you're done. Restore the database data using the populate script from class 3.
 */

INSERT INTO
    customer (
        store_id,
        first_name,
        last_name,
        email,
        address_id,
        active
    )
SELECT
    1,
    'Santiago',
    'Carranza',
    'santiagocarranzazinny@gmail.com',
    MAX(ad.address_id),
    1
FROM address ad
WHERE ad.city_id IN (
        SELECT ci.city_id
        FROM
            country co,
            city ci
        WHERE
            co.country = "United States"
            AND co.country_id = ci.country_id
            AND ci.city_id = ad.city_id
    );

#2
INSERT INTO
    rental (
        rental_date,
        inventory_id,
        customer_id,
        return_date,
        staff_id
    )
SELECT CURRENT_TIMESTAMP, (
        SELECT
            MAX(i.inventory_id)
        FROM inventory i
            INNER JOIN film f USING(film_id)
        WHERE
            f.title LIKE 'ZORRO ARK'
    ),
    1,
    NULL, (
        SELECT
            manager_staff_id
        FROM store
        WHERE store_id = 2
        ORDER BY RAND()
        LIMIT 1
    );

#3 UPDATE film SET release_year = 2001 WHERE rating ='G';

UPDATE film SET release_year = 2023 WHERE rating = 'PG';

UPDATE film SET release_year = 2022 WHERE rating ='NC-17';

UPDATE film SET release_year = 2021 WHERE rating ='PG-13';

UPDATE film SET release_year = 2020 WHERE rating = 'R';

#4
SELECT
    r.rental_id,
    r.return_date
FROM film f
    INNER JOIN inventory i USING(film_id)
    INNER JOIN rental r USING(inventory_id)
WHERE r.return_date IS NULL
ORDER BY r.rental_date DESC
LIMIT 5;
#rental_id:16057
UPDATE rental
SET
    return_date = CURRENT_TIMESTAMP
WHERE rental_id = 16057;

#5 SELECT * FROM film ORDER BY film_id LIMIT 1;

DELETE FROM film WHERE title = 'ACE GOLDFINGER';

/*
 Cannot delete or update a parent row: a foreign key constraint fails (`sakila`.`film_actor`, CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE)
 */

# lo que habria que hacer es eliminar todas los registros que tienen relacion con Academy Dinousar, por ejemplo en film_actor,inventory, film_category y rental.
DELETE FROM rental
WHERE inventory_id IN (
        SELECT inventory_id
        FROM inventory
        WHERE film_id = (
                SELECT
                    film_id
                FROM film
                WHERE
                    title = 'ACE GOLDFINGER'
            )
    );

DELETE FROM inventory
WHERE film_id = (
        SELECT film_id
        FROM film
        WHERE
            title = 'ACE GOLDFINGER'
    );

DELETE FROM film_category
WHERE film_id = (
        SELECT film_id
        FROM film
        WHERE
            title = 'ACE GOLDFINGER'
    );

DELETE FROM film_actor
WHERE film_id = (
        SELECT film_id
        FROM film
        WHERE
            title = 'ACE GOLDFINGER'
    );
#ahora que los registros relacionados fueron eliminados, si se puede borrar la peli :)
DELETE FROM film WHERE title = 'ACE GOLDFINGER';

#6
SELECT inventory_id, film_id
FROM inventory
WHERE inventory_id NOT IN (
        SELECT inventory_id
        FROM inventory
            INNER JOIN rental USING (inventory_id)
        WHERE
            return_date IS NULL
    );

#film_id: 1000
#inventory_id: 4580
INSERT INTO
    rental (
        rental_date,
        inventory_id,
        customer_id,
        staff_id
    )
VALUES (
        CURRENT_DATE(),
        4580, (
            SELECT
                customer_id
            FROM customer
            ORDER BY
                customer_id DESC
            LIMIT 1
        ), (
            SELECT staff_id
            FROM staff
            WHERE store_id = (
                    SELECT
                        store_id
                    FROM
                        inventory
                    WHERE
                        inventory_id = 4580
                )
        )
    );

INSERT INTO
    payment (
        customer_id,
        staff_id,
        rental_id,
        amount,
        payment_date
    )
VALUES( (
            SELECT customer_id
            FROM customer
            ORDER BY customer_id DESC
            LIMIT 1
        ), (
            SELECT staff_id
            FROM staff
            LIMIT 1
        ), (
            SELECT rental_id
            FROM rental
            ORDER BY rental_id DESC
            LIMIT 1
        ), (
            SELECT rental_rate
            FROM film
            WHERE
                film_id = 400
        ),
        CURRENT_DATE()
    );