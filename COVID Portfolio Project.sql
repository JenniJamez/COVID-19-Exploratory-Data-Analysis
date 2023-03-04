select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4 


-- Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

-- Looking at Total Cases vs Total Deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
order by 1,2
 
 -- Looking at Total Cases vs Total Deaths using state
 -- shows the likelihood of dying if u contract covid in your country 
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
and  continent is not null
order by 1,2

-- Total Cases vs Population
Select location, date, Population, total_cases,  (total_cases/population)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

Select location, date, Population, total_cases,  (total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
order by 1,2

--HIGHEST INFECTION COUNT AND PERCENTAGE OF PEOPLE INFECTED
Select location, Population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 as PercentagePolulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
Group by Location, Population
order by PercentagePolulationInfected desc

--DATE
Select location, Population,date, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 as PercentagePolulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
Group by Location, Population, date
order by PercentagePolulationInfected desc


-- countries with the highest death count per Population 
Select location, MAX(cast (Total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group by Location
order by  TotalDeathCount  desc

--LET'S WORK WITH CONTINENT

--showing continent with the highest death count

Select continent, MAX(cast (Total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
Group by continent
order by  TotalDeathCount  desc

-- MORE ACCURATE NUMBER/RESULT
Select location, MAX(cast (Total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is null
Group by location
order by  TotalDeathCount  desc

-- GLOBAL NUMBERS
--SUM OF THE NEW CASES
select date, SUM(new_cases)--, total_cases,total deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
Group By date
order by 1,2


--SUM OF THE NEW DEATHS
select date, SUM(new_cases)as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
Group By date
order by 1,2


-- TOTAL DEATH COUNT 
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



-- TOTAL CASES ACROSS THE WORLD 
select SUM(new_cases)as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null
--Group By date
order by 1,2

-- TOTAL HOSPITAL PATIENTS ACROSS THE WORLD 
select SUM(new_cases)as total_cases, SUM(cast(hosp_patients as int)) as hosp_patients, SUM(cast(hosp_patients as int))/SUM(New_Cases)*100 as hospPercentage
From PortfolioProject..CovidDeaths
where continent is not null
--Group By date
order by 1,2


-- TOTAL ICU PATIENTS VS HOSPITAL PATIENTS ACROSS THE WORLD 
select SUM(CAST(hosp_patients as int))as hosp_patients, SUM(cast(icu_patients as int)) as icu_patients
From PortfolioProject..CovidDeaths
where continent is not null
--Group By date
order by 1,2

--  TOTAL POPULATION VS VACCINATIONS

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 1,2

 
 --  TOTAL POPULATION VS TESTS
 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_tests
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 1,2

 
 ----- POSITIVES RATE NS TOTAL TEST
 Select dea.continent, dea.location, dea.date, dea.population, vac.positive_rate, vac.total_tests
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 1,2

 --  TOTAL POPULATION VS NEW VACCINATIONS
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

  --  TOTAL POPULATION VS NEW tested
  --  NOTE Adding the number of people tested by each day
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_tests
, SUM(CONVERT(int,vac.new_tests)) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleTested
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

 --- Population vs Percentage of Vaccinated People each day
 -- USE CTE

 with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
 as 
 (
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 )
 Select *, (RollingPeopleVaccinated/Population)*100
 From PopvsVac


 ---------- Population vs Percentage of Hospital Patients
 -- USE CTE
 with PopvsVac (Continent, Location, Date, Population, icu_patients, hosp_patients, RollingHospPatients)
 as 
 (
 Select dea.continent, dea.location, dea.date, dea.population, dea.icu_patients, dea.hosp_patients
, SUM(CONVERT(int,dea.hosp_patients)) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingHospPatients
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 )
 Select *, (RollingHospPatients/Population)*100
 From PopvsVac
 ----------------------------------------------
 
 
 --- Population vs Percentage of People Tested Per Day
 -- USE CTE

 with PopvsVac (Continent, Location, Date, Population, new_tests, RollingPeopleTested)
 as 
 (
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_tests
, SUM(CONVERT(int,vac.new_tests)) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleTested
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 )
 Select *, (RollingPeopleTested/Population)*100
 From PopvsVac


 --max

  with PopvsVac (Continent, Location, Population, New_Vaccinations, RollingPeopleVaccinated)
 as 
 (
 Select dea.continent, dea.location, dea.population, vac.new_vaccinations
, MAX(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 where dea.continent is not null
 --order by 2,3
 )
 Select *, (RollingPeopleVaccinated/Population)*100
 From PopvsVac

 --TEMP TABLE

 Drop Table if exists #PercentPopulationVaccinated
 Create Table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 --where dea.continent is not null
 --order by 2,3 

 Select *, (RollingPeopleVaccinated/Population)*100
 From #PercentPopulationVaccinated


 --TEMP TABLE
 DROP Table if exists #PercentPopulationTested
 Create Table #PercentPopulationTested
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 new_tests numeric,
RollingPeopleTested numeric
 )

 Insert into #PercentPopulationTested
Select dea.continent, dea.location, dea.date, dea.population, vac.new_tests
, SUM(CONVERT(int,vac.new_tests)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleTested
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 --where dea.continent is not null
 --order by 2,3

 Select *, (RollingPeopleTested/Population)*100
 From #PercentPopulationTested


 -- Creating view to store data for later visualizations 
 Create View PercentPopulationVaccinated as
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
-- order by 2,3 

Select * 
From PercentPopulationVaccinated


