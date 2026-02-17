USE AdventureWorks2019; 
-- Salary progression by department
WITH EmployeeSalaryHistory AS (
    SELECT 
        e.BusinessEntityID,
        e.JobTitle,
        d.Name AS DepartmentName,
        eph.Rate,
        YEAR(eph.RateChangeDate) AS Year
    FROM HumanResources.Employee e
    JOIN HumanResources.EmployeePayHistory eph
        ON e.BusinessEntityID = eph.BusinessEntityID
    JOIN HumanResources.EmployeeDepartmentHistory edh
        ON e.BusinessEntityID = edh.BusinessEntityID
    JOIN HumanResources.Department d
        ON edh.DepartmentID = d.DepartmentID
    WHERE edh.EndDate IS NULL -- this is so that we get the current department 
)
SELECT TOP 10
    DepartmentName,
    JobTitle,
    Year,
    AVG(Rate) AS avg_salary,
    MIN(Rate) AS min_salary,
    MAX(Rate) AS max_salary
FROM EmployeeSalaryHistory
GROUP BY DepartmentName, JobTitle, Year
ORDER by AVG(rate) ASC; 