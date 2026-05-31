/*
Goal:    Creating table objects to store data.

		 tables: 
			sync.ProductCategory
			sync.Products
			sync.Purchases
			sync.SalesDetails
			sync.SaleMaster
			sync.StoreSettings
			sync.WaiterCashup

Author:  Rodney Zhou

Project: MiniPOS
*/

CREATE TABLE [sync].[ProductCategory](
	[ProdCatID] [bigint] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NOT NULL,
	[CategoryCode] [varchar](10) NOT NULL,
	[Description] [varchar](20) NOT NULL,
	[CategoryType] [varchar](4) NOT NULL,
	[Value] [numeric](10, 2) NOT NULL,
	[Tax] [numeric](10, 2) NOT NULL,
	[OpenSTK] [numeric](10, 2) NULL,
	[CloseSTK] [numeric](10, 2) NULL,
	[CCnt] [varchar](10) NOT NULL,
	[IsVisible] [bit] NOT NULL,
	[SyncUpdated] [datetime2] NOT NULL DEFAULT GETDATE(),
	[ModifiedDate] [datetime2] NULL,
	CONSTRAINT PK_ProductCategory
		PRIMARY KEY CLUSTERED([ProdCatID]),
	CONSTRAINT CHK_ProductCategory_Value
		CHECK ([Value] >=0),
	CONSTRAINT CHK_ProductCategory_Tax
		CHECK ([Tax] >=0),
	CONSTRAINT UQ_ProductCategory_Store_Category
		UNIQUE (StoreId,CategoryCode)
)
GO

CREATE TABLE [sync].[Products](
	[ProductID] [bigint] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NOT NULL,
	[ProductCode] [int] NOT NULL,
	[Cat] [char](2) NULL,
	[ProductName] [varchar](30) NULL,
	[StockSheet] [varchar](10) NULL,
	[Cost] [numeric](18, 2) NULL,
	[Cost1] [numeric](18, 2) NULL,
	[Cost2] [numeric](18, 2) NULL,
	[Cost3] [numeric](18, 2) NULL,
	[Price] [numeric](18, 2) NULL,
	[Unit] [varchar](10) NULL,
	[PackDescription] [varchar](10) NULL,
	[ReOrderLevel] [numeric](18, 4) NULL,
	[ReOrderQuantity] [numeric](18, 4) NULL,
	[BackStock] [numeric](10, 2) NULL,
	[FrontStock] [numeric](10, 2) NULL,
	[TotalStock] AS
	(
		ISNULL([BackStock],0) + ISNULL([FrontStock],0)
	) PERSISTED,
	[TotalStockValue] AS
	(
		(ISNULL([BackStock],0) + ISNULL([FrontStock],0)) * ISNULL([Cost],0)
	) PERSISTED,
	[SupplierCode] [varchar](6) NULL,
	[SupplierCode1] [varchar](6) NULL,
	[SupplierCode2] [varchar](6) NULL,
	[SyncUpdated] [datetime2] NOT NULL DEFAULT GETDATE(),
	[ModifiedDate] [datetime2] NULL,
	CONSTRAINT [PK_Products]
		PRIMARY KEY CLUSTERED ([ProductID]),
	CONSTRAINT [UQ_Products_StoreId_ProductCode] 
		UNIQUE ([StoreId],[ProductCode]),
	CONSTRAINT [CHK_Cost]
		CHECK ([Cost] IS NULL OR [Cost]>=0),
	CONSTRAINT [CHL_Price]
		CHECK ([Price] IS NULL OR [Price]>=0)
) ON [PRIMARY] 
GO

CREATE TABLE [sync].[Purchases](
	[PurchaseId] [nvarchar](255) NOT NULL,
	[StoreId] [int] NOT NULL,
	[SupplierId] [int] NOT NULL,
	[SupplierName] [varchar](255) NOT NULL,
	[SupplierReference] [varchar](255) NOT NULL,
	[PaymentType] [varchar](50) NULL,
	[PurchaseDate] [date] NOT NULL,
	[PurchaseReference] [varchar](255) NOT NULL,
	[Cost] [decimal](18, 2) NOT NULL,
	[Vat] [decimal](18, 2) NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[SyncUpdated] [datetime] NOT NULL,
	[Data] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Purchases_StoreId_Key] PRIMARY KEY CLUSTERED 
