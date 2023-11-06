CREATE DATABASE Covid_Data_Analysis;
Use Covid_Data_Analysis;

select * from coviddeaths;

select * from covidvaccinations;

select Location,Date_Format(date,"%Y/%c/%e") as date,total_cases,new_cases,population 
from Coviddeaths 
order by 1,2 asc;

alter table Coviddeaths
add column DeathPercentage int not null;

-- Total Cases vs Total Deaths 

select Location,Date_Format(date,"%e/%c/%y") as date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from Coviddeaths 
where Location like "%India%"
order by 1,2;

-- Total Cases vs Population

select Location,Max(total_cases),Population, Max((total_cases/Population)*100) as Infected
from Coviddeaths
group by Location,Population
order by 4 desc;

-- Total Deaths vs Population

select Location,Max(total_deaths),Population, Max((total_deaths/Population)*100) as Dead, ROW_NUMBER() OVER(order by Max((total_deaths/Population)*100 )desc) position
from Coviddeaths
group by location,population
order by Dead desc;

-- Highest Death Counts per Population

select Location,Max(cast(total_deaths as unsigned)) as TotalDeaths
from Coviddeaths 
where continent != ''
group by Location
order by 2 desc;  

-- Showing continents with highest deaths per population

select continent, Max(cast(total_deaths as unsigned)) as Total_Deaths,Population
from Coviddeaths
where continent != ''
group by continent
order by Total_Deaths desc;

select * 
from Coviddeaths as dea
join Covidvaccinations as vac
on dea.location = vac.location
and dea.date = vac.date;


-- Total Population vs Vaccinations

CREATE USER 'keshav'@'localhost' IDENTIFIED BY 'Leonardo@best';
GRANT ALL ON Covid_Data_Analysis.* TO 'keshav'@'localhost';

alter table CovidDeaths
modify date date;

select dea.location as location,Date_Format(dea.date,"%e/%c/%y") as date,sum(cast(new_vaccinations as unsigned)) over (partition by dea.location order by dea.location,Date_Format(dea.date,"%e/%c/%y"))as Vaccinations,new_vaccinations
from Coviddeaths as dea
join Covidvaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
where new_vaccinations != ''
order by dea.location,date;


With PopvsVac(Continent,Location,Date,Population,new_vaccinations,Vaccinations)
as
(
select dea.continent,dea.location ,Date_Format(dea.date,"%e/%c/%y") as date,population,new_vaccinations,sum(cast(new_vaccinations as unsigned)) over (partition by dea.location order by dea.location,Date_Format(dea.date,"%e/%c/%y"))as Vaccinations
from Coviddeaths as dea
join Covidvaccinations as vac
on dea.location = vac.location
and dea.date = vac.date
)
Select *,(Vaccinations/Population)*100
From PopvsVac;

create view Percent_population_Vaccinated as
select dea.location as location,Date_Format(dea.date,"%e/%c/%y") as date,sum(cast(new_vaccinations as unsigned)) over (partition by dea.location order by dea.location,Date_Format(dea.date,"%e/%c/%y"))as Vaccinations,new_vaccinations
from Coviddeaths as dea
join Covidvaccinations as vac
on dea.location = vac.location
and dea.date = vac.date;

select * from Percent_population_Vaccinated;
