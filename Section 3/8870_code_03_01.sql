
SELECT t.*, 
 t.payment_date - t.prior_order as some_interval, -- raw interval
 EXTRACT(epoch FROM t.payment_date - t.prior_order ) / 3600 as hours_since-- interval to hours
 
 FROM (
	SELECT p.*, 
		lag(p.payment_date) OVER (PARTITION BY p.customer_id) as prior_order
	FROM payment p
)t

