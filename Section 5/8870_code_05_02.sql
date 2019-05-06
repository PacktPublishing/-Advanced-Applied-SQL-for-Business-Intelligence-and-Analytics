-- first, first 7, 14 days, etc...
-- idea of the interval

-- SELECT d, d + INTERVAL '1 week' as aweekfromnow
-- FROM generate_series('2017-01-01', current_date, INTERVAL '1 day') d

WITH bt as (
		SELECT * FROM (
		SELECT p.customer_id, p.payment_date, row_number() over(partition by p.customer_id order by p.payment_date)
		FROM payment p
	)t WHERE t.row_number = 1
)

SELECT bt.*, 
(
 SELECT SUM(p2.amount) FROM payment p2 WHERE p2.customer_id = bt.customer_id
 AND p2.payment_date BETWEEN bt.payment_date AND bt.payment_date + INTERVAL '7 days'
) as first7_sales,

(
 SELECT SUM(p2.amount) FROM payment p2 WHERE p2.customer_id = bt.customer_id
 AND p2.payment_date BETWEEN bt.payment_date AND bt.payment_date + INTERVAL '14 days'
) as first14_sales,

(
 SELECT SUM(p2.amount) FROM payment p2 WHERE p2.customer_id = bt.customer_id
 --AND p2.payment_date BETWEEN bt.payment_date AND bt.payment_date + INTERVAL '14 days'
) as LTV

FROM bt bt