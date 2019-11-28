USE DM_Northwind
go

DROP TABLE Changed_Customer
DROP TABLE Changed_Employee
DROP TABLE Changed_Product

--Create temp_tables for each dimension, except date and all without validTo/validFrom
--These are used for changed entities, not inserts and deletes.
CREATE TABLE Changed_Product(
ProductId INT,
ProductName NVARCHAR(50), 
CategoryName NVARCHAR(50),
SupplierName NVARCHAR(50),
UnitPrice FLOAT
);

CREATE TABLE Changed_Employee(
EmployeeId INT,
FullName NVARCHAR(50), 
Title NVARCHAR(50), 
City NVARCHAR(50)
);

CREATE TABLE Changed_Customer(
CustomerID NVARCHAR(5),
CustomerName NVARCHAR(50), 
City  NVARCHAR(50), 
Country NVARCHAR(50),
PostalCode NVARCHAR(50)
);


--Last updated variables
DECLARE @lastUpdated Date = (Select Last_updated from DM_Northwind.dbo.DM_Update)
DECLARE @lastUpdatedPlusOne Date = DATEADD(day,1,(Select Last_updated from DM_Northwind.dbo.DM_Update))
DECLARE @endDate Date = '12/31/9999' 
------------------------
--------Customer--------
------------------------
---Insert a row and find added rows
Delete from NorthwindDB.dbo.Customers where CustomerID = 'MAKKR' -- this line is for testing
Delete from DM_Northwind.dbo.D_Customer where CustomerID = 'MAKKR' -- this line is for testing
--Insert a row
Insert into NorthwindDB.dbo.Customers(CustomerID, CompanyName, ContactName, City, Country, PostalCode)
values ('MAKKR', 'Makkerne', 'Jens Yeet','Horsens','Denmark','8700')
--Find the new item
INSERT INTO DM_Northwind.dbo.D_Customer(CustomerID, CustomerName, City, Country, PostalCode,validFrom, validTo)
Select CustomerID, CompanyName, City, Country, PostalCode, @lastUpdatedPlusOne, @endDate from NorthwindDB.dbo.Customers 
WHERE CustomerID in 
(
	( --today
	SELECT CustomerID FROM NorthwindDB.dbo.Customers
	)
	EXCEPT
	( --yesterday
	SELECT CustomerID FROM DM_Northwind.dbo.D_Customer
	)
)

--- Delete a row and find deleted rows
--Maybe you need to update the references somewhere. like this 
UPDATE NorthwindDB.dbo.Orders SET CustomerID = NULL WHERE CustomerID = 'BOTTM' -- set references to null instead of deleting
--Delete a row 
DELETE FROM NorthwindDB.dbo.Customers WHERE CustomerID = 'BOTTM'
--Update the deleted
UPDATE DM_Northwind.dbo.D_Customer SET validTo = @lastUpdated
WHERE CustomerID in
(  
	(--Yesterday and past
	SELECT CustomerID FROM DM_Northwind.dbo.D_Customer
	)
	EXCEPT 
	( --Today
	SELECT CustomerID FROM NorthwindDB.dbo.Customers 
	)
)

--- Change a row and find the changed row
--Change a row 
UPDATE NorthwindDB.dbo.Customers SET Country = 'England' WHERE CustomerID = 'MEREP' -- change it
--UPDATE dbo.Customers SET Country = 'Canada' WHERE CustomerID = 'MEREP' -- this can change it back
--SELECT * FROM DM_Northwind.dbo.D_Customer WHERE CustomerID = 'MEREP' -- this is the one being changed
--Find changed row 
INSERT INTO DM_Northwind.dbo.Changed_Customer(CustomerName, CustomerID, City, Country, PostalCode)
(
	SELECT CompanyName, CustomerID, City, Country, PostalCode FROM NorthwindDB.dbo.Customers --Today
	EXCEPT --Yesterday 
	(
		SELECT CustomerName, CustomerID, City, Country, PostalCode FROM DM_Northwind.dbo.D_Customer
	)
	EXCEPT
	(
		SELECT CompanyName, CustomerID, City, Country, PostalCode FROM NorthwindDB.dbo.Customers 
		WHERE CustomerID NOT IN 
		(
			SELECT CustomerID FROM DM_Northwind.dbo.D_Customer
		)
	)
)
--Update Existing row in dimension table
UPDATE DM_Northwind.dbo.D_Customer
SET validTo = @lastUpdated
WHERE CustomerID IN
(SELECT CustomerID
FROM DM_Northwind.dbo.Changed_Customer)
--Insert new row in dimension table
INSERT INTO DM_Northwind.dbo.D_Customer(CustomerName, CustomerID, City, Country, PostalCode, validFrom, validTo)
SELECT CustomerName, CustomerID, City, Country, PostalCode, @lastUpdatedPlusOne, @endDate FROM DM_Northwind.dbo.Changed_Customer
------------------------
--------Employee--------
------------------------
---Insert a row and find added rows 
Delete from NorthwindDB.dbo.Employees where Title = 'CEO Å' -- this line is for testing
Delete from DM_Northwind.dbo.D_Employee where Title = 'CEO Å' -- this line is for testing
--Insert a row
Insert into NorthwindDB.dbo.Employees(LastName,FirstName, Title,City, Country, PostalCode)
values ('Hansen', 'Hans', 'CEO Å','Horsens','Denmark','8700')
--Find the new item
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

--- Delete a row and find deleted rows
--Delete a row (this deletes the newly inserted one)
DELETE FROM NorthwindDB.dbo.Employees WHERE EmployeeID in (Select max(EmployeeID) from NorthwindDB.dbo.Employees)
--Update the deleted
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

--Clear the changed data from yesterday
--delete from DM_Northwind.dbo.Changed_Employee

--- Change a row and find the changed row
--Change a row 
UPDATE NorthwindDB.dbo.Employees SET City = 'yeet' WHERE EmployeeID in (Select max(EmployeeID) from NorthwindDB.dbo.Employees) 
--Find changed row 
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




-----------------------
--------Product--------
-----------------------