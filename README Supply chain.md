# 📦 Supply Chain SQL Analysis — SQL Project

## Project Overview

This project performs exploratory data analysis on a real-world supply chain dataset using MySQL. The goal is to extract meaningful business insights about sales performance, delivery efficiency, customer behavior, shipping modes, and product profitability across global markets.

- **Database:** supplychain  
- **Table:** datacosupplychaindataset  
- **Tool Used:** MySQL Workbench  
- **Total Queries:** 15  
- **Dataset Size:** 6,118 rows  

---

## Dataset Description

The `datacosupplychaindataset` table contains order-level supply chain data including:

| Column | Description |
|---|---|
| Market | Global market/region (LATAM, Europe, USCA, Pacific Asia, Africa) |
| Sales | Total sales value per order |
| Order Profit Per Order | Profit generated per order |
| Late_delivery_risk | Binary flag — 1 if late delivery risk, 0 if not |
| Shipping Mode | Shipping type (Standard Class, First Class, Second Class, Same Day) |
| Category Name | Product category |
| Customer Segment | Segment type (Consumer, Corporate, Home Office) |
| Days for shipping (real) | Actual days taken to ship |
| Days for shipment (scheduled) | Scheduled days for shipment |
| Customer Fname / Lname | Customer first and last name |
| Department Name | Internal department name |
| Benefit per order | Net benefit per order |
| Customer Country / City | Customer location |
| Delivery Status | Late delivery / Shipping on time / Advance shipping |
| Product Name | Name of product ordered |
| Order Item Discount | Discount applied per item |
| Order Item Profit Ratio | Profit ratio per item |
| order date (DateOrders) | Date the order was placed |

---

## Queries & Results

### Q1. Which market generates the highest total sales and profit?

**Objective:** Identify top-performing global markets by total sales and total profit.

```sql
Select Market, ROUND(SUM(Sales), 2) as `Total Sales`,
ROUND(SUM(`Order Profit Per Order`), 2) as `Total Profit`
from datacosupplychaindataset
GROUP BY Market
ORDER BY `Total Sales` DESC;
```

**Result:**

| Market | Total Sales | Total Profit |
|---|---|---|
| Pacific Asia | 433,734.94 | 47,431.42 |
| Europe | 357,765.58 | 38,327.64 |
| LATAM | 355,273.24 | 38,422.86 |
| USCA | 66,294.76 | 5,676.31 |
| Africa | 43,304.53 | 4,001.38 |

**Insight:** Pacific Asia leads in both total sales and total profit. LATAM has higher profit than Europe despite lower sales — indicating better margins.

---

### Q2. What is the late delivery rate per shipping mode?

**Objective:** Find which shipping mode has the highest percentage of late deliveries.

```sql
Select `Shipping Mode`, 
ROUND(SUM(Late_delivery_risk) / COUNT(*) * 100 , 2) as `Late Delivery Rate`
from datacosupplychaindataset
Group by `Shipping Mode`
ORDER BY `Late Delivery Rate` DESC;
```

**Result:**

| Shipping Mode | Late Delivery Rate |
|---|---|
| First Class | 99.50% |
| Second Class | 80.02% |
| Same Day | 56.64% |
| Standard Class | 36.12% |

**Insight:** First Class has the highest late delivery rate at 99.50% — despite being a premium option. Standard Class is the most reliable.

---

### Q3. Which product category has the highest sales and profit ratio?

**Objective:** Compare categories by total sales, total profit, and profit ratio.

```sql
Select `Category Name`,
ROUND(SUM(Sales), 2) AS `Total Sales`,
ROUND(SUM(`Order Profit Per Order`) , 2) AS `Total Profit`,
ROUND(AVG(`Order Item Profit Ratio`) , 3) as `Profit Ratio`
from datacosupplychaindataset
GROUP BY `Category Name`
ORDER BY `Total Sales` DESC;
```

**Result (Top 10 by Sales):**

| Category Name | Total Sales | Total Profit | Profit Ratio |
|---|---|---|---|
| Cleats | 205,285.87 | 19,077.35 | 0.103 |
| Cardio Equipment | 171,133.05 | 16,139.80 | 0.102 |
| Women's Apparel | 150,450.00 | 16,005.68 | 0.118 |
| Camping & Hiking | 134,691.02 | 15,597.18 | 0.129 |
| Sporting Goods | 117,006.75 | 12,518.61 | 0.121 |
| Men's Footwear | 104,511.96 | 9,765.55 | 0.105 |
| Fishing | 93,995.30 | 8,213.18 | 0.101 |
| Shop By Sport | 63,354.58 | 6,733.95 | 0.113 |
| Hockey | 48,360.73 | 5,397.43 | 0.128 |
| Computers | 19,500.00 | 3,966.48 | 0.236 |

