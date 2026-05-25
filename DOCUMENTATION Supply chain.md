# 📋 Supply Chain Analysis — Full Project Documentation

## What is this project?

This project takes a real-world supply chain dataset and uses MySQL to answer 15 specific business questions. Each query is written with a clear purpose — not just to explore data, but to extract insights that a business could actually act on.

The dataset contains order-level records from a global supply chain operation — covering markets in LATAM, Europe, Pacific Asia, USCA, and Africa. It includes information about sales, profit, shipping, customers, products, and delivery performance.

---

## Why these questions?

Every query in this project maps to a real business concern:

- Is our delivery system reliable? → Q2, Q5, Q10, Q15
- Which markets and customers drive revenue? → Q1, Q4, Q6, Q11
- Where are we losing money? → Q8, Q12
- How do our products and departments perform? → Q3, Q7
- When should we stock up and prepare? → Q13
- Where do our customers come from? → Q9, Q14

---

## Full Query Explanations

---

### Q1 — Market Sales and Profit

**What it does:**
Groups all orders by market region and calculates total sales and total profit for each. Results are sorted by total sales descending so the highest-performing market appears first.

**How it works:**
- `SUM(Sales)` adds up all order values per market
- `SUM(Order Profit Per Order)` adds up all profit per market
- `ROUND(..., 2)` formats the numbers to 2 decimal places
- `GROUP BY Market` separates the calculation per market
- `ORDER BY Total Sales DESC` puts the best market on top

**What the result tells you:**
Which global region is generating the most revenue and profit. A market with high sales but low profit signals a discount or cost problem.

---

### Q2 — Late Delivery Rate by Shipping Mode

**What it does:**
Calculates what percentage of orders were at risk of late delivery for each shipping mode.

**How it works:**
- `Late_delivery_risk` is a binary column — 1 means late risk, 0 means no risk
- `SUM(Late_delivery_risk)` counts how many orders had late risk per shipping mode
- Dividing by `COUNT(*)` gives the proportion
- Multiplying by 100 converts it to a percentage
- `ROUND(..., 2)` formats to 2 decimal places

**What the result tells you:**
First Class has a 99.50% late delivery rate — almost every First Class shipment is at risk of being late. This is a serious operations problem. Standard Class at 36.12% is the most reliable despite being the slowest scheduled option.

---

### Q3 — Category Sales and Profit Ratio

**What it does:**
Compares product categories by three metrics: total sales, total profit, and average profit ratio per item.

**How it works:**
- `SUM(Sales)` — total revenue per category
- `SUM(Order Profit Per Order)` — total profit per category
- `AVG(Order Item Profit Ratio)` — average margin per item in that category
- All three together give a complete financial picture per category

**What the result tells you:**
A category can have high total sales but a low profit ratio — meaning it sells a lot but earns little per unit. This query catches that gap and shows which categories are truly profitable vs just high volume.

---

### Q4 — Revenue by Customer Segment

**What it does:**
Groups orders by customer segment type and sums total revenue for each.

**How it works:**
- `GROUP BY Customer Segment` separates Consumer, Corporate, and Home Office
- `SUM(Sales)` adds up revenue per segment
- `ORDER BY Total Revenue DESC` shows highest first

**What the result tells you:**
Which type of customer drives the most business. Useful for deciding where to focus sales and marketing efforts.

---

### Q5 — Actual vs Scheduled Shipping Days (Gap Analysis)

**What it does:**
For each shipping mode, compares how long shipping actually takes vs how long it was scheduled to take. Calculates the gap between the two.

**How it works:**
- `AVG(Days for shipping real)` — average actual shipping time
- `AVG(Days for shipment scheduled)` — average promised shipping time
- Subtracting one from the other gives the gap
- Positive gap = consistently late, Negative gap = consistently early

**What the result tells you:**
Second Class has a +2.05 day gap — it consistently takes over 2 days longer than scheduled. Standard Class has a -0.03 gap — it actually arrives slightly ahead of schedule on average. This is the most operationally honest shipping mode.

---

