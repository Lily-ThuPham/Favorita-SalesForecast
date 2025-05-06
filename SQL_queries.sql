-- Create the database 
USE favorita_schema; 

SET GLOBAL local_infile=1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- import transaction table
CREATE TABLE transaction_table(
	id INT PRIMARY KEY,
    date_ DATE NOT NULL, 
    store_nbr INT NOT NULL,
    family VARCHAR(100) NOT NULL,
    sales FLOAT NOT NULL, 
    onpromotion INT NOT NULL,
    Year INT NOT NULL)
;
LOAD DATA LOCAL INFILE 'G:/My Drive/Lily Career/Work/Portfolio/Favorita Retails - Sale Forecast/Data_model/cleaned_train.csv'
INTO TABLE transaction_table
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, date_, store_nbr, family, sales, onpromotion,Year)
;

-- import family info table 
CREATE TABLE family_info (
	family VARCHAR(100) PRIMARY KEY,
    category VARCHAR(100) NOT NULL)
;

LOAD DATA LOCAL INFILE 'G:/My Drive/Lily Career/Work/Portfolio/Favorita Retails - Sale Forecast/Data_model/family_info.csv'
INTO TABLE family_info
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(family,category)
;

-- Update transaction_table 
ALTER TABLE transaction_table ADD promo_status VARCHAR(30);

UPDATE transaction_table 
SET promo_status = CASE 
	WHEN onpromotion > 0 THEN "promotion" 
    ELSE "non-promotion" 
END;

-- Import transaction_table 
CREATE TABLE transaction_summary (
	date_ DATE NOT NULL,
    store_nbr INT NOT NULL, 
    transaction_nb FLOAT NOT NULL, 
    PRIMARY KEY(date_, store_nbr)
    );

LOAD DATA LOCAL INFILE 'G:/My Drive/Lily Career/Work/Portfolio/Favorita Retails - Sale Forecast/Data_model/cleaned_transactions.csv'
INTO TABLE transaction_summary
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(date_, store_nbr, transaction_nb)
;


-- GENERAL DATASET EXPLORATION 
-- 1. Start date and end date of the dataset 
SELECT  MIN(date_) as earliest_date,
		MAX(date_) as latest_date
FROM transaction_table;

-- Date start and end in the data in oil table 
SELECT MIN(date) as earliest_date, 
	   MAX(date) as latest_date 
FROM oil;

-- 2. How many types of products are there? and the product list
SELECT COUNT(DISTINCT family) as number_froductfamily
FROM transaction_table;
-- List of product 
SELECT distinct family FROM transaction_table;

-- 3. Stores and locations 
-- How many stores,cities and states are there over the year? 
SELECT YEAR(date_) as year, 
	   COUNT(DISTINCT s.store_nbr) as number_of_stores,
	   COUNT(DISTINCT city) as number_of_city,
       COUNT(DISTINCT state) as number_of_state,
       COUNT(DISTINCT type) as number_store_type,
       COUNT(distinct cluster) as number_of_cluster 
FROM stores s 
JOIN transaction_table t 
ON s.store_nbr = t.store_nbr
WHERE sales > 0
GROUP BY 1 
ORDER BY 1;

-- State and City list 
SELECT DISTINCT state as state,
				city as city
FROM stores
ORDER BY 1;

-- Store type list 
SELECT DISTINCT type as type 
FROM stores
ORDER BY 1;

-- Stores and clusters 
SELECT cluster, 
	   GROUP_CONCAT(DISTINCT city ORDER BY city SEPARATOR ', ') as city,
       GROUP_CONCAT(DISTINCT state ORDER BY state SEPARATOR ', ') as state 
FROM stores 
GROUP BY 1;


-- 4. Holiday events 
-- Types of events documented 
SELECT DISTINCT type as type_of_event
FROM holidays;

