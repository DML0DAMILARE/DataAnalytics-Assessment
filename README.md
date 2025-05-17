1). High Value Customers with Multiple Products: Assessment_Q1.sql
* plan_type_id values:
1 = Savings plan (based on common values in the data)
2 = Investment plan (Mutual Funds, Managed Portfolios)
3 = Family plan
4 = Emergency plan

status_id 1 means active/funded plans
is_deleted = 0 and is_archived = 0 filters out inactive plans

* The query joins with users_customuser to get customer names.
* The results are sorted by total deposits in descending order to show high-value customers first.


2). Transaction Frequency Analysis: Assessment_Q2.sql
* Transactions table with columns - 
customer_id (linking to users_customuser.id)
transaction_date (the date of the transaction)

* The query:
First calculates monthly transaction counts per customer (CTE monthly_transactions)
Then calculates average monthly transactions and assigns frequency categories (CTE customer_avg)
Finally aggregates results by frequency category

* The analysis looks at the last 12 months of data (adjustable)

3). Account Inactivity Alert: Assessment_Q3.sql
* This query uses the plans_plan table fields - 
last_charge_date: Last deposit date
last_returns_date: Last interest/return date
created_on: Account creation date (used if no transaction dates exist)

* Key logic:
Considers an account inactive if no transactions for >365 days
Uses the most recent of charge or returns date to determine inactivity
Includes accounts with no transactions since creation (>365 days old)

* Output matches requested format showing:
Plan ID
Owner ID
Account type
Last transaction date
Days inactive

4).  Customer Lifetime Value (CLV) Estimation: Assessment_Q4.sql
users_customuser has created_at field for signup date
Using plans_plan as proxy for transactions (count of plans = transaction count)
Profit per transaction is 0.1% (0.001) of transaction amount
CLV formula: (total_transactions/tenure_months) * 12 * (avg_transaction_amount * 0.001)

* Key components:
First CTE calculates customer tenure, transaction counts, and average amounts
Main query computes the CLV using the specified formula
NULLIF prevents division by zero for new customers
Results ordered by CLV (highest value first)

* Output matches your requested format with:
Customer ID
Name
Tenure in months
Total transactions
Estimated CLV




