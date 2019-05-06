
SELECT t.*, 
 t.payment_date - t.prior_order as some_interval, -- raw interval
 EXTRACT(epoch FROM t.payment_date - t.prior_order ) / 3600 as hours_since-- interval to hours
 
 FROM (
	SELECT p.*, 
		lag(p.payment_date) OVER (PARTITION BY p.customer_id) as prior_order
	FROM payment p
)t

-- Alternate Syntax and Some Moving Calculations

SELECT p.* , 
	avg(p.amount) over w2 as avg_over_prior7,
	avg(p.amount) over w2 as back3_fwd_3_avg
FROM payment p

WINDOW w AS (PARTITION BY p.customer_id ORDER BY p.payment_id ROWS BETWEEN 7 PRECEDING AND 0 FOLLOWING),
       w2 AS (PARTITION BY p.customer_id  ROWS BETWEEN 7 PRECEDING AND 0 FOLLOWING)
