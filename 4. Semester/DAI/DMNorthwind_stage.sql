---Create stage dimensional tables
Use StageNorthwind
go
DROP TABLE Stage_D_Date;
DROP TABLE Stage_D_Customer;
DROP TABLE Stage_D_Employee;
DROP TABLE Stage_D_Product;

CREATE TABLE Stage_D_Product(
P_ID INT PRIMARY KEY IDENTITY (1, 1),
ProductName NVARCHAR(50), 
CategoryName NVARCHAR(50),
SupplierName NVARCHAR(50)
);

CREATE TABLE Stage_D_Employee(
E_ID INT PRIMARY KEY IDENTITY (1, 1),
FullName NVARCHAR(50), 
Title NVARCHAR(50), 
City NVARCHAR(50)
);

CREATE TABLE Stage_D_Customer(
C_ID INT PRIMARY KEY IDENTITY (1, 1),
CustomerID NVARCHAR(5),
CustomerName NVARCHAR(50), 
City  NVARCHAR(50), 
Country NVARCHAR(50),
PostalCode NVARCHAR(10)
);

CREATE TABLE Stage_D_Date(
D_ID INT PRIMARY KEY IDENTITY (1, 1),
OrderdateID Datetime,
DD INT,
MM INT,
YYYY INT,
HH24 INT,
MM60 INT,
WeekNumber INT, 
NameOfMonth NVARCHAR(50), 
NameOfWeekday NVARCHAR(50)
);

---Fill stage dimensionals
--Customer
INSERT INTO Stage_D_Customer(CustomerID,CustomerName, City,Country, PostalCode)
SELECT c.CustomerID,c.CompanyName,c.City,c.Country,c.PostalCode
FROM NorthwindDB.dbo.Customers c

--Employee
INSERT INTO Stage_D_Employee(FullName, Title, City)
SELECT e.FirstName +' '+ e.LastName, e.Title, e.City
FROM NorthwindDB.dbo.Employees e

--Product
INSERT INTO Stage_D_Product(ProductName, CategoryName,SupplierName)
SELECT p.ProductName, c.CategoryName, s.CompanyName
FROM NorthwindDB.dbo.Products p
JOIN NorthwindDB.dbo.Categories c on c.CategoryID = p.CategoryID
JOIN NorthwindDB.dbo.Suppliers s on s.SupplierID = p.SupplierID

--Date
INSERT INTO Stage_D_Date(OrderdateID,DD,MM,YYYY,HH24,MM60,WeekNumber,NameOfMonth, NameOfWeekday)
Select o.OrderDate,DAY(o.OrderDate),MONTH(o.OrderDate),YEAR(o.OrderDate),DATEPART(HOUR,o.OrderDate),
DATEPART(MINUTE,o.OrderDate), DATEPART(week, o.OrderDate), DATENAME(month, o.OrderDate), DATENAME(WEEKDAY, o.OrderDate)
FROM  NorthwindDB.dbo.Orders o

---Fill dw dimensional tables from stage
Use DM_Northwind
--Customer
INSERT INTO D_Customer(CustomerID,CustomerName, City, Country, PostalCode, validFrom, validTo)
SELECT CustomerID,CustomerName, City, Country, PostalCode,'01/01/1996','01/01/2099' 
FROM StageNorthwind.dbo.Stage_D_Customer

--Employee
INSERT INTO D_Employee(FullName, Title, City, validFrom, validTo)
SELECT FullName,Title, City,'01/01/1996','01/01/2099' 
FROM StageNorthwind.dbo.Stage_D_Employee

--Product
INSERT INTO D_Product (ProductName,CategoryName,SupplierName,validFrom,validTo)
SELECT ProductName,CategoryName,SupplierName,'01/01/1996','01/01/2099'
FROM StageNorthwind.dbo.Stage_D_Product

--Date
INSERT INTO D_Date(DD, MM, YYYY,HH24, MM60,WeekNumber,NameOfMonth, NameOfWeekday)
Select DD, MM, YYYY,HH24, MM60,WeekNumber,NameOfMonth, NameOfWeekday
From StageNorthwind.dbo.Stage_D_Date 

---Create stage Fact table
USE StageNorthwind
GO
DROP TABLE stage_fact_sales
CREATE TABLE stage_fact_sales(
[C_ID] [int] NULL,
[E_ID] [int] NULL,
[P_ID] [int] NULL,
[D_ID] [int] NULL,
[CustomerID] [nchar](5) NULL,
[ProductID] [int] NULL,
[EmployeeID] [int] NULL,
[OrderDateID] [nvarchar](50) NULL,
[Quantity] [bigint] NULL,
[SalesAmount] [decimal](18, 2) NULL
)

---Fill stage fact table
USE NorthWindDB
GO
INSERT INTO StageNorthwind.dbo.stage_fact_sales
(Quantity,SalesAmount,ProductID,CustomerID,EmployeeID,OrderDateID)
SELECT 
Quantity, 
[Order Details].UnitPrice* Quantity,
Products.ProductID, 
Customers.CustomerID, 
Employees.EmployeeID, 
Orders.OrderDate
FROM [Order Details] 
JOIN Orders ON  Orders.OrderID= [Order Details].OrderID
JOIN Customers on Orders.CustomerID= Customers.CustomerID
JOIN Employees on Employees.EmployeeID= Orders.EmployeeID
JOIN Products on Products.ProductID= [Order Details].ProductID

---Update stage fact table surrogate keys
Use StageNorthwind
--Customer
UPDATE stage_fact_sales
SET C_ID = (
	SELECT C_ID 
	FROM DM_Northwind.dbo.D_Customer c
	WHERE c.C_ID = stage_fact_sales.CustomerID
)

--Employee
UPDATE stage_fact_sales
SET E_ID = (
	SELECT E_ID 
	FROM DM_Northwind.dbo.D_Employee e
	WHERE e.E_ID = stage_fact_sales.EmployeeID
)

--Product
UPDATE stage_fact_sales
SET P_ID = (
	SELECT P_ID 
	FROM DM_Northwind.dbo.D_Product p
	WHERE p.P_ID = stage_fact_sales.ProductID
)

--Date
UPDATE stage_fact_sales
SET D_ID = (
	SELECT d.D_ID
	FROM DM_Northwind.dbo.D_Date d 
	WHERE d.D_ID = stage_fact_sales.D_ID
)

---Populate data warehouse fact table from the stage fact table
USE StageNorthwind
GO
INSERT INTO DM_Northwind.dbo.F_Sales(D_ID,C_ID,P_ID,E_ID,Quantity, LineTotal)
SELECT s.D_ID, s.C_ID, s.P_ID, s.E_ID, s.Quantity, s.SalesAmount 
FROM stage_fact_sales s

Select * from DM_Northwind.dbo.F_Sales

select * from stage_fact_sales