([StoreId] ASC,[PurchaseId] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [sync].[SalesDetail](
	[StoreId] [varchar](100) NOT NULL,
	[LineId] [varchar](100) NOT NULL,
	[OrderId] [nvarchar](255) NOT NULL,
	[PluCode] [varchar](100) NOT NULL,
	[ItemName] [varchar](255) NOT NULL,
	[Quantity] [int] NOT NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[Total] [decimal](18, 2) NULL,
	[Tax] [decimal](18, 2) NULL,
	[TaxCode] [varchar](50) NULL,
	[OrderMessages] [varchar](max) NULL,
	[IsItemOrdered] [bit] NOT NULL,
	[StatusId] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[TradingDate] [datetime] NULL,
 CONSTRAINT [PK_SalesDetail_StoreId_Key] PRIMARY KEY CLUSTERED 
(
	[StoreId] ASC,
	[LineId] ASC
)
) ON [PRIMARY] 
GO

CREATE TABLE [sync].[SalesMaster](
	[OrderId] [nvarchar](255) NOT NULL,
	[RequestId] [varchar](100) NULL,
	[VendorId] [varchar](100) NOT NULL,
	[SiteId] [int] NOT NULL,
	[BillStatus] [int] NOT NULL,
	[TotalAmount] [decimal](18, 2) NOT NULL,
	[DiscountAmount] [decimal](18, 2) NOT NULL,
	[Payments] [decimal](18, 2) NOT NULL,
	[Tip] [decimal](18, 2) NULL,
	[Timestamp] [datetime] NOT NULL,
	[TaxTotal] [decimal](18, 2) NOT NULL,
	[Covers] [int] NULL,
	[OrderType] [varchar](50) NULL,
	[OrderReference] [varchar](100) NULL,
	[OrderDate] [datetime] NULL,
	[TradingDate] [datetime] NULL,
	[SubBrand] [varchar](100) NULL,
	[NumberOfGuests] [int] NULL,
	[DeviceId] [varchar](100) NULL,
	[TableNumber] [varchar](50) NULL,
	[CashierId] [varchar](100) NULL,
	[TransactionId] [varchar](100) NULL,
	[CustomerAccountId] [varchar](100) NULL,
	[CustomerName] [varchar](255) NULL,
	[CustomerEmail] [varchar](255) NULL,
	[CustomerContactNumber] [varchar](50) NULL,
	[CustomerStreetAddress] [varchar](255) NULL,
	[CustomerCity] [varchar](100) NULL,
	[CustomerRegion] [varchar](100) NULL,
	[CustomerCountry] [varchar](100) NULL,
	[CustomerPostalCode] [varchar](50) NULL,
	[CustomerLatitude] [decimal](9, 6) NULL,
	[CustomerLongitude] [decimal](9, 6) NULL,
	[StatusId] [int] NOT NULL,
	[InvoiceNumber] [int] NOT NULL,
 CONSTRAINT [PK_SalesMaster_StoreId_Key] PRIMARY KEY CLUSTERED 
(
	[SiteId] ASC,
	[OrderId] ASC
)) ON [PRIMARY]
GO

CREATE TABLE [sync].[StoreSettings](
	[StoreId] [int] NOT NULL,
	[TradingDate] [date] NULL,
	[Active] [int] NOT NULL,
	[ImageUrl] [nvarchar](255) NOT NULL,
	[StoreName] [nvarchar](100) NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [sync].[WaiterCashup](
	[CashupId] [varchar](100) NULL,
	[TradingDate] [datetime] NOT NULL,
	[StoreId] [int] NOT NULL,
	[WaitronId] [int] NULL,
	[WaiterName] [varchar](100) NULL,
	[CashupTo] [varchar](100) NULL,
	[SalesIncl] [decimal](18, 2) NOT NULL,
	[NonTurnover] [decimal](18, 2) NOT NULL,
	[SubTotal] [decimal](18, 2) NOT NULL,
	[Tender] [decimal](18, 2) NOT NULL,
	[ApprovedPayments] [decimal](18, 2) NOT NULL,
	[PayCommission] [decimal](18, 2) NOT NULL,
	[RetainedTips] [decimal](18, 2) NOT NULL,
	[CashDue] [decimal](18, 2) NOT NULL,
	[CommissionPercentage] [decimal](18, 2) NOT NULL,
	[Commission] [decimal](18, 2) NOT NULL,
	[ExcludedCommission] [decimal](18, 2) NOT NULL,
	[Voids] [int] NOT NULL,
	[ItemDiscounts] [decimal](18, 2) NOT NULL,
	[BillDiscounts] [decimal](18, 2) NOT NULL,
	[TableCount] [int] NOT NULL,
	[SplitCount] [int] NOT NULL,
	[CreditCardCount] [int] NOT NULL,
	[CashupDate] [datetime] NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [sync].[Waitrons](
	[StoreId] [int] NOT NULL,
	[WaitronId] [int] NOT NULL,
	[WaitronName] [varchar](255) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [sync].[Purchases] ADD  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [sync].[Purchases] ADD  DEFAULT (getdate()) FOR [DateUpdated]
GO
ALTER TABLE [sync].[SalesDetail] ADD  DEFAULT ((0)) FOR [IsItemOrdered]
GO
ALTER TABLE [sync].[SalesDetail] ADD  DEFAULT ((0)) FOR [StatusId]
GO
ALTER TABLE [sync].[SalesDetail] ADD  DEFAULT (getdate()) FOR [OrderDate]
GO
ALTER TABLE [sync].[SalesMaster] ADD  DEFAULT (getdate()) FOR [Timestamp]
GO
ALTER TABLE [sync].[SalesMaster] ADD  DEFAULT ((0)) FOR [StatusId]
GO
ALTER TABLE [sync].[WaiterCashup] ADD  DEFAULT (getdate()) FOR [TradingDate]
GO
