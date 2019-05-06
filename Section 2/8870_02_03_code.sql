
with random_numbers as (
	select random() * 100 as val
	FROM generate_series(1,100)
)

SELECT rn.*, 
   CASE 
     WHEN rn.val < 50 THEN 'lt_50'
     WHEN rn.val >=50 THEN 'gte_50'
     ELSE 'some_other_condition'
     END as rand_outcome

FROM random_numbers rn

-- Get order nbr
WITH order_nbrs AS (
	SELECT p.*, row_number() over(partition by p.customer_id ORDER BY p.payment_date)
	FROM payment p
)

SELECT ons.* , 
CASE 
 WHEN ons.row_number = 1 THEN 'first_order'
 WHEN ons.row_number > 1 THEN 'repeat_order'
 ELSE 'checkme' END as order_outocme
FROM order_nbrs ons
