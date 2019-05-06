-- FINDING all data about a customer's first order
-- Should have 1 row for each customer
-- the min is determined by the payment_date

SELECT * FROM (
	SELECT p.* FROM payment p
	JOIN (
	  SELECT p2.customer_id, min(p2.payment_date) as fo_date
	  FROM payment p2 
	  GROUP BY 1 
	)zebra ON zebra.fo_date = p.payment_date
	ORDER BY 2
)t WHERE t.staff_id = 2



-- row_number
-- can you get a list of orders by staff member, in reverse order?
-- get customer's most recent orders?

WITH first_orders AS (
SELECT * FROM (
	SELECT p.*, 
	       ROW_NUMBER() OVER(PARTITION BY p.customer_id ORDER BY p.payment_date )
	       FROM payment p
	       ORDER BY 2
	)t WHERE t.row_number = 1
)

SELECT * FROM first_orders








-- CASE
with rando_nbrs AS (
	select random() * 100 as val
	from generate_series(1,100)
)
SELECT rn.* ,
CASE
 WHEN rn.val < 50 THEN 'lt_50'
 WHEN rn.val < 90 THEN 'lt_90'
 WHEN rn.val < 101 THEN 'gt_90'
 ELSE 'oops' -- filter on that later...
END as outcome 
FROM rando_nbrs rn





WITH ranked_orders AS (
SELECT p.*, 
ROW_NUMBER() OVER(PARTITION BY p.customer_id ORDER BY p.payment_date )
FROM payment p
ORDER BY 2
)

SELECT ro.*,
CASE 
 WHEN ro.row_number = 1 THEN 'new_order'
 WHEN ro.row_number > 1 THEN 'rept_order'
  ELSE 'oops' END as outcome
FROM ranked_orders ro


