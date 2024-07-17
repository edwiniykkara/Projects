/*
US Baby Name Analysis (UBN) - Popularity Across Regions - Comparison
*/

/*
Skills Used: Window Functions, Common Table Expressions (CTEs), Subqueries, Conditional Logic (CASE Statements), Joining Data, Union Operations
*/

-- 1. Number of babies born in each of the six regions (NOTE: The state of MI should be in the Midwest region)
SELECT * FROM regions;

WITH clean_regions AS (SELECT State,
		CASE WHEN Region = 'New England' THEN 'New_England' ELSE Region END AS clean_region
FROM regions
UNION
SELECT 'MI' AS State, 'Midwest' AS Region)

SELECT clean_region, SUM(Births) AS num_babies
FROM names n 
LEFT JOIN clean_regions cr
	ON n.State = cr.State
GROUP BY clean_region;

-- 2. Three most popular girl names and 3 most popular boy names within each region

SELECT * FROM

(WITH babies_by_region AS (
    WITH clean_regions AS (SELECT State,
			CASE WHEN Region = 'New England' THEN 'New_England' ELSE Region END AS clean_region
	FROM regions
	UNION
	SELECT 'MI' AS State, 'Midwest' AS Region)

	SELECT cr.clean_region, n.Gender, n.Name, SUM(n.Births) AS num_babies
	FROM names n 
	LEFT JOIN clean_regions cr
		ON n.State = cr.State
	GROUP BY cr.clean_region, n.Gender, n.Name)
    
SELECT clean_region, Gender, Name,
		ROW_NUMBER() OVER (PARTITION BY clean_region, Gender ORDER BY num_babies DESC) AS popularity
FROM babies_by_region) AS region_popularity

WHERE popularity < 4
