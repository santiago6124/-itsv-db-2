-- Active: 1681488495868@@127.0.0.1@3306@sakila
/*

    Write a function that returns the amount of copies of a film in a store in sakila-db. Pass either the film id or the film name and the store id.
    Write a stored procedure with an output parameter that contains a list of customer first and last names separated by ";", that live in a certain country. You pass the country it gives you the list of people living there. USE A CURSOR, do not use any aggregation function (ike CONTCAT_WS.
    Review the function inventory_in_stock and the procedure film_in_stock explain the code, write usage examples.

*/

#1
DELIMITER //

CREATE FUNCTION GetFilmCopiesInStore(filmIdentifier INT, storeId INT) RETURNS INT
BEGIN
    DECLARE copies INT;

    IF filmIdentifier < 1000 THEN
        SELECT COUNT(*) INTO copies
        FROM inventory i
        WHERE i.store_id = storeId
        AND i.film_id = filmIdentifier;
    ELSE
        SELECT COUNT(*) INTO copies
        FROM inventory i
        JOIN film f ON i.film_id = f.film_id
        WHERE i.store_id = storeId
        AND f.title = filmIdentifier;
    END IF;

    RETURN copies;
END //

DELIMITER ;
SELECT GetFilmCopiesInStore('3', 2);

#2
DELIMITER //

CREATE PROCEDURE RetrieveCustomerListInCountry(
    IN countryName VARCHAR(50),
    OUT customerNames VARCHAR(255)
)
BEGIN
    # declaramos las variables que vamos a usar
    DECLARE done INT DEFAULT 0;
    DECLARE firstName VARCHAR(50);
    DECLARE lastName VARCHAR(50);
    DECLARE fullName VARCHAR(100);

    # creamos el cursor para sacar los nombres
    DECLARE customerCursor CURSOR FOR
        SELECT first_name, last_name
        FROM customer cu
        JOIN address ad ON cu.address_id = ad.address_id
        JOIN city ci ON ad.city_id = ci.city_id
        JOIN country co ON ci.country_id = co.country_id
        WHERE co.country = countryName;

    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    # seteamos el string
    SET customerNames = '';

    # abrimos el cursor
    OPEN customerCursor;

    # starteamos el loop
    readLoop: LOOP
        FETCH customerCursor INTO firstName, lastName;

        IF done THEN
            LEAVE readLoop;
        END IF;

        SET fullName = CONCAT(firstName, ' ', lastName);

        IF customerNames = '' THEN
            SET customerNames = fullName;
        ELSE
            SET customerNames = CONCAT(customerNames, '; ', fullName);
        END IF;
    END LOOP;

    # Lo cerramos
    CLOSE customerCursor;
END;
//
DELIMITER ;
# declaramos la variable output
SET @outputCustomerList = '';

# Lo probamos con los clientes de Argentina
CALL RetrieveCustomerListInCountry('Argentina', @outputCustomerList);

# Mostramos el output
SELECT @outputCustomerList;

#3

# inventory_in_stock
------------------------------------------------------------
#Esta función está diseñada para determinar si una película en el inventario está en stock. 
#Toma un inventory_id como parámetro y devuelve 1 (VERDADERO) o 0 (FALSO), diciendo si el artículo del inventario está en stock.

# Esta es la funcion en cuestion
CREATE FUNCTION `inventory_in_stock`(p_inventory_id INT) RETURNS tinyint(1)
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out INT;

    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END

#Explicación:

    #La función verifica si existen alquileres (v_rentals) para el inventory_id especificado. Si no hay alquileres, devuelve VERDADERO (1), indicando que el artículo del inventario está en stock.
    #Si hay alquileres, verifica si hay alquileres con una return_date NULL (v_out). Si no hay alquileres de este tipo, devuelve VERDADERO; de lo contrario, devuelve FALSO.

#Ejemplos de Uso:
SELECT inventory_in_stock(1111); # Devuelve 1 (VERDADERO)
SELECT inventory_in_stock(4568); # Devuelve 0 (FALSO)
# film_in_stock

# está diseñado para encontrar elementos del inventario de una película específica en una tienda en particular y, opcionalmente devolver la cantidad de elementos disponibles.
# Toma p_film_id (ID de película), p_store_id (ID de tienda) y un parámetro de salida p_film_count para almacenar la cantidad de elementos disponibles.

#el procedimiento en cuestion

CREATE PROCEDURE `film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
BEGIN
    SELECT inventory_id
    FROM inventory
    WHERE film_id = p_film_id
    AND store_id = p_store_id
    AND inventory_in_stock(inventory_id);

    SELECT COUNT(*)
    FROM inventory
    WHERE film_id = p_film_id
    AND store_id = p_store_id
    AND inventory_in_stock(inventory_id)
    INTO p_film_count;
END

#Explicación:

   # El procedimiento primero recupera el inventory_id de los elementos del inventario que coinciden con el film_id y el store_id especificados y que están en stock (usando la función inventory_in_stock).
   # Despues, cuenta el número total de elementos que cumplen los mismos criterios y almacena el recuento en el parámetro de salida p_film_count.

#Ejemplo de Uso:


# Llama al procedimiento para encontrar elementos del inventario de la película con ID 2 en la tienda con ID 2
CALL film_in_stock(1, 3, @total);

# Muestra la cantidad de elementos disponibles
SELECT @total;

#Este ejemplo llama al procedimiento film_in_stock para encontrar elementos del inventario de la película con ID 1 en la tienda con ID 3 y almacena el recuento de elementos disponibles en la variable @total, mostrando el resultado