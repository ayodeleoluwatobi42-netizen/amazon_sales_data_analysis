/*
==========================================================
Amazon E-commerce Sales Analysis
==========================================================

Project: E-commerce Sales Analysis
Database: E_commerceDB
Tool: Microsoft SQL Server

Description:
Analysis of Amazon e-commerce sales data to identify
sales patterns, product performance, order trends,
and other business insights.
==========================================================
Author: MIRACLE
==========================================================
*/

USE E_commerceDB;
-- =====================================================
-- PHASE 1: DATA VALIDATION
-- =====================================================
/*Total_number of records */
SELECT COUNT(*) AS total_records
FROM [dbo].[Amazon Sale Report];
/* phase_2 ; Inspect the Dataset */
SELECT TOP 10 * FROM  [dbo].[Amazon Sale Report];
/* check columns and data types */
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Amazon Sale Report'
ORDER BY ORDINAL_POSITION;
/* Check Missing Values */
SELECT
    COUNT(*) AS total_records,
    COUNT(*) - COUNT([Order_ID]) AS missing_order_id,
    COUNT(*) - COUNT([Date]) AS missing_date,
    COUNT(*) - COUNT([Status]) AS missing_status,
    COUNT(*) - COUNT([Fulfilment]) AS missing_fulfilment,
    COUNT(*) - COUNT([Category]) AS missing_category,
    COUNT(*) - COUNT([Qty]) AS missing_qty,
    COUNT(*) - COUNT([Amount]) AS missing_amount,
    COUNT(*) - COUNT([ship_city]) AS missing_ship_city,
    COUNT(*) - COUNT([ship_state]) AS missing_ship_state,
    COUNT(*) - COUNT([ship_postal_code]) AS missing_postal_code,
    COUNT(*) - COUNT([ship_country]) AS missing_ship_country
FROM [dbo].[Amazon Sale Report];
-- Task 5: Check for Duplicate Records--
SELECT
    [Order_ID],
    COUNT(*) AS duplicate_count
FROM [dbo].[Amazon Sale Report]
GROUP BY [Order_ID]
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
-- =====================================================
-- PHASE 2: SALES PERFORMANCE
-- =====================================================
/* total orders of unique orders */
SELECT
    COUNT(DISTINCT [Order_ID]) AS total_orders
FROM [dbo].[Amazon Sale Report];
/* total quantity sold */
SELECT
 SUM([Qty]) AS total_Amount
FROM [dbo].[Amazon Sale Report];
-- Sales by Category--
SELECT
    [Category],
    SUM([Amount]) AS total_sales
FROM [dbo].[Amazon Sale Report]
WHERE [Amount] IS NOT NULL
GROUP BY [Category]
ORDER BY total_sales DESC;
-- Task 9: Sales by SKU --
SELECT
    [SKU],
    SUM([Amount]) AS total_sales
FROM [dbo].[Amazon Sale Report]
WHERE [Amount] IS NOT NULL
GROUP BY [SKU]
ORDER BY total_sales DESC;
-- total sales by date
SELECT
[Date],
SUM ([Amount]) AS total_sales_by_Date
FROM [Amazon Sale Report]
WHERE ([Amount]) IS NOT NULL
GROUP BY [Date]
ORDER BY [Date];
--  Monthly Sales Trend--
SELECT
    YEAR([Date]) AS sales_year,
    MONTH([Date]) AS sales_month,
    SUM([Amount]) AS total_sales
FROM [dbo].[Amazon Sale Report]
WHERE [Amount] IS NOT NULL
GROUP BY
    YEAR([Date]),
    MONTH([Date])
ORDER BY
    sales_year,
    sales_month;
  -- =====================================================
-- PHASE 3: GEOGRAPHIC ANALYSIS
-- =====================================================

-- Sales by  ship_state--
SELECT
    [ship_state],
    SUM([Amount]) AS total_sales
FROM [dbo].[Amazon Sale Report]
WHERE [Amount] IS NOT NULL
GROUP BY [ship_state]
ORDER BY total_sales DESC; 
-- total sales by ship_city--
SELECT
    ship_city,
    SUM([Amount]) AS total_sales
