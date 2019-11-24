INSERT INTO[stage_dim_customer] ([CustomerID],[CompanyName],[City],[Region],[Country])
SELECT [CustomerID],[CompanyName],[City],[Region],[Country]
FROM [Northwind].[dbo].[Customers]
