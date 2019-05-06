-- buyerid, email, first order, recent order, total spend
WITH base_table AS (
 SELECT p.customer_id, p.payment_date, 
 row_number() over(partition by p.customer_id order by p.payment_date asc) as early_order,
 row_number() over(partition by p.customer_id order by p.payment_date desc) as late_order	
 FROM payment p
), second_table AS (

	SELECT * FROM base_table bt 
	WHERE bt.early_order = 1 OR bt.late_order = 1
)

SELECT st.customer_id, max(st.payment_date) as rec_order, min(st.payment_date) as first_order,
(
	SELECT SUM(p2.amount) FROM payment p2 WHERE p2.customer_id = st.customer_id
) as ltv_spend
FROM second_table st 
GROUP BY 1 ORDER BY 1

-- Preferred Rating need to figure out  how to get their ratings
SELECT * FROM (
	SELECT t.customer_id, t.rating, count(*) , 
	row_number() over(partition by t.customer_id ORDER BY COUNT(*) DESC)
	FROM (
		SELECT r.customer_id, r.inventory_id, i.film_id, f.rating
		FROM rental r
		 JOIN inventory i on r.inventory_id = i.inventory_id
		 JOIN film f ON f.film_id = i.film_id
	) t GROUP BY 1, 2 ORDER BY 1, 3 DESC
) t2 WHERE t2.row_number = 1


SELECT t.customer_id, count(*) ,  array_agg(distinct t.rating),
row_number() over(partition by t.customer_id ORDER BY COUNT(*) DESC)
FROM (
	SELECT r.customer_id, r.inventory_id, i.film_id, f.rating
	FROM rental r
	 JOIN inventory i on r.inventory_id = i.inventory_id
	 JOIN film f ON f.film_id = i.film_id
) t GROUP BY 1
ORDER BY 1, 3 DESC