FROM [dbo].[Amazon Sale Report]
WHERE [Amount] IS NOT NULL
GROUP BY [ship_city]
ORDER BY total_sales DESC;
-- Task 14: Top 10 Geographic Markets--
SELECT TOP 10
    [ship_city],
    [ship_state],
    SUM([Amount]) AS total_sales
FROM [dbo].[Amazon Sale Report]
WHERE [Amount] IS NOT NULL
GROUP BY
    [ship_city],
    [ship_state]
ORDER BY total_sales DESC;
-- =====================================================
-- PHASE 4: ORDER & FULFILLMENT ANALYSIS
-- =====================================================

--  Fulfillment Methods--
SELECT
    [Fulfilment],
    COUNT(DISTINCT [Order_ID]) AS total_orders
FROM [dbo].[Amazon Sale Report]
GROUP BY [Fulfilment]
ORDER BY total_orders DESC;
--  Order Status--
SELECT
    [Status],
    COUNT(DISTINCT [Order_ID]) AS total_orders
FROM [dbo].[Amazon Sale Report]
GROUP BY [Status]
ORDER BY total_orders DESC;
--Cancellation Rate--
SELECT
    COUNT(DISTINCT [Order_ID]) AS total_orders,

    COUNT(DISTINCT CASE
        WHEN [Status] LIKE '%Cancel%'
        THEN [Order_ID]
    END) AS cancelled_orders,

    CAST(
        COUNT(DISTINCT CASE
            WHEN [Status] LIKE '%Cancel%'
            THEN [Order_ID]
        END) * 100.0
        / NULLIF(COUNT(DISTINCT [Order_ID]), 0)
        AS DECIMAL(5,2)
    ) AS cancellation_rate_percent

FROM [dbo].[Amazon Sale Report];
--  Cancellations by Category--
SELECT
    [Category],
    COUNT(DISTINCT [Order_ID]) AS cancelled_orders
FROM [dbo].[Amazon Sale Report]
WHERE [Status] LIKE '%Cancel%'
GROUP BY [Category]
ORDER BY cancelled_orders DESC;
--Cancellations by Fulfillment Method--
SELECT
    [Fulfilment],
    COUNT(DISTINCT [Order_ID]) AS cancelled_orders
FROM [dbo].[Amazon Sale Report]
WHERE [Status] LIKE '%Cancel%'
GROUP BY [Fulfilment]
ORDER BY cancelled_orders DESC;
-- =====================================================
-- PHASE 5: PRICING & PRODUCT ANALYSIS
-- =====================================================

--  Inspect Pricing Columns--
SELECT TOP 10
    [SKU],
    [Category],
    [Qty],
    [Amount]
FROM [dbo].[Amazon Sale Report];
--Sales Amount by Quantity--
SELECT
    [Qty],
    COUNT(*) AS number_of_records,
    SUM([Amount]) AS total_sales
FROM [dbo].[Amazon Sale Report]
WHERE [Amount] IS NOT NULL
GROUP BY [Qty]
ORDER BY [Qty];
 --Average Order Value--
SELECT
    SUM([Amount]) / NULLIF(COUNT(DISTINCT [Order_ID]), 0) AS average_order_value
FROM [dbo].[Amazon Sale Report]
WHERE [Amount] IS NOT NULL;
--Sales Amount Distribution--
SELECT
    MIN([Amount]) AS minimum_amount,
    MAX([Amount]) AS maximum_amount,
    AVG([Amount]) AS average_amount
FROM [dbo].[Amazon Sale Report]
WHERE [Amount] IS NOT NULL;
--Top 10 SKUs by Sale--
SELECT TOP 10
    [SKU],
    SUM([Amount]) AS total_sales,
    SUM([Qty]) AS total_quantity_sold
FROM [dbo].[Amazon Sale Report]
WHERE [Amount] IS NOT NULL
GROUP BY [SKU]
ORDER BY total_sales DESC;
-- =====================================================
-- PHASE 6: SHIPPING ANALYSIS
-- =====================================================
--Shipping Service Levels--
SELECT
    [ship_service_level],
    COUNT(DISTINCT [Order_ID]) AS total_orders
FROM [dbo].[Amazon Sale Report]
GROUP BY [ship_service_level]
ORDER BY total_orders DESC;
--Shipping by State--
SELECT
    [ship_state],
    COUNT(DISTINCT [Order_ID]) AS total_orders
