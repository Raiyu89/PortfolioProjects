# US Household Income Data Cleaning

SELECT * 
FROM us_project.us_household_income;

SELECT * 
FROM us_project.us_household_income_statistics;

ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

SELECT COUNT(id) 
FROM us_project.us_household_income;

SELECT COUNT(id) 
FROM us_project.us_household_income_statistics;

SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

SELECT *
FROM (
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM us_project.us_household_income
) duplicates
WHERE row_num > 1
;


DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM us_project.us_household_income
		) duplicates
	WHERE row_num > 1)
;

SELECT State_Name, COUNT(State_Name)
FROM us_project.us_household_income
GROUP BY State_Name
;

SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY 1
;

UPDATE us_project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE us_project.us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

SELECT *
FROM us_project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1
;

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont';

SELECT *
FROM us_project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1
;

SELECT Type, COUNT(Type)
FROM us_project.us_household_income
GROUP BY Type
#ORDER BY 1
;

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

SELECT ALand, AWater
FROM us_project.us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL
;

SELECT DISTINCT AWater
FROM us_project.us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL
;

SELECT ALand, AWater
FROM us_project.us_household_income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL) # Breaking it up
AND (ALand = 0 OR ALand = '' OR ALand IS NULL) # Breaking it up
;

SELECT ALand, AWater
FROM us_project.us_household_income
WHERE (ALand = 0 OR ALand = '' OR ALand IS NULL) 
;