-- Get all first orders
-- Get their movie ratings

-- Get a common table expression of all first orders, try without looking

WITH first_orders AS (
  SELECT * FROM (
	  SELECT p.payment_id, p.customer_id,p.payment_date,
	  row_number() over(partition by p.customer_id ORDER BY p.payment_date)
	  FROM payment p
  )t WHERE t.row_number = 1
)

-- Rental --> Inventory --> Film



