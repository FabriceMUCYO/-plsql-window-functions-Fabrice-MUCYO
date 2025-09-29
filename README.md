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
### -CUSTOMER
<img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/Create%20Table%20customers.png" width=800>
<img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/customer%20data.png" width=500>

---

### -PRODUCT
<img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/Create%20Table%20product.png" width=800>
<img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/product%20data.png" width=500>

---

### -TRANSACTION
<img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/Create%20Table%20Transaction.png" width=800>
<img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/transaction%20data.png" width=500>

---


### -ER Diagram
Here is the ER Diagram from the above table created 

<img src="https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/ER%20Diagram.png" width=700>

---

## Step4: Window Function Implementation
 1. Ranking: ROW_NUMBER(), RANK(), DENSE_RANK(), PERCENT_RANK() Use case: Top N customers by
 revenue
 ```sql
 
 2. Aggregate: SUM(), AVG(), MIN(), MAX() with frame comparisons (ROWS vs RANGE) Use case: Running
 totals & trends
 3. Navigation: LAG(), LEAD(), growth % calculations Use case: Period-to-period analysis
 4. Distribution: NTILE(4), CUME_DIST() Use case: Customer segmentatio



