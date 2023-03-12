use [PortfolioProject];
go

select *
from [dbo].[CovidDeaths]
order by 3,4;

select *
from [dbo].[CovidVaccinations]
order by 3,4;

select location,date,total_cases,new_cases,total_deaths,population
from [dbo].[CovidDeaths]
order by 1,2;

--Looking at total vases vs total deaths
--likelihood of dying of covid in saudi arabia
select location,date,total_cases,new_cases,total_deaths, round((total_deaths/total_cases) * 100,1)  as deathpercentage
from [dbo].[CovidDeaths]
where location like '%arabia%'
order by 1,2;


--looking at total cases vs population
--percentage of confirmed population that contracted covid 
select location,date,total_cases,new_cases,population, round((total_cases/population) * 100,1)  as casepercentage
from [dbo].[CovidDeaths]
where location like '%arabia%'
order by 1,2;

--looking at countries with highest infection rate
select location,population,MAX(total_cases) as highestinfectioncount,max(round((total_cases/population) * 100,1))  as casepercentage
from [dbo].[CovidDeaths]
group by location,population
order by casepercentage desc;

--continent with highest death count
select location,MAX(cast(total_deaths as int)) as totalDeaths
from [dbo].[CovidDeaths]
where continent is null
group by location
order by 2 desc;

--country with highest death count 
select location,MAX(cast(total_deaths as int)) as totalDeaths
from [dbo].[CovidDeaths]
where continent is not null
group by location
order by 2 desc;

--global numbers
select 
SUM(new_cases) as total_cases,
SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percent
from [dbo].[CovidDeaths]
where continent is not null
order by 1,2;

--total population vs vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location) as vacc_sum
from [dbo].[CovidDeaths] dea
join [dbo].[CovidVaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


