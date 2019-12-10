USE sep4
go
--TODO (for initial load):

--discuss fact table values... only got ids right now

--Update calendar surrogate key, missing an ID
--Fill data warehouse fact

--Entire incremential load stuff, not now plz

-----------------------
---Create Dimensions---
-----------------------
DROP TABLE DW_Update;
DROP TABLE DW_F_Data;
DROP TABLE DW_D_Sensor;
DROP TABLE DW_D_Calendar;
DROP TABLE DW_D_WineCellar;
DROP TABLE DW_D_Measurement;

CREATE TABLE DW_D_Measurement(
M_ID INT PRIMARY KEY, 
MeasureID INT,
CO2Value INT,
TemperatureValue INT,
HumidityValue INT,
MeasureTimestamp Datetime,
validFrom DATE,
validTo DATE
);

CREATE TABLE DW_D_WineCellar(
W_ID INT PRIMARY KEY, 
WineCellarID INT,
CellarName NVARCHAR(50),
validFrom DATE,
validTo DATE
);

CREATE TABLE DW_D_Calendar(
D_ID INT PRIMARY KEY, 
DD_inserted INT,
MM_inserted INT,
YYYY_inserted INT,
HH24_inserted INT,
MM60_inserted INT,
WeekNumber_inserted INT, 
NameOfMonth_inserted NVARCHAR(50), 
NameOfWeekday_inserted NVARCHAR(50)
);


CREATE TABLE DW_D_Sensor(
S_ID INT PRIMARY KEY,
SensorID INT,
SensorName NVARCHAR(50),
RoomLocation NVARCHAR(50), 
MeasureID INT,
WineCellarID INT,
validFrom DATE,
validTo DATE
);

CREATE TABLE DW_F_Data(
	D_ID INT REFERENCES DW_D_Calendar(D_ID),
	S_ID INT REFERENCES DW_D_Sensor(S_ID),
	W_ID INT REFERENCES DW_D_WineCellar(W_ID),
	M_ID INT REFERENCES DW_D_Measurement(M_ID)
);

CREATE TABLE DW_Update(
	Last_updated Date
)
--Insert last updated date into table
INSERT INTO DW_Update(Last_updated) select CAST(GETDATE() as date)

-----------
---Stage---
-----------
DROP TABLE Stage_Sensor;
DROP TABLE Stage_Calendar;
DROP TABLE Stage_WineCellar;
DROP TABLE Stage_Measurement;

