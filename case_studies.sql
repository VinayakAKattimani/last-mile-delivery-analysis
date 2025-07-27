SELECT * FROM delivery_cleaned 


-----------------------------------------------------------------------------------

--What is our average delivery time across all orders?
SELECT 
    ROUND(AVG(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600), 2) AS avg_delivery_hours
FROM delivery_cleaned;


--What is our average delivery time across all regions?
SELECT region_id,
    ROUND(AVG(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600), 2) AS avg_delivery_hours
FROM delivery_cleaned
GROUP BY region_id;



--How many deliveries are delayed (say, more than avg hours)?

SELECT COUNT(*)
  FROM delivery_cleaned 
  where EXTRACT(EPOCH FROM (delivery_time - accept_time)) /3600 > 
  ( select 
   ROUND(AVG(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600), 2) as avg_t
   FROM delivery_cleaned )
   
     
--How many deliveries are delayed (say, more than avg hours) by region
SELECT region_id, COUNT(*) as total_delayed
      FROM delivery_cleaned
where EXTRACT(EPOCH FROM (delivery_time - accept_time))/3600 > 
(SELECT 
       ROUND(AVG(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600),2) as avg_t
	   from delivery_cleaned
	   )
GROUP BY region_id
order by total_delayed DESC

--Which regions have the most delayed deliveries?
SELECT region_id, COUNT(*) as total_delayed
      FROM delivery_cleaned
where EXTRACT(EPOCH FROM (delivery_time - accept_time))/3600 > 
(SELECT 
       ROUND(AVG(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600),2) as avg_t
	   from delivery_cleaned
	   )
GROUP BY region_id
order by total_delayed DESC
LIMIT 3

--Are some couriers slower than others?
SELECT COUNT(*)
FROM (
    SELECT courier_id,
           AVG(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600) AS courier_avg_time
    FROM delivery_cleaned
    GROUP BY courier_id
) AS courier_avg
WHERE courier_avg_time > (
    SELECT AVG(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600)
    FROM delivery_cleaned
);


--THE COURIERS WHICH ARE SLOWER THAN OTHERS
SELECT courier_id,
       ROUND(AVG(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600), 2) AS courier_avg_time
FROM delivery_cleaned
GROUP BY courier_id
HAVING AVG(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600) >
       (SELECT AVG(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600)
        FROM delivery_cleaned)
ORDER BY courier_avg_time DESC;

--Where are we losing time?

SELECT 
    courier_id,
    COUNT(*) AS total_deliveries,
    SUM(CASE WHEN timediffminutes > 30 THEN 1 ELSE 0 END) AS delayed_deliveries,
    ROUND(
        100.0 * SUM(CASE WHEN timediffminutes > 30 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS delay_percent
FROM 
    delivery
GROUP BY 
    courier_id
ORDER BY 
    delay_percent DESC;


--Who/what is responsible for delays?
SELECT 
    courier_id,
    COUNT(*) AS total_deliveries,
    SUM(CASE WHEN timediffminutes > 30 THEN 1 ELSE 0 END) AS delayed_deliveries,
    ROUND(100.0 * SUM(CASE WHEN timediffminutes > 30 THEN 1 ELSE 0 END) / COUNT(*), 2) AS delay_rate_percent
FROM 
    delivery
GROUP BY 
    courier_id
ORDER BY 
    delay_rate_percent DESC;


-- How can we improve on-time delivery rates?
SELECT 
    EXTRACT(HOUR FROM accept_time) AS accept_hour,
    COUNT(*) AS total_orders,
    ROUND(AVG(timediffminutes), 2) AS avg_delivery_time,
    SUM(CASE WHEN timediffminutes > 30 THEN 1 ELSE 0 END) AS delayed_orders
FROM 
    delivery
GROUP BY 
    EXTRACT(HOUR FROM accept_time)
ORDER BY 
    avg_delivery_time DESC;


















