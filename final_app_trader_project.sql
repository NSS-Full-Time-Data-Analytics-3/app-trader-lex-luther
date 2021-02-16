SELECT distinct(asa.name) as app_name,
       asa.price as asa_price,
	   psa.price as psa_price,
	   asa.rating as asa_rating,
	   psa.rating as psa_rating,
	   asa.primary_genre as genre
FROM app_store_apps as asa
INNER JOIN play_store_apps as psa ON asa.name = psa.name
WHERE asa.rating >= 4.5
AND psa.rating >= 4.5
ORDER BY asa.price,
		 psa.price,
		 asa.rating desc,
         psa.rating desc;
		 
SELECT COUNT(*)
FROM app_store_apps;
--
SELECT COUNT(*)
FROM play_store_apps
--
SELECT *
FROM app_store_apps
LIMIT 5;
--
SELECT *
FROM play_store_apps
LIMIT 5;
--
​
-- DELIVERABLES
​
--- Finds names of apps in both app stores.
​
SELECT DISTINCT name
FROM app_store_apps
INTERSECT
SELECT DISTINCT name
FROM play_store_apps
ORDER BY name;
--- There are a total of 328 apps returned
​
--- Shows distinct genres in both stores. There are 23 total
​
SELECT DISTINCT(asa.primary_genre)
FROM app_store_apps as asa
LEFT JOIN play_store_apps as psa
ON psa.name = asa.name
​
-- INNER JOIN play with app since app and creates table as data_table
​
CREATE TABLE data_table as (SELECT distinct(asa.name) as app_name,
       CAST(asa.price as money) as asa_price,
	   CAST(psa.price as money) as psa_price,			
	   asa.rating as asa_rating,
	   psa.rating as psa_rating,
	   asa.primary_genre as genre
FROM app_store_apps as asa
INNER JOIN play_store_apps as psa ON asa.name = psa.name
WHERE asa.rating >= 4.5
AND psa.rating >= 4.5
ORDER BY asa.rating desc,
         psa.rating desc
LIMIT 30)
​
--- Adding aggregate columns to table to calculate average rating, cost of purchase, total net income, and total long term value
​
ALTER TABLE data_table ADD avg_rating decimal;
UPDATE data_table SET avg_rating = CASE
	WHEN psa_rating < 4.8 THEN 4.5
	WHEN psa_rating >= 4.8 THEN 5
	ELSE 0
	END;
​
ALTER TABLE data_table ADD asa_rev money;
UPDATE data_table SET asa_rev = CASE
	WHEN asa_rating = 5 THEN 528000
	WHEN asa_rating <> 5 THEN 480000 
	ELSE 0
	END;
​
ALTER TABLE data_table ADD psa_rev money;
UPDATE data_table SET psa_rev = CASE
	WHEN avg_rating = 5 THEN 528000
	WHEN avg_rating <> 5 THEN 480000
	ELSE 0
	END;
​
ALTER TABLE data_table ADD total_net_income money;
UPDATE data_table SET total_net_income = (asa_rev + psa_rev);
​
ALTER TABLE data_table ADD cost_to_purchase_rights money;
UPDATE data_table SET cost_to_purchase_rights = CASE
	WHEN asa_price * 10000 < '1' THEN 10000 * 2
	WHEN asa_price * 10000 > '1' THEN CAST(asa_price as decimal) * 10000 * 2
	ELSE 0
	END;
​
ALTER TABLE data_table ADD total_LTV money;
UPDATE data_table SET total_LTV = (total_net_income - cost_to_purchase_rights);
​
​
--- From creadted table with data we want to analyze pull 30 selections to narrow our top 10
SELECT *
FROM data_table
ORDER BY total_ltv DESC
LIMIT 30
​
SELECT genre, SUM(total_ltv)
FROM data_table
GROUP BY genre
ORDER BY SUM(total_ltv) DESC
LIMIT 30
​
--- Genre Games seems to be most valuable
		 
		 
		