use sep4
go
DROP TABLE DW_Update;
DROP TABLE DW_F_Date;
DROP TABLE DW_Sensor;
DROP TABLE DW_Calendar;
DROP TABLE DW_WineCellar;
DROP TABLE DW_Measurement;

CREATE TABLE DW_D_Measurement(
M_ID INT PRIMARY KEY, 
MeasureID INT,
CO2Value INT,
TemperatureValue INT,
HumidityValue INT,
MeasureTimestamp Datetime
);

CREATE TABLE DW_D_WineCellar(
W_ID INT PRIMARY KEY, 
WineCellarID INT,
CellarName NVARCHAR(50) 
);

CREATE TABLE DW_D_Calendar(
C_ID INT PRIMARY KEY, 
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
WineCellarID INT
);

CREATE TABLE DW_F_Date(
	C_ID INT REFERENCES DW_D_Calendar(C_ID),
	S_ID INT REFERENCES DW_D_Sensor(S_ID),
	W_ID INT REFERENCES DW_D_WineCellar(W_ID),
	M_ID INT REFERENCES DW_D_Measurement(M_ID),
	LineTotal FLOAT,
	Quantity INT,
	Discount FLOAT
);

CREATE TABLE DW_Update(
	Last_updated Date
)