-- How many local and regional holiday event are there in each year? 
SELECT YEAR(date) as year_events, 
	   COUNT(DISTINCT CASE WHEN locale = "Local" THEN description ELSE NULL END) as local_event,
       COUNT(DISTINCT CASE WHEN locale = "National" THEN description ELSE NULL END) as national_event, 
       COUNT(DISTINCT CASE WHEN locale = "Regional" THEN description ELSE NULL END) as regional_event,
       COUNT(DISTINCT description) as total_holiday
FROM holidays
WHERE type = "Holiday" 
GROUP BY 1
ORDER BY 1;

-- List of regional event 
SELECT distinct description as regional_event,
				GROUP_CONCAT(CASE WHEN YEAR(date) = "2012" THEN CONCAT(date) ELSE NULL END) AS date_in_2012,
                GROUP_CONCAT(CASE WHEN YEAR(date) = "2013" THEN CONCAT(date) ELSE NULL END) AS date_in_2013,
                GROUP_CONCAT(CASE WHEN YEAR(date) = "2014" THEN CONCAT(date) ELSE NULL END) AS date_in_2014,
                GROUP_CONCAT(CASE WHEN YEAR(date) = "2015" THEN CONCAT(date) ELSE NULL END) AS date_in_2015,
                GROUP_CONCAT(CASE WHEN YEAR(date) = "2016" THEN CONCAT(date) ELSE NULL END) AS date_in_2016,
                GROUP_CONCAT(CASE WHEN YEAR(date) = "2017" THEN CONCAT(date) ELSE NULL END) AS date_in_2017
FROM holidays 
WHERE locale = "Regional" AND type = "Holiday"
GROUP BY description;

-- List of national event 
SELECT distinct description as national_event,
				GROUP_CONCAT(CASE WHEN YEAR(date) = "2012" THEN CONCAT(date) ELSE NULL END) AS date_in_2012,
                GROUP_CONCAT(CASE WHEN YEAR(date) = "2013" THEN CONCAT(date) ELSE NULL END) AS date_in_2013,
                GROUP_CONCAT(CASE WHEN YEAR(date) = "2014" THEN CONCAT(date) ELSE NULL END) AS date_in_2014,
                GROUP_CONCAT(CASE WHEN YEAR(date) = "2015" THEN CONCAT(date) ELSE NULL END) AS date_in_2015,
                GROUP_CONCAT(CASE WHEN YEAR(date) = "2016" THEN CONCAT(date) ELSE NULL END) AS date_in_2016,
                GROUP_CONCAT(CASE WHEN YEAR(date) = "2017" THEN CONCAT(date) ELSE NULL END) AS date_in_2017
FROM holidays 
WHERE locale = "National" AND type = "Holiday"
GROUP BY description
;

-- How many events occured i a year ?
SELECT YEAR(date) as event_year,
	   COUNT(DISTINCT description) as event_name
FROM holidays 
WHERE type = "Event" 
GROUP BY 1 
ORDER BY 1;

-- Event list 
SELECT distinct description as event_name,
                GROUP_CONCAT(CASE WHEN YEAR(date) = "2013" THEN CONCAT(date) ELSE NULL END) AS date_in_2013,
                GROUP_CONCAT(CASE WHEN YEAR(date) = "2014" THEN CONCAT(date) ELSE NULL END) AS date_in_2014,
                GROUP_CONCAT(CASE WHEN YEAR(date) = "2015" THEN CONCAT(date) ELSE NULL END) AS date_in_2015,
                GROUP_CONCAT(CASE WHEN YEAR(date) = "2016" THEN CONCAT(date) ELSE NULL END) AS date_in_2016,
                GROUP_CONCAT(CASE WHEN YEAR(date) = "2017" THEN CONCAT(date) ELSE NULL END) AS date_in_2017
FROM holidays 
WHERE type = "Event" 
AND description in ("Dia de la Madre","Black Friday","Cyber Monday")
GROUP BY description
ORDER BY 5 ASC
;

