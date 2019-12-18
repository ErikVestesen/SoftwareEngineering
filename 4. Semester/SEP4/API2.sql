DECLARE @roomLocation nvarchar(50)
DECLARE @wineCellarId int

set @wineCellarId = 1;
set @roomLocation = 'Basement'

Select distinct RoomLocation from DW_D_Sensor where WineCellarID = 1;

--Return the current value of CO2 in a certain room, in a certain cellar
Select * from DW_D_Measurement 
where SensorID in ( 
	Select SensorID from DW_D_Sensor where WineCellarID = @wineCellarId and RoomLocation = @roomLocation
	)
and DataName  = 'CO2' and MeasureTimestamp >= DATEADD(day, -1, GETDATE())
order by MeasureTimestamp desc

