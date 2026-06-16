

DECLARE @dclink INT = (
		SELECT TOP 1 dclink
		FROM system
		);
DECLARE @company VARCHAR(100) = (
		SELECT TOP (1) Company
		FROM system
		)
DECLARE @zdate AS DATE = (
		SELECT TOP (1) Zdate
		FROM System
		);
DECLARE @tdate AS DATE;
DECLARE @V VARCHAR(100);

IF LEN(ISNULL(@key, '')) <= 0
BEGIN
	SET @key = format(dateadd(minute, - 60, getdate()), 'yyyyMMddHHmm')
	SET @V = LEFT(@key, 8) + ' ' + SUBSTRING(@key, 9, 2) + ':' + RIGHT(@key, 2);
	SET @tdate = CAST(@V AS DATETIME);
END;
ELSE
BEGIN
	SET @V = LEFT(@key, 8) + ' ' + SUBSTRING(@key, 9, 2) + ':' + RIGHT(@key, 2);
	SET @tdate = CAST(@V AS DATETIME);
END;

IF (@tdate < cast(getdate() AS DATETIME))
BEGIN
	SELECT @dclink
		,@company
		,CONVERT(DATE, id.INVDATE)
		,id.INVDATE
		,id.CASID
		,id.PLU
		,id.ITEM
		,id.PRICE
		,id.DISCNT
		,im.BDISCNT
		,id.QTY
		,im.AMOUNT
		,id.TAX
		,vp.PaymentType
		,im.TYME
		,im.INVNUM
		,id.OUTM
FROM [PilotDB].[dbo].[invtrn] id
JOIN [PilotDB].[dbo].[invtot] im 
    ON id.OUTM = im.OUTM
OUTER APPLY (
    SELECT STRING_AGG(x.PaymentType, ', ') AS PaymentType
    FROM (
        SELECT DISTINCT CASE 
            WHEN vp.INFO = 'Payment' THEN vp.VendorName
            WHEN vp.INFO LIKE 'SalesOrder%' THEN 'Uber Eats'
            ELSE vp.INFO
        END AS PaymentType
        FROM VendorPayment vp
        WHERE vp.Outm = im.OUTM
          AND vp.TranDate = im.IDATE
          AND vp.INFO <> 'tip'
    ) x
) vp
WHERE vp.PaymentType IS NOT NULL
  AND id.INVDATE >= @zdate
  AND id.INVDATE >= @tdate;
END;

