/*
Motor Vehicle Thefts Analysis
*/

-- 1. Number of vehicles stolen each year

SELECT COUNT(*) AS vehicles_stolen, YEAR(date_stolen) AS Year
FROM stolen_vehicles
GROUP BY Year;

-- 2. Number of vehicles stolen each month

SELECT COUNT(*) AS vehicles_stolen, MONTH(date_stolen) AS Month
FROM stolen_vehicles
GROUP BY Month;

-- 3. Number of vehicles stolen each day of the week

SELECT COUNT(*) AS vehicles_stolen, DAYOFWEEK(date_stolen) AS day_of_week
FROM stolen_vehicles
GROUP BY day_of_week;

-- 4. Number of vehicles stolen each day of the week (Sunday, Monday, Tuesday, etc.)

SELECT COUNT(*) AS vehicles_stolen, 
		(CASE WHEN DAYOFWEEK(date_stolen) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(date_stolen) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(date_stolen) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(date_stolen) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(date_stolen) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(date_stolen) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(date_stolen) = 1 THEN 'Saturday'
        ELSE 'None' END) AS day_of_week
FROM stolen_vehicles
GROUP BY day_of_week;

-- 5. Type of vehicles that are most often and least often stolen

SELECT * FROM stolen_vehicles;

SELECT vehicle_type, COUNT(*) AS stolen_vehicles
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY stolen_vehicles;

-- 6. Average age of the cars that are stolen for each vehicle types

SELECT DISTINCT vehicle_type, AVG(YEAR(date_stolen) - model_year) AS Age
FROM stolen_vehicles
GROUP BY vehicle_type;

-- 7. Percent of vehicles stolen that are luxury versus standard for each vehicle types

SELECT * FROM make_details;

WITH lux_standard AS (SELECT sv.vehicle_type, CASE WHEN md.make_type = 'Luxury' THEN 1 ELSE 0 END AS luxury
FROM stolen_vehicles sv
LEFT JOIN make_details md ON sv.make_id = md.make_id)

SELECT vehicle_type, SUM(luxury)/COUNT(luxury)*100 AS pct_lux
FROM lux_standard
GROUP BY vehicle_type
ORDER BY pct_lux DESC;

-- 8. Create a table where the rows represent the top 10 vehicle types, the columns represent the top 7 vehicle colors (plus 1 column for all other colors) and the values are the number of vehicles stolen

SELECT DISTINCT color FROM stolen_vehicles;

SELECT color, COUNT(vehicle_id) AS num_vehicles
FROM stolen_vehicles
GROUP BY color
ORDER BY num_vehicles DESC;
/*'Silver', '1272'
'White', '934'
'Black', '589'
'Blue', '512'
'Red', '390'
'Grey', '378'
'Green', '224'
'Other
*/

SELECT vehicle_type, COUNT(vehicle_id) AS num_vehicles,
	SUM(CASE WHEN color = 'Silver' THEN 1 ELSE 0 END) AS silver,
    SUM(CASE WHEN color = 'White' THEN 1 ELSE 0 END) AS white,
    SUM(CASE WHEN color = 'Black' THEN 1 ELSE 0 END) AS black,
    SUM(CASE WHEN color = 'Blue' THEN 1 ELSE 0 END) AS blue,
    SUM(CASE WHEN color = 'Red' THEN 1 ELSE 0 END) AS red,
    SUM(CASE WHEN color = 'Grey' THEN 1 ELSE 0 END) AS grey,
    SUM(CASE WHEN color = 'Green' THEN 1 ELSE 0 END) AS green,
    SUM(CASE WHEN color IN ('Gold', 'Brown', 'Yellow', 'Orange', 'Purple', 'Cream', 'Pink') THEN 1 ELSE 0 END) AS other
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_vehicles DESC
LIMIT 10;

-- 9. Number of vehicles that were stolen in each region

SELECT l.region, COUNT(sv.vehicle_id) AS num_vehicles 
FROM stolen_vehicles sv
LEFT JOIN locations l 
ON sv.location_id = l.location_id
GROUP BY l.region
ORDER BY num_vehicles;

-- 10. Number of vehicles that were stolen in each region with the population and density statistics for each region

SELECT l.region, COUNT(sv.vehicle_id) AS num_vehicles, l.population, l.density 
FROM stolen_vehicles sv
LEFT JOIN locations l 
ON sv.location_id = l.location_id
GROUP BY l.region, l.population, l.density
ORDER BY num_vehicles;

-- 11. Do the types of vehicles stolen in the three most dense regions differ from the three least dense regions?

SELECT l.region, COUNT(sv.vehicle_id) AS num_vehicles, l.population, l.density 
FROM stolen_vehicles sv
LEFT JOIN locations l 
ON sv.location_id = l.location_id
GROUP BY l.region, l.population, l.density
ORDER BY density DESC;
/*Auckland
Nelson
Wellington*/
SELECT l.region, COUNT(sv.vehicle_id) AS num_vehicles, l.population, l.density 
FROM stolen_vehicles sv
LEFT JOIN locations l 
ON sv.location_id = l.location_id
GROUP BY l.region, l.population, l.density
ORDER BY density;
/*Southland
Gisborne
Otago*/

(SELECT DISTINCT 'high_density', sv.vehicle_type, COUNT(sv.vehicle_id) AS num_vehicles
FROM stolen_vehicles sv
LEFT JOIN locations l 
ON sv.location_id = l.location_id
WHERE region IN ('Auckland', 'Nelson', 'Wellington')
GROUP BY sv.vehicle_type
ORDER BY num_vehicles DESC
LIMIT 5)

UNION

(SELECT DISTINCT 'low_density', sv.vehicle_type, COUNT(sv.vehicle_id) AS num_vehicles
FROM stolen_vehicles sv
LEFT JOIN locations l 
ON sv.location_id = l.location_id
WHERE region IN ('Southland', 'Gisborne', 'Otago')
GROUP BY sv.vehicle_type
ORDER BY num_vehicles DESC
LIMIT 5);

-- 12. Total vehicles were stolen in the most dense region

SELECT l.region, COUNT(sv.vehicle_id) AS num_vehicles, l.density 
FROM stolen_vehicles sv
LEFT JOIN locations l 
ON sv.location_id = l.location_id
GROUP BY l.region, l.density
ORDER BY density DESC
LIMIT 1; -- 1638