use world;
SHOW TABLES;
SELECT country.name, countrylanguage.language
FROM country	
JOIN countrylanguage ON country.code = countrylanguage.countrycode;

SELECT city.name, city.population
FROM city
JOIN country ON city.countrycode = country.code
WHERE country.name = 'Germany';

SELECT country.name, country.surfacearea
FROM country
ORDER BY surfacearea ASC
LIMIT 5;

SELECT country.name, country.population
FROM country
WHERE population>=50000000
ORDER BY population desc;

SELECT country.continent, AVG(LifeExpectancy) 
From country 
Group by Continent;

SELECT country.region, SUM(population) AS total_population
FROM country
GROUP BY region;

SELECT country.name, COUNT(city.id) AS city_count
FROM city
JOIN country ON city.countrycode = country.code
GROUP BY country.name
ORDER BY city_count DESC;

-- Cuando haya un "JOIN" se deben de cambiar los nombres en "SELECT" con "AS"--

SELECT city.name AS city_name, country.name AS country_name, country.surfacearea
FROM city
JOIN country ON city.countrycode = country.code
ORDER BY country.surfacearea DESC
LIMIT 10;