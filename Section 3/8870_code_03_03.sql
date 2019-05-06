SELECT t.*, 
 t.payment_date - t.prior_order as some_interval, -- raw interval
 EXTRACT(epoch FROM t.payment_date - t.prior_order ) / 3600 as hours_since
 
 FROM (
	SELECT p.*, 
		lag(p.payment_date) OVER (PARTITION BY p.customer_id) as prior_order,
		row_number() over(partition by p.customer_id order by p.payment_date) as order_rank
	FROM payment p
)t