/*Managing The World*/
use world;
DESCRIBE city;
DESCRIBE country;
DESCRIBE countrylanguage;

ALTER TABLE city
ADD COLUMN is_population_large BOOLEAN DEFAULT NULL;
UPDATE city 
SET is_population_large = (Population > 1000000);

ALTER TABLE Country 
ADD COLUMN region_code CHAR(3) DEFAULT 'NA';

ALTER TABLE City
ADD CONSTRAINT chk_population_non_negative
CHECK (population >= 0);

SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE table_name = 'CITY';

ALTER TABLE country
ADD CONSTRAINT unique_country_code UNIQUE (code);
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE table_name = 'country';

CREATE INDEX idx_city_name 
ON city(name);
SHOW INDEX FROM city;
EXPLAIN SELECT * FROM City WHERE name = 'New York';

CREATE VIEW high_population_cities AS
SELECT name AS city_name, countrycode, population
FROM city WHERE population > 1000000;
SELECT * FROM high_population_cities;

CREATE VIEW countries_with_languages AS
SELECT country.name AS country_name, 
countrylanguage.language AS spoken_language
FROM country JOIN countrylanguage ON country.code = countrylanguage.countrycode
WHERE countrylanguage.language != 'English';
SELECT * FROM countries_with_languages;
