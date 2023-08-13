/*
Covid-19 Data Exploration for tableau

Skills used: Converting Data Types, Joins, Windows Functions, CTE, Temp Tables, Aggregate Functions

*/


-- Convert datatype of date to datetime
alter table PortfolioProject
modify column date datetime



-- Looking at Getting Covid Rate
select continent, location, date, total_cases, population, round(total_cases/ population, 2) get_rate
from PortfolioProject.coviddeaths
Where continent is not null
order by continent, location;



-- Looking at Death Rate
select continent, location, date, total_cases, total_deaths, round(total_deaths/total_cases, 2) Death_Rate
from PortfolioProject.coviddeaths
Where continent is not null
order by continent, location;



-- Looking at Highest Geting Covid Rate in the period
select continent, location, max(total_cases) total_cases, population, round(max(total_cases) / population, 2) highest_get_covid_rate
from PortfolioProject.coviddeaths
Where continent is not null
group by continent, location, population
order by highest_get_covid_rate desc;




-- Looking at Highest Death Rate in the period
select continent, location, max(total_deaths) total_deaths, population, max(total_deaths) / population highest_death_rate
from PortfolioProject.coviddeaths
Where continent is not null
group by continent, location, population
order by highest_death_rate desc;



-- Looking at overall cases, deaths, deathpercentage
select sum(new_deaths) total_deaths, sum(new_cases) total_cases, sum(new_deaths)/sum(new_cases) * 100 deathpercentage
from PortfolioProject.coviddeaths
where continent is not null;


-- Total population vs vaccinations and rate of number of people got vaccinated
-- using window function to calculation number of vaccinated people
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


-- Using CTE to perform previous query
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


-- Using Temp Table to perform previous query
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


