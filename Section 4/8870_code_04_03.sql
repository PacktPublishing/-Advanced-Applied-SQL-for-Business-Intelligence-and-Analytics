-- Top 5 highest grossing actors?
-- Table of actors and revenue per actor
-- Top 5 actors by rental revenues
-- Get all films those actors appeared in
-- compare total customers and customers renting from those films?

-- Big idea here is that do the top 5 actors by revenue really influence overall rentals

WITH base_table AS (
SELECT p.amount, r.inventory_id, f.film_id, a.first_name || ' ' || a.last_name as actor_actress,
a.actor_id
FROM payment p 
 JOIN rental r ON r.rental_id = p.rental_id
 JOIN inventory i ON i.inventory_id = r.inventory_id
 JOIN film f ON f.film_id = i.film_id
 JOIN film_actor fa ON fa.film_id = f.film_id
 JOIN actor a ON fa.actor_id = a.actor_id
), top5 as (

SELECT bt.actor_actress, bt.actor_id, SUM(bt.amount)
FROM base_table bt GROUP BY 1, 2 ORDER BY 3 DESC
LIMIT 5
), movies_top as (

-- get all the films these actors appeared in
-- get all customers renting these films

SELECT distinct fa.film_id 
FROM film_actor fa WHERE fa.actor_id IN (
  SELECT t5.actor_id FROM top5 t5
)
)

-- SELECT * FROM movies_top -- of the 183 rows, how omany of 599 customers rented from this set

-- SELECT count(distinct p.customer_id) FROM payment p -- 599

SELECT distinct t.customer_id FROM (
	SELECT p.amount, p.customer_id, r.inventory_id, f.film_id
	FROM payment p 
	 JOIN rental r ON r.rental_id = p.rental_id
	 JOIN inventory i ON i.inventory_id = r.inventory_id
	 JOIN film f ON f.film_id = i.film_id

	WHERE f.film_id IN (
	  SELECT mt.film_id FROM movies_top mt
	)
)t

-- 599 customers, 591 rented a movie which the top 5 grossing actors/actresses appeared in



-- Gross revenue per actor, per film

WITH base_table AS (
	SELECT p.amount, r.inventory_id, f.film_id, a.first_name || ' ' || a.last_name as actor_actress,
	a.actor_id
	FROM payment p 
	 JOIN rental r ON r.rental_id = p.rental_id
	 JOIN inventory i ON i.inventory_id = r.inventory_id
	 JOIN film f ON f.film_id = i.film_id
	 JOIN film_actor fa ON fa.film_id = f.film_id
	 JOIN actor a ON fa.actor_id = a.actor_id
), second_table AS (

	SELECT  f.film_id, SUM(p.amount) as gross_sales
	FROM payment p 
	 JOIN rental r ON r.rental_id = p.rental_id
	 JOIN inventory i ON i.inventory_id = r.inventory_id
	 JOIN film f ON f.film_id = i.film_id
	 GROUP BY 1 ORDER BY 2 DESC
)

SELECT bt.film_id, st.gross_sales, array_agg(distinct bt.actor_id), array_length(array_agg(distinct bt.actor_id), 1)
FROM base_table bt JOIN second_table st ON st.film_id = bt.film_id
GROUP BY 1, 2







