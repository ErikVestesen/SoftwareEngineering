USE 
go

--TODO (for initial load):
--Discuss Sensor entities in source database
--Create dimensions
--Fill dimensions
--Fill stage calendar
--Fill stage fact
--Fill data warehouse fact

--Entire incremential load stuff, not now plz

-----------------------
---Create Dimensions---
-----------------------

--TODO, Do not create identity (1,1) on the dimensions because the stage dimensions already got this.

-----------
---Stage---
-----------
DROP TABLE Stage_Sensor;
--DROP TABLE Stage_Calendar;
DROP TABLE Stage_WineCellar;
DROP TABLE Stage_Measurement;

CREATE TABLE Stage_Measurement(
M_ID INT PRIMARY KEY IDENTITY (1, 1), 
MeasurementID INT,
CO2Value INT,
TemperatureValue INT,
HumidityValue INT,
MeasureTimestamp Datetime
);

CREATE TABLE Stage_WineCellar(
W_ID INT PRIMARY KEY IDENTITY (1, 1), 
WineCellarID INT,
CellarName NVARCHAR(50) 
);

--CREATE TABLE Stage_Calendar(
--CalendarID INT PRIMARY KEY IDENTITY (1, 1), 
--DD_inserted INT,
--MM_inserted INT,
--YYYY_inserted INT,
--HH24_inserted INT,
--MM60_inserted INT,
--WeekNumber_inserted INT, 
--NameOfMonth_inserted NVARCHAR(50), 
--NameOfWeekday_inserted NVARCHAR(50)
--);


CREATE TABLE Stage_Sensor(
S_ID INT PRIMARY KEY IDENTITY (1, 1),
SensorID INT,
RoomLocation NVARCHAR(50),
CalendarID INT, 
MeasurementID INT,
WineCellarID INT
);

----------------
---Fill Stage---
----------------

--Stage Measurement
INSERT INTO Stage_Measurement(MeasurementID,CO2Value, TemperatureValue,HumidityValue,MeasureTimestamp)
SELECT MeasurementID,CO2Value, TemperatureValue,HumidityValue,MeasureTimestamp
FROM SEP4.dbo.Stage_Measurement -- change me to source database

--Stage WineCellar
INSERT INTO Stage_WineCellar(WineCellarID,CellarName)
SELECT WineCellarID,CellarName
FROM SEP4.dbo.Stage_WineCellar -- change me to source database

--Stage Sensor
INSERT INTO Stage_Sensor(SensorID,RoomLocation, CalendarID,MeasurementID,WineCellarID)
SELECT SensorID,RoomLocation, CalendarID,MeasurementID,WineCellarID
FROM SEP4.dbo.Stage_Sensor -- change me to source database

---Fill stage Calendar when discussed---

----------------
---Stage Fact---
----------------
DROP TABLE Stage_fact_data;
CREATE TABLE Stage_fact_data(
[M_ID] [int] NULL, --Measurement ID
[C_ID] [int] NULL, --cellar ID
[S_ID] [int] NULL, --sensor id
[D_ID] [int] NULL, --date id
[MeasurementID] [int] NULL,
[SensorID] [int] NULL,
[WineCellarID] [int] NULL
);

---------------------
---Fill Stage fact---
---------------------
INSERT INTO Stage_fact_data 
(MeasurementID, SensorID, WineCellarID)
SELECT
M.MeasurementID, S.SensorID, W.WinecellarID
From SEP4.dbo.Stage_Sensor S
JOIN SEP4.dbo.Stage_WineCellar W on W.WineCellarID = S.WineCellarID
JOIN SEP4.dbo.Stage_Measurement M on M.MeasurementID = S.MeasurementID

------------------------------------
---Fill Data warehouse Dimensions---
------------------------------------

--TODO

---------------------------
---Update surrogate keys---
---------------------------
--Use StageNorthwind

----WineCellar
--UPDATE Stage_fact_data
--SET C_ID = (
--	SELECT E_ID 
--	FROM Stage_fact_data --change me to source database (Winecellar table)
--	WHERE e.E_ID = Stage_F_sales.EmployeeID
--)

----Measurement
--UPDATE Stage_fact_data
--SET M_ID = (
--	SELECT P_ID 
--	FROM Stage_fact_data --change me to source database (Measurement table)
--	WHERE p.P_ID = Stage_F_sales.ProductID
--)

----Calendar
--UPDATE Stage_fact_data
--SET D_ID = (
--	SELECT Top 1 (d.D_ID)
--	FROM Stage_fact_data --change me to source database (Calendar table)
--	WHERE d.EntireDate = Stage_F_sales.OrderDateID
--)

----Sensor
--UPDATE Stage_fact_data
--SET S_ID = (
--	SELECT Top 1 (d.D_ID)
--	FROM Stage_fact_data --change me to source database (sensor table) 
--	WHERE d.EntireDate = Stage_F_sales.OrderDateID
--)


------------------------------
---Fill Data warehouse fact---
------------------------------

--TODO