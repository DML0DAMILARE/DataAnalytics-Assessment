SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.plan_type_id IN (1, 3, 4) THEN 'Savings'
        WHEN p.plan_type_id = 2 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    GREATEST(p.last_charge_date, p.last_returns_date) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE(), GREATEST(p.last_charge_date, p.last_returns_date)) AS inactivity_days
FROM 
    plans_plan p
WHERE 
    p.is_deleted = 0 
    AND p.is_archived = 0
    AND p.status_id = 1  -- Assuming status_id 1 means active
    AND (
        (p.last_charge_date IS NOT NULL AND DATEDIFF(CURRENT_DATE(), p.last_charge_date) > 365)
        OR 
        (p.last_returns_date IS NOT NULL AND DATEDIFF(CURRENT_DATE(), p.last_returns_date) > 365)
        OR
        (GREATEST(p.last_charge_date, p.last_returns_date) IS NULL AND DATEDIFF(CURRENT_DATE(), p.created_on) > 365)
    )
ORDER BY 
    inactivity_days DESC;