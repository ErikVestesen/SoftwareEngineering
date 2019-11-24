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
SupplierName NVARCHAR(50),
UnitPrice float
);

CREATE TABLE Stage_D_Employee(
E_ID INT PRIMARY KEY IDENTITY (1, 1),
FullName NVARCHAR(50), 
Title NVARCHAR(50), 
City NVARCHAR(50)
);

CREATE TABLE Stage_D_Customer(
C_ID INT PRIMARY KEY IDENTITY (1, 1),
CustomerName NVARCHAR(50), 
City  NVARCHAR(50), 
Country NVARCHAR(50),
PostalCode INT
);

CREATE TABLE Stage_D_Date(
D_ID INT PRIMARY KEY IDENTITY (1, 1), 
OrderDate DATE,
WeekNumber INT, 
NameOfMonth NVARCHAR(50), 
NameOfWeekday NVARCHAR(50)
);


