--ЗАДАНИЕ 1

WITH 
  population_avg AS (
	SELECT 
	  ce.ethnos AS ethnos_number, 
	  AVG(ce.ethnic_population) AS ethnos_avg
	FROM
      countries_ethnoses ce
	GROUP BY ce.ethnos
)

SELECT 
  c.country_name AS Страна, 
  ce.year_coloumn AS Год,
  e.ethnos_name AS Этнос
FROM countries c
JOIN countries_ethnoses ce
  ON c.country_number = ce.country
JOIN ethnoses e 
  ON ce.ethnos = e.code
JOIN population_avg pa
  ON pa.ethnos_number = e.code
WHERE ce.ethnic_population > pa.ethnos_avg

--ЗАДАНИЕ 2

WITH
  races_info AS (
    SELECT 
	  e.code AS ethnos_number,
	  e.ethnos_name,
	  e.race
	FROM ethnoses e
  ),

  countries_info AS (
    SELECT
	  ce.ethnos AS ethnos_number,
	  ce.year_coloumn,
	  ce.ethnic_population,
	  c.country_name
	FROM countries_ethnoses ce
	JOIN countries c
	ON c.country_number = ce.country
  )

SELECT
  ci.country_name AS Страна,
  ri.race AS Раса,
  SUM(ci.ethnic_population) AS Численность_представителей,
  ci.year_coloumn AS Год
FROM races_info ri
JOIN countries_info ci
ON ri.ethnos_number = ci.ethnos_number
GROUP BY
  ci.country_name,
  ri.race,
  ci.year_coloumn

--ЗАДАНИЕ 3

WITH RECURSIVE 
  ethnic_changes AS (
    SELECT 
	  c.country_name,
	  c.population,
	  e.ethnos_name,
	  ce.ethnic_population,
	  ce.year_coloumn,  
	  1 as year_cnt
	FROM countries c
	JOIN countries_ethnoses ce 
	ON c.country_number = ce.country
	JOIN ethnoses e
	ON e.code = ce.ethnos
	WHERE ce.year_coloumn = 2018
	
    UNION ALL
	
	SELECT 
	  c.country_name,
	  c.population,
	  e.ethnos_name,
	  ce.ethnic_population,
	  ce.year_coloumn,  
	  ec.year_cnt + 1 
    FROM countries c
	JOIN countries_ethnoses ce 
	ON c.country_number = ce.country
	JOIN ethnoses e
	ON e.code = ce.ethnos 
	JOIN ethnic_changes ec
	ON ce.year_coloumn - 2018 = ec.year_cnt
	WHERE ec.year_cnt < 3
)

SELECT
  country_name AS Страна,
  population AS Население_всего,
  ethnos_name AS Этнос,
  ethnic_population AS Количество_представителей,
  (ethnic_population / (population * 1000) * 100) AS Процент_этноса_,
  year_coloumn AS Год
FROM ethnic_changes
ORDER BY 
  population

--ЗАДАНИЕ 4

INSERT INTO COUNTRIES_ETHNOSES (country, ethnos, year_coloumn, ethnic_population)
VALUES 
    (1, 9, 2017, 2000)

CREATE TABLE countries_ethnoses_archive AS TABLE countries_ethnoses WITH NO DATA;

WITH
  data_to_delete AS ( 
    SELECT *
    FROM countries_ethnoses
    WHERE year_coloumn < 2018
),

  archive_before_delete AS ( 
    INSERT INTO countries_ethnoses_archive (country, ethnos, year_coloumn, ethnic_population) 
    SELECT * 
    FROM data_to_delete 
    RETURNING
	  country, 
	  ethnos, 
	  year_coloumn, 
	  ethnic_population
)

DELETE  
FROM countries_ethnoses 
  WHERE EXISTS (
    SELECT * 
	FROM data_to_delete  
    WHERE countries_ethnoses.country = data_to_delete.country
    AND countries_ethnoses.ethnos = data_to_delete.ethnos 
    AND countries_ethnoses.year_coloumn = data_to_delete.year_coloumn
	AND countries_ethnoses.ethnic_population = data_to_delete.ethnic_population
	) 
RETURNING
  country, 
  ethnos, 
  year_coloumn,
  ethnic_population;