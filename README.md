# PL/SQL Assignment

  ### Name: MUCYO Fabrice
  ### ID: 27823
  ### Course: Database Development with PL/SQL


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
### Customer
![Customer](https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/Create%20Table%20customers.png)

### Product
![Product](https://github.com/FabriceMUCYO/-plsql-window-functions-Fabrice-MUCYO/blob/main/Oracle%20Screenshots/Create%20Table%20product.png)

### Transaction
![Transaction]()
