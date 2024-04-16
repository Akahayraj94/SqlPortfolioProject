Select *
From Covid_deaths
Order by 3,4
UPDATE Covid_deaths set new_cases= NULL where new_cases='';
UPDATE Covid_deaths set total_cases= NULL where total_cases='';
UPDATE Covid_deaths set total_deaths= NULL where total_deaths='';

ALTER TABLE Covid_deaths
ALTER COLUMN date DATE;

ALTER TABLE Covid_deaths
ALTER COLUMN total_cases decimal(20,2);

ALTER TABLE Covid_deaths
ALTER COLUMN total_deaths decimal(20,2);

ALTER TABLE Covid_deaths
ALTER COLUMN new_deaths decimal(20,2);

ALTER TABLE Covid_deaths
ALTER COLUMN new_cases decimal(20,2);

Select *
From Covid_vaccinations
Order by 3,4

-- selecting the data that we are going to use

Select location, date, total_cases, new_cases, total_deaths, population
From Covid_deaths
Order by 1,2

--looking at total cases vs total deaths
-- shows chances of a person dying by covid country wise

Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as Deaths_percentage 
From Covid_deaths
Where location like '%india%' 
Order by 1,2

-- total cases vs population
-- shows wat % of population got covid

Select location, date, population, total_cases,(total_cases/population)*100 as cases_percentage 
From Covid_deaths
where location <> 'world'
and location <> 'high income'
and location <> 'upper middle income'
and location <> 'europe'
and location <> 'north america'
and location <> 'asia'
and location <> 'south america'
and location <> 'lower middle income'
and location <> 'european union'
--Where location like '%india%' 
Order by 1,2

-- looking at countries with highest infection rate compared to population

Select location, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectionPercentage 
From Covid_deaths
where location <> 'world'
and location <> 'high income'
and location <> 'upper middle income'
and location <> 'europe'
and location <> 'north america'
and location <> 'asia'
and location <> 'south america'
and location <> 'lower middle income'
and location <> 'european union'
Group by location, population
Order by InfectionPercentage desc

-- showing countries with highest death count per population

Select location, MAX(cast(total_deaths as int)) as HighestDeathCount, MAX((total_deaths/population))*100 as DeathsPercentage 
From Covid_deaths
where location <> 'world'
and location <> 'high income'
and location <> 'upper middle income'
and location <> 'europe'
and location <> 'north america'
and location <> 'asia'
and location <> 'south america'
and location <> 'lower middle income'
and location <> 'european union'
Group by location
Order by HighestDeathCount desc

-- comparing continents
Select continent, MAX(cast(total_deaths as int)) as HighestDeathCount, MAX((total_deaths/population))*100 as DeathPercentage 
From Covid_deaths
where NOT continent = ''
Group by continent
Order by HighestDeathCount desc

-- global numbers
--date wise
Select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths
, SUM(new_deaths)/nullif(sum(cast(new_cases as int)),0)*100 as DeathPercentage
From Covid_deaths
Group by date
order by 1,2

--overall total figure
Select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths
, SUM(new_deaths)/nullif(sum(new_cases),0)*100 as DeathPercentage
From Covid_deaths
order by 1,2

-- total population vs vaccinations

Select*
FROM Covid_deaths as dea
Join Covid_vaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date

Select dea.continent, dea.location, dea.date, population, new_vaccinations,
SUM(Cast(new_vaccinations as bigint)) over (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
FROM Covid_deaths as dea
Join Covid_vaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
order by 1,2,3

