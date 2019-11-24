USE NorthwindDB
go

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
	SELECT CustomerID FROM myNorthWindDB.dbo.D_Customer
	)
)


--- Delete a row and find deleted rows
--Maybe you need to update the references somewhere. like this 
-- UPDATE dbo.Orders SET CustomerID = NULL WHERE CustomerID = 'BOTTM' -- set references to null instead of deleting

--Delete a row 
DELETE FROM dbo.Customers WHERE CustomerID = 'BOTTM'
--Find the deleted
SELECT * FROM myNorthWindDB.dbo.D_Customer dc
WHERE dc.CustomerID in
(  
	(--Yesterday and past
	SELECT ddc.CustomerID FROM myNorthWindDB.dbo.D_Customer ddc
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
	SELECT CustomerName, CustomerID, City, Country FROM myNorthWindDB.dbo.D_Customer
)
EXCEPT
(
	SELECT CompanyName, CustomerID, City, Country FROM dbo.Customers 
	WHERE CustomerID NOT IN 
	(
		SELECT CustomerID FROM myNorthWindDB.dbo.D_Customer
	)
)