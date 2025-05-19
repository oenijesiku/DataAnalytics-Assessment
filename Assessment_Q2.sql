-- Step 1: Count the number of transactions each customer made per month
WITH customer_monthly_tx AS (
    SELECT
        owner_id,  -- The customer ID
        MONTH(transaction_date) AS tx_month,  -- Extract the month from transaction date
        COUNT(*) AS tx_count  -- Count number of transactions for that customer in that month
    FROM savings_savingsaccount
    GROUP BY owner_id, MONTH(transaction_date)  -- Group by customer and month
),

-- Step 2: Calculate average transactions per month for each customer
average_tx_per_customer AS (
    SELECT
        owner_id,
        ROUND(AVG(tx_count), 2) AS avg_transactions_per_month  -- Average of monthly transaction counts per customer
    FROM customer_monthly_tx
    GROUP BY owner_id
),

-- Step 3: Categorize customers based on their average monthly transactions
categorized_customers AS (
    SELECT
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,  -- Assign frequency label
        avg_transactions_per_month
    FROM average_tx_per_customer
)

-- Step 4: Final aggregation - how many customers are in each frequency category
SELECT
    frequency_category,  -- High / Medium / Low Frequency
    COUNT(*) AS customer_count,  -- How many customers fall in this category
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month  -- Average across customers in that category
FROM categorized_customers
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');  -- Maintain desired output order