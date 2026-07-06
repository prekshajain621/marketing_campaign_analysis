SELECT * FROM marketing_campaign_data
-- DATA CLEANING PROCESS IN THE SQL '
-- 1) REMOVING THE NULL ENTRIES USING COALESCE() FUNCTION. 
-- 2) STRING VALUES WITH THE SAME MEANING BUT DIFFERENT WRITTEN STYLE FOR EG. Single, SIngle, SINGLE ALL ARE SAME BUT WRITTEN IN DIFFERENT 
-- STYLES CAN BE CORRECTED BY REPLACE() FUNCTION 
-- 3) USING TRIM() FUNCTION TO REMOVE THE SPACES,BLANKS 
-- 4) REMOVING DUPLICATES USING CTE


-- IN EDUCATION WE CAN REPLACE THE 2n Cycle BY ASSOCIATE DEGREE
UPDATE marketing_campaign_data SET Education = 'Associate degree' WHERE Education = '2n Cycle'

-- WE KNOW THAT Martial_Status CAN BE DIVORCED,MARRIED,SINGLE AND WIDOW BUT ACCORDING TO DATA 
-- WE CAN MERGE ALONE AS SINGLE BECAUSE ALONE IS SOMEWHAT SIMILAR TO SINGLE 
-- TOGETHER CAN ALSO BE CLASSIFIED AS THAT THEY ARE NOT MARRIED BUT ONLY ON LIVING BASIS SO WE CAN CATEGORIZE THEM AS DOMESTIC PARTNERS

UPDATE marketing_campaign_data SET Marital_Status = 'Single' WHERE Marital_Status = 'Alone' 
UPDATE marketing_campaign_data SET Marital_Status = 'Domestic Partners' WHERE Marital_Status = 'Together' 

-- DELETE THE COLUMNS YOLO AND ABSURD FROM Marital Status
DELETE FROM marketing_campaign_data WHERE Marital_Status IN ('YOLO','Absurd');

-- REMOVING DUPLICATES 
WITH CTE AS (SELECT ROW_NUMBER() OVER(PARTITION BY ID ORDER BY ID) AS row_num FROM marketing_campaign_data) 
SELECT * FROM CTE WHERE row_num>1

-- CHECKING WHERE ARE NULL VALUES
SELECT Income FROM marketing_campaign_data WHERE Income IS NULL
SELECT CTR_Cost_Through_Rate FROM marketing_campaign_data WHERE CTR_Cost_Through_Rate IS NULL
SELECT CPC_Cost_Per_Click FROM marketing_campaign_data WHERE CPC_Cost_Per_Click IS NULL
SELECT Conversion_Rate FROM marketing_campaign_data WHERE Conversion_Rate IS NULL

SELECT * FROM marketing_campaign_data
ALTER TABLE marketing_campaign_data ALTER COLUMN Response INT;
ALTER TABLE marketing_campaign_data ALTER COLUMN Conversions INT;
ALTER TABLE marketing_campaign_data ALTER COLUMN AcceptedCmp3 INT;
ALTER TABLE marketing_campaign_data ALTER COLUMN Complain INT;
-- SELECT ID,Clicks,Impressions,CTR_Cost_Through_Rate,TRY_CAST(REPLACE (CTR_Cost_Through_Rate,'%','') AS DECIMAL(10,2)) AS DecimalValue FROM marketing_campaign_data WHERE CTR_Cost_Through_Rate IS NULL order by ID;
-- ALTER TABLE marketing_campaign_data ALTER COLUMN CTR_Cost_Through_Rate DECIMAL(10,2)
-- SELECT ID,Clicks,Impressions,CTR_Cost_Through_Rate,TRY_CAST(REPLACE (CTR_Cost_Through_Rate,'%','') AS DECIMAL(10,2)) AS DecimalValue FROM marketing_campaign_data order by ID;

-- CHANGING THE COLUMN CTR_Cost_Through_Rate FROM VARCHAR TO DECIMAL IN TWO STEPS 
-- STEP 1 REPLACE THE % SIGN 
UPDATE marketing_campaign_data SET CTR_Cost_Through_Rate = REPLACE (CTR_Cost_Through_Rate,'%','')
-- STEP 2 CONVERT THE COLUMN INTO DECIMAL 
ALTER TABLE marketing_campaign_data ALTER COLUMN CTR_Cost_Through_Rate DECIMAL(10,2)

