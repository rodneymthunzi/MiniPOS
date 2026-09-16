DECLARE @dclink INT = (SELECT TOP 1 dclink FROM SYSTEM)
DECLARE @unit VARCHAR(100) = (SELECT COMPANY FROM SYSTEM)
DECLARE @fromDate DATE = '2026-07-05'
DECLARE @toDate DATE = '2026-07-05'

SELECT 
	CAST(INVDATE as date) BusinessDate
	,@unit Unit
	,CASE 
		WHEN @unit like '%Golden Valley%' THEN 'GV - ' 
		WHEN @unit like '%flamingo%' THEN 'FM - ' 
		WHEN @unit like '%Windmill%' THEN 'WM - ' 
	END +RevCentre Outlet
	,sd.CASID
	,sd.PLU
	,sd.ITEM MenuItemName
	,sd.CostCentre
	,sd.DTAB
	,SUM(sd.VALUE - sd.DISCNT) Amount
	,sd.PDEST
	,CASE 
		WHEN CAST(LEFT(sd.PDEST,2) AS INT) BETWEEN 5 AND 10  THEN 'Breakfast'
		WHEN CAST(LEFT(sd.PDEST,2) AS INT) BETWEEN 11 AND 15 THEN 'Lunch'
		WHEN CAST(LEFT(sd.PDEST,2) AS INT) BETWEEN 16 AND 22 THEN 'Dinner'
		ELSE 'Late Night'
	 END DayPart
	,SUM(sd.VALUE) SalesTotsl
	,SUM(sd.DISCNT) DiscntTotal
	,CASE WHEN sd.TAX<>0 THEN 1 ELSE 0 END ApplyVAT
	,'3' Source
FROM dbo.SALESDETAIL sd
JOIN dbo.casname c ON c.CASID=sd.CASID
WHERE sd.INVDATE BETWEEN @fromDate AND @toDate AND sm.DTAB <> 'MODIFY'
GROUP BY INVDATE,RevCentre,sd.CASID,sd.PLU,sd.ITEM,sd.CostCentre,sd.DTAB
		,sd.PDEST,CASE WHEN sd.TAX<>0 THEN 1 ELSE 0 END
ORDER BY CAST(INVDATE as date),sd.PDEST
