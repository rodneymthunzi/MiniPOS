DECLARE @dclink INT = (SELECT TOP 1 dclink FROM SYSTEM)
DECLARE @unit VARCHAR(100) = (SELECT COMPANY FROM SYSTEM)
DECLARE @fromDate date = '2026-07-05'
DECLARE @toDate date = '2026-07-05'

DECLARE @tableName VARCHAR(50) = 'CVH' + FORMAT(@fromDate, 'MMMyy')
DECLARE @sql NVARCHAR(MAX)

IF OBJECT_ID(@tableName, 'U') IS NOT NULL
BEGIN
	SET @sql = N'
	SELECT FORMAT(cvh.[VDATE],''yyyy-MM-dd'') BusinessDate
		,@unitParam Unit
		,CASE WHEN @unitParam like ''%Golden Valley%'' THEN ''GV - '' WHEN @unitParam like ''%flamingo%'' THEN ''FM - '' WHEN @unitParam like ''%Windmill%'' THEN ''WM - '' END +RevCentre Outlet2
		,(cvh.[REASON]+''_''+cvh.[SUBREASON]) [NAME]
		,SUM(cvh.[AMOUNT]) DiscountTotal
		,COUNT(cvh.[REASON]+''_''+cvh.[SUBREASON]) DiscountCount
		,''3'' Source
	FROM ' + QUOTENAME(@tableName) + N' cvh 
	JOIN SALESDETAIL sd ON sd.INVDATE=cvh.VDATE AND sd.OUTM=cvh.OUTM
	WHERE cvh.[VDATE] BETWEEN @fromDateParam AND @toDateParam
	GROUP BY FORMAT(cvh.[VDATE],''yyyy-MM-dd''),(cvh.[REASON]+''_''+cvh.[SUBREASON]),sd.RevCentre'

	EXEC sp_executesql @sql
		,N'@unitParam VARCHAR(100), @fromDateParam DATE, @toDateParam DATE'
		,@unitParam = @unit
		,@fromDateParam = @fromDate
		,@toDateParam = @toDate
END