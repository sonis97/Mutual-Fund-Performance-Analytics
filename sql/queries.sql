-- =====================================================
-- Bluestock Mutual Fund Analytics Project
-- SQL Analysis Queries
-- Author: Saurabh Soni
-- Database: PostgreSQL
-- =====================================================

--------------------------------------------------------
-- 1. View all Mutual Fund Schemes
--------------------------------------------------------

SELECT *
FROM fund_master;

--------------------------------------------------------
-- 2. Count Total Mutual Fund Schemes
--------------------------------------------------------

SELECT COUNT(*) AS total_schemes
FROM fund_master;

--------------------------------------------------------
-- 3. List Distinct Fund Categories
--------------------------------------------------------

SELECT DISTINCT category
FROM fund_master
ORDER BY category;

--------------------------------------------------------
-- 4. Filter Funds with Expense Ratio Less Than 1%
--------------------------------------------------------

SELECT scheme_name,
       category,
       expense_ratio
FROM fund_master
WHERE expense_ratio < 1
ORDER BY expense_ratio;

--------------------------------------------------------
-- 5. Top 10 Fund Houses by AUM
--------------------------------------------------------

SELECT fund_house,
       SUM(aum_crore) AS total_aum
FROM aum_by_fund_house
GROUP BY fund_house
ORDER BY total_aum DESC
LIMIT 10;

--------------------------------------------------------
-- 6. Average Expense Ratio by Category
--------------------------------------------------------

SELECT category,
       ROUND(AVG(expense_ratio),2) AS avg_expense_ratio
FROM fund_master
GROUP BY category
ORDER BY avg_expense_ratio DESC;

--------------------------------------------------------
-- 7. Categories Having More Than 5 Schemes
--------------------------------------------------------

SELECT category,
       COUNT(*) AS total_schemes
FROM fund_master
GROUP BY category
HAVING COUNT(*) > 5
ORDER BY total_schemes DESC;

--------------------------------------------------------
-- 8. Top 10 Funds by 5-Year Return
--------------------------------------------------------

SELECT scheme_name,
       five_year_return
FROM scheme_performance
ORDER BY five_year_return DESC
LIMIT 10;

--------------------------------------------------------
-- 9. Average NAV of Each Scheme
--------------------------------------------------------

SELECT amfi_code,
       ROUND(AVG(nav),2) AS average_nav
FROM nav_history
GROUP BY amfi_code
ORDER BY average_nav DESC;

--------------------------------------------------------
-- 10. Monthly SIP Inflow Trend
--------------------------------------------------------

SELECT month,
       sip_inflow_crore
FROM monthly_sip_inflows
ORDER BY month;

--------------------------------------------------------
-- 11. Total Investor Transactions by State
--------------------------------------------------------

SELECT state,
       COUNT(*) AS total_transactions
FROM investor_transactions
GROUP BY state
ORDER BY total_transactions DESC;

--------------------------------------------------------
-- 12. Category-wise Net Inflows
--------------------------------------------------------

SELECT category,
       SUM(net_inflow_crore) AS total_inflow
FROM category_inflows
GROUP BY category
ORDER BY total_inflow DESC;

--------------------------------------------------------
-- 13. Rank Funds by Sharpe Ratio
--------------------------------------------------------

SELECT scheme_name,
       sharpe_ratio,
       RANK() OVER (
           ORDER BY sharpe_ratio DESC
       ) AS fund_rank
FROM scheme_performance;

--------------------------------------------------------
-- 14. Top 5 Funds in Each Risk Grade
--------------------------------------------------------

SELECT *
FROM
(
    SELECT
        scheme_name,
        risk_grade,
        five_year_return,
        ROW_NUMBER() OVER (
            PARTITION BY risk_grade
            ORDER BY five_year_return DESC
        ) AS rn
    FROM scheme_performance
) ranked_funds
WHERE rn <= 5;

--------------------------------------------------------
-- 15. Top Holdings by Sector
--------------------------------------------------------

SELECT sector,
       ROUND(SUM(weight_pct),2) AS total_weight
FROM portfolio_holdings
GROUP BY sector
ORDER BY total_weight DESC;

--------------------------------------------------------
-- 16. Benchmark Performance
--------------------------------------------------------

SELECT index_name,
       MAX(closing_value) AS highest_value
FROM benchmark_indices
GROUP BY index_name
ORDER BY highest_value DESC;

--------------------------------------------------------
-- 17. Fund Performance Analysis Using INNER JOIN
--------------------------------------------------------

SELECT
    fm.scheme_name,
    fm.category,
    sp.five_year_return,
    sp.sharpe_ratio
FROM fund_master fm
INNER JOIN scheme_performance sp
ON fm.amfi_code = sp.amfi_code
ORDER BY sp.five_year_return DESC;