-- CHANGING THE COLUMN Conversion_Rate FROM VARCHAR TO DECIMAL IN TWO STEPS 
-- STEP 1 REPLACE THE % SIGN 
UPDATE marketing_campaign_data SET Conversion_Rate = REPLACE (Conversion_Rate,'%','')
-- STEP 2 CONVERT THE COLUMN INTO DECIMAL 
ALTER TABLE marketing_campaign_data ALTER COLUMN Conversion_Rate DECIMAL(10,2)


-- HANDILING THE NULL VALUES USING COALESCE 
-- 1) null values are present in the income columnn
SELECT Income FROM marketing_campaign_data WHERE Income IS NULL
-- PERMANENTLY UPDATE THE INCOME COLUMN WHERE INCOME IS NULL
UPDATE marketing_campaign_data SET Income = COALESCE(Income,0)
SELECT Income FROM marketing_campaign_data WHERE Income = 0 

-- 2) null values are present in the CTR columnn
SELECT CTR_Cost_Through_Rate FROM marketing_campaign_data WHERE CTR_Cost_Through_Rate IS NULL
-- PERMANENTLY UPDATE THE CTR COLUMN WHERE CTR IS NULL
UPDATE marketing_campaign_data SET CTR_Cost_Through_Rate = COALESCE(CTR_Cost_Through_Rate,0)
SELECT CTR_Cost_Through_Rate FROM marketing_campaign_data WHERE CTR_Cost_Through_Rate = 0.00

-- 3) null values are present in the CPC columnn
SELECT CPC_Cost_Per_Click FROM marketing_campaign_data WHERE CPC_Cost_Per_Click IS NULL
-- PERMANENTLY UPDATE THE CPC COLUMN WHERE CPC IS NULL
UPDATE marketing_campaign_data SET CPC_Cost_Per_Click = COALESCE(CPC_Cost_Per_Click,0)
SELECT CPC_Cost_Per_Click FROM marketing_campaign_data WHERE CPC_Cost_Per_Click = 0

-- 4) null values are present in the Conversion_Rate columnn
SELECT Conversion_Rate FROM marketing_campaign_data WHERE Conversion_Rate IS NULL
-- PERMANENTLY UPDATE THE Conversion_Rate COLUMN WHERE Conversion_Rate IS NULL
UPDATE marketing_campaign_data SET Conversion_Rate = COALESCE(Conversion_Rate,0)
SELECT Conversion_Rate FROM marketing_campaign_data WHERE Conversion_Rate = 0
SELECT COUNT(*) AS Conversion_Rate FROM marketing_campaign_data WHERE Conversion_Rate = 0

-- KPI'S 
SELECT * FROM marketing_campaign_data
-- 1) TOTAL NO OF CUSTOMERS IN THIS MARKETING CAMPAIGN DATA 
SELECT COUNT(*) AS Total_Customers FROM marketing_campaign_data;

--2) TOTAL RESPONSE THE NUMBER OF CUSTOMERS WHO ACCEPTED THE OFFER IN LAST CAMPAIGN 
SELECT SUM(Response) AS Total_Response FROM marketing_campaign_data;

--3) TOTAL REVENUE(SPENDING) OF A CUSTOMER 
SELECT SUM(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) AS Total_Revenue FROM marketing_campaign_data;

-- 4) AVERAGE CUSTOMER VALUE
SELECT AVG(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) AS Avg_Customer_Value FROM marketing_campaign_data;

-- 5) NET INCOME OF A CUSTOMER 
SELECT SUM(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) - SUM(Cost) AS Net_Income FROM marketing_campaign_data;

--6) TOTAL PURCHASES MADE BY DIFFERENT SOURCES BY THE CUSTOMER 
SELECT SUM(NumWebPurchases + NumCatalogPurchases + NumStorePurchases) AS Total_Purchases FROM marketing_campaign_data;

--7) PURCHASES OF PRODUCTS BY EDUCATION 
SELECT Education,SUM(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) AS Total_Revenue FROM marketing_campaign_data GROUP BY Education;

--8) CTR CTR = CLICKS/IMPRESSIONS
SELECT CAST(SUM(Clicks)*1.0/ SUM(Impressions) AS DECIMAL(10,5)) AS CTR FROM marketing_campaign_data;

