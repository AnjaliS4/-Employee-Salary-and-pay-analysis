-- department analysis 
-- which departments cost the most? 
use AdventureWorks2019; 
WITH LatestSalary AS (
select 
	 hrp.BusinessEntityID, 
	 hrp.Rate, 
	 hrp.RateChangeDate, 
	 row_number() over( 
		partition by hrp.BusinessEntityID
		order by hrp.ratechangedate DESC
		) as rn
from HumanResources.EmployeePayHistory  hrp 

),
CurrentDepartment AS (
    SELECT *
    FROM HumanResources.EmployeeDepartmentHistory
    WHERE EndDate IS NULL
)

SELECT 
    d.Name AS DepartmentName,
    COUNT(e.BusinessEntityID) AS total_employees,
    AVG(ls.Rate) AS average_salary,
    SUM(ls.Rate) AS total_payroll_cost
FROM HumanResources.Employee e
JOIN LatestSalary ls 
    ON e.BusinessEntityID = ls.BusinessEntityID
JOIN CurrentDepartment cd
    ON e.BusinessEntityID = cd.BusinessEntityID
JOIN HumanResources.Department d
    ON cd.DepartmentID = d.DepartmentID
WHERE ls.rn = 1
GROUP BY d.Name
ORDER BY total_payroll_cost DESC;

