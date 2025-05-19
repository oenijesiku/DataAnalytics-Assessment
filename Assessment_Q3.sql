-- Step 1: Get the most recent savings transaction date per plan and owner
WITH last_savings AS (
    SELECT
        p.id AS plan_id,
        s.owner_id,
        'Savings' AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount s
    LEFT JOIN plans_plan p ON s.plan_id = p.id
    -- Only include regular savings plans with confirmed deposits
    WHERE p.is_regular_savings = 1 AND s.confirmed_amount > 0
    GROUP BY p.id, s.owner_id
),

-- Step 2: Get the most recent investment transaction date per plan and owner
last_investments AS (
    SELECT
        p.id AS plan_id,
        s.owner_id,
        'Investment' AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount s
    LEFT JOIN plans_plan p ON s.plan_id = p.id
    -- Only include investment plans with confirmed deposits
    WHERE p.is_a_fund = 1 AND s.confirmed_amount > 0
    GROUP BY p.id, s.owner_id
),

-- Step 3: Combine both savings and investment last transaction records
combined AS (
    SELECT * FROM last_savings
    UNION ALL
    SELECT * FROM last_investments
)

-- Step 4: Select plans with no transactions in the last 365 days
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    -- Calculate the number of days since last transaction
    TIMESTAMPDIFF(DAY, last_transaction_date, CURRENT_DATE) AS inactivity_days
FROM combined
-- Filter to only include plans inactive for at least 1 year
WHERE last_transaction_date <= CURRENT_DATE - INTERVAL 365 DAY;