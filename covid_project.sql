USE PortfolioProject;
 
SELECT
	location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths
ORDER BY location, date;

-- Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract covid in China before 2021-04-30

SELECT
	location, 
    date, 
    total_cases, 
    total_deaths, 
    (total_deaths/total_cases) * 100 AS death_percentage
FROM covid_deaths
WHERE location like '%China%'
ORDER BY location, date;

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid in China before 2020-4-30

SELECT
	location, 
    date, 
    total_cases, 
    population,
    total_deaths, 
    (total_cases/population) * 100 AS infection_percentage
FROM covid_deaths
WHERE location like '%China%'
ORDER BY location, date;

-- Countries with the Highest Infection Rate compared to Population

SELECT
	location,
    population,
    MAX(total_cases) AS highest_infection_count,
    MAX((total_cases/population)) * 100 AS infection_percentage
FROM covid_deaths
GROUP BY location, population
ORDER BY infection_percentage DESC;

-- Countries with the Highest Death Count per Population

SELECT
	location,
    MAX(total_deaths) AS highest_death_count
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY highest_death_count DESC;

-- BREAKING THINGS DOWN BY CONTINENT

-- Continents with the Highest Death Count per Population

SELECT
	location,
    MAX(total_deaths) AS highest_death_count
FROM covid_deaths
WHERE continent IS NULL
GROUP BY location
ORDER BY highest_death_count DESC;

--  GLOBAL NUMBERS

SELECT
	date, 
    SUM(new_cases) AS total_cases, 
    SUM(new_deaths) AS total_deaths, 
    (SUM(new_deaths)/SUM(new_cases)) * 100 AS death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;


-- Total Population vs Vaccination WITH CTE

WITH pop_vs_vac AS(
	SELECT
		cd.continent,
		cv.location,
		cd.date,
		cd.population,
		cv.new_vaccinations,
		SUM(cv.new_vaccinations) OVER
		(PARTITION BY cd.location
		ORDER BY cd.location, cd.date) AS rolling_people_vaccinated
	FROM covid_deaths cd
    JOIN covid_vaccinations cv USING(location, date)
	WHERE cd.continent IS NOT NULL
	ORDER BY 2, 3
)

SELECT *, (rolling_people_vaccinated/population) * 100
FROM pop_vs_vac;

-- Creating View to Store Data for Later Visualization

CREATE VIEW percent_population_vaccinated AS
SELECT
		cd.continent,
		cv.location,
		cd.date,
		cd.population,
		cv.new_vaccinations,
		SUM(cv.new_vaccinations) OVER
		(PARTITION BY cd.location
		ORDER BY cd.location, cd.date) AS rolling_people_vaccinated
	FROM covid_deaths cd
    JOIN covid_vaccinations cv USING(location, date)
	WHERE cd.continent IS NOT NULL
	ORDER BY 2, 3




