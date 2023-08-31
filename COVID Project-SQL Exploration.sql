/* COVID 19 Data Exploration

Skills used:Joins,CTE's,Temp Tables,Window Functions,Aggregare Functions,Creating Views,Converting Data Types

*/
Select *
From [Portfolio Project]..CovidDeaths
where continent is not null
Order by 3,4

--Select Data that we are going to start with
	
Select location,date,total_cases,new_cases,total_deaths,population
From [Portfolio Project]..CovidDeaths
where continent is not null
order by 1,2

--Total Cases vs Total Deaths

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
From [Portfolio Project]..CovidDeaths
where location like '%states%'
where continent is not null
order by 1,2

--Total Cases vs Population

Select location,date,population,total_cases,(total_cases/population)*100 as InfectedPopulationPercent
From [Portfolio Project]..CovidDeaths
where location like '%states%'
where continent is not null
order by 1,2

--Countries with Highest Infection Rate Compared to population

Select location,population,MAX(total_cases) as HighestInfectionCount,MAx((total_cases/population))*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths
--where location like '%india%'
where continent is not null
Group by population,location
order by PercentPopulationInfected Desc

--Countries with Highest Death Count per Population

Select location,MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
--where location like '%india%'
where continent is not null
Group by location
order by TotalDeathCount Desc

--Breaking things Down by Continent

--Showing continents with the highest Death Count per Population

Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
--where location like '%india%'
where continent is not null
Group by continent
order by TotalDeathCount Desc

--Global Numbers

Select SUM(new_cases) as Total_cases,SUM(cast(new_deaths as int)) as Total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage
From [Portfolio Project]..CovidDeaths
--where location like '%states%'
where continent is not null
Group by date
order by 1,2


Select SUM(new_cases) as Total_cases,SUM(cast(new_deaths as int)) as Total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage
From [Portfolio Project]..CovidDeaths
--where location like '%states%'
where continent is not null
--Group by date
order by 1,2


--Total Population vs Vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Use CTE to perform Calculation on Partition By 

with PopvsVac (Continent,location,Date,Population,New_Vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac

--Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Creating view to store Data For later Visualizations

Create View PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
join [Portfolio Project]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated





