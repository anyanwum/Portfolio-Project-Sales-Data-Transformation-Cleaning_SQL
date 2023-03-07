/* 
SQL DATA TRANSFORMATION AND CLEANING PORTFOLIO PROJECT

REFERENCE 
For the purpose of this SQL Data Transformation and Cleaning Project, We will be extracting tables from AdventureWorks Database 2019 [AdventureWorksDW2019] based on the below assumed email request from the client. 
The Dimension-Dim and Fact Tables to be used are; Date Table -[dbo].[DimDate], Customer Table -[dbo].[DimCustomer], Geography Table - [dbo].[DimGeography], 
Product Table - [dbo].[DimProduct], Product Category Table - [dbo].[DimProductCategory], Product Sub-Category Table - [dbo].[DimProductSubcategory] and lastly the
Fact table i.e. Internet Sales Table - [dbo].[FactInternetSales].

Assumed Email Request Recieved from Client.

Good morning Michael,

I hope this email finds you well. 
Recently we have been facing issues with our reporting system, and have decided it's time for improvement and upgade.
We need to improve our Sales reports and would like to migrate from our current static reports to visual dashboards as per management request.
Actually, we want the report dataset to focus on how much we have sold of what products, to which customers/clients and the trend over time i.e. from 2020 - 2022.
We want to also see how each sales personnel works on different customers and products, while been able to filter them as well, should incase we require specific 
information.
Our figures are measured against our budget so we have added that in an Excel spreadsheet for easy comparism of our values against performance.
Finally, our budget is for 2022 and we usually look 2 years back in time whenever we want to carry out Sales Analysis.

Best Regards,
Geroge Andrew (Senior Manager - Sales) 
*/

/*
DATA TRANFORMATION AND CLEANING SEQUENCE 1 (Calendar-Date Table)
CLeaning of Dimension Date Table i.e. [dbo].[DimDate] to obtain specific fields and removed the fields that are not required for the purpose of this project.
*/
SELECT 
      [DateKey], 
      [FullDateAlternateKey] AS Date,  --Introducing Alias "Date" used for renaming field/columns and will do same for the other fields where required.
      [EnglishDayNameOfWeek] AS Day, 
      [EnglishMonthName] AS Month, 
      Left([EnglishMonthName], 3) AS MonthShort,   -- This is usually beneficial during frontend navigation using short form of dates and also frontend visuals.
      [MonthNumberOfYear] AS MonthNo, 
      [CalendarQuarter] AS Quarter, 
      [CalendarYear] AS Year 
FROM 
      [AdventureWorksDW2019].[dbo].[DimDate]
WHERE 
      CalendarYear BETWEEN 2020 AND 2022  -- Filtered down to 3 years range/interval.
/*
DATA TRANSFORMATION AND CLEANING SEQUENCE 2 (Customer Table)
CLeaning of Dimension Customer Table [dbo].[DimCustomer] and using JOIN function to join it to Georgraphy Table i.e. [dbo].[DimGeography] to obtain specicific fields 
and removed the fields that are not required for the purpose of this project.
*/
SELECT 
     DimCus.CustomerKey AS CustomerKey, 
     DimCus.FirstName	AS [First Name], 
     DimCus.LastName	AS [Last Name], 
     DimCus.FirstName + ' ' + LastName AS [Full Name],         -- Concatinated/Combined First and Last Name as Full Name
CASE 
     DimCus.Gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' -- Used Case Statement to define the conditions/full meaning, I want to show in the Gender field.
END AS Gender,
     DimCus.DateFirstPurchase AS DateFirstPurchase, 
     DimGeo.City AS [Customer City]             -- Used LEFT JOIN to combine the Customer City from Geography Table along with the selected fields from Customer table.
FROM 
     [AdventureWorksDW2019].[dbo].[DimCustomer] AS DimCus
LEFT JOIN dbo.dimgeography AS DimGeo 
ON   DimGeo.geographykey = DimCus.geographykey 
ORDER BY 
     CustomerKey ASC                             -- Finally, Arrange the list of outcome using CustomerKey field to Order it in an Ascending Order (ASC).
/*
DATA TRANFORMATION AND CLEANING SEQUENCE 3 (Product Table)
CLeaning of Dimension Product Table [dbo].[DimProduct] and using JOIN function to join it to Product Category Table [dbo].[DimProductCategory] and Product Sub-Category 
Table [dbo].[DimProductSubcategory] to obtain specicific fields and removed the fields that are not required for the purpose of this project.
*/
SELECT 
      DimProd.[ProductKey], 
      DimProd.[ProductAlternateKey] AS ProductItemCode, 
      DimProd.[EnglishProductName] AS [Product Name], 
	    DimProSub.EnglishProductSubcategoryName AS [Sub Category], -- Joined in from Product Sub-Category Table
      DimProCat.EnglishProductCategoryName AS [Product Category], -- Joined in from Product Category Table
      DimProd.[Color] AS [Product Color], 
      DimProd.[Size] AS [Product Size], 
      DimProd.[ProductLine] AS [Product Line], 
      DimProd.[ModelName] AS [Product Model Name], 
      DimProd.[EnglishDescription] AS [Product Description], 
      ISNULL (DimProd.Status, 'Outdated') AS [Product Status] 
FROM 
     [AdventureWorksDW2019].[dbo].[DimProduct] as DimProd
LEFT JOIN dbo.DimProductSubcategory AS DimProSub ON DimProSub.ProductSubcategoryKey = DimProd.ProductSubcategoryKey  --Used LEFT JOIN to combine the 3 Tables and using
LEFT JOIN dbo.DimProductCategory AS DimProCat ON DimProSub.ProductCategoryKey = DimProCat.ProductCategoryKey         --their Primary keys to create relationship.
ORDER BY
      DimProd.ProductKey ASC
/*
DATA TRANFORMATION AND CLEANING SEQUENCE 4 (Internet Sales Table)
CLeaning of Fact Internet Sales Table - [dbo].[FactInternetSales] to obtain specific fields and removed the fields that are not required for the purpose of this project.
*/
SELECT 
     [ProductKey], 
     [OrderDateKey], 
     [DueDateKey], 
     [ShipDateKey], 
     [CustomerKey], 
     [SalesOrderNumber], 
     [SalesAmount]
FROM 
     [AdventureWorksDW2019].[dbo].[FactInternetSales]
WHERE 
LEFT (OrderDateKey, 4) >= YEAR(GETDATE()) -2 -- The Date Function and Syntax helps us filter our date extraction down to two years and also update automatically  
ORDER BY                                     --whenever their is a new input into the database which will affect the date, our output/visualization will still remain  
     OrderDateKey ASC                       -- valid once refreshed without any further changes at the backend.

	 /*
   END OF PROJECT FOR SQL
   */

