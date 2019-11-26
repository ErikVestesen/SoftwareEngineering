USE DM_Northwind;
go 
--Product
INSERT INTO D_Product (ProductName,CategoryName,SupplierName,validFrom,validTo)
SELECT ProductName,CategoryName,SupplierName,'01/01/1996','01/01/2099'
FROM StageNorthwind.dbo.Stage_D_Product

--Customer
INSERT INTO D_Customer(CustomerID,CustomerName, City, Country, PostalCode, validFrom, validTo)
SELECT CustomerID,CustomerName, City, Country, PostalCode,'01/01/1996','01/01/2099' 
FROM StageNorthwind.dbo.Stage_D_Customer

--Employee
INSERT INTO D_Employee(FullName, Title, City, validFrom, validTo)
SELECT FullName,Title, City,'01/01/1996','01/01/2099' 
FROM StageNorthwind.dbo.Stage_D_Employee

--Date
INSERT INTO D_Date(DD, MM, YYYY,HH24, MM60,WeekNumber,NameOfMonth, NameOfWeekday)
Select DD, MM, YYYY,HH24, MM60,WeekNumber,NameOfMonth, NameOfWeekday
From StageNorthwind.dbo.Stage_D_Date 

--Last Updated
INSERT INTO DM_Northwind.dbo.DM_Update(Last_updated)
VALUES ('1994/12/31')