### Q6 — Top 10 Customers by Total Sales

**What it does:**
Identifies the 10 highest-value customers by combining their first and last name and summing their total purchases.

**How it works:**
- `CONCAT(Customer Fname, ' ', Customer Lname)` joins the name columns into one full name
- `GROUP BY Customer Name` groups all orders per customer
- `SUM(Sales)` adds up each customer's total spending
- `LIMIT 10` returns only the top 10

**What the result tells you:**
Which individual customers are driving the most revenue. These are high-priority accounts — losing one of them would have a significant impact on total sales.

---

### Q7 — Department Benefit Per Order

**What it does:**
Ranks internal departments by how much total benefit they generate across all their orders.

**How it works:**
- `GROUP BY Department Name` separates calculations per department
- `SUM(Benefit per order)` adds up all net benefit for each department
- `ORDER BY Total Benefit Per Order DESC` shows the highest-performing department first

**What the result tells you:**
Which internal departments are the most financially valuable. Useful for resource allocation — departments with high benefit per order should get investment priority.

---

### Q8 — Negative Profit Orders by Category

**What it does:**
Filters only the orders where the business lost money (negative benefit), then counts how many such orders exist per product category.

**How it works:**
- `WHERE Benefit per order < 0` filters only loss-making rows
- `COUNT(*)` counts how many loss-making orders per category
- `GROUP BY Category Name` separates the count by category
- `ORDER BY Total Orders DESC` shows the worst category first

**What the result tells you:**
Which product categories are generating the most financial losses. This could be caused by excessive discounts, high return rates, or poor pricing strategy in specific categories.

---

### Q9 — Orders and Late Delivery Risk by Country

**What it does:**
Ranks countries by total order volume and shows their average late delivery risk rate.

