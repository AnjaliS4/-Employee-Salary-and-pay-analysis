-- gender pay analysis
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
select 
	  e.Gender, 
	  COUNT(ls.ID) as total_employees, 
	  AVG(ls.rate) as average_salary,
	   max(ls.rate) as max_salary,
	  MIN(ls.rate) as min_salary,  
	  sum(ls.rate) as total_payroll 
from latest_salary as ls 
join HumanResources.Employee e 
on ls.id = e.BusinessEntityID 
where ls.rn = 1
group by e.Gender 
order by  MAX(ls.rate) DESC; 