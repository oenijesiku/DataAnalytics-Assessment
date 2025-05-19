# Data Analytics Assessment

This repository contains my SQL solutions to the Data Analytics Assessment.

---

## Assessment_Q1.sql - High-Value Customers with Multiple Products

**Approach:**  
Identified users with at least one savings and one investment plan by using `COUNT` and `CASE` filters grouped by user ID. Filtered only those with both types.

**Challenges:**  
Clarifying the relationship between plans and transactions, and ensuring each plan was correctly categorized using flags (`is_regular_savings`, `is_a_fund`).

---

## Assessment_Q2.sql - Transaction Frequency Analysis

**Approach:**  
Used monthly aggregation (`MONTH(transaction_date)`) to find average transactions per customer. Categorized using `CASE` logic.

**Challenges:**  
Handling missing months and ensuring fair averaging. Used CTEs to separate concerns.

---

## Assessment_Q3.sql - Customer Lifetime Value (CLV)

**Approach:**  
Calculated tenure in months from `date_joined` to current date. Used given formula to estimate CLV.

**Challenges:**  
Aligning date logic with MySQL's month diff functions and managing zero-tenure edge cases.

---

## Assessment_Q4.sql - Account Inactivity Alert

**Approach:**  
Used `MAX(transaction_date)` per plan and checked against current date for inactivity over 365 days.

**Challenges:**  
Ensuring investment and savings plans were both covered, and using `TIMESTAMPDIFF` for exact inactivity days.

# DataAnalytics-Assessment