--9) CPC CPC = COST/CLICKS
SELECT SUM(Cost)/SUM(Clicks) AS CPC FROM marketing_campaign_data;

--10) CONVERSION RATE = CONVERSIONS/CLICKS
SELECT CAST(SUM(Conversions)*1.0/SUM(Clicks) AS DECIMAL(10,5)) AS CONVERSION_RATE FROM marketing_campaign_data;

--11) R0I RETURN ON INVESTMENT 
SELECT (SUM(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds)-SUM(Cost))*1.0/SUM(Cost) AS ROI
FROM marketing_campaign_data;

--CHARTS 
-------------------------------------------------------------------------------------------
SELECT * FROM marketing_campaign_data
-- 1)WHICH CAMPAIGN PERFORMS THE BEST THE LATEST OR THE LAST CAMPAIGN PERFORMS THE BEST  (RESPONSE) (BAR CHART)
SELECT SUM(AcceptedCmp3) AS CAMPAIGN3 FROM marketing_campaign_data;
SELECT SUM(AcceptedCmp4) AS CAMPAIGN4 FROM marketing_campaign_data;
SELECT SUM(AcceptedCmp5) AS CAMPAIGN5 FROM marketing_campaign_data;
SELECT SUM(AcceptedCmp1) AS CAMPAIGN1 FROM marketing_campaign_data;
SELECT SUM(AcceptedCmp2) AS CAMPAIGN2 FROM marketing_campaign_data;


-- 2)PRODUCT SPENDING WHICH PRODUCT LEADS TO THE HIGHEST REVENUE (WINES) (DONUT)
SELECT CAST(SUM(MntWines)*100.0/SUM(MntWines + MntFruits + MntMeatProducts + 
        MntFishProducts + MntSweetProducts + MntGoldProds) AS DECIMAL(10,3)) AS PRODUCT_WINES FROM marketing_campaign_data;
SELECT CAST(SUM(MntFruits)*100.0/SUM(MntWines + MntFruits + MntMeatProducts + 
        MntFishProducts + MntSweetProducts + MntGoldProds) AS DECIMAL(10,3)) AS PRODUCT_FRUITS FROM marketing_campaign_data;
SELECT CAST(SUM(MntMeatProducts)*100.0/SUM(MntWines + MntFruits + MntMeatProducts + 
        MntFishProducts + MntSweetProducts + MntGoldProds) AS DECIMAL(10,3)) AS PRODUCT_MEAT FROM marketing_campaign_data;
SELECT CAST(SUM(MntFishProducts)*100.0/SUM(MntWines + MntFruits + MntMeatProducts + 
        MntFishProducts + MntSweetProducts + MntGoldProds) AS DECIMAL(10,3)) AS PRODUCT_FISH FROM marketing_campaign_data;
SELECT CAST(SUM(MntSweetProducts)*100.0/SUM(MntWines + MntFruits + MntMeatProducts + 
        MntFishProducts + MntSweetProducts + MntGoldProds) AS DECIMAL(10,3)) AS PRODUCT_SWEET FROM marketing_campaign_data;
SELECT CAST(SUM(MntGoldProds)*100.0/SUM(MntWines + MntFruits + MntMeatProducts + 
        MntFishProducts + MntSweetProducts + MntGoldProds) AS DECIMAL(10,3)) AS PRODUCT_GOLD FROM marketing_campaign_data;

-- SELECT SUM(MntWines) AS WINES, SUM(MntFruits) AS PRODUCT_FRUITS , SUM(MntMeatProducts) AS PRODUCT_MEAT,
-- SUM(MntFishProducts) AS PRODUCT_FISH, SUM(MntSweetProducts) AS PRODUCT_SWEET, SUM(MntGoldProds) AS PRODUCT_GOLD FROM marketing_campaign_data;

-- 3)PREFERED CHANNEL SUCH AS WEBSITE CATLOG ON STORES PURCHASES  (STORE) 
SELECT 'Web' AS Channel, SUM(NumWebPurchases) AS Total_Purchases FROM marketing_campaign_data
UNION ALL
SELECT 'Store', SUM(NumStorePurchases) FROM marketing_campaign_data
UNION ALL
SELECT 'Catalog', SUM(NumCatalogPurchases) FROM marketing_campaign_data;

