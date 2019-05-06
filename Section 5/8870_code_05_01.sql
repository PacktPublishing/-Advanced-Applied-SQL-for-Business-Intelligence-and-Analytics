SELECT p.*, s.store_id
 FROM payment p 
JOIN staff s ON s.staff_id = p.staff_id
WHERE p.customer_id = 1 ORDER BY 6