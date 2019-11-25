USE DM_Northwind;
go 


--Product
INSERT INTO D_Product(ProductName,CategoryName,SupplierName,validFrom,validTo)
SELECT p.ProductName,c.CategoryName,s.CompanyName,'01/01/1996','01/01/2099'
FROM NorthwindDB.dbo.Products p
join NorthwindDB.dbo.Categories c on c.CategoryID = p.CategoryID
join NorthwindDB.dbo.Suppliers s on s.SupplierID = p.SupplierID

--Customer
INSERT INTO D_Customer(CompanyName, City, Country, PostalCode, validFrom, validTo)
SELECT CompanyName, City, Country, PostalCode,'01/01/1996','01/01/2099' from NorthwindDB.dbo.Customers

--Employee
INSERT INTO D_Employee(FullName, Title, City, validFrom, validTo)
SELECT FirstName+' '+LastName,Title, City,'01/01/1996','01/01/2099' from NorthwindDB.dbo.Employees

--Select dp.ProductName, dp.CategoryName, dp.SupplierName, dd.OrderDate from D_Product dp
--join F_Sales f on f.P_ID = dp.P_ID
--join D_Date dd on f.D_ID = dd.D_ID
--WHERE dd.OrderDate >= '1996/01/01' and dd.OrderDate <= '1997/12/31'
--Order by dp.ProductName
















