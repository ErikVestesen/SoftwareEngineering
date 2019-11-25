USE DM_Northwind;
go

DROP TABLE F_Sales;
DROP TABLE D_Date;
DROP TABLE D_Customer;
DROP TABLE D_Employee;
DROP TABLE D_Product;

CREATE TABLE D_Product(
P_ID INT PRIMARY KEY IDENTITY (1, 1),
ProductName NVARCHAR(50), 
CategoryName NVARCHAR(50),
SupplierName NVARCHAR(50),
validFrom DATE,
validTo DATE
);

CREATE TABLE D_Employee(
E_ID INT PRIMARY KEY IDENTITY (1, 1),
FullName NVARCHAR(50), 
Title NVARCHAR(50), 
City NVARCHAR(50),
validFrom DATE,
validTo DATE
);

CREATE TABLE D_Customer(
C_ID INT PRIMARY KEY IDENTITY (1, 1),
CompanyName NVARCHAR(50), 
City  NVARCHAR(50), 
Country NVARCHAR(50),
PostalCode NVARCHAR(50),
validFrom DATE,
validTo DATE
);

CREATE TABLE D_Date(
D_ID INT PRIMARY KEY IDENTITY (1, 1), 
OrderDate DATE,
WeekNumber INT, 
NameOfMonth NVARCHAR(50), 
NameOfWeekday NVARCHAR(50)
);

CREATE TABLE F_Sales(
	C_ID INT REFERENCES D_Customer(C_ID),
	D_ID INT REFERENCES D_Date(D_ID),
	E_ID INT REFERENCES D_Employee(E_ID),
	P_ID INT REFERENCES D_Product(P_ID),
	LineTotal FLOAT,
	Quantity INT,
	Discount FLOAT
);


