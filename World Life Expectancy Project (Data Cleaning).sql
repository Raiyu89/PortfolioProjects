# World Life Expectancy Project (Data Cleaning)

SELECT * 
FROM world_life_expectancy
;

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

SELECT *
FROM (
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM world_life_expectancy
    ) AS Row_table
WHERE Row_Num > 1
;

DELETE FROM world_life_expectancy
WHERE
	Row_ID IN (
    SELECT Row_ID
FROM (
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM world_life_expectancy
    ) AS Row_table
WHERE Row_Num > 1
)
;

SELECT * 
FROM world_life_expectancy
WHERE Status = ''
;

SELECT * 
FROM world_life_expectancy
WHERE Status IS NULL
;

SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

# We are updating this table (below). We are setting the status equal to developing where the country
# is in this list right here (above), which is these are the ones that have the status equal to 
# developing. So we are just setting it to developing if it is developing. So if there's any that
# are blank, they should be populated. 

UPDATE world_life_expectancy
SET status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country)
				FROM world_life_expectancy
				WHERE Status = 'Developing');
			
# We are actually joining two itself in here. Now we could not say this before using just the world
# life expectancy because we can't say take it from here but not here. We can't say take it from 
# where it's blank but also not blank. It would basically cancel itself out. But when we join right
# here to the table again, we can now filter based off that other table and that is exactly what 
# we are doing. So we are going to set it to developing where it's blank in this table (t1) but not blank
# in this table (t2) where the country is still the same. So for Afghanistan, if Afghanistan is equal
# to Afghanistan right there (t1.Country = t2.Country), then if this one's blank in this table 
# (t1.Country) and this one is not blank in this table (t2.Country) and it's developing, we can set
# this to developing as well. 

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country 
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

SELECT * 
FROM world_life_expectancy
WHERE Country = 'United States of America'
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country 
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

SELECT * 
FROM world_life_expectancy
#WHERE `life expectancy` = ''
;

SELECT Country, Year, `life expectancy` 
FROM world_life_expectancy
WHERE `life expectancy` = ''
;

SELECT t1.Country, t1.Year, t1.`life expectancy`, 
t2.Country, t2.Year, t2.`life expectancy`,
t3.Country, t3.Year, t3.`life expectancy`,  
ROUND((t2.`life expectancy` + t3.`life expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.year = t3.year + 1
WHERE t1.`life expectancy` = ''
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.year = t3.year + 1
SET t1.`life expectancy` = ROUND((t2.`life expectancy` + t3.`life expectancy`)/2,1)
WHERE t1.`life expectancy` = ''
;

SELECT *
FROM world_life_expectancy
#WHERE `life expectancy` = ''
;