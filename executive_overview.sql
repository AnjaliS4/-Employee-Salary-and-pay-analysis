
use AdventureWorks2019; 

-- part 1: executive compensation overview 
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
select --hre.BusinessEntityID, hre.jobtitle, hre.Gender, hre.organizationlevel, hre.hiredate,
	   COUNT(hre.BusinessEntityID) as total_employees, 
	   AVG(ls.Rate) as average_salary,
	   MIN(ls.rate) as min_salary, 
	   MAX(ls.rate) as max_salary, 
	   SUM(ls.rate) as total_payrool_cost 
from latest_salary  ls
join HumanResources.Employee  hre 
on ls.id = hre.BusinessEntityID
where rn = 1; 




