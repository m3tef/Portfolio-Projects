select location , date , total_cases , new_cases , total_deaths , population

from CovidDeaths

order by 1 


--percentage of death by covid each day

select location , date , total_cases , total_deaths , (cast(total_deaths as float)/cast(total_cases as float))* 100 as DeathPercentage

from CovidDeaths

where location like '%germany%'

order by 1


--Total cases vs population

select location , date , total_cases , population , (cast(total_deaths as float)/cast(population as float))* 100 as Infected

from CovidDeaths

where location like '%germany%'

order by 1


--countries wit high infection rate compared to population

select location , population , max(total_cases) as [Highest infection count] , max(cast(total_cases as float)/nullif(cast(population as float),0))* 100 as Percentpopulationinfected

from CovidDeaths

group by location , population

order by Percentpopulationinfected desc


--countries with highest death count per population

select location , max(cast(total_deaths as int)) as [Total Death Count]

from CovidDeaths

where len(continent) <> 0  

group by location

order by [Total Death Count] desc


-- showing things by continent

select continent , max(cast(total_deaths as int)) as [Total Death Count]

from CovidDeaths

where len(continent) <> 0

group by continent

order by [Total Death Count] desc




--use CTE


with PopvsVac (continent , location , date , population , new_vaccinations ,  [Rolling People Vaccinated])
as(
select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations , 
	
	sum(convert(int , vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as [Rolling People Vaccinated]

from[Covid 2]..CovidDeaths dea
join [Covid 2]..CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date
where len(dea.continent) <> 0
--order by  2 , 3
)

select * ,( [Rolling People Vaccinated]/population) * 100
from PopvsVac




create view populationvaccinated as

select dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations , 
	
	sum(convert(int , vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as [Rolling People Vaccinated]

from[Covid 2]..CovidDeaths dea
join [Covid 2]..CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date
--where len(dea.continent) <> 0
--order by  2 , 3























