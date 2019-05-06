-- I want the top 10% of movies by dollar value rented

SELECT * FROM (
	SELECT  f.film_id, f.title, SUM(p.amount) as sales,
	NTILE(100) OVER ( ORDER BY SUM(p.amount) ) as sales_rank_ntile, 
	SUM(SUM(p.amount) ) OVER () as global_sales

	FROM rental r JOIN inventory i ON i.inventory_id = r.inventory_id
		      JOIN film f ON f.film_id = i.film_id
		      JOIN payment p ON p.rental_id = r.rental_id

	GROUP BY 1,2  
	ORDER BY 3 DESC  
)t WHERE t.sales_rank_ntile > 89    