**How it works:**
- `COUNT(*)` counts total orders per country
- `AVG(Late_delivery_risk)` calculates the average risk rate (since it's 0/1, this gives a proportion)
- `ROUND(..., 2)` formats to 2 decimal places
- `ORDER BY Total Orders DESC` shows the highest-order countries first

**What the result tells you:**
Countries with high order volume AND high late delivery risk are the biggest logistics problems — they need the most operational attention.

---

### Q10 — Delivery Status Percentage Breakdown

**What it does:**
Calculates what percentage of all orders fall into each delivery status category — Late, On Time, or Advance.

**How it works:**
- The subquery `(SELECT COUNT(*) FROM datacosupplychaindataset)` gets the total number of all orders
- `COUNT(*)` per group counts orders in each status
- Dividing group count by total count gives the proportion
- Multiplying by 100.0 converts to percentage
- `WHERE Delivery Status IN (...)` filters only the three relevant statuses
- `GROUP BY Delivery Status` separates the calculation per status

**What the result tells you:**
The overall health of the delivery operation at a glance. If late delivery is above 50%, the entire logistics system needs review.

---

### Q11 — Top 3 Customers Per Market (CTE + Window Function)

**What it does:**
For every market region, finds the top 3 customers by total sales — using a CTE and the RANK() window function.

**How it works:**
- The CTE calculates total sales per customer per market and assigns a rank using `RANK() OVER(PARTITION BY Market ORDER BY SUM(Sales) DESC)`
- `PARTITION BY Market` means ranking restarts for each market — so every market gets its own top 1, 2, 3
- The outer query filters `WHERE rnk <= 3` to keep only top 3 per market
- `CONCAT` combines first and last name into full name

**Why a CTE was needed:**
Window functions cannot be filtered directly in WHERE — you need to wrap them in a CTE or subquery first and then filter. This is a standard pattern for window function filtering.

**What the result tells you:**
Which customers dominate each regional market. The fact that "Mary Smith" appears as rank 1 in every market is suspicious — this is likely a data quality issue where customer names in the dataset are not unique identifiers.

---

### Q12 — Highest Discount Products — Profitable or Not?

**What it does:**
Ranks products by average discount rate and labels each one as profitable or not based on their average profit ratio.

**How it works:**
- `AVG(Order Item Discount)` calculates average discount per product
- `AVG(Order Item Profit Ratio)` calculates average margin per product
- The `CASE WHEN` statement checks if average profit ratio is above 0 — if yes, labels it "Yes" (profitable), otherwise "No"
- `ORDER BY Avg Discount Rate DESC` shows the most heavily discounted products first

**What the result tells you:**
Some products can sustain heavy discounts and still be profitable. Others cannot. This query reveals which products are being discounted into a loss — actionable information for pricing strategy.

---

### Q13 — Monthly Sales Trend vs Average (CTE)

**What it does:**
Calculates total sales for each calendar month, then filters to show only the months that performed above the overall monthly average.

**How it works:**
- `MONTH(STR_TO_DATE(...))` extracts the month number from the date string
- `STR_TO_DATE` converts the text date column into a proper date format MySQL can process
- The CTE stores total sales per month
- The outer query uses a subquery `(SELECT AVG(Total Sales) FROM CTE)` to calculate the average of all monthly totals
- Only months where `Total Sales > average` are returned

**Why a CTE was needed:**
You cannot reference an alias like `Total Sales` in a WHERE clause in the same query — it doesn't exist yet at that point in execution. The CTE creates a named result set that the outer query can filter against.

**What the result tells you:**
Which months are peak sales periods. Businesses can use this to plan inventory stocking, staffing levels, and marketing campaigns around consistently strong months.

---

### Q14 — Top City by Orders

**What it does:**
Counts total orders per customer city and sorts descending to find the most active cities.

**How it works:**
- `COUNT(*)` counts all rows (orders) per city
- `GROUP BY Customer City` separates by city
- `ORDER BY TOTAL ORDERS DESC` puts the highest-order city first

**What the result tells you:**
Which cities are the most active customer bases. These are the most important locations for local logistics, warehousing, and delivery optimization.

---

### Q15 — Late Delivery Risk by Shipping Mode and Market

**What it does:**
Combines shipping mode and market into one grouped analysis to find which specific combination has the highest total late delivery risk.

**How it works:**
- `GROUP BY Shipping Mode, Market` creates a group for every unique combination of the two columns
- `SUM(Late_delivery_risk)` adds up total risk count per combination
- `ORDER BY LATE DELIVERY RISK DESC` shows the worst combination first

**Why this is more useful than Q2 alone:**
Q2 shows overall rate per shipping mode. Q15 shows where the problem is most concentrated geographically. Standard Class globally looks reliable (36% rate) — but Standard Class in Pacific Asia has 540 high-risk orders, making it the single biggest delivery problem in the dataset.

---

## SQL Concepts Used — Full Breakdown

| Concept | Queries Used In | Purpose |
|---|---|---|
| SUM, AVG, COUNT | Q1–Q15 | Core aggregations |
| ROUND | Q1–Q13 | Format decimal output |
| GROUP BY | Q1–Q15 | Separate calculations per group |
| ORDER BY | Q1–Q15 | Sort results |
| WHERE | Q8, Q10 | Filter rows before aggregation |
| HAVING | — | Filter after aggregation (not needed here) |
| CASE WHEN | Q8, Q12 | Conditional labeling |
| CONCAT | Q6, Q11 | Combine name columns |
| STR_TO_DATE | Q13 | Convert text to date format |
| MONTH() | Q13 | Extract month from date |
| Subquery | Q10, Q13 | Calculate totals used in filtering |
| CTE | Q11, Q13 | Store intermediate results for reuse |
| RANK() OVER() | Q11 | Rank rows within partitions |
| PARTITION BY | Q11 | Restart ranking per group |
| LIMIT | Q6 | Return only top N rows |

---

## Data Quality Note

**Mary Smith appearing as rank 1 in every market** is a data quality flag. In real datasets, customer names are not unique identifiers — multiple people can share the same name. This result should be verified using `Customer ID` rather than name alone before making any business decisions based on it.

---

*Documentation — Supply Chain SQL Analysis Project*  
*Tool: MySQL Workbench | Dataset: DataCo Supply Chain*