**Insight:** Cleats has the highest total sales. Computers has a significantly higher profit ratio (0.236) despite lower sales volume — meaning it earns more per unit sold.

---

### Q4. Which customer segment generates the most revenue?

**Objective:** Identify the most valuable customer segment by total revenue.

```sql
Select `Customer Segment`, 
ROUND(SUM(Sales) , 2) as `Total Revenue`
from datacosupplychaindataset
GROUP BY `Customer Segment`
ORDER BY `Total Revenue` DESC;
```

**Result:**

| Customer Segment | Total Revenue |
|---|---|
| Consumer | 722,257.60 |
| Corporate | 377,052.74 |
| Home Office | 157,062.70 |

**Insight:** Consumer segment generates nearly double the revenue of Corporate — it is the most valuable segment by far.

---

### Q5. Average actual vs scheduled shipping days — where is the biggest gap?

**Objective:** Find which shipping mode consistently takes longer than scheduled.

```sql
Select `Shipping Mode`,
ROUND(AVG(`Days for shipping (real)`) , 2) as `Average Actual Shipping`,
ROUND(AVG(`Days for shipment (scheduled)`), 2) as `Average Scheduled Shipping`,
ROUND(AVG(`Days for shipping (real)`) - AVG(`Days for shipment (scheduled)`) , 2) as `Biggest gap`
from datacosupplychaindataset
GROUP BY `Shipping Mode`
ORDER BY `Biggest gap` DESC;
```

**Result:**

| Shipping Mode | Avg Actual | Avg Scheduled | Gap |
|---|---|---|---|
| Second Class | 4.05 | 2.00 | +2.05 |
| First Class | 2.00 | 1.00 | +1.00 |
| Same Day | 0.59 | 0.00 | +0.59 |
| Standard Class | 3.97 | 4.00 | -0.03 |

**Insight:** Second Class has the biggest gap — 2.05 days over schedule. Standard Class is the only mode that arrives slightly ahead of schedule.

---

### Q6. Which top 10 customers have the highest total sales?

**Objective:** Identify the highest-value customers by total sales.

```sql
Select CONCAT(`Customer Fname`, ' ' , `Customer Lname`) as `Customer Name`,
ROUND(SUM(Sales) , 2) as `Total Sales`
from datacosupplychaindataset
GROUP BY `Customer Name`
ORDER BY `Total Sales` DESC LIMIT 10;
```

**Result:**

| Customer Name | Total Sales |
|---|---|
| Mary Smith | 147,368.45 |
| John Smith | 4,549.50 |
| Steven Smith | 4,034.71 |
| William Smith | 3,739.70 |
| Nicholas Smith | 3,639.69 |
| Robert Smith | 3,504.54 |
| James Smith | 3,486.62 |
| Mary Anderson | 3,390.69 |
| Sandra Smith | 3,316.54 |
| George Smith | 3,174.75 |

**Insight:** Mary Smith's total sales (147,368.45) are over 32x higher than the second-ranked customer — a strong data quality flag. This customer likely represents aggregated or masked data.

---

### Q7. Which department has the highest total benefit per order?

**Objective:** Find which internal department generates the most benefit.

```sql
Select `Department Name` , 
ROUND(SUM(`Benefit per order`), 2) as `Total Benefit Per Order`
from datacosupplychaindataset
GROUP BY `Department Name`
ORDER BY `Total Benefit Per Order` DESC;
```

**Result:**

| Department Name | Total Benefit Per Order |
|---|---|
| Apparel | 33,790.00 |
| Fan Shop | 24,226.72 |
| Golf | 23,588.98 |
| Fitness | 20,734.07 |
| Footwear | 18,091.23 |
| Technology | 7,572.74 |
| Outdoors | 4,648.71 |
| Discs Shop | 916.01 |
| Health and Beauty | 212.88 |
| Pet Shop | 95.87 |
| Book Shop | -17.60 |

**Insight:** Apparel leads with the highest total benefit. Book Shop is the only department generating negative total benefit — a loss-making department that needs pricing review.

---

### Q8. How many orders have negative profit — and which categories lose the most?

**Objective:** Identify loss-making orders and which categories they belong to.

