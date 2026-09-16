DECLARE @dclink INT = (SELECT TOP 1 dclink FROM SYSTEM)
DECLARE @unit VARCHAR(100) = (SELECT COMPANY FROM SYSTEM)
DECLARE @fromDate DATE = '2026-07-05'
DECLARE @toDate DATE = '2026-07-05'

SELECT 
	CAST(TranDate As Date) BusinessDate
	,@unit Unit
	,CASE 
		WHEN @unit like '%Golden Valley%' THEN 'GV - ' WHEN @unit like '%flamingo%' THEN 'FM - ' 
		WHEN @unit like '%Windmill%' THEN 'WM - ' END + RevCentre Outlet
	,vp.CasName Waitron
	,vp.Amount
	,vp.Info TenderMediaType
	,CASE 
		WHEN DATEPART(HOUR, timestamp) BETWEEN 5 AND 10  THEN 'Breakfast'
		WHEN DATEPART(HOUR, timestamp) BETWEEN 11 AND 15 THEN 'Lunch'
		WHEN DATEPART(HOUR, timestamp) BETWEEN 16 AND 22 THEN 'Dinner'
		ELSE 'Late Night'
	 END DayPart
	 ,'3' Source
FROM dbo.VendorPayment vp
JOIN SALESDETAIL sm ON sm.INVDATE=vp.TranDate AND sm.OUTM=vp.Outm
WHERE vp.TranDate BETWEEN @fromDate AND @toDate AND Info not like '%tip%'
ORDER BY timestamp
