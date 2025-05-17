WITH monthly_transactions AS (
    SELECT 
        t.customer_id,
        u.name,
        DATE_FORMAT(t.transaction_date, '%Y-%m') AS month,
        COUNT(*) AS transactions_count
    FROM 
        transactions t
    JOIN 
        users_customuser u ON t.customer_id = u.id
    WHERE 
        t.transaction_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 12 MONTH)
    GROUP BY 
        t.customer_id, u.name, DATE_FORMAT(t.transaction_date, '%Y-%m')
),

customer_avg AS (
    SELECT 
        customer_id,
        name,
        AVG(transactions_count) AS avg_transactions_per_month,
        CASE 
            WHEN AVG(transactions_count) >= 10 THEN 'High Frequency'
            WHEN AVG(transactions_count) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM 
        monthly_transactions
    GROUP BY 
        customer_id, name
)

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM 
    customer_avg
GROUP BY 
    frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;