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
    ```sql
    WITH regional_products AS (
       SELECT 
          c.region,
          p.name AS product_name,
          SUM(t.amount) AS regional_revenue,
          RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.amount) DESC) AS region_rank
       FROM transactions t
       JOIN customers c ON t.customer_id = c.customer_id
       JOIN products p ON t.product_id = p.product_id
       GROUP BY c.region, p.name
    )
    SELECT region, product_name, regional_revenue, region_rank
    FROM regional_products
    WHERE region_rank <= 5
    ORDER BY region, region_rank;



 3. Running monthly sales totals → SUM() OVER()
 4. Month-over-month growth → LAG()/LEAD()
 5. Customer quartiles → NTILE(4)
 6. 3-month moving averages → AVG() OVER()
