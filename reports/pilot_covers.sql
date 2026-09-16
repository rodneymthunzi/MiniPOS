DECLARE @dclink int = (Select dclink from system)
DECLARE @unit varchar(100) = (Select COMPANY from system)
DECLARE @fromDate date = '2026-07-05'
DECLARE @toDate date = '2026-07-05'
SELECT  CAST(INVDATE as date) BusinessDate
		,@unit Unit
		,CASE WHEN @unit like '%Golden Valley%' THEN 'GV - ' WHEN @unit like '%flamingo%' THEN 'FM - ' WHEN @unit like '%Windmill%' THEN 'WM - ' END +RevCentre Outlet
		,SUM(sm.CUST) NumberOfGuest
		,'3' Source
FROM dbo.SALESDETAIL sd
JOIN dbo.SALESMASTER sm ON sd.INVDATE=sm.IDATE AND sd.OUTM=sm.OUTM
WHERE sd.INVDATE BETWEEN @fromDate AND @toDate
GROUP BY INVDATE, RevCentre