-- First, there's no right way to do this! Just try to get 
-- data in a format that you can understand, then iterate


-- I like breaking it into pieces, buyerid/email, first order, last order, total spend

WITH base_table AS (
	SELECT p.customer_id, p.payment_date, p.payment_id, 
	row_number() OVER(partition by p.customer_id ORDER BY p.payment_date ASC) as order_rank_early,
	row_number() OVER(partition by p.customer_id ORDER BY p.payment_date DESC) as order_rank_late,
	(
	  SELECT SUM(p2.amount) FROM payment p2 WHERE p2.customer_id = p.customer_id
	) as LTV
	FROM payment p
	GROUP BY 1,2,3
	ORDER BY 1,2
), second_table AS (

	SELECT bt.* 
	FROM 
	base_table bt 
	WHERE bt.order_rank_early = 1 OR bt.order_rank_late = 1
)

SELECT st.customer_id, min(st.payment_date), max(st.payment_date), min(st.ltv)
FROM second_table st
GROUP BY 1 ORDER BY 1



-- still need their top rating as well as all rating rented from (R, PG, etc)
SELECT r.customer_id, r.inventory_id, i.film_id, f.rating
FROM rental r -- start with the activity
	JOIN inventory i on i.inventory_id = r.inventory_id
	JOIN film f ON f.film_id = i.film_id


-- still need their top rating as well as all rating rented from (R, PG, etc)
-- not worry about ties:

SELECT * FROM (
SELECT r.customer_id, f.rating, COUNT(*),
row_number() OVER(partition by r.customer_id ORDER BY COUNT(*) DESC) as rental_freq_rank
FROM rental r -- start with the activity
	JOIN inventory i on i.inventory_id = r.inventory_id
	JOIN film f ON f.film_id = i.film_id
GROUP BY 1,2
ORDER BY 1, 3 DESC
)t WHERE t.rental_freq_rank = 1




SELECT r.customer_id, array_agg(distinct f.rating)
FROM rental r -- start with the activity
	JOIN inventory i on i.inventory_id = r.inventory_id
	JOIN film f ON f.film_id = i.film_id
GROUP BY 1