-- 4) INCOME DISTRIBUTION MEDIUM>LOW>HIGH
SELECT CASE WHEN Income>=100000 THEN 'HIGH' 
WHEN Income BETWEEN 10000 AND 99999 THEN 'MEDIUM' 
ELSE 'LOW'
END AS Income_Classification,COUNT(*) AS Customers FROM marketing_campaign_data 
GROUP BY CASE 
    WHEN Income>=100000 THEN 'HIGH' 
    WHEN Income BETWEEN 10000 AND 99999 THEN 'MEDIUM' 
    ELSE 'LOW' 
END;


--6) ROI BY COUNTRY 
SELECT Country,CAST((SUM(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds)-SUM(Cost))*1.0/
SUM(Cost)*100 AS DECIMAL(10,3)) AS ROI FROM marketing_campaign_data GROUP BY Country ORDER BY ROI DESC;
-- MEXICO HAS HIGHEST ROI THAT LEADS TO HIGH PROFITS AS COMPARE TO OTHER COUNTRIES 
-- INDIA HAS LOWEST ROI THAT LEADS TO LOWEST PROFIT AS COMPARE TO OTHER COUNTRIES 
SELECT * FROM marketing_campaign_data
--7) COMPLAIN WHICH 1 if customer complained in the last 2 years, 0 otherwise COMPLAIN BY MARITAL STATUS 
SELECT Marital_Status,SUM(Complain) AS Complain FROM marketing_campaign_data GROUP BY Marital_Status ORDER BY Complain DESC;
-- MARRIED PEOPLE HAVE HIGHEST COMPLAIN IN THE LAST 2 YEARS 
-- WIDOW PEOPLE HAVE LOWEST COMPLAIN IN SHORT NO COMPLAINS FROM WIDOW 

--8) REVENUE BY EDUCATION (GRADUATION HIGHEST) (BASIC LOWEST) (BAR CHART)
SELECT Education,SUM(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) 
AS total_revenue FROM marketing_campaign_data GROUP BY Education ORDER BY total_revenue DESC;

--2ND PAGE 
-- CPC CPC = COST/CLICKS CPC BY SEGMENT (EDUCATION/COUNTRY) 
SELECT Education,CAST(SUM(Cost)*1.0/SUM(Clicks) AS DECIMAL(10,2)) AS CPC FROM marketing_campaign_data GROUP BY 
Education ORDER BY CPC DESC;
SELECT Country,CAST(SUM(Cost)*1.0/SUM(Clicks) AS DECIMAL(10,2)) AS CPC FROM marketing_campaign_data GROUP BY 
Country ORDER BY CPC DESC;

-- CONVERSION RATE = CONVERSIONS/CLICKS CONVERSITION RATE SEGMENT (MARTIAL STATUS/COUNTRY)
SELECT Marital_Status,CAST(SUM(Conversions)*1.0/SUM(Clicks)*100  AS DECIMAL(10,2)) AS Conversion_Rate FROM 
marketing_campaign_data GROUP BY Marital_Status ORDER BY Conversion_Rate DESC;
SELECT Country,CAST(SUM(Conversions)*1.0/SUM(Clicks)*100  AS DECIMAL(10,2)) AS Conversion_Rate FROM marketing_campaign_data 
GROUP BY Country ORDER BY Conversion_Rate DESC;

--5) CTR BY COUNTRY CTR = CLICKS/IMPRESSIONS
SELECT Country,CAST(SUM(Clicks)*1.0/SUM(Impressions)*100 AS DECIMAL(10,3)) AS CTR FROM marketing_campaign_data GROUP BY Country 
ORDER BY CTR DESC;
-- MEXICO HAS HIGHEST CTR INDICATING STRONGER CUSTOMER ENGAGEMENT 
-- INDIA HAS LOWEST CTR INDICATING WEAKER CUSTOMER ENGAGEMENT 

-- WHICH COUNTRY HAS THE HIGHEST RESPONSE FROM THE LATEST/LAST CAMPAIGN  (SPAIN) HAS PERFORMED THE BEST LAST CAMPAIGN
SELECT SUM(Response) AS Total_Response,Country FROM marketing_campaign_data GROUP BY Country ORDER BY SUM(Response) DESC;

select * from marketing_campaign_data
SELECT count(*) FROM marketing_campaign_data
SELECT * FROM marketing_campaign_data WHERE ID IN (492,11133,4369,7734);


