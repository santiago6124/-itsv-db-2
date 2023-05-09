use sakila;

/*
    1_Find the films with less duration, show the title and rating.
    2_Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.
    3_Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.
    4_Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.
 */

#1
select title, length
from film
where length = (select min(length) from film);

#2
select title, length
from film as f1
where length <= (select min(length) from film)
  and not EXISTS(select * from film AS f2 where f2.film_id != f1.film_id and f2.length <= f1.length);

#3
select c.first_name as nombre,c.last_name as apellido, a.address as direccion,
	(select min(amount) from payment p where c.customer_id = p.customer_id ) as min
from customer c
JOIN address a on c.address_id = a.address_id
order by c.first_name;

#4
select c.first_name as nombre,c.last_name as apellido, a.address as direccion,
	(select MIN(amount) from payment p where c.customer_id = p.customer_id ) as min, 
    (select MAX(amount) from payment p where c.customer_id = p.customer_id ) AS max
from customer c
JOIN address a on c.address_id = a.address_id
order by c.first_name;
