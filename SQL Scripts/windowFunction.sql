-- (1) Ranking function: Top customers by total revenue per region
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


-- (2) Aggregate Function: Running monthly sales totals
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

-- (3) Navigation Function: Month-over-month growth
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


-- (4) Distribution Function: Customer segmentation
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