-- Events which happen on the same data focus on Events and Holiday types 
WITH cte as (
SELECT date as event_date, 
		COUNT(description) as occurence
FROM holidays 
GROUP BY 1) 

SELECT date as event_date, 
	   locale, locale_name, type, description
FROM holidays 
WHERE date IN (SELECT event_date FROM cte WHERE occurence > 1) 
AND type IN ('Holiday','Event');


-- 2. BUSINESS METRIC AND QUESTIONS 
-- 2.1 Overall Sales Trend 
-- Yearly Sales 
SELECT Sale_year, Total_sale, 
	   LAG(Total_sale) OVER (ORDER BY Sale_year) as Last_year_sale, 
       CASE WHEN Total_sale IS NULL THEN "--" 
       ELSE ROUND(100*(Total_sale - LAG(Total_sale) OVER (ORDER BY Sale_year))/(LAG(Total_sale) OVER (ORDER BY Sale_year)),1) END AS Growth 
FROM 
	(SELECT YEAR(date_) as Sale_year,
			ROUND(SUM(sales),0) as Total_sale 
	 FROM transaction_table
     GROUP BY 1) as total_table 
GROUP BY 1
ORDER BY 1;

-- YTD Sales 
SELECT DATE_FORMAT(date_,'%Y-%m') as YearMonth,
	   ROUND(SUM(sales),0) as Total_sale 
FROM transaction_table 
WHERE 
	date_ between date_sub((SELECT MAX(date_) FROM transaction_table), INTERVAL 12 MONTH) and (SELECT MAX(date_) FROM transaction_table)
GROUP BY 1
ORDER BY 1;

-- MTD Sales 
SELECT date_ as sale_date, 
	   ROUND(SUM(sales),0) as sale 
FROM transaction_table 
WHERE 
	 date_ between date_sub((SELECT MAX(date_) FROM transaction_table), INTERVAL 1 MONTH) and (SELECT MAX(date_) FROM transaction_table)
GROUP BY 1
ORDER BY 1;

-- Monthly Sales Trend 
SELECT MONTH(date_) as month_sale, 
	   ROUND(SUM(CASE WHEN YEAR(date_) = "2013" THEN sales ELSE NULL END),0) as 2013_sale, 
       ROUND(SUM(CASE WHEN YEAR(date_) = "2014" THEN sales ELSE NULL END),0) as 2014_sale, 
       ROUND(SUM(CASE WHEN YEAR(date_) = "2015" THEN sales ELSE NULL END),0) as 2015_sale, 
       ROUND(SUM(CASE WHEN YEAR(date_) = "2016" THEN sales ELSE NULL END),0) as 2016_sale, 
       ROUND(SUM(CASE WHEN YEAR(date_) = "2017" THEN sales ELSE NULL END),0) as 2017_sale
FROM transaction_table 
GROUP BY 1
ORDER BY 1;

-- 2.1.2 Sale trend based on promotion activities 
WITH cte AS (
SELECT YEAR(date_) as sale_year, promo_status,
		ROUND(SUM(sales),0) as total_sales
FROM transaction_table 
GROUP BY 1,2 
ORDER BY 1,2)

SELECT *, 
	   ROUND(100*total_sales/SUM(total_sales) OVER (PARTITION BY sale_year),1) as contribution 
FROM cte 
;

-- 2.2 Sales by Locations (Stores, State, city)
-- Top 10 store with highest last 12 months sales 
SELECT s.store_nbr as store, state,city,
	   ROUND(SUM(sales),0) as total_sale,
       ROUND(100*SUM(sales)/
			(SELECT SUM(sales) FROM transaction_table 
			  WHERE date_ between DATE_SUB((SELECT MAX(date_) FROM transaction_table), INTERVAL 12 MONTH) AND (SELECT MAX(date_) FROM transaction_table))
              ,1) as contribution 
