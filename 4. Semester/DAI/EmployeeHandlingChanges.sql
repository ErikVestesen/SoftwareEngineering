use DM_Northwind
go

------------------------
--------Employee--------
------------------------

---Insert added employees
INSERT INTO DM_Northwind.dbo.D_Employee(FullName, Title, City,EmployeeId, validFrom, validTo)
Select FirstName+' '+LastName,Title, City,EmployeeId, '01/01/1998', '01/01/9999' from NorthwindDB.dbo.Employees
WHERE EmployeeID in 
(
	( --today
	SELECT EmployeeID FROM NorthwindDB.dbo.Employees
	)
	EXCEPT
	( --yesterday
	SELECT EmployeeID FROM DM_Northwind.dbo.D_Employee
	)
)

--Update deleted Employees
UPDATE DM_Northwind.dbo.D_Employee SET validTo = '1997/12/31'
WHERE EmployeeID in
(  
	(--Yesterday and past
	SELECT EmployeeID FROM DM_Northwind.dbo.D_Employee
	)
	EXCEPT 
	( --Today
	SELECT EmployeeID FROM NorthwindDB.dbo.Employees 
	)
)

--Insert and update changed employees 
INSERT INTO DM_Northwind.dbo.Changed_Employee(FullName, Title, City,EmployeeId)
(
	SELECT FirstName+' '+LastName, Title, City,EmployeeId FROM NorthwindDB.dbo.Employees --Today
	EXCEPT --Yesterday 
	(
		SELECT  FullName, Title, City,EmployeeId  FROM DM_Northwind.dbo.D_Employee
	)
	EXCEPT
	(
		SELECT  FirstName+' '+LastName, Title, City, EmployeeId  FROM NorthwindDB.dbo.Employees 
		WHERE EmployeeID NOT IN 
		(
			SELECT EmployeeID FROM DM_Northwind.dbo.D_Employee
		)
	)
)
--Update Existing row in dimension table
UPDATE DM_Northwind.dbo.D_Employee
SET validTo = '1997/12/31'
WHERE EmployeeId in
(SELECT EmployeeId
FROM DM_Northwind.dbo.Changed_Employee)
--Insert new row in dimension table
INSERT INTO DM_Northwind.dbo.D_Employee(FullName, Title, City,EmployeeId, validFrom, validTo)
SELECT FullName, Title, City,EmployeeId, '01/01/1998', '01/01/9999' FROM DM_Northwind.dbo.Changed_Employee

