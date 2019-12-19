select count(*) from DW_D_Measurement --order by MeasureTimestamp desc
select count(*) from DW_F_Data 

select * from DW_D_Measurement

SELECT FD.* --, M.validTo
--M.M_ID, S.SensorID, W.WinecellarID, C.EntireDateInserted
From DW_F_Data FD
JOIN SEP4.dbo.DW_D_Sensor S on S.S_ID = FD.S_ID
JOIN SEP4.dbo.DW_D_WineCellar W on W.W_ID = FD.W_ID
JOIN SEP4.dbo.DW_D_Measurement M on M.M_ID = FD.M_ID
JOIN SEP4.dbo.DW_D_Calendar C on C.D_ID = FD.D_ID
ORDER BY M.validTo desc

WHERE M.validTo > DATEADD(day,1,GETDATE())