FROM stores as s
JOIN transaction_table as t 
ON s.store_nbr = t.store_nbr
WHERE date_ between DATE_SUB((SELECT MAX(date_) FROM transaction_table), INTERVAL 12 MONTH) AND (SELECT MAX(date_) FROM transaction_table)
GROUP BY 1,2,3
ORDER BY 4 DESC
LIMIT 10;

-- Top 10 store with lowest sale last 12 months sales 
SELECT s.store_nbr as store, state,city,
	   ROUND(SUM(sales),0) as total_sale,
       ROUND(100*SUM(sales)/
			(SELECT SUM(sales) FROM transaction_table 
			  WHERE date_ between DATE_SUB((SELECT MAX(date_) FROM transaction_table), INTERVAL 12 MONTH) AND (SELECT MAX(date_) FROM transaction_table))
              ,1) as contribution 
FROM stores as s
JOIN transaction_table as t 
ON s.store_nbr = t.store_nbr
WHERE date_ between DATE_SUB((SELECT MAX(date_) FROM transaction_table), INTERVAL 12 MONTH) AND (SELECT MAX(date_) FROM transaction_table)
GROUP BY 1,2,3
ORDER BY 4 ASC
LIMIT 10;

-- Sales by city last 12 months 
SELECT city, state,
	   COUNT(DISTINCT s.store_nbr) as nb_ofstores,
	   ROUND(SUM(sales),0) as total_sale,
       ROUND(100*SUM(sales)/
			(SELECT SUM(sales) FROM transaction_table 
			  WHERE date_ between DATE_SUB((SELECT MAX(date_) FROM transaction_table), INTERVAL 12 MONTH) AND (SELECT MAX(date_) FROM transaction_table))
              ,1) as contribution 
FROM stores as s 
JOIN transaction_table as t 
ON s.store_nbr = t.store_nbr
WHERE date_ between DATE_SUB((SELECT MAX(date_) FROM transaction_table), INTERVAL 12 MONTH) AND (SELECT MAX(date_) FROM transaction_table)
GROUP BY 1,2
ORDER BY 4 DESC;

-- Sales by state last 12 months 
SELECT state,
	   COUNT(DISTINCT s.store_nbr) as nb_ofstores,
	   ROUND(SUM(sales),0) as total_sale,
       ROUND(100*SUM(sales)/
			(SELECT SUM(sales) FROM transaction_table 
			  WHERE date_ between DATE_SUB((SELECT MAX(date_) FROM transaction_table), INTERVAL 12 MONTH) AND (SELECT MAX(date_) FROM transaction_table))
              ,1) as contribution 
FROM stores as s 
JOIN transaction_table as t 
ON s.store_nbr = t.store_nbr
WHERE date_ between DATE_SUB((SELECT MAX(date_) FROM transaction_table), INTERVAL 12 MONTH) AND (SELECT MAX(date_) FROM transaction_table)
GROUP BY 1
ORDER BY 3 DESC;

-- Average transactions per stores 
WITH cte as (
SELECT YEAR(date_) as year, 
	   COUNT(DISTINCT store_nbr) as nb_stores,
	   ROUND(SUM(transaction_nb) / COUNT(DISTINCT store_nbr),1) as avg_trans_per_store,
       SUM(transaction_nb) as total
FROM transaction_summary 
GROUP BY 1
ORDER BY 1) 

SELECT *,
	   ROUND(100*(avg_trans_per_store-LAG(avg_trans_per_store) OVER(ORDER BY year))/(LAG(avg_trans_per_store) OVER(ORDER BY year)),1) as growth_avg,
       ROUND(100*(total - LAG(total) OVER (ORDER BY year))/(LAG(total) OVER (ORDER BY year)),1) as growth_total
FROM cte 

