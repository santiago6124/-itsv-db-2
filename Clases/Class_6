USE sakila;

/*
 List all the actors that share the last name. Show them in order
 Find actors that don't work in any film
 Find customers that rented only one film
 Find customers that rented more than one film
 List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'
 List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
 List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'
 List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'
 */

#List all the actors that share the last name. Show them in order
SELECT first_name, last_name
FROM actor a
WHERE EXISTS (
        SELECT *
        FROM actor a2
        WHERE
            a.last_name = a2.last_name
            AND a.actor_id <> a2.actor_id
    )
ORDER BY a.last_name;

#2 Find actors that dont work in any film
SELECT
    a.first_name,
    a.last_name
FROM actor a
WHERE NOT EXISTS (
        SELECT *
        FROM film_actor fa
        WHERE
            a.actor_id = fa.actor_id
    );

# Find customers that rented only one film
SELECT
    c.first_name,
    c.last_name
FROM customer c
WHERE 1 = (
        SELECT COUNT(*)
        FROM rental r
        WHERE
            c.customer_id = r.customer_id
    );


# Find customers that rented more than one film
SELECT
    c.first_name,
    c.last_name
FROM customer c
WHERE 1 < (
        SELECT COUNT(*)
        FROM rental r
        WHERE
            c.customer_id = r.customer_id
    );

# List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'
SELECT
    A.actor_id,
    A.first_name,
    A.last_name
FROM actor A
WHERE EXISTS(
        SELECT TITLE
        FROM film F
            INNER JOIN film_actor FA ON F.film_id = FA.film_id
        WHERE
            F.film_id = FA.film_id
            AND A.actor_id = FA.actor_id
            AND (
                F.title = 'BETRAYED REAR'
                OR F.title = 'CATCH AMISTAD'
            )
    );

# List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
SELECT
    actor_id,
    first_name,
    last_name
FROM actor A
WHERE EXISTS(
        SELECT title
        FROM film F
            INNER JOIN film_actor FA ON F.film_id = FA.film_id
        WHERE
            F.film_id = FA.film_id
            AND A.actor_id = FA.actor_id
            AND F.title = 'BETRAYED REAR'
    )
    AND NOT EXISTS (
        SELECT title
        FROM film F
            INNER JOIN film_actor FA ON F.film_id = FA.film_id
        WHERE
            F.film_id = FA.film_id
            AND A.actor_id = FA.actor_id
            AND F.title = 'CATCH AMISTAD'
    );

# List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'
SELECT
    actor_id,
    first_name,
    last_name
FROM actor A
WHERE EXISTS(
        SELECT title
        FROM film F
            INNER JOIN film_actor FA ON F.film_id = FA.film_id
        WHERE
            F.film_id = FA.film_id
            AND A.actor_id = FA.actor_id
            AND F.title = 'BETRAYED REAR'
    )
    AND EXISTS (
        SELECT title
        FROM film F
            INNER JOIN film_actor FA ON F.film_id = FA.film_id
        WHERE
            F.film_id = FA.film_id
            AND A.actor_id = FA.actor_id
            AND F.title = 'CATCH AMISTAD'
    );

# List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'
SELECT
    actor_id,
    first_name,
    last_name
FROM actor A
WHERE NOT EXISTS(
        SELECT title
        FROM film F
            INNER JOIN film_actor FA ON F.film_id = FA.film_id
        WHERE
            F.film_id = FA.film_id
            AND A.actor_id = FA.actor_id
            AND (
                F.title = 'BETRAYED REAR'
                OR F.title = 'CATCH AMISTAD'
            )
    );
