-- CREATE TABLE IF NOT EXISTS customer_sources (
--    customer_id integer REFERENCES customer(customer_id) ON DELETE RESTRICT,
--    traffic_source text,
--    PRIMARY KEY(customer_id)
-- );

SELECT c.customer_id, c.first_name, c.email, cs.*
FROM customer c JOIN customer_sources cs ON cs.customer_id = c.customer_id

-- Source / medium, cost, month

DROP TABLE source_spend_all;

CREATE TABLE IF NOT EXISTS source_spend_all (
   spend_source text,
   spend integer,
   visits integer
);

SELECT t.spend_source, max(t.spend)::money as spend, 
	count(*) as customers, 
	(max(t.spend)/count(*))::money as CPA, 
	(SUM(t.LTV) / 3)::money as total_gross_margin  

	FROM (
	SELECT ssa.*,cs.*, (
         SELECT sum(p.amount) FROM payment p WHERE cs.customer_id = p.customer_id
	) as LTV
	FROM source_spend_all ssa 
	JOIN customer_sources cs ON cs.traffic_source = ssa.spend_source
)t 

GROUP BY 1 ORDER BY 2 DESC
-- source, spend, nbr customers