```sql
Select `Category Name`, 
Count(*) as `Total Orders`
from datacosupplychaindataset
WHERE `Benefit per order` < 0
Group by `Category Name`
ORDER BY `Total Orders` DESC;
```

**Result (Top 10):**

| Category Name | Total Loss Orders |
|---|---|
| Cleats | 213 |
| Women's Apparel | 153 |
| Men's Footwear | 153 |
| Hockey | 111 |
| Cardio Equipment | 102 |
| Shop By Sport | 87 |
| Camping & Hiking | 74 |
| Sporting Goods | 60 |
| Fishing | 43 |
| Accessories | 21 |

**Insight:** Cleats has the most loss-making orders (213) — the same category that leads in total sales. This means heavy discounting is eating into profits despite high volume.

---

### Q9. Which country receives the most orders and what is their late delivery rate?

**Objective:** Rank countries by order volume and show their delivery reliability.

```sql
Select `Customer Country`, Count(*) as `Total Orders`,
ROUND(AVG(Late_delivery_risk) , 2) as `Late Delivery Rate`
from datacosupplychaindataset
GROUP BY `Customer Country`
ORDER BY `Total Orders` DESC;
```

**Result:**

| Customer Country | Total Orders | Late Delivery Rate |
|---|---|---|
| EE. UU. | 3,695 | 0.44 |
| Puerto Rico | 2,423 | 0.65 |

**Insight:** Puerto Rico has a significantly higher late delivery rate (0.65) despite fewer orders — delivery reliability in Puerto Rico needs urgent attention.

---

### Q10. What percentage of orders were delivered late vs on time vs advance?

**Objective:** Get a complete delivery status breakdown as percentages.

```sql
SELECT `Delivery Status`, 
ROUND(COUNT(*)/(Select COUNT(*) from datacosupplychaindataset) * 100.0 , 2) AS `Delivery Rate`
from datacosupplychaindataset
WHERE `Delivery Status` IN ('Late delivery', 'Shipping on time', 'Advance shipping')
GROUP BY `Delivery Status`;
```

**Result:**

| Delivery Status | Delivery Rate |
|---|---|
| Late delivery | 52.50% |
| Advance shipping | 25.29% |
| Shipping on time | 16.95% |

**Insight:** Over half of all orders (52.50%) are delivered late — this is a critical operations problem. Only 16.95% ship on time.

---

### Q11. For each market, who are the top 3 customers by total sales?

**Objective:** Use Window Functions and CTE to rank customers within each market.

```sql
WITH CTE AS(
Select `Market`, 
CONCAT(`Customer Fname` , ' ' , `Customer Lname`) as `Full Name`,
ROUND(SUM(Sales) , 2) as `Total Sales`,
Rank() OVER(partition by `Market` ORDER BY SUM(Sales) DESC) as rnk 
from datacosupplychaindataset
GROUP BY `Market`, `Customer Fname`, `Customer Lname`)
select * from CTE WHERE rnk <= 3;
```

**Result:**

| Market | Full Name | Total Sales | Rank |
|---|---|---|---|
| Africa | Mary Smith | 5424.46 | 1 |
| Africa | George Middleton | 799.92 | 2 |
| Africa | Wayne Rodriguez | 729.95 | 3 |
| Europe | Mary Smith | 40995.33 | 1 |
| Europe | Steven Smith | 2879.83 | 2 |
| Europe | David Smith | 2125.76 | 3 |
| LATAM | Mary Smith | 51269.34 | 1 |
| LATAM | William Smith | 3029.76 | 2 |
| LATAM | Mary Anderson | 2159.81 | 3 |
| Pacific Asia | Mary Smith | 41735.26 | 1 |
| Pacific Asia | John Smith | 2119.77 | 2 |
| Pacific Asia | Mary Allen | 1821.90 | 3 |
| USCA | Mary Smith | 7944.06 | 1 |
| USCA | Madison Russo | 924.85 | 2 |
| USCA | Mary Phillips | 909.96 | 3 |

**Insight:** Mary Smith appears as rank 1 in every single market — this is likely a data quality issue worth investigating. Real customer names may be masked or duplicated in the dataset.

---

### Q12. Which product has the highest average discount — and is it profitable?

**Objective:** Find heavily discounted products and check if they still generate profit.

```sql
Select `Product Name`, 
ROUND(AVG(`Order Item Discount`) , 2) AS `Avg Discount Rate`,
CASE WHEN AVG(`Order Item Profit Ratio`) > 0 THEN 'Yes'
ELSE 'No' END as Profitable
from datacosupplychaindataset
GROUP BY `Product Name`
Order By `Avg Discount Rate` DESC;
```

