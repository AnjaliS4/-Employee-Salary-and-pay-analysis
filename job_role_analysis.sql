-- job role analysis: how does compensation vary across hierarchy 
use AdventureWorks2019;  

with latest_salary as ( 
select 
	 hrp.BusinessEntityID as id, 
	 hrp.Rate, 
	 hrp.RateChangeDate,
	 row_number() over( 
		partition by hrp.BusinessEntityID
		order by hrp.ratechangedate DESC
		) as rn
from HumanResources.EmployeePayHistory  hrp 

) 
select top 10 
		e.jobtitle, 
		e.gender, 
	   COUNT(ls.ID) as total_employees, 
	   SUM(ls.rate) as total_payrool_cost,    
	   AVG(ls.Rate) as average_salary,
	   MIN(ls.rate) as min_salary, 
	   MAX(ls.rate) as max_salary
	   
from latest_salary ls 
join HumanResources.Employee as e 
on ls.id = e.BusinessEntityID 
where rn = 1 
group by e.JobTitle, e.Gender
order by SUM(ls.rate) DESC; 