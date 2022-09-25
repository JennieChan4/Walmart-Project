Select *
From walmart

-- Standardize Date Format
Update  walmart
Set Ship_Date = STR_TO_DATE(Ship_Date,"%e/%c/%Y")

-- Temp Table for Yearly Figure
DROP TABLE IF EXISTS YearlyFigure
Create Table YearlyFigure (year YEAR, YearlyProfit varchar(255),YearlyOrder varchar(255), YearlySales varchar(255));
Insert Into YearlyFigure
Select year(Order_Date) as Year, 
sum(profit) as YearlyProfit, 
sum(Order_Quantity) as YearlyOrder,
sum(Sales) as YearlySales
From walmart
Group by year(Order_Date);

-- Calculate Annual Growth Rate with the Temp Table YearlyFigure
Select *,LAG(YearlyProfit,1) over(order by year asc),
(YearlyProfit-LAG(YearlyProfit,1) over(order by year asc))/LAG(YearlyProfit,1) over(order by year asc) as ProfitAnnualGrowth,
(YearlyOrder-LAG(YearlyOrder,1) over(order by year asc))/LAG(YearlyOrder,1) over(order by year asc) as OrderAnnualGrowth,
(YearlySales-LAG(YearlySales,1) over(order by year asc))/LAG(YearlySales,1) over(order by year asc) as SalesAnnualGrowth
from yearlyfigure


/* Customers Related */
-- Find Top 10 Customers with Highest Spending in 2015
Select Customer_Name,Customer_Segment,City,sum(sales) as Total_Spending, count(Order_ID) as Total_Order
from Walmart
Where Year(Order_Date) = '2015'
Group by Customer_Name,Customer_Segment,City
Order by Total_Spending desc
Limit 10

-- Find Total Spending in each Customer_Segment and City in 2015
Select Customer_Segment,sum(sales) as Total_Spending, count(Order_ID) as Total_Order
from Walmart
Where Year(Order_Date) = '2015'
Group by Customer_Segment
Order by Total_Spending desc
