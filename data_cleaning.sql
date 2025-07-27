--CREATING new DELIVERY TABLE
CREATE TABLE delivery (
    order_id INT,
    region_id INT,
    city VARCHAR(30),
    courier_id INT,
    lng FLOAT,
    lat FLOAT,
    aoi_id INT,
    aoi_type INT,
    accept_time TIMESTAMP,
    accept_gps_time TIMESTAMP,
    accept_gps_lng FLOAT,
    accept_gps_lat FLOAT,
    delivery_time TIMESTAMP,
    delivery_gps_time TIMESTAMP,
    delivery_gps_lng FLOAT,
    delivery_gps_lat FLOAT,
    ds INT
);

--LOADING THE 858899 ROW CSV DATA INTO THE TABLE DELIVERY USING PSQL COMMANDLINE
\copy delivery(order_id,region_id,city,courier_id,lng,lat,aoi_id,aoi_type,
                accept_time,accept_gps_time,accept_gps_lng,accept_gps_lat,
				delivery_time,delivery_gps_time,delivery_gps_lng,delivery_gps_lat,ds) 
FROM 'C:\Users\vinay\Downloads\delivery_hz.csv' DELIMITER ',' CSV HEADER;

--QUERING ALL ROWS
select * from delivery


/*CLEANING DATA*/


--Checking for duplicate values
SELECT * FROM(
select *,
   ROW_NUMBER() OVER(PARTITION BY order_id)  as rn
   FROM delivery) AS tab
   where rn>1 ;

--checking for inconsistency in data
 SELECT *
FROM delivery
WHERE delivery_time < accept_time
LIMIT 50;

DELETE FROM delivery
WHERE delivery_time < accept_time;

SELECT 
    MIN(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600) AS min_hours,
    MAX(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600) AS max_hours
FROM delivery


--extreme inconsistency rows 
SELECT order_id, accept_time, delivery_time,
       EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600 AS hours_taken
FROM delivery
ORDER BY hours_taken DESC


/* CREATING NEW TABLE WITH CLEAED DATA */ 

CREATE TABLE delivery_cleaned AS
SELECT *
FROM delivery
WHERE delivery_time >= accept_time
  AND (delivery_time - accept_time) <= INTERVAL '48 hours';
  
--VERIFYING THE  DATA
SELECT 
    MIN(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600) AS min_hours,
    MAX(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600) AS max_hours,
    AVG(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600) AS avg_hours
FROM delivery_cleaned;


SELECT
    MIN(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600) AS min_hours,
    MAX(EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600) AS max_hours,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY EXTRACT(EPOCH FROM (delivery_time - accept_time)) / 3600) AS median_hours
FROM delivery_cleaned;