INSERT INTO marketing_campaign_data(ID,Year_birth,Education,Marital_Status,Income,Kidhome,Teenhome,Dt_Customer,
Recency,MntWines,MntFruits,MntMeatProducts,MntFishProducts,MntSweetProducts,MntGoldProds,NumDealsPurchases,NumWebPurchases,
NumCatalogPurchases,NumStorePurchases,NumWebVisitsMonth,AcceptedCmp3,AcceptedCmp4,AcceptedCmp5,AcceptedCmp1,AcceptedCmp2,
Response,Complain,Country,Impressions,Clicks,Conversions,Cost,CTR_Cost_Through_Rate,CPC_Cost_Per_Click,Conversion_Rate) VALUES
(492,1973,'PhD','YOLO',48432,0,1,'2012-10-18',3,322,3,50,4,3,42,5,7,1,6,8,0,0,0,0,0,0,0,'Canada',800,7,0,14,0.88,2,0.00);

INSERT INTO marketing_campaign_data(ID,Year_birth,Education,Marital_Status,Income,Kidhome,Teenhome,Dt_Customer,
Recency,MntWines,MntFruits,MntMeatProducts,MntFishProducts,MntSweetProducts,MntGoldProds,NumDealsPurchases,NumWebPurchases,
NumCatalogPurchases,NumStorePurchases,NumWebVisitsMonth,AcceptedCmp3,AcceptedCmp4,AcceptedCmp5,AcceptedCmp1,AcceptedCmp2,
Response,Complain,Country,Impressions,Clicks,Conversions,Cost,CTR_Cost_Through_Rate,CPC_Cost_Per_Click,Conversion_Rate) VALUES
(11133,1973,'PhD','YOLO',48432,0,1,'2012-10-18',3,322,3,50,4,3,42,5,7,1,6,8,0,0,0,0,0,1,0,'India',800,7,1,14,0.88,2,14.29);

INSERT INTO marketing_campaign_data(ID,Year_birth,Education,Marital_Status,Income,Kidhome,Teenhome,Dt_Customer,
Recency,MntWines,MntFruits,MntMeatProducts,MntFishProducts,MntSweetProducts,MntGoldProds,NumDealsPurchases,NumWebPurchases,
NumCatalogPurchases,NumStorePurchases,NumWebVisitsMonth,AcceptedCmp3,AcceptedCmp4,AcceptedCmp5,AcceptedCmp1,AcceptedCmp2,
Response,Complain,Country,Impressions,Clicks,Conversions,Cost,CTR_Cost_Through_Rate,CPC_Cost_Per_Click,Conversion_Rate) VALUES
(4369,1957,'Master','Absurd',65487,0,0,'2014-01-10',48,240,67,500,199,0,163,3,3,5,6,2,0,0,0,0,0,0,0,'Canada',200,3,0,6,1.50,2,0.00);

INSERT INTO marketing_campaign_data(ID,Year_birth,Education,Marital_Status,Income,Kidhome,Teenhome,Dt_Customer,
Recency,MntWines,MntFruits,MntMeatProducts,MntFishProducts,MntSweetProducts,MntGoldProds,NumDealsPurchases,NumWebPurchases,
NumCatalogPurchases,NumStorePurchases,NumWebVisitsMonth,AcceptedCmp3,AcceptedCmp4,AcceptedCmp5,AcceptedCmp1,AcceptedCmp2,
Response,Complain,Country,Impressions,Clicks,Conversions,Cost,CTR_Cost_Through_Rate,CPC_Cost_Per_Click,Conversion_Rate) VALUES
(7734,1993,'Graduation','Absurd',79244,0,0,'2012-12-19',58,471,102,125,212,61,245,1,4,10,7,1,0,0,1,1,0,1,0,'Australia',100,4,1,8,4.00,2,25.00);

--KPI'S 
select CAST(SUM(Clicks)*1.0/SUM(Impressions)*100 AS DECIMAL(10,3)) AS CTR from marketing_campaign_data
SELECT CAST(SUM(Cost)*1.0/SUM(Clicks) AS DECIMAL(10,2)) AS CPC FROM marketing_campaign_data
SELECT CAST(SUM(Conversions)*1.0/SUM(Clicks) AS DECIMAL(10,2)) AS Conversion_Rate FROM marketing_campaign_data
SELECT SUM(Impressions) AS Total_Impressions FROM marketing_campaign_data;
SELECT SUM(Clicks) AS Total_Clicks FROM marketing_campaign_data;
SELECT SUM(Cost) AS Total_Cost FROM marketing_campaign_data;
SELECT SUM(Conversions) AS Total_Cost FROM marketing_campaign_data;

