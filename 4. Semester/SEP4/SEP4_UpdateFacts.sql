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
