-- Exploratory Data Analysis on Covid Data set


-- Selecting specific data to focus on.
SELECT 
	location, date, total_cases, new_cases, total_deaths, population
FROM 
	[Portfolio Project]..Covid_Death_Table
WHERE 
	continent IS NOT NULL
ORDER BY 
	1,2


-- COVID death-rate to understand the probability of death if one test positive covid.
SELECT
	location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_rate
FROM
	[Portfolio Project]..Covid_Death_Table
WHERE continent IS NOT NULL AND
	date like '%India%'
ORDER BY 
	1,2


--What percentage of population got COVID
SELECT 
	location, date, total_cases, population, (total_cases/population)*100 AS percentage_total_caseS
FROM
	[Portfolio Project]..Covid_Death_Table
WHERE continent IS NOT NULL AND 
	date = '2020-10-14'
ORDER BY
	5 DESC 


-- To see which location has the highiest Percentages of cases.
SELECT 
	location, MAX(total_cases) AS Max_cases, population, MAX((total_cases/population))*100 AS percentage_total_caseS
FROM
	[Portfolio Project]..Covid_Death_Table
WHERE 
	continent IS NOT NULL
GROUP BY 
	location, population
ORDER BY 
	4 DESC


-- Locations with highest death rate.
SELECT 
	location, MAX(CAST(total_deaths AS float)) AS Max_deaths, population, MAX((CAST(total_deaths AS float)/population))*100 AS percentage_total_deaths
FROM
	[Portfolio Project]..Covid_Death_Table
GROUP BY 
	location, population
ORDER BY 
	4 DESC


--Location with highest death counts.
SELECT 
	location, MAX(CAST(total_deaths AS float)) AS Max_deaths
FROM
	[Portfolio Project]..Covid_Death_Table
WHERE 
	continent IS NOT NULL
GROUP BY 
	location, population
ORDER BY 
	2 DESC


-- Death by Continents 
SELECT 
	continent, MAX(CAST(total_deaths AS float)) AS Max_deaths
FROM	
	[Portfolio Project]..Covid_Death_Table
Where continent IS NOT NULL
GROUP BY
	continent
ORDER BY
	2 DESC
	

-- WORLD WIDE STATS

-- Date wise cases and deaths
SELECT 
	date,SUM(CAST(new_deaths AS int))AS total_deaths, SUM(new_cases) as total_cases
FROM	
	[Portfolio Project]..Covid_Death_Table
GROUP BY
	date
ORDER BY
	1

-- Total cases and deaths
SELECT 
	SUM(CAST(new_deaths AS int))AS Total_deaths, SUM(new_cases) as Total_cases, (SUM(CAST(new_deaths AS int))/ SUM(new_cases) )*100 AS death_percentage
FROM	
	[Portfolio Project]..Covid_Death_Table


-- running total of vaccinactions
-- Creating a VIEW to use data for later

CREATE VIEW rolling_population_vacination AS
SELECT 
	dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CAST(vac.new_vaccinations AS bigint))	
		OVER 
			(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_Vaccination_Total
FROM 
	[Portfolio Project]..Covid_Death_Table dea
	JOIN
	[Portfolio Project]..Covid_Vactination_Table vac
	ON  
		dea.location=vac.location AND dea.date=vac.date
WHERE 
	dea.continent IS NOT NULL	   

SELECT * 
FROM rolling_population_vacination