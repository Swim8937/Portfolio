/*
Goal: Analyzing covid-19 death percentage, infection rate per country, and so on.

Methods: Converting Data Types, Joins, Windows Functions, CTE, ifnull, Temp Tables, Aggregate Functions

Data resource: Kaggle
*/


-- Convert date datatype to datetime
alter table PortfolioProject
modify date datetime



-- Looking at Infection Rate
select location, ifnull(max(total_cases),0) total_cases, population, ifnull(round(max(total_cases) / population, 2),0) Infection_Rate
from PortfolioProject.coviddeaths
Where continent is not null
group by location, population
order by Infection_Rate desc;



-- Looking at Death Rate
select continent, location, date, total_cases, total_deaths, round(total_deaths/total_cases, 2) Death_Rate
from PortfolioProject.coviddeaths
Where continent is not null
order by continent, location;



-- Looking at the Highest Infection Rate in the period
select continent, location, max(total_cases) total_cases, population, round(max(total_cases) / population, 2) highest_get_covid_rate
from PortfolioProject.coviddeaths
Where continent is not null
group by continent, location, population
order by highest_get_covid_rate desc;




-- Looking at the Highest Death Rate in the period
select continent, location, max(total_deaths) total_deaths, population, max(total_deaths) / population highest_death_rate
from PortfolioProject.coviddeaths
Where continent is not null
group by continent, location, population
order by highest_death_rate desc;




-- Looking at overall cases, deaths, and death percentage
select sum(new_deaths) total_deaths, sum(new_cases) total_cases, sum(new_deaths)/sum(new_cases) * 100 deathpercentage
from PortfolioProject.coviddeaths
where continent is not null;




-- Exploring Vaccinations data



-- Total population vs vaccinations and get vaccinated rate
-- using window function to calculate the number of vaccinated people
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
	sum(cv.new_vaccinations)over(partition by cd.location order by cd.date) RollingPeopleVaccinated,
    sum(cv.new_vaccinations)over(partition by cd.location order by cd.date) / cd.population vaccinated_rate
from PortfolioProject.coviddeaths cd
join PortfolioProject.covidvaccinations cv
	on cd.continent = cv.continent
    and cd.location = cv.location
    and cd.date = cv.date
where cd.continent is not null
order by 2,3;





-- Using CTE to perform the previous query
with PopvsVac
as
(
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
	sum(cv.new_vaccinations)over(partition by cd.location order by cd.date) RollingPeopleVaccinated,
    sum(cv.new_vaccinations)over(partition by cd.location order by cd.date) / cd.population vaccinated_rate
from PortfolioProject.coviddeaths cd
join PortfolioProject.covidvaccinations cv
	on cd.continent = cv.continent
    and cd.location = cv.location
    and cd.date = cv.date
where cd.continent is not null
order by 2,3
)
select *
from PopvsVac;





-- Using Temp Table to perform the previous query
drop table if exists PopulationVaccinatedRate;
create table PopulationVaccinatedRate
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
vaccinated_rate numeric
);
insert into PopulationVaccinatedRate
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
	sum(cv.new_vaccinations)over(partition by cd.location order by cd.date) RollingPeopleVaccinated,
    sum(cv.new_vaccinations)over(partition by cd.location order by cd.date) / cd.population vaccinated_rate
from PortfolioProject.coviddeaths cd
join PortfolioProject.covidvaccinations cv
	on cd.continent = cv.continent
    and cd.location = cv.location
    and cd.date = cv.date
where cd.continent is not null
order by 2,3;

select *
from PopulationVaccinatedRate