CREATE TABLE Stage_Measurement(
M_ID INT PRIMARY KEY IDENTITY (1, 1), 
MeasureID INT,
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

CREATE TABLE Stage_Calendar(
C_ID INT PRIMARY KEY IDENTITY (1, 1), 
DD_inserted INT,
MM_inserted INT,
YYYY_inserted INT,
HH24_inserted INT,
MM60_inserted INT,
WeekNumber_inserted INT, 
NameOfMonth_inserted NVARCHAR(50), 
NameOfWeekday_inserted NVARCHAR(50)
);


CREATE TABLE Stage_Sensor(
S_ID INT PRIMARY KEY IDENTITY (1, 1),
SensorID INT,
SensorName NVARCHAR(50),
RoomLocation NVARCHAR(50), 
MeasureID INT,
WineCellarID INT
);

----------------
---Fill Stage---
----------------

--Stage Measurement
INSERT INTO Stage_Measurement(MeasureID,CO2Value, TemperatureValue,HumidityValue,MeasureTimestamp)
SELECT MeasureID,CO2Value, TemperatureValue,HumidityValue,MeasureTimestamp
FROM sep4.dbo.Measurement

--Stage WineCellar
INSERT INTO Stage_WineCellar(WineCellarID,CellarName)
SELECT WineCellarID,CellarName
FROM sep4.dbo.WineCellar

--Stage Sensor
INSERT INTO Stage_Sensor(SensorID,SensorName,RoomLocation,MeasureID,WineCellarID)
SELECT SensorID,SensorName,RoomLocation,MeasurementID,WineCellarID
FROM sep4.dbo.Sensor
---Fill stage Calendar when discussed---
INSERT INTO Stage_Calendar(DD_inserted,MM_inserted,YYYY_inserted,HH24_inserted,MM60_inserted,WeekNumber_inserted,NameOfMonth_inserted, NameOfWeekday_inserted)
Select DAY(m.MeasureTimestamp),MONTH(m.MeasureTimestamp),YEAR(m.MeasureTimestamp),DATEPART(HOUR,m.MeasureTimestamp),
DATEPART(MINUTE,m.MeasureTimestamp), DATEPART(week, m.MeasureTimestamp), DATENAME(month, m.MeasureTimestamp), DATENAME(WEEKDAY, m.MeasureTimestamp)
FROM sep4.dbo.Measurement m

----------------
---Stage Fact---
----------------
DROP TABLE Stage_Fact_Data;
CREATE TABLE Stage_Fact_Data(
M_ID int NULL, --Measurement ID
W_ID int NULL, --winecellar ID
S_ID int NULL, --sensor id
D_ID int NULL, --date id
MeasureID int NULL,
SensorID int NULL,
WineCellarID int NULL
);

---------------------
---Fill Stage fact---
---------------------
INSERT INTO Stage_Fact_Data 
(MeasureID, SensorID, WineCellarID)
SELECT
M.MeasureID, S.SensorID, W.WinecellarID
From SEP4.dbo.Stage_Sensor S
JOIN SEP4.dbo.Stage_WineCellar W on W.WineCellarID = S.WineCellarID
JOIN SEP4.dbo.Stage_Measurement M on M.MeasureID = S.MeasureID

------------------------------------
---Fill Data warehouse Dimensions---
------------------------------------
DECLARE @endTime date;
DECLARE @now date;
set @endTime = '2099/01/01'
set @now = (select max(Last_updated) from DW_Update)

--Calendar
INSERT INTO DW_D_Calendar(D_ID, DD_inserted,MM_inserted,YYYY_inserted,HH24_inserted,MM60_inserted,WeekNumber_inserted,NameOfMonth_inserted, NameOfWeekday_inserted)
SELECT C_ID, DD_inserted,MM_inserted,YYYY_inserted,HH24_inserted,MM60_inserted,WeekNumber_inserted,NameOfMonth_inserted, NameOfWeekday_inserted
FROM Stage_Calendar

--WineCellar
INSERT INTO DW_D_WineCellar(W_ID,WineCellarID,CellarName,validFrom, validTo)
SELECT W_ID,WineCellarID,CellarName, @now, @endTime
FROM Stage_WineCellar

--Measurement
INSERT INTO DW_D_Measurement(M_ID,MeasureID,CO2Value, TemperatureValue,HumidityValue,MeasureTimestamp, validFrom, validTo)
SELECT M_ID,MeasureID,CO2Value, TemperatureValue,HumidityValue,MeasureTimestamp, @now, @endTime
FROM Stage_Measurement

--Sensor
INSERT INTO DW_D_Sensor(S_ID,SensorID,SensorName,RoomLocation,MeasureID,WineCellarID, validFrom, validTo)
SELECT S_ID,SensorID,SensorName,RoomLocation,MeasureID,WineCellarID, @now, @endTime
FROM Stage_Sensor

---------------------------
---Update surrogate keys---
---------------------------
----WineCellar
UPDATE Stage_Fact_Data
SET W_ID = (
	SELECT W_ID 
	FROM DW_D_WineCellar w 
	WHERE w.WineCellarID = Stage_Fact_Data.WineCellarID
)

----Measurement
UPDATE Stage_Fact_Data
SET M_ID = (
	SELECT M_ID 
	FROM DW_D_Measurement m
	WHERE m.MeasureID = Stage_Fact_Data.MeasureID
)

----Sensor
UPDATE Stage_Fact_Data
SET S_ID = (
	SELECT S_ID 
	FROM DW_D_Sensor s
	WHERE s.SensorID = Stage_Fact_Data.SensorID
)


----Calendar
--UPDATE Stage_Fact_Data
--SET D_ID = (
--	SELECT D_ID
--	FROM DW_D_Calendar c 
--	WHERE c. = Stage_Fact_Data.
--)




------------------------------
---Fill Data warehouse fact---
------------------------------
INSERT INTO DW_F_Data(S_ID, W_ID, M_ID, D_ID)
SELECT S_ID, W_ID, M_ID, D_ID 
FROM Stage_Fact_Data

--Testing stuff, remove me later plz
Select * from Stage_fact_data
--Select * from Stage_Measurement
--Select * from Stage_Sensor
--Select * from Stage_WineCellar
--Select * from Stage_Calendar

Select * from DW_F_Data