-- 2.3 Sales by Products 
-- YTD sales by products family 
SELECT family, 
	   ROUND(SUM(sales),0) as total_YTD_sales,
       ROUND(100*SUM(sales)/(
							 SELECT SUM(sales) FROM transaction_table WHERE YEAR(date_) = '2017'),1) as contribution
FROM transaction_table 
WHERE YEAR(date_) = '2017'
GROUP BY 1
ORDER BY 2 DESC;

-- Last 12 months sale by product new category 
SELECT category, 
	  ROUND(SUM(sales),0) as total_sales, 
      ROUND(100*SUM(sales)/(
							SELECT SUM(sales)
							FROM transaction_table
                            WHERE date_ between DATE_SUB((SELECT MAX(date_) FROM transaction_table), INTERVAL 12 MONTH) AND (SELECT MAX(date_) FROM transaction_table)),
                            1) as contribution
FROM family_info f 
JOIN transaction_table t 
ON f.family = t.family 
WHERE date_ between DATE_SUB((SELECT MAX(date_) FROM transaction_table), INTERVAL 12 MONTH) AND (SELECT MAX(date_) FROM transaction_table)
GROUP BY 1
ORDER BY 2 DESC; 

-- Yearly sale by product category 
WITH cte as (
SELECT YEAR(date_) as sale_year, category,
		ROUND(SUM(sales),0) as total_sales
FROM family_info f 
JOIN transaction_table t 
ON f.family = t.family 
GROUP BY 1,2)

SELECT *,
	   ROUND(100*total_sales/(SUM(total_sales) OVER (PARTITION BY sale_year)),1) as contribution_year
FROM cte 
ORDER BY 1,3 desc;

-- Last 12 months sale by product family 
SELECT f.family, category, 
	  ROUND(SUM(sales),0) as total_sales, 
      ROUND(100*SUM(sales)/(
							SELECT SUM(sales)
							FROM transaction_table
                            WHERE date_ between DATE_SUB((SELECT MAX(date_) FROM transaction_table), INTERVAL 12 MONTH) AND (SELECT MAX(date_) FROM transaction_table)),
                            1) as contribution
FROM family_info f 
JOIN transaction_table t 
ON f.family = t.family 
WHERE date_ between DATE_SUB((SELECT MAX(date_) FROM transaction_table), INTERVAL 12 MONTH) AND (SELECT MAX(date_) FROM transaction_table)
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5; 	

-- Best products sales from top selling cities (Quito & Guayaquil) last 12 months
WITH cte as (
	SELECT city,t.family,
		   ROUND(SUM(sales),0) as total_sales,
           RANK() OVER (PARTITION BY city ORDER BY SUM(sales) DESC) as ranking 
	FROM family_info as f
    JOIN transaction_table as t ON t.family = f.family 
    JOIN stores as s ON s.store_nbr = t.store_nbr 
    WHERE date_ between DATE_SUB((SELECT MAX(date_) FROM transaction_table), INTERVAL 12 MONTH) AND (SELECT MAX(date_) FROM transaction_table) 
    AND city in ('Quito','Guayaquil')
    GROUP BY 1,2
    ORDER BY 1
)

SELECT family,
	   SUM(CASE WHEN city="Quito" THEN total_sales ELSE NULL END) as Quito_sale,
       SUM(CASE WHEN city="Guayaquil" THEN total_sales ELSE NULL END) as Guayaquil_sale
FROM cte 
WHERE ranking <= 10
GROUP BY 1
ORDER BY 2 desc;

-- Check calculation 
-- Sales from 15-08-2016 to 14-11-2016
(SELECT "Aug-16 to Nov-16" as Period, round(SUM(sales),0) as total
FROM transaction_table
WHERE date_ between '2016-08-16' AND '2016-11-14')
UNION 
(SELECT "Aug-16 to Feb-17" as Period, ROUND(SUM(sales),0) as total
FROM transaction_table
WHERE date_ between '2016-08-16' AND '2017-02-14')

