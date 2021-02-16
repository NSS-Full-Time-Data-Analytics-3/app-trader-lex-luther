CREATE TABLE data_table as (SELECT distinct(asa.name) as app_name,
       asa.price as asa_price,
	   psa.price as psa_price,
	   asa.rating as asa_rating,
	   psa.rating as psa_rating,
	   asa.primary_genre as genre
FROM app_store_apps as asa
INNER JOIN play_store_apps as psa ON asa.name = psa.name
WHERE asa.rating >= 4.5
AND psa.rating >= 4.5
ORDER BY asa.rating desc,
         psa.rating desc
LIMIT 100);	 				
	   
	   

