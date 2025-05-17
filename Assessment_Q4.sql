WITH customer_stats AS (
    SELECT 
        p.owner_id AS customer_id,
        u.name,
        -- Calculate tenure in months
        TIMESTAMPDIFF(MONTH, u.created_at, CURRENT_DATE()) AS tenure_months,
        -- Count all plans as proxy for transactions (adjust if you have actual transaction data)
        COUNT(p.id) AS total_transactions,
        -- Calculate average transaction amount (using plan amount as proxy)
        AVG(p.amount) AS avg_transaction_amount
    FROM 
        plans_plan p
    JOIN 
        users_customuser u ON p.owner_id = u.id
    WHERE 
        p.is_deleted = 0
        AND p.is_archived = 0
    GROUP BY 
        p.owner_id, u.name, u.created_at
)

SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    -- CLV calculation: (total_transactions/tenure)*12*(avg_transaction_amount*0.001)
    ROUND((total_transactions / NULLIF(tenure_months, 0)) * 12 * (avg_transaction_amount * 0.001), 2) AS estimated_clv
FROM 
    customer_stats
WHERE 
    tenure_months > 0  -- Exclude customers who joined this month
ORDER BY 
    estimated_clv DESC;