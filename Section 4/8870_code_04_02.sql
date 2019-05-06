-- Get all first orders
-- Get their movie ratings

-- Get a common table expression of all first orders, try without looking

WITH first_orders AS (
  SELECT * FROM (
	  SELECT p.payment_id, p.amount, p.customer_id,p.payment_date, p.rental_id,
	  row_number() over(partition by p.customer_id ORDER BY p.payment_date)
	  FROM payment p
  )t WHERE t.row_number = 1
), second_table AS (

-- Rental --> Inventory --> Film
SELECT t.rating, t.customer_id, SUM(t.amount) as fo_sum, count(*) , (
 SELECT sum(p2.amount) from payment p2 
 WHERE p2.customer_id = t.customer_id
) as lifetime_spend
FROM (
	SELECT fo.payment_id, fo.amount, r.*, i.*, f.*
	FROM first_orders fo 
	JOIN rental r ON r.rental_id = fo.rental_id
	JOIN inventory i ON i.inventory_id = r.inventory_id
	JOIN film f ON f.film_id = i.film_id
)t 
GROUP BY 1, 2
)

SELECT st.rating, avg(st.lifetime_spend)
FROM second_table st
GROUP BY 1

-- First a word on these results: someone astute might ask: "Without looking at
-- the nbr of films available overall per genre, can we really say pg13 is more popular?"
-- try and figure that out
-- SELECT rating, count(*) FROM film f GROUP BY 1
-- total rentals henceforth....get a diff result? avg unit price being difference

-- Was my averaging correct here? I took a non weighted mean