FROM [dbo].[Amazon Sale Report]
WHERE [ship_state] IS NOT NULL
GROUP BY [ship_state]
ORDER BY total_orders DESC;
-- Shipping Status--
SELECT
    [Courier_Status],
    COUNT(DISTINCT [Order_ID]) AS total_orders
FROM [dbo].[Amazon Sale Report]
WHERE [Courier_Status] IS NOT NULL
GROUP BY [Courier_Status]
ORDER BY total_orders DESC;
-- =====================================================
-- PHASE 7: ADVANCED SQL ANALYSIS
-- =====================================================
 --Rank SKUs by Sales--
SELECT
    [SKU],
    SUM([Amount]) AS total_sales,
    RANK() OVER (
        ORDER BY SUM([Amount]) DESC
    ) AS sales_rank
FROM [dbo].[Amazon Sale Report]
WHERE [Amount] IS NOT NULL
GROUP BY [SKU]
ORDER BY sales_rank;
-- Task 29: Top SKUs Within Each Category--

WITH sku_sales AS
(
    SELECT
        [Category],
        [SKU],
        SUM([Amount]) AS total_sales
    FROM [dbo].[Amazon Sale Report]
    WHERE [Amount] IS NOT NULL
    GROUP BY
        [Category],
        [SKU]
)

SELECT
    [Category],
    [SKU],
    total_sales,
    RANK() OVER
    (
        PARTITION BY [Category]
        ORDER BY total_sales DESC
    ) AS category_rank
FROM sku_sales
ORDER BY
    [Category],
    category_rank;
--  Monthly Sales Ranking--

WITH monthly_sales AS
(
    SELECT
        YEAR([Date]) AS sales_year,
        MONTH([Date]) AS sales_month,
        SUM([Amount]) AS total_sales
    FROM [dbo].[Amazon Sale Report]
    WHERE [Amount] IS NOT NULL
    GROUP BY
        YEAR([Date]),
        MONTH([Date])
)