**Insight:** High discounts don't always mean loss — this query combines both metrics to give a complete picture of each product's financial health.

---

### Q13. Monthly sales trend — which months consistently perform above average?

**Objective:** Use a CTE to calculate monthly sales and filter months above the overall average.

```sql
WITH CTE AS (
SELECT MONTH(STR_TO_DATE(`order date (DateOrders)`, '%m/%d/%Y')) AS `Month`,
ROUND(SUM(Sales) , 2) AS `Total Sales`
FROM datacosupplychaindataset
GROUP BY MONTH(STR_TO_DATE(`order date (DateOrders)`, '%m/%d/%Y'))
ORDER BY ROUND(SUM(Sales) , 2) DESC)
Select `Month`, `Total Sales` from CTE 
WHERE `Total Sales` > (Select Avg(`Total Sales`) from CTE);
```

**Result:**

| Month | Total Sales |
|---|---|
| 1 (January) | 180,100.50 |
| 12 (December) | 146,766.47 |
| 10 (October) | 107,876.94 |
| 11 (November) | 106,414.89 |
| 9 (September) | 105,714.28 |
| 2 (February) | 104,731.80 |

**Insight:** January is the strongest sales month by far. Q4 (October–December) consistently performs above average — suggesting strong seasonal demand toward year-end.

---

### Q14. Which customer city has the highest number of orders?

**Objective:** Find the most active customer cities by order volume.

```sql
Select `Customer City`, COUNT(*) AS `TOTAL ORDERS`				
FROM datacosupplychaindataset
GROUP BY `Customer City`
ORDER BY `TOTAL ORDERS` DESC;
```

**Insight:** High-order cities are priority locations for logistics optimization and customer service investment.

---

### Q15. Which shipping mode has the highest late delivery risk per market?

**Objective:** Break down late delivery risk by both shipping mode and market combined.

```sql
SELECT `shipping mode`, Market,
ROUND(SUM(Late_delivery_risk) , 2) AS `LATE DELIVERY RISK`
from datacosupplychaindataset
GROUP BY `shipping mode`, Market
ORDER BY `LATE DELIVERY RISK` DESC;
```

**Result (Top 5):**

| Shipping Mode | Market | Late Delivery Risk |
|---|---|---|
| Standard Class | Pacific Asia | 540 |
| Standard Class | LATAM | 415 |
| Standard Class | Europe | 383 |
| Second Class | Europe | 326 |
| First Class | Pacific Asia | 240 |

**Insight:** Standard Class in Pacific Asia has the highest absolute late delivery risk. Combined with Q2, this shows Standard Class has the lowest rate but highest volume — meaning it generates the most late deliveries overall.

---

## Key Takeaways

- **Pacific Asia** leads all markets in total sales ($433,734) and total profit ($47,431).
- **52.50%** of all orders are delivered late — a critical supply chain problem.
- **First Class** shipping has the highest late delivery rate (99.50%) despite being premium.
- **Second Class** has the biggest gap between actual and scheduled shipping (+2.05 days).
- **Standard Class** is the only shipping mode that arrives ahead of schedule (-0.03 days).
- **Consumer segment** generates nearly double the revenue of Corporate ($722K vs $377K).
- **Cleats** is the top-selling category but also has the most loss-making orders (213) — heavy discounting is hurting margins.
- **Book Shop** is the only department with negative total benefit (-17.60).
- **Puerto Rico** has a 65% late delivery rate — the worst delivery reliability of any country.
- **January** is the strongest sales month; Q4 (Oct–Dec) consistently performs above average.
- **Mary Smith** appearing as rank 1 across all markets with $147K in sales is a data quality flag.

---

## SQL Concepts Used

- Aggregate Functions — SUM, AVG, COUNT, ROUND
- GROUP BY and ORDER BY
- WHERE and HAVING
- CASE Statements — conditional profitability labeling
- CTEs (Common Table Expressions) — monthly trend analysis
- Window Functions — RANK() OVER(PARTITION BY) for top customers per market
- Subqueries — delivery percentage calculation
- String Functions — CONCAT for full customer names
- Date Functions — STR_TO_DATE, MONTH

---

## Author

**SQL Project — Supply Chain Analysis**  
Tool: MySQL Workbench  
Dataset: DataCo Supply Chain Dataset  
LinkedIn: [Tahoor Tayyab](https://www.linkedin.com/in/tahoor-tayyab/)
