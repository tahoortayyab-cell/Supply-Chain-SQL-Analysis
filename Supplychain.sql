Create database supplychain;
USE supplychain;

select * from datacosupplychaindataset;

-- 1. Which market (Region) generates the highest total
--  sales and total profit?

Select Market, ROUND(SUM(Sales), 2) as `Total Sales`,
ROUND(SUM(`Order Profit Per Order`), 2) as `Toal Profit`
from datacosupplychaindataset
GROUP BY Market
ORDER BY `Total Sales` DESC;

-- 2. What is the late delivery rate per shipping
--  mode — which mode has the most late deliveries?

 Select `Shipping Mode`, 
 ROUND(SUM(Late_delivery_risk) / COUNT(*) * 100 , 2) as `Late Delivery Rate`
 from datacosupplychaindataset
 Group by `Shipping Mode`
 ORDER BY `Late Delivery Rate`
 DESC;
 
 -- 3. Which product category has the highest total 
 -- sales and highest profit ratio?

 Select `Category Name`,
 ROUND(SUM(Sales), 2) AS `Total Sales`,
 ROUND(SUM(`Order Profit Per Order`) , 2) AS `Total Profit`,
 ROUND(AVG(`Order Item Profit Ratio`) , 3) as `Profit Ratio`
 from datacosupplychaindataset
 GROUP BY `Category Name`
 ORDER BY `Total Sales`
 DESC;
 
 -- 4. Which customer segment (Consumer, Corporate, Home Office) 
 -- generates the most revenue?
 
 
Select `Customer Segment`, 
ROUND(SUM(Sales) , 2) as `Total Revenue`
from datacosupplychaindataset
GROUP BY `Customer Segment`
ORDER BY  `Total Revenue`
DESC;

-- 5. What is the average actual shipping days vs scheduled shipping days per
-- shipping mode — where is the biggest gap?
 
Select `Shipping Mode` ,
ROUND(AVG(`Days for shipping (real)`) , 2) as `Average Actual Shipping`,
ROUND(AVG(`Days for shipment (scheduled)`), 2)  as `Average Scheduled Shipping`,
ROUND(AVG(`Days for shipping (real)`) - AVG(`Days for shipment (scheduled)`) , 2) 
as `Biggest gap`
from datacosupplychaindataset
GROUP BY `Shipping Mode`
ORDER BY `Biggest gap`
DESC;

-- 6. Which top 10 customers have the highest total sales?

Select CONCAT(`Customer Fname`, ' ' , `Customer Lname`) as `Customer Name`,
ROUND(SUM(Sales) , 2) as `Total Sales`
from datacosupplychaindataset
GROUP BY `Customer Name`
ORDER BY `Total Sales`
DESC LIMIT 10;

-- 7. Which department has the highest total benefit per order?

Select `Department Name` , 
ROUND(SUM(`Benefit per order`), 2) as `Total Benefit Per Order`
from datacosupplychaindataset
GROUP BY `Department Name`
ORDER BY `Total Benefit Per Order`
DESC;

-- 8. How many orders have negative profit — and
-- which categories have the most loss-making orders?

Select `Category Name`, 
Count(*) as `Total Orders`
from datacosupplychaindataset
WHERE `Benefit per order` < 0
Group by `Category Name`
ORDER BY `Total Orders`
DESC;

-- 9. Which country receives the most orders 
-- and what is their average delivery status?

Select `Customer Country`, Count(*) as `Total Orders`,
ROUND(AVG(Late_delivery_risk) , 2) as `Late Delivery Rate`
from datacosupplychaindataset
GROUP BY `Customer Country`
ORDER BY `Total Orders` 
DESC;

-- 10. What percentage of orders were
--  delivered late vs on time vs advance?

SELECT `Delivery Status`, 
ROUND(COUNT(*)/(Select COUNT(*)
from datacosupplychaindataset) * 100.0 , 2) AS  `Delivery Rate`
from datacosupplychaindataset
WHERE `Delivery Status` IN ('Late delivery', 'Shipping on time', 'Advance shipping')
GROUP BY `Delivery Status`;


-- 11. For each market, who are the top 3
--  customers by total sales?

WITH CTE AS(
Select `Market`, 
 CONCAT( `Customer Fname` , ' ' , `Customer Lname`) as `Full Name`,
ROUND(SUM(Sales) , 2) as `Total Sales`,
Rank() OVER(partition by `Market` ORDER BY SUM(Sales)  DESC ) as rnk 
from datacosupplychaindataset
GROUP BY 
`Market`, 
`Customer Fname`, 
`Customer Lname` )
select * from CTE 
WHERE rnk<= 3;

-- 12. Which product has the highest average discount
--  rate — and is it profitable?

Select `Product Name`, 
ROUND(AVG(`Order Item Discount`) , 2) AS `Avg Discount Rate`,
CASE
      WHEN
 AVG(`Order Item Profit Ratio`) > 0 THEN 'Yes'
 ELSE 'No' END as Profitable
from datacosupplychaindataset
GROUP BY `Product Name`
Order By `Avg Discount Rate`
DESC;

 -- 13. Monthly sales trend — which months 
 -- consistently perform above average?

WITH CTE AS (
SELECT MONTH(STR_TO_DATE(`order date (DateOrders)`,  '%m/%d/%Y')) AS `Month`,
ROUND(SUM(Sales) , 2) AS `Total Sales`
FROM datacosupplychaindataset
GROUP BY MONTH(STR_TO_DATE(`order date (DateOrders)`,  '%m/%d/%Y'))
ORDER BY  ROUND(SUM(Sales) , 2) DESC )
Select `Month` , `Total Sales` from CTE 
WHERE `Total Sales` > (Select Avg (`Total Sales`) from CTE );

-- 14. Which customer city has the 
--  highest number of orders?

Select `Customer City`, COUNT(*) AS `TOTAL ORDERS`				
FROM datacosupplychaindataset
GROUP BY `Customer City`
ORDER BY `TOTAL ORDERS`	
DESC;

-- 15. Which shipping mode has the highest late delivery risk 
--  percentage — and in which market is this problem worst?


SELECT `shipping mode`, Market,
ROUND(SUM(Late_delivery_risk) , 2) AS `LATE DELIVERY RISK`
from datacosupplychaindataset
GROUP BY `shipping mode`, Market
ORDER BY `LATE DELIVERY RISK`
DESC;

