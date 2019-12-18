----select * from measurement order by Date_Inserted desc

--Select * from DW_F_Data where S_ID = 1

--select * from DW_D_Measurement where SensorID = 2 order by MeasureTimestamp desc

--select m.* from DW_F_Data df
--join DW_D_Calendar c on c.D_ID = df.D_ID
--join DW_D_Measurement m on m.M_ID = df.M_ID
--Where m.M_ID = 27

--select * from DW_D_Measurement where MeasureTimestamp = '2019-12-13'
--select * from DW_D_Measurement where MeasureTimestamp = '2019-12-12 01:14:03.247'
--Select AVG(DataValue) as Average, 
--	CONVERT(date, MeasureTimestamp) as dateTimestamp
--	from DW_D_Measurement where SensorID in 
--	(   
--		Select SensorID from DW_D_Sensor where WineCellarID = 1 
--	)   
--	and DataName  = 'CO2'
--	GROUP BY CONVERT(date, MeasureTimestamp) 


--SELECT a.Average FROM 
--(
--	Select AVG(DataValue) as Average, 
--	CONVERT(date, MeasureTimestamp) as dateTimestamp
--	from DW_D_Measurement where SensorID in 
--	(   
--		Select SensorID from DW_D_Sensor where WineCellarID = 1 
--	)   
--	and DataName  = 'CO2'
--	GROUP BY CONVERT(date, MeasureTimestamp) 
--	--ORDER BY dateTimestamp desc
--) a, DW_D_Calendar c
--WHERE CONVERT(date, c.EntireDateInserted) = a.dateTimestamp

--SELECT a.Average FROM 
--(
--	Select AVG(DataValue) as Average, 
--	CONVERT(date, MeasureTimestamp) as dateTimestamp
--	from DW_D_Measurement where SensorID in 
--	(   
--		Select SensorID from DW_D_Sensor where WineCellarID = 1 
--	)   
--	and DataName  = 'Temperature'
--	GROUP BY CONVERT(date, MeasureTimestamp) 
--	--ORDER BY dateTimestamp desc
--) a, DW_D_Calendar c
--WHERE CONVERT(date, c.EntireDateInserted) = a.dateTimestamp


--JOIN DW_D_Calendar c on CONVERT(date,c.EntireDateInserted) = a.dateTimestamp
--WHERE a.dateTimestamp = '2019-12-15'


Update 
	DW_F_Data 
Set 
	DailyAverageCO2 = (
		SELECT DISTINCT a.Average FROM 
		(
			Select AVG(DataValue) as Average, 
			CONVERT(date, MeasureTimestamp) as dateTimestamp
			from DW_D_Measurement where SensorID in 
			(   
				Select SensorID from DW_D_Sensor where WineCellarID = 1 
			)   
			and DataName  = 'CO2'
			GROUP BY CONVERT(date, MeasureTimestamp) 
		) a, DW_D_Measurement m
		WHERE m.M_ID = DW_F_Data.M_ID
		AND CONVERT(date, m.MeasureTimestamp) = a.dateTimestamp
	),
	DailyAverageTemperature = (
		SELECT DISTINCT a.Average FROM 
		(
			Select AVG(DataValue) as Average, 
			CONVERT(date, MeasureTimestamp) as dateTimestamp
			from DW_D_Measurement where SensorID in 
			(   
				Select SensorID from DW_D_Sensor where WineCellarID = 1 
			)   
			and DataName  = 'Temperature'
			GROUP BY CONVERT(date, MeasureTimestamp) 
		) a, DW_D_Measurement m
		WHERE m.M_ID = DW_F_Data.M_ID
		AND CONVERT(date, m.MeasureTimestamp) = a.dateTimestamp
	),
	DailyAverageHumidity = (
		SELECT DISTINCT a.Average FROM 
		(
			Select AVG(DataValue) as Average, 
			CONVERT(date, MeasureTimestamp) as dateTimestamp
			from DW_D_Measurement where SensorID in 
			(   
				Select SensorID from DW_D_Sensor where WineCellarID = 1 
			)   
			and DataName  = 'Humidity'
			GROUP BY CONVERT(date, MeasureTimestamp) 
		) a, DW_D_Measurement m
		WHERE m.M_ID = DW_F_Data.M_ID
		AND CONVERT(date, m.MeasureTimestamp) = a.dateTimestamp
	)
