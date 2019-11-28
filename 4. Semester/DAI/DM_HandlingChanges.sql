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
DECLARE @lastUpdated Date = (Select Last_updated from DM_Northwind.dbo.DM_Update) --31/12/1997
DECLARE @lastUpdatedPlusOne Date = DATEADD(day,1,(Select Last_updated from DM_Northwind.dbo.DM_Update)) -- 01/01/1998
DECLARE @endDate Date = '12/31/9999' 
------------------------
--------Customer--------
------------------------

---Insert added customers
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

--Update deleted customers
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

--Insert and update changed customers
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

---Insert added employees
INSERT INTO DM_Northwind.dbo.D_Employee(FullName, Title, City,EmployeeId, validFrom, validTo)
Select FirstName+' '+LastName,Title, City,EmployeeId, @lastUpdatedPlusOne, @endDate from NorthwindDB.dbo.Employees
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
UPDATE DM_Northwind.dbo.D_Employee SET validTo = @lastUpdated
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
SET validTo =  @lastUpdated
WHERE EmployeeId in
(SELECT EmployeeId
FROM DM_Northwind.dbo.Changed_Employee)
--Insert new row in dimension table
INSERT INTO DM_Northwind.dbo.D_Employee(FullName, Title, City,EmployeeId, validFrom, validTo)
SELECT FullName, Title, City,EmployeeId, @lastUpdatedPlusOne, @endDate FROM DM_Northwind.dbo.Changed_Employee


------------------------
--------Product--------
------------------------
---Insert added products
INSERT INTO DM_Northwind.dbo.D_Product(ProductId,ProductName, UnitPrice, CategoryName,SupplierName, validFrom, validTo)
Select ProductId,ProductName,UnitPrice, CategoryName,Suppliers.CompanyName, @lastUpdatedPlusOne, @endDate from NorthwindDB.dbo.Products
join NorthwindDB.dbo.Categories on Categories.CategoryID = Products.CategoryID
join NorthwindDB.dbo.Suppliers on Suppliers.SupplierID = Products.SupplierID
WHERE ProductID in 
(
	( --today
	SELECT ProductID FROM NorthwindDB.dbo.Products
	join NorthwindDB.dbo.Categories on Categories.CategoryID = Products.CategoryID
	join NorthwindDB.dbo.Suppliers on Suppliers.SupplierID = Products.SupplierID
	)
	EXCEPT
	( --yesterday
	SELECT ProductID FROM DM_Northwind.dbo.D_Product
	)
)

--Update deleted products
UPDATE DM_Northwind.dbo.D_Product SET validTo =  @lastUpdated
WHERE ProductID in
(  
	(--Yesterday and past
	SELECT ProductID FROM DM_Northwind.dbo.D_Product
	)
	EXCEPT 
	( --Today
	SELECT ProductID FROM NorthwindDB.dbo.Products
	join NorthwindDB.dbo.Categories on Categories.CategoryID = Products.CategoryID
	join NorthwindDB.dbo.Suppliers on Suppliers.SupplierID = Products.SupplierID
	)
)

--Insert and update changed products 
INSERT INTO DM_Northwind.dbo.Changed_Product(ProductId, ProductName, CategoryName,SupplierName,UnitPrice)
(
	SELECT ProductId, ProductName, CategoryName,Suppliers.CompanyName,UnitPrice FROM NorthwindDB.dbo.Products--Today
	join NorthwindDB.dbo.Categories on Categories.CategoryID = Products.CategoryID
	join NorthwindDB.dbo.Suppliers on Suppliers.SupplierID = Products.SupplierID
	
	EXCEPT --Yesterday 
	(
		SELECT  ProductId, ProductName, CategoryName,SupplierName,UnitPrice  FROM DM_Northwind.dbo.D_Product
	)
	EXCEPT
	(
		SELECT  ProductId, ProductName, CategoryName,Suppliers.CompanyName,UnitPrice  FROM NorthwindDB.dbo.Products
		join NorthwindDB.dbo.Categories on Categories.CategoryID = Products.CategoryID
		join NorthwindDB.dbo.Suppliers on Suppliers.SupplierID = Products.SupplierID
		WHERE ProductId NOT IN 
		(
			SELECT ProductId FROM DM_Northwind.dbo.D_Product
		)
	)
)
----Update Existing row in dimension table
UPDATE DM_Northwind.dbo.D_Product
SET validTo = @lastUpdated
WHERE ProductId in
(SELECT ProductId
FROM DM_Northwind.dbo.Changed_Product)
----Insert new row in dimension table
INSERT INTO DM_Northwind.dbo.D_Product(ProductId, ProductName, CategoryName,SupplierName,UnitPrice, validFrom, validTo)
SELECT ProductId, ProductName, CategoryName,SupplierName,UnitPrice, @lastUpdatedPlusOne, @endDate FROM DM_Northwind.dbo.Changed_Product