SELECT
    sales_year,
    sales_month,
    total_sales,
    RANK() OVER
    (
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM monthly_sales
ORDER BY sales_rank;
-- Task 31: Running Total of Sales--
WITH monthly_sales AS
(
    SELECT
        YEAR([Date]) AS sales_year,
        MONTH([Date]) AS sales_month,
        SUM([Amount]) AS total_sales
    FROM [dbo].[Amazon Sale Report]
    WHERE [Amount] IS NOT NULL
    GROUP BY
        YEAR([Date]),
        MONTH([Date])
)

SELECT
    sales_year,
    sales_month,
    total_sales,
    SUM(total_sales) OVER
    (
        ORDER BY sales_year, sales_month
    ) AS running_total_sales
FROM monthly_sales
ORDER BY
    sales_year,
    sales_month;
-- Identify Underperforming SKUs-- 
WITH sku_sales AS
(
    SELECT
        [SKU],
        SUM([Amount]) AS total_sales
    FROM [dbo].[Amazon Sale Report]
    WHERE [Amount] IS NOT NULL
    GROUP BY [SKU]
)

SELECT
    [SKU],
    total_sales
FROM sku_sales
WHERE total_sales <
(
    SELECT AVG(total_sales)
    FROM sku_sales
)
ORDER BY total_sales ASC;
 -- =====================================================
-- PHASE 8: DATA CLEANING
-- =====================================================-- 
--  Clean Dataset--
SELECT *
INTO [dbo].[Amazon_Sale_Report_Clean]
FROM [dbo].[Amazon Sale Report];
--  Clean Text Whitespace--

UPDATE [dbo].[Amazon_Sale_Report_Clean]
SET
    [Order_ID] = TRIM([Order_ID]),
    [Status] = TRIM([Status]),
    [Fulfilment] = TRIM([Fulfilment]),
    [Category] = TRIM([Category]),
    [Size] = TRIM([Size]),
    [SKU] = TRIM([SKU]),
    [ASIN] = TRIM([ASIN]),
    [Courier_Status] = TRIM([Courier_Status]),
    [ship_city] = TRIM([ship_city]),
    [ship_state] = TRIM([ship_state]),
    [ship_country] = TRIM([ship_country]);
--  Standardize Blank Text Values--

UPDATE [dbo].[Amazon_Sale_Report_Clean]
SET
    [Order_ID] = NULLIF([Order_ID], ''),
    [Status] = NULLIF([Status], ''),
    [Fulfilment] = NULLIF([Fulfilment], ''),
    [Category] = NULLIF([Category], ''),
    [Size] = NULLIF([Size], ''),
    [SKU] = NULLIF([SKU], ''),
    [ASIN] = NULLIF([ASIN], ''),
    [Courier_Status] = NULLIF([Courier_Status], ''),
    [ship_city] = NULLIF([ship_city], ''),
    [ship_state] = NULLIF([ship_state], ''),
    [ship_country] = NULLIF([ship_country], '');
--  Standardize Categorical Values--

UPDATE [dbo].[Amazon_Sale_Report_Clean]
SET
    [Status] = UPPER(TRIM([Status])),
    [Fulfilment] = UPPER(TRIM([Fulfilment])),
    [Category] = UPPER(TRIM([Category])),
    [Courier_Status] = UPPER(TRIM([Courier_Status]));   
--  Clean Date Values--
UPDATE [dbo].[Amazon_Sale_Report_Clean]
SET [Date] = NULL
WHERE [Date] IS NOT NULL
  AND TRY_CONVERT(date, [Date]) IS NULL;
--  Clean Amount Values--

UPDATE [dbo].[Amazon_Sale_Report_Clean]
SET [Amount] = NULL
WHERE [Amount] < 0;  
-- Task 39: Clean Quantity Values--

UPDATE [dbo].[Amazon_Sale_Report_Clean]
SET [Qty] = NULL
WHERE [Qty] < 0;
-- Standardize Shipping Country--

UPDATE [dbo].[Amazon_Sale_Report_Clean]
SET [ship_country] = UPPER(TRIM([ship_country]))
WHERE [ship_country] IS NOT NULL;
--  Standardize Shipping State--

UPDATE [dbo].[Amazon_Sale_Report_Clean]
SET [ship_state] = UPPER(TRIM([ship_state]))
WHERE [ship_state] IS NOT NULL;
--Standardize Shipping City--
UPDATE [dbo].[Amazon_Sale_Report_Clean]
SET [ship_city] = UPPER(TRIM([ship_city]))
WHERE [ship_city] IS NOT NULL;
--  Convert Postal Code to Text--
ALTER TABLE [dbo].[Amazon_Sale_Report_Clean]
ALTER COLUMN [ship_postal_code] VARCHAR(20);
--  Clean Shipping Postal Codes--

UPDATE [dbo].[Amazon_Sale_Report_Clean]
SET [ship_postal_code] = TRIM([ship_postal_code])
WHERE [ship_postal_code] IS NOT NULL;
--  Standardize SKU Values--
UPDATE [dbo].[Amazon_Sale_Report_Clean]
SET [SKU] = UPPER(TRIM([SKU]))
WHERE [SKU] IS NOT NULL;
--  Clean Important Text Fields--
UPDATE [dbo].[Amazon_Sale_Report_Clean]
SET
    [SKU] = UPPER(TRIM([SKU])),
    [ASIN] = UPPER(TRIM([ASIN])),
    [ship_city] = UPPER(TRIM([ship_city])),
    [ship_state] = UPPER(TRIM([ship_state])),
    [ship_country] = UPPER(TRIM([ship_country]))
WHERE [SKU] IS NOT NULL
   OR [ASIN] IS NOT NULL
   OR [ship_city] IS NOT NULL
   OR [ship_state] IS NOT NULL
   OR [ship_country] IS NOT NULL;
-- Task 45: Final Data Quality Check--
SELECT
    COUNT(*) AS total_records,
    COUNT([Order_ID]) AS records_with_order_id,
    COUNT([Date]) AS records_with_date,
    COUNT([Category]) AS records_with_category,
    COUNT([SKU]) AS records_with_sku,
    COUNT([Amount]) AS records_with_amount,
    COUNT([Qty]) AS records_with_quantity
FROM [dbo].[Amazon_Sale_Report_Clean];
--  Compare Raw vs Cleaned Dataset--

SELECT
    'Raw Dataset' AS dataset,
    COUNT(*) AS total_records
FROM [dbo].[Amazon Sale Report]

UNION ALL

SELECT
    'Clean Dataset' AS dataset,
    COUNT(*) AS total_records
FROM [dbo].[Amazon_Sale_Report_Clean];
-- =====================================================
-- PHASE 9: BUSINESS INSIGHTS
-- =====================================================

-- 1. Overall Sales Performance
SELECT
    COUNT(DISTINCT [Order_ID]) AS total_orders,
    SUM([Qty]) AS total_quantity_sold,
    SUM([Amount]) AS total_sales,
    AVG([Amount]) AS average_sales_amount
FROM [dbo].[Amazon_Sale_Report_Clean]
WHERE [Amount] IS NOT NULL;


-- 2. Sales by Category
SELECT
    [Category],
    SUM([Amount]) AS total_sales,
    SUM([Qty]) AS total_quantity_sold
FROM [dbo].[Amazon_Sale_Report_Clean]
WHERE [Amount] IS NOT NULL
GROUP BY [Category]
ORDER BY total_sales DESC;


-- 3. Top 10 SKUs
SELECT TOP 10
    [SKU],
    SUM([Amount]) AS total_sales,
    SUM([Qty]) AS total_quantity_sold
FROM [dbo].[Amazon_Sale_Report_Clean]
WHERE [Amount] IS NOT NULL
GROUP BY [SKU]
ORDER BY total_sales DESC;


-- 4. Top 10 States by Sales
SELECT TOP 10
    [ship_state],
    SUM([Amount]) AS total_sales,
    COUNT(DISTINCT [Order_ID]) AS total_orders
FROM [dbo].[Amazon_Sale_Report_Clean]
WHERE [Amount] IS NOT NULL
  AND [ship_state] IS NOT NULL
GROUP BY [ship_state]
ORDER BY total_sales DESC;


-- 5. Top 10 Cities by Sales
SELECT TOP 10
    [ship_city],
    [ship_state],
    SUM([Amount]) AS total_sales,
    COUNT(DISTINCT [Order_ID]) AS total_orders
FROM [dbo].[Amazon_Sale_Report_Clean]
WHERE [Amount] IS NOT NULL
  AND [ship_city] IS NOT NULL
GROUP BY
    [ship_city],
    [ship_state]
ORDER BY total_sales DESC;


-- 6. Order Status
SELECT
    [Status],
    COUNT(DISTINCT [Order_ID]) AS total_orders
FROM [dbo].[Amazon_Sale_Report_Clean]
GROUP BY [Status]
ORDER BY total_orders DESC;


-- 7. Cancellation Rate
SELECT
    COUNT(DISTINCT [Order_ID]) AS total_orders,
    COUNT(DISTINCT CASE
        WHEN [Status] LIKE '%CANCEL%'
        THEN [Order_ID]
    END) AS cancelled_orders,
    CAST(
        COUNT(DISTINCT CASE
            WHEN [Status] LIKE '%CANCEL%'
            THEN [Order_ID]
        END) * 100.0
        / NULLIF(COUNT(DISTINCT [Order_ID]), 0)
        AS DECIMAL(5,2)
    ) AS cancellation_rate_percent
FROM [dbo].[Amazon_Sale_Report_Clean];


-- 8. Fulfillment Performance
SELECT
    [Fulfilment],
    COUNT(DISTINCT [Order_ID]) AS total_orders,
    SUM([Amount]) AS total_sales
FROM [dbo].[Amazon_Sale_Report_Clean]
WHERE [Amount] IS NOT NULL
GROUP BY [Fulfilment]
ORDER BY total_sales DESC;


-- 9. Shipping Service Level
SELECT
    [ship_service_level],
    COUNT(DISTINCT [Order_ID]) AS total_orders
FROM [dbo].[Amazon_Sale_Report_Clean]
GROUP BY [ship_service_level]
ORDER BY total_orders DESC;


-- 10. Monthly Sales Performance
SELECT
    YEAR([Date]) AS sales_year,
    MONTH([Date]) AS sales_month,
    SUM([Amount]) AS total_sales,
    SUM([Qty]) AS total_quantity_sold
FROM [dbo].[Amazon_Sale_Report_Clean]
WHERE [Amount] IS NOT NULL
GROUP BY
    YEAR([Date]),
    MONTH([Date])
ORDER BY
    sales_year,
    sales_month;
       