SELECT 
    u.id AS owner_id,  -- Get the user ID
    CONCAT(u.first_name, ' ', u.last_name) AS name,  -- Combine first and last name as full name

    -- Count distinct savings plans (where the plan is a regular savings type)
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,

    -- Count distinct investment plans (where the plan is a fund/investment type)
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,

    -- Sum up confirmed deposits (in kobo), convert to naira, and round to 2 decimal places
    ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits

FROM savings_savingsaccount s
-- Join the plan information to know the type of each savings/investment plan
LEFT JOIN plans_plan p ON s.plan_id = p.id

-- Join the user data to get names and associate savings with users
LEFT JOIN users_customuser u ON s.owner_id = u.id

-- Only include transactions where money was actually deposited
WHERE s.confirmed_amount > 0

-- Group results by user
GROUP BY u.id, u.first_name, u.last_name

-- Only include users who have at least one savings and one investment plan
HAVING 
    savings_count > 0 AND 
    investment_count > 0

-- Order by the total amount deposited (highest first)
ORDER BY total_deposits DESC;