# PL/SQL Window Functions Assignment

  #### Name: MUCYO Fabrice
  #### ID: 27823
  #### Course: Database Development with PL/SQL


---


## Step1: Problem Definition
The company is called NewSpecies is a technology retail company in Rwanda and it has sales and Marketing departments 

### Data Challenge:
The company needs to analyze sales performance across different regions to optimize inventory management and 
marketing strategies and they are struggling to identify top performing products by region and understand 
sales trends over time and segment customers effectively for targeted campaigns

### Expected Outcome:
Identify regional product performance and analyze sales growth patterns and create customer segments for 
personalized marketing campaigns to increase revenue by 15% in the next quarter

---

## Step2: Step 2: Success Criteria
 Define exactly 5 measurable goals:
 1. Top 5 products per region/quarter → RANK()
 2. Running monthly sales totals → SUM() OVER()
 3. Month-over-month growth → LAG()/LEAD()
 4. Customer quartiles → NTILE(4)
 5. 3-month moving averages → AVG() OVER()

## Step3: Database Schema
Here is the 3 tables that are created
### - CUSTOMER
<img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/Create%20Table%20customers.png" width=800>
<img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/customer%20data.png" width=500>

---

### - PRODUCT
<img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/Create%20Table%20product.png" width=800>
<img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/product%20data.png" width=500>

---

### - TRANSACTION
<img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/Create%20Table%20Transaction.png" width=800>
<img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/transaction%20data.png" width=500>

---


### - ER Diagram
Here is the ER Diagram from the above table created 

<img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/ER%20Diagram.png" width=700>

---

## Step4: Window Function Implementation
 ## 1. RANKING
 This query ranks customers within each region by their total spending and ROW_NUMBER gives unique sequential numbers and RANK shows position with gaps for ties and DENSE_RANK shows position without gaps and PERCENT_RANK shows relative standing as a percentage
 
 ```sql
 SELECT 
    c.region,
    c.name AS customer_name,
    SUM(t.amount) AS total_revenue,
    ROW_NUMBER() OVER (PARTITION BY c.region ORDER BY SUM(t.amount) DESC) AS row_num,
    RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.amount) DESC) AS rank,
    DENSE_RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.amount) DESC) AS dense_rank,
    ROUND(PERCENT_RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.amount) DESC), 2) AS percent_rank
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.region, c.name
ORDER BY c.region, total_revenue DESC;
```
<p float='left'>
  <img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/Rank%20insert.png" width=500>
  <img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/rank%20table.png" width=500>
</p>

---

 ## 2. AGGREGATE
The first query shows running totals using both ROWS (physical rows) and RANGE (logical values) framing and also the second query calculates a 3 month moving average to smooth out sales trends and identify patterns

```sql
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') AS sale_month,
    SUM(amount) AS monthly_sales,
    SUM(SUM(amount)) OVER (
        ORDER BY TO_CHAR(sale_date, 'YYYY-MM') 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_rows,
    SUM(SUM(amount)) OVER (
        ORDER BY TO_CHAR(sale_date, 'YYYY-MM') 
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_range
FROM transactions
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY sale_month;

-- 3-month moving average
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') AS sale_month,
    SUM(amount) AS monthly_sales,
    ROUND(AVG(SUM(amount)) OVER (
        ORDER BY TO_CHAR(sale_date, 'YYYY-MM')
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3months
FROM transactions
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY sale_month;
```
<p float='left'>
  <img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/Aggregate%20insert.png" width=500>
  <img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/Aggregate%20insert%202.png" width=500>
</p>

---

 ## 3. NAVIGATION
These queries analyze period to period changes and LAG() helps calculate month over month growth percentages while LEAD() can be used for basic forecasting by looking at subsequent periods

```sql
WITH monthly_sales AS (
    SELECT 
        TO_CHAR(sale_date, 'YYYY-MM') AS sale_month,
        SUM(amount) AS monthly_sales
    FROM transactions
    GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
)
SELECT 
    sale_month,
    monthly_sales,
    LAG(monthly_sales) OVER (ORDER BY sale_month) AS previous_month_sales,
    ROUND(
        ((monthly_sales - LAG(monthly_sales) OVER (ORDER BY sale_month)) / 
        LAG(monthly_sales) OVER (ORDER BY sale_month)) * 100, 2
    ) AS growth_percentage
FROM monthly_sales
ORDER BY sale_month;

-- LEAD for next period forecasting
WITH monthly_sales AS (
    SELECT 
        TO_CHAR(sale_date, 'YYYY-MM') AS sale_month,
        SUM(amount) AS monthly_sales
    FROM transactions
    GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
)
SELECT 
    sale_month,
    monthly_sales,
    LEAD(monthly_sales) OVER (ORDER BY sale_month) AS next_month_actual,
    ROUND(monthly_sales * 1.1, 2) AS next_month_forecast
FROM monthly_sales
ORDER BY sale_month;
```
<p>
  <img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/Navigation%20insert.png" width=500>
  <img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/NAvigation%20table%20(2).png" width=500>
</p>

---

 ## 4. DISTRIBUTION
This query segments customers into quartiles based on their total spending and NTILE(4) divides customers into 4 equal groups while CUME_DIST() shows the cumulative distribution percentage of each customer's spending relative to others

```sql
SELECT 
    c.customer_id,
    c.name AS customer_name,
    c.region,
    SUM(t.amount) AS total_spent,
    NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) AS spending_quartile,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) = 1 THEN 'Platinum'
        WHEN NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) = 2 THEN 'Gold'
        WHEN NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) = 3 THEN 'Silver'
        ELSE 'Bronze'
    END AS customer_segment,
    ROUND(CUME_DIST() OVER (ORDER BY SUM(t.amount) DESC), 2) AS cumulative_distribution
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.name, c.region
ORDER BY total_spent DESC;
```
<p float='left'>
  <img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/Distribution%20insert.png" width=500>
  <img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/Distribution%20table.png" width=500>
</p>

---

## Step6: Result Analysis

### 




