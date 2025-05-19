-- Step 1: Calculate total transactions and account tenure in months for each customer
WITH user_activity AS (
    SELECT
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        SUM(s.confirmed_amount) AS total_transaction_value
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY u.id, u.first_name, u.last_name, u.date_joined
    HAVING tenure_months > 0  -- Prevent division by zero
),

-- Step 2: Estimate CLV based on formula
clv_estimate AS (
    SELECT
        customer_id,
        name,
        tenure_months,
        total_transactions,
        ROUND((total_transactions / tenure_months) * 12 * (total_transaction_value * 0.001 / total_transactions), 2) AS estimated_clv
        -- avg_profit_per_transaction = 0.001 * avg transaction value
    FROM user_activity
    WHERE total_transactions > 0
)

-- Final Output
SELECT *
FROM clv_estimate
ORDER BY estimated_clv DESC;
