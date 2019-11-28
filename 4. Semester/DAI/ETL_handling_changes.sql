USE NorthwindDB
go
--Create temp_tables for each dimension, except date and all without validTo/validFrom
CREATE TABLE D_Product(
P_ID INT PRIMARY KEY IDENTITY (1, 1),
ProductName NVARCHAR(50), 
CategoryName NVARCHAR(50),
SupplierName NVARCHAR(50)
);

CREATE TABLE D_Employee(
E_ID INT PRIMARY KEY IDENTITY (1, 1),
FullName NVARCHAR(50), 
Title NVARCHAR(50), 
City NVARCHAR(50)
);

CREATE TABLE D_Customer(
C_ID INT PRIMARY KEY IDENTITY (1, 1),
CustomerID NVARCHAR(5),
CustomerName NVARCHAR(50), 
City  NVARCHAR(50), 
Country NVARCHAR(50),
PostalCode NVARCHAR(50)
);


------------------------
--------Customer--------
------------------------
---Insert a row and find added rows
--Insert a row
Insert into dbo.Customers(CustomerID, CompanyName, ContactName, Country, City)
values ('MAKKR', 'Makkerne', 'Jens Yeet', 'Denmark','Horsens')
--Find the new item
Select * from dbo.Customers 
WHERE CustomerID in 
(
	( --today
	SELECT CustomerID FROM dbo.Customers
	)
	EXCEPT
	( --yesterday
	SELECT CustomerID FROM DM_Northwind.dbo.D_Customer
	)
)


--- Delete a row and find deleted rows
--Maybe you need to update the references somewhere. like this 
-- UPDATE dbo.Orders SET CustomerID = NULL WHERE CustomerID = 'BOTTM' -- set references to null instead of deleting

--Delete a row 
DELETE FROM dbo.Customers WHERE CustomerID = 'BOTTM'
--Find the deleted
SELECT * FROM DM_Northwind.dbo.D_Customer dc
WHERE dc.CustomerID in
(  
	(--Yesterday and past
	SELECT ddc.CustomerID FROM DM_Northwind.dbo.D_Customer ddc
	)
	EXCEPT 
	( --Today
	SELECT c.CustomerID FROM NorthwindDB.dbo.Customers c
	)
)

--- Change a row and find the changed row
--Change a row 
UPDATE dbo.Customers SET Country = 'England' WHERE CustomerID = 'MEREP' -- change it
--UPDATE dbo.Customers SET Country = 'Canada' WHERE CustomerID = 'MEREP' -- this can change it back

--Find changed row
--Today
SELECT CompanyName, CustomerID, City, Country FROM dbo.Customers
EXCEPT --Yesterday 
(
	SELECT CustomerName, CustomerID, City, Country FROM DM_Northwind.dbo.D_Customer
)
EXCEPT
(
	SELECT CompanyName, CustomerID, City, Country FROM dbo.Customers 
	WHERE CustomerID NOT IN 
	(
		SELECT CustomerID FROM DM_Northwind.dbo.D_Customer
	)
)
------------------------
--------Employee--------
------------------------

-----------------------
--------Product--------
-----------------------