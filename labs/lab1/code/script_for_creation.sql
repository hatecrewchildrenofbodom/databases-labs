--CREATE DATABASE ethnic_composition;

CREATE TABLE COUNTRIES
(country_number serial PRIMARY KEY,
country_name char(20) NOT NULL,
continent char(20) NOT NULL,
capital char(20),
population real
);

CREATE TABLE ETHNOSES
(code serial PRIMARY KEY,
ethnos_name char(20),
race char(20),
ethnos_language char(20)
);

CREATE TABLE COUNTRIES_ETHNOSES
(country int,
ethnos int,
year_coloumn int CHECK (year_coloumn BETWEEN 2018 AND 2020),
ethnic_population real,

CONSTRAINT PK_COUNTRIES_ETHNOSES
PRIMARY KEY (country, ethnos, year_coloumn),
CONSTRAINT FK_COUNTRIES_ETHNOSES_COUNTRY
FOREIGN KEY (country) REFERENCES COUNTRIES(country_number),
CONSTRAINT FK_COUNTRIES_ETHNOSES_ETHNOS
FOREIGN KEY (ethnos) REFERENCES ETHNOSES(code)
);

INSERT INTO COUNTRIES (country_name, continent, capital, population)
VALUES
('Россия', 'Евразия', 'Москва', 141),
('Украина', 'Евразия', 'Киев', 43),
('Эстония', 'Евразия', NULL, NULL),
('Беларусь', 'Евразия', 'Минск', 9),
('Нигерия', 'Африка', 'Лагос', 80),
('Алжир', 'Африка', 'Алжир', 1),
('Египет', 'Африка', 'Каир', 38),
('Канада', 'Северная Америка', 'Оттава', 23),
('Монголия', 'Евразия', 'Улан-Батор', 1.5),
('Китай', 'Евразия', 'Пекин', 1000);

INSERT INTO ETHNOSES (code, ethnos_name, race, ethnos_language)
VALUES
(1, 'Русские', 'Европеоидная', 'Русский'),
(2, 'Украинцы', 'Европеоидная', 'Украинский'),
(3, 'Эстонцы', 'Европеоидная', 'Эстонский'),
(4, 'Белорусы', 'Европеоидная', 'Белорусский'),
(5, 'Йоруба', 'Негроидная', 'Йоруба'),
(6, 'Алжирцы', 'Европеоидная', 'Арабский'),
(7, 'Египтяне', 'Европеоидная', 'Арабский'),
(8, 'Канадцы', 'Европеоидная', 'Английский'),
(9, 'Монголы', 'Монголоидная', 'Монгольский'),
(10, 'Китайцы', 'Монголоидная', 'Китайский');

INSERT INTO COUNTRIES_ETHNOSES (country, ethnos, year_coloumn, ethnic_population)
VALUES 
    (1, 1, 2019, 94000),
    (1, 6, 2020, 0.9),
    (1, 7, 2019, 1000),
    (1, 9, 2019, 900),
    (1, 9, 2020, 2000),
    (1, 10, 2019, 20000),
    (2, 1, 2020, 20000),
    (2, 3, 2019, 2),
    (3, 1, 2019, 300),
    (3, 9, 2020, 0.3),
    (4, 2, 2020, 2000),
    (5, 5, 2020, 60000),
    (5, 6, 2019, 10000),
    (6, 8, 2018, 1),
    (7, 6, 2020, 35000),
    (7, 10, 2019, 2000),
    (8, 4, 2020, 1),
    (8, 9, 2018, 1000),
    (9, 9, 2019, 1),
    (10, 7, 2019, 1);