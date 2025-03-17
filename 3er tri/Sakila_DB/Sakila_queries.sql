/*Sakila DB */
use sakila;
show tables;

/*02_modify_actor*/

INSERT INTO actor (actor_id, first_name, last_name, last_update) VALUES
(8162, 'Juan', 'López', now()); 
select actor_id, first_name, last_name, last_update FROM actor;

UPDATE actor SET last_name = 'Oliva' WHERE first_name = 'Juan';

DELETE FROM actor WHERE actor_id = 8162;

/*03_Create_recent_films*/

SELECT * FROM film WHERE release_year >= 2005;

CREATE TABLE recent_films AS
SELECT * 
FROM film
WHERE release_year >= 2005;
SELECT * FROM recent_films;

/*04_complex_queries*/

-- Lists all customers who have rented a film in the last 30 days
SELECT DISTINCT c.customer_id, c.first_name, c.last_name, r.rental_date
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE r.rental_date >= CURDATE() - INTERVAL 30 DAY;

--  Identifies the most rented film in the database.
SELECT f.film_id, f.title, COUNT(r.rental_id) AS total_alquileres
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY total_alquileres DESC
LIMIT 1;

-- Displays the total revenue generated per store
SELECT s.store_id, SUM(p.amount) AS ingresos_totales
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

/*05_transaction_example*/

START TRANSACTION;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES (NOW(), 5, 3, NULL, 1);

COMMIT;

/*06_rollback_example*/

START TRANSACTION;

SELECT COUNT(*) INTO @stock_disponible
FROM inventory i
LEFT JOIN rental r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL
WHERE i.inventory_id = 5;

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
SELECT NOW(), 5, 3, NULL, 1
WHERE @stock_disponible > 0;

SELECT IF(@stock_disponible = 0, SLEEP(0), NULL) INTO @error;
COMMIT;

/*08_data_integrity*/

ALTER TABLE rental
ADD CONSTRAINT fk_customer_id
FOREIGN KEY (customer_id)
REFERENCES customer (customer_id)
ON DELETE CASCADE;

-- We ensure that if an actor is removed, their relationships with the films are also removed.
ALTER TABLE film_actor
ADD CONSTRAINT fk_actor_id
FOREIGN KEY (actor_id)
REFERENCES actor (actor_id)
ON DELETE CASCADE;

-- The rental dates in the rental table do not follow a correct format or are inconsistent, such as having a rental date that is later than the return date.
DELIMITER //

CREATE TRIGGER check_rental_dates
BEFORE INSERT ON rental
FOR EACH ROW
BEGIN
    IF NEW.rental_date > NEW.return_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de alquiler no puede ser posterior a la fecha de devolución';
    END IF;
END //

DELIMITER ;

-- In the payment table, recording payments without verifying that the full rent amount has been paid correctly could lead to data inconsistencies.
DELIMITER //

CREATE TRIGGER check_payment_amount
BEFORE INSERT ON payment
FOR EACH ROW
BEGIN
    DECLARE rental_amount DECIMAL(6,2);
    
    -- Obtener el monto total del alquiler desde la tabla rental
    SELECT amount INTO rental_amount
    FROM rental
    WHERE rental_id = NEW.rental_id;
    
    -- Verificar que el monto del pago no sea mayor que el monto total del alquiler
    IF NEW.amount > rental_amount THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El monto del pago no puede ser mayor que el monto del alquiler';
    END IF;
END //

DELIMITER ;