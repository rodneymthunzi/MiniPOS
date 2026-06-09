/*
Goal:    Creating schema objects to serve various functions.

         rpt: Reporting
         sync: Data sync
         loadData: Loading data
         dim: Dimensions
         fact: Fact tables

Author:  Rodney Zhou

Project: MiniPOS
*/

/* For GP reports*/
CREATE INDEX IX_Products_TotalStock
ON sync.Products(TotalStock)

CREATE INDEX IX_Products_Category_Stock
ON sync.Products(StoreId,Cat,TotalStock)

CREATE INDEX IX_Products_Category 
    ON sync.Products(StoreId,Description)

/* For GP reports*/


/* For GP reports*/


/* For GP reports*/


/* For GP reports*/


/* For GP reports*/


