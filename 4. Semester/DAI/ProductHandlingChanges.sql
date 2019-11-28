use DM_Northwind
go
------------------------
--------Product--------
------------------------
---Insert added products
INSERT INTO DM_Northwind.dbo.D_Product(ProductId,ProductName, UnitPrice, CategoryName,SupplierName, validFrom, validTo)
Select ProductId,ProductName,UnitPrice, CategoryName,Suppliers.CompanyName, '01/01/1998', '01/01/9999' from NorthwindDB.dbo.Products
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
UPDATE DM_Northwind.dbo.D_Product SET validTo = '1997/12/31'
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
SET validTo = '1997/12/31'
WHERE ProductId in
(SELECT ProductId
FROM DM_Northwind.dbo.Changed_Product)
----Insert new row in dimension table
INSERT INTO DM_Northwind.dbo.D_Product(ProductId, ProductName, CategoryName,SupplierName,UnitPrice, validFrom, validTo)
SELECT ProductId, ProductName, CategoryName,SupplierName,UnitPrice, '01/01/1998', '01/01/9999' FROM DM_Northwind.dbo.Changed_Product
