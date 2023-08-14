-- Subqueries Challenge
-- Write SQL queries to perform the following tasks using the Sakila database:

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
USE sakila;
SELECT f.title, COUNT(i.inventory_id) 
FROM sakila.film f
JOIN sakila.inventory i 
Using (film_id)
WHERE f.title = "Hunchback Impossible";

SELECT 
    title,
    (SELECT COUNT(inventory_id) 
     FROM sakila.inventory i 
     WHERE i.film_id = f.film_id) AS inventory_count
FROM 
    sakila.film f
WHERE 
    title = "Hunchback Impossible";


-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT AVG(length)
FROM sakila.film;
-- 115 min

SELECT * FROM sakila.film
WHERE 
	length > (SELECT 
            AVG(length)
        FROM
            sakila.film);
-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
-- JOIN
SELECT 
    actor.actor_id,
    actor.first_name,
    actor.last_name
FROM 
    sakila.actor
WHERE 
    actor.actor_id IN (
        SELECT 
            fa.actor_id
        FROM 
            sakila.film
        JOIN 
            sakila.film_actor fa
        USING 
            (film_id)
        WHERE 
            film.title = 'Alone Trip'
    );


-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT NAME FROM CATEGORY;

SELECT title
FROM sakila.film
WHERE film_id IN (
    SELECT film_id
    FROM sakila.film_category
    WHERE category_id = (
        SELECT category_id
        FROM sakila.category
        WHERE name = "Family"
    )
);


-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.

SELECT first_name, last_name, email
FROM sakila.customer
WHERE address_id IN (
    SELECT a.address_id
    FROM sakila.address a
    JOIN sakila.city c
    ON a.city_id = c.city_id
    JOIN sakila.country co
    ON c.country_id = co.country_id
    WHERE co.country = 'Canada');

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT actor_id
        FROM sakila.film_actor
        GROUP BY actor_id
        ORDER BY COUNT(*) DESC
        Limit 1;


SELECT title
FROM sakila.film
WHERE film_id IN (
    SELECT film_id
    FROM sakila.film_actor
    WHERE actor_id = (
        SELECT actor_id
        FROM sakila.film_actor
        GROUP BY actor_id
        ORDER BY COUNT(*) DESC
        LIMIT 1
    )
);
        
        
-- 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT 
    customer_id
FROM
    sakila.payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1;
        
SELECT 
    title
FROM
    sakila.film
WHERE
    film_id IN (SELECT 
            i.film_id
        FROM
            sakila.inventory i
                JOIN
            sakila.rental r ON i.inventory_id = r.inventory_id
                JOIN
            sakila.payment p ON r.rental_id = p.rental_id
        WHERE
            r.customer_id = (SELECT 
					customer_id
                FROM
                    sakila.payment
                GROUP BY customer_id
                ORDER BY SUM(amount) DESC));
        
        
-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. 
-- You can use subqueries to accomplish this.

SELECT customer_id, SUM(amount) AS total_amount_spent
FROM sakila.payment
WHERE customer_id IN (
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
SELECT AVG(total_amount_spent)
FROM (
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
) AS customer_spending
)
)
GROUP BY customer_id
ORDER BY total_amount_spent DESC;