SELECT * FROM marketing_campaign_data;
SELECT YEAR(Dt_Customer) AS YEAR , SUM(Clicks) AS CLICKS , SUM(Conversions) AS CONVERSIONS FROM marketing_campaign_data GROUP BY YEAR(Dt_Customer) ORDER BY SUM(Clicks),SUM(Conversions);
SELECT DATENAME(weekday,Dt_Customer) AS DAY , SUM(Clicks) AS CLICKS , SUM(Conversions) AS CONVERSIONS FROM marketing_campaign_data GROUP BY DATENAME(weekday,Dt_Customer) ORDER BY DATENAME(weekday,Dt_Customer);

-- 1)WHICH CAMPAIGN PERFORMS THE BEST THE LATEST OR THE LAST CAMPAIGN PERFORMS THE BEST  (RESPONSE) (BAR CHART)
SELECT SUM(AcceptedCmp3) AS CAMPAIGN3 FROM marketing_campaign_data;
SELECT SUM(AcceptedCmp4) AS CAMPAIGN4 FROM marketing_campaign_data;
SELECT SUM(AcceptedCmp5) AS CAMPAIGN5 FROM marketing_campaign_data;
SELECT SUM(AcceptedCmp1) AS CAMPAIGN1 FROM marketing_campaign_data;
SELECT SUM(AcceptedCmp2) AS CAMPAIGN2 FROM marketing_campaign_data;

--3) TOTAL REVENUE(SPENDING) OF A CUSTOMER 
SELECT SUM(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) AS Total_Revenue FROM marketing_campaign_data;

SELECT SUM(AcceptedCmp3) AS Campaign_3, SUM(AcceptedCmp4) AS Campaign_4 , SUM(AcceptedCmp5) AS Campaign_5,
SUM(AcceptedCmp1) AS Campaign_1 , SUM(AcceptedCmp2) AS Campaign_2,SUM(MntWines + MntFruits + MntMeatProducts + 
MntFishProducts + MntSweetProducts + MntGoldProds) AS Total_Revenue FROM marketing_campaign_data GROUP BY SUM(MntWines + 
MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds)

SELECT 'Campaign 1' AS Campaign, SUM(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) 
AS Total_Revenue FROM marketing_campaign_data WHERE AcceptedCmp1 = 1 
UNION ALL
SELECT 'Campaign 2' AS Campaign, SUM(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) 
AS Total_Revenue FROM marketing_campaign_data WHERE AcceptedCmp2 = 1 
UNION ALL
SELECT 'Campaign 3' AS Campaign, SUM(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) 
AS Total_Revenue FROM marketing_campaign_data WHERE AcceptedCmp3 = 1 
UNION ALL
SELECT 'Campaign 4' AS Campaign, SUM(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) 
AS Total_Revenue FROM marketing_campaign_data WHERE AcceptedCmp4 = 1 
UNION ALL
SELECT 'Campaign 5' AS Campaign, SUM(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) 
AS Total_Revenue FROM marketing_campaign_data WHERE AcceptedCmp5 = 1 ORDER BY Total_Revenue DESC

SELECT 'Campaign 1' AS Campaign, SUM(AcceptedCmp1) FROM marketing_campaign_data WHERE AcceptedCmp1 = 1 
UNION ALL
SELECT 'Campaign 2' AS Campaign, SUM(AcceptedCmp2) FROM marketing_campaign_data WHERE AcceptedCmp2 = 1 
UNION ALL
SELECT 'Campaign 3' AS Campaign, SUM(AcceptedCmp3) FROM marketing_campaign_data WHERE AcceptedCmp3 = 1 
UNION ALL
SELECT 'Campaign 4' AS Campaign, SUM(AcceptedCmp4) FROM marketing_campaign_data WHERE AcceptedCmp4 = 1 
UNION ALL
SELECT 'Campaign 5' AS Campaign, SUM(AcceptedCmp5) FROM marketing_campaign_data WHERE AcceptedCmp5 = 1 ORDER BY Campaign DESC

SELECT * FROM marketing_campaign_data