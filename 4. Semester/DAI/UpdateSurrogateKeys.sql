USE StageNorthwind

/*
UPDATE stage_fact_sales
SET C_ID = (
	SELECT C_ID 
	FROM myNorthWindDB.dbo.D_Customer c
	WHERE c.C_ID = stage_fact_sales.CustomerID
)
*/
UPDATE stage_fact_sales
SET E_ID = (
	SELECT E_ID 
	FROM myNorthWindDB.dbo.D_Employee E
	WHERE e.E_ID = stage_fact_sales.EmployeeID
)

Select count(*) as Employees from myNorthWindDB.dbo.D_Employee
Select count(*) as NotNullers from stage_fact_sales where E_ID is not null
Select count(*) as Nullers from stage_fact_sales where E_ID is null