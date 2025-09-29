-- (1) RANKING FUNCTION: Top customers by total revenue per region
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


-- (2) AGGREGATE FUNCTION: Running monthly sales totals
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

-- (3) NAVIGATION FUNCTION: Month-over-month growth
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


-- (4) DISTRIBUTION FUNCTION: Customer segmentation
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

-- SUCCESSFUL CRITERIA

-- 1. Top 5 products per region using RANK()
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

-- 2. Running monthly sales totals
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') AS sale_month,
    SUM(amount) AS monthly_sales,
    SUM(SUM(amount)) OVER (
        ORDER BY TO_CHAR(sale_date, 'YYYY-MM')
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM transactions
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY sale_month;

-- 3. Month-over-month growth percentage
WITH monthly_data AS (
    SELECT 
        TO_CHAR(sale_date, 'YYYY-MM') AS sale_month,
        SUM(amount) AS monthly_sales
    FROM transactions
    GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
)
SELECT 
    sale_month,
    monthly_sales,
    LAG(monthly_sales) OVER (ORDER BY sale_month) AS prev_month,
    ROUND(
        ((monthly_sales - LAG(monthly_sales) OVER (ORDER BY sale_month)) / 
        NULLIF(LAG(monthly_sales) OVER (ORDER BY sale_month), 0)) * 100, 2
    ) AS growth_pct
FROM monthly_data
ORDER BY sale_month;

-- 4. Customer spending quartiles
SELECT 
    c.customer_id,
    c.name,
    SUM(t.amount) AS total_spent,
    NTILE(4) OVER (ORDER BY SUM(t.amount) DESC) AS spending_quartile
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.name
ORDER BY spending_quartile, total_spent DESC;

-- 5. 3-month moving averages
SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') AS sale_month,
    SUM(amount) AS monthly_sales,
    ROUND(AVG(SUM(amount)) OVER (
        ORDER BY TO_CHAR(sale_date, 'YYYY-MM')
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3month
FROM transactions
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY sale_month;




