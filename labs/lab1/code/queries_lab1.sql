--ЗАДАНИЕ 1.1
CREATE VIEW  ETHNIC_COMPOSITION_INFO
  AS
  SELECT
  c.country_name AS "НАЗВАНИЕ_СТРАНЫ",
  e.ethnos_name AS "НАЗВАНИЕ_НАЦИОНАЛЬНОСТИ",
  ce.year_coloumn AS "ГОД",
  ce.ethnic_population AS "ЧИСЛЕННОСТЬ НАРОДНОСТЕЙ"
  FROM COUNTRIES c
  JOIN COUNTRIES_ETHNOSES  ce
    ON c.country_number = ce.country
  JOIN ETHNOSES E
    ON e.code = ce.ethnos
ORDER BY ce.country, ce.ethnos, ce.year_coloumn;

--ЗАДАНИЕ 1.2
SELECT 
  НАЗВАНИЕ_СТРАНЫ,
  COUNT(НАЗВАНИЕ_НАЦИОНАЛЬНОСТИ) AS "КОЛИЧЕСТВО_НАРОДНОСТЕЙ"
  FROM ETHNIC_COMPOSITION_INFO
  GROUP BY НАЗВАНИЕ_СТРАНЫ;

--ЗАДАНИЕ 2.1
CREATE VIEW  COUNTRIES_WCO
  AS
  SELECT
  country_number AS "НОМЕР",
  country_name AS "НАЗВАНИЕ_СТРАНЫ",
  continent AS "МАТЕРИК",
  capital AS "СТОЛИЦА",
  population AS "НАСЕЛЕНИЕ"
  FROM COUNTRIES
WHERE population < 1
WITH CHECK OPTION;

--ЗАДАНИЕ 2.2

--ЗАПРОС ДОБАВЛЕНИЯ
INSERT INTO COUNTRIES_WCO
    ("НАЗВАНИЕ_СТРАНЫ", "МАТЕРИК", "СТОЛИЦА", "НАСЕЛЕНИЕ")
VALUES
    ('Монако', 'Евразия', 'Монако-Вилль', 0.038);

--ЗАПРОС ОБНОВЛЕНИЯ
UPDATE COUNTRIES_WCO
  SET НАСЕЛЕНИЕ = 0.04
  WHERE НАЗВАНИЕ_СТРАНЫ = 'Монако';
  
--ЗАПРОС УДАЛЕНИЯ
DELETE FROM COUNTRIES_WCO
  WHERE НАЗВАНИЕ_СТРАНЫ = 'Монако';


--ЗАДАНИЕ 3
CREATE MATERIALIZED VIEW ETHNOSES_M
  AS 
  SELECT
    e.ethnos_name AS "НАЗВАНИЕ_НАЦИОНАЛЬНОСТИ",
    SUM(ce.ethnic_population) AS "ОБЩАЯ_ЧИСЛЕННОСТЬ_В_ТЫСЯЧАХ_ЗА_ПОСЛЕДНИЕ_3_ГОДА",
    COUNT(DISTINCT ce.country) AS "КОЛИЧЕСТВО_СТРАН",
    ROUND(AVG(ce.ethnic_population)) AS "СРЕДНЯЯ_ЧИСЛЕННОСТЬ_В_СТРАНЕ"
FROM ETHNOSES e
JOIN COUNTRIES_ETHNOSES ce
    ON e.code = ce.ethnos
WHERE ce.year_coloumn BETWEEN 2018 AND 2020
GROUP BY e.code, e.ethnos_name
ORDER BY e.ethnos_name;

--ЗАДАНИЕ 4
CREATE MATERIALIZED VIEW COUNTRIES_M
  AS
  SELECT
  c.country_name AS "НАЗВАНИЕ_СТРАНЫ",
  c.continent AS "МАТЕРИК",
  c.capital AS "СТОЛИЦА",
  COUNT(DISTINCT ce.ethnos) AS "КОЛИЧЕСТВО_НАЦИОНАЛЬНОСТЕЙ_В_СТРАНЕ",
  c.population AS "ОБЩАЯ_ЧИСЛЕННОСТЬ_НАСЕЛЕНИЯ"
FROM COUNTRIES c
  JOIN COUNTRIES_ETHNOSES ce
  ON c.country_number = ce.country
GROUP BY c.country_number
ORDER BY c.country_number;

--ЗАДАНИЕ 5
--ЗАПРОС, НА ОСНОВЕ КОТОРОГО БЫЛ СОЗДАН СКРИПТ ОБНОВЛЕНИЯ
SELECT schemaname, matviewname,  
matviewowner, ispopulated  
FROM pg_matviews  
WHERE schemaname NOT LIKE 'pg_%'; 

--СКРИПТ ОБНОВЛЕНИЯ
DO $$  --ВЫПОЛНИТЬ 1 РАЗ
DECLARE  --ОБЪЯВЛЕНИЕ ПЕРЕМЕННЫХ
    r RECORD;
BEGIN  --НАЧАЛО БЛОКА
    FOR r IN  --ДЛЯ ВСЕХ НАЙДЕННЫХ МАТЕРИАЛИЗОВАННЫХ ПРЕДСТАВЛЕНИЙ
        SELECT schemaname, matviewname
        FROM pg_matviews
        WHERE schemaname NOT LIKE 'pg_%'
    LOOP  --ЦИКЛ

        EXECUTE format(  --ОБНОВИТЬ
            'REFRESH MATERIALIZED VIEW %I.%I',
            r.schemaname,
            r.matviewname
        );
    END LOOP;  --КОНЕЦ ЦИКЛА
END $$;  --КОНЕЦ БЛОКА

--ЗАДАНИЕ 6
CREATE MATERIALIZED VIEW ETHNOSES_DYNAMICS AS
SELECT
    c.country_name AS "СТРАНА",
    e.ethnos_name AS "НАЦИОНАЛЬНОСТЬ",
    ce.year_coloumn AS "ГОД",
    ce.ethnic_population AS "ЧИСЛЕННОСТЬ_НАРОДНОСТИ"
FROM COUNTRIES_ETHNOSES ce
JOIN COUNTRIES c
    ON ce.country = c.country_number
JOIN ETHNOSES e
    ON ce.ethnos = e.code
ORDER BY c.country_number;