-- =============================================
-- CREDIT & FRAUD RISK ANALYTICS PROJECT
-- Name: Mohd Falak Khan
-- Date: June 2026
-- =============================================

USE credit_risk_db;

-- QUERY 1: Total Records Check
SELECT COUNT(*) AS total_records 
FROM transactions;
-- Result: 1000 records

-- QUERY 2: Fraud vs Normal Count
SELECT 
    Class,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY Class;
-- Result: 998 Normal | 2 Fraud

-- QUERY 3: Top 10 Highest Amount Transactions
-- (Fraud detection mein badi transactions suspicious hoti hain)
SELECT 
    Time,
    Amount,
    Class
FROM transactions
ORDER BY Amount DESC
LIMIT 10;
-- Result: Top amount 3828.04 | Sabhi Class 0 (Normal) hain
-- Highest transaction: Time 103, Amount 3828.04

-- QUERY 4: Fraud Transactions Detail
-- (Sirf Class 1 wali transactions dekho)
SELECT 
    Time,
    Amount,
    Class
FROM transactions
WHERE Class = 1
ORDER BY Amount DESC;
-- Result: 2 Fraud transactions found
-- Time 472: Amount 529 (Suspicious mid-range amount)
-- Time 406: Amount 0 (Test transaction - classic fraud pattern!)

-- QUERY 5: Average Transaction Amount - Normal vs Fraud
SELECT 
    Class,
    COUNT(*) AS total,
    AVG(Amount) AS avg_amount,
    MAX(Amount) AS max_amount,
    MIN(Amount) AS min_amount
FROM transactions
GROUP BY Class;
-- Result: Normal avg: 66.03 | Fraud avg: 264.5
-- Fraud amount 4x higher than normal!
-- Key Insight: Fraudsters target higher amounts

-- QUERY 6: Time Pattern Analysis
-- (Fraud kis time pe hua?)
SELECT 
    Class,
    MIN(Time) AS earliest_txn,
    MAX(Time) AS latest_txn,
    AVG(Time) AS avg_time
FROM transactions
GROUP BY Class;
-- Result: Normal: Time 0 to 755 (poore dataset mein)
-- Fraud: Time 406 to 472 (specific window!)
-- Key Insight: Fraud ek limited time window mein hua - suspicious pattern!

-- QUERY 7: Data Quality Check
-- (NULL values hain kya data mein?)
SELECT 
    COUNT(*) AS total_records,
    COUNT(Amount) AS amount_filled,
    COUNT(Time) AS time_filled,
    COUNT(Class) AS class_filled
FROM transactions;
-- Result: All 1000 records complete
-- No NULL values found in any column
-- Key Insight: Data quality is excellent - 100% complete!

-- QUERY 8: Anomaly Detection
-- (Normal range se bahar ki transactions)
SELECT 
    Time,
    Amount,
    Class,
    CASE 
        WHEN Amount > 500 THEN 'HIGH RISK'
        WHEN Amount > 200 THEN 'MEDIUM RISK'
        ELSE 'LOW RISK'
    END AS risk_level
FROM transactions
ORDER BY Amount DESC
LIMIT 20;
-- Result: Top 20 HIGH RISK transactions sab Class 0 (Normal) hain
-- Key Insight: High amount != Fraud
-- Real fraud (Class 1) Amount 529 tha - medium range mein!
-- Banks sirf amount se fraud detect nahi karte - multiple factors chahiye!

-- QUERY 9: Risk Level Summary
SELECT 
    CASE 
        WHEN Amount > 500 THEN 'HIGH RISK'
        WHEN Amount > 200 THEN 'MEDIUM RISK'
        ELSE 'LOW RISK'
    END AS risk_level,
    COUNT(*) AS total_transactions,
    AVG(Amount) AS avg_amount,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS fraud_count
FROM transactions
GROUP BY risk_level;
-- Result: LOW RISK=928(1 fraud), MEDIUM=45(0 fraud), HIGH=27(1 fraud)
-- Key Insight: Fraud amount se predict nahi hota!
-- LOW RISK mein bhi fraud mila - amount 0 tha (test transaction)
-- Multi-factor analysis zaroori hai!

-- QUERY 10: Final Risk Report Summary
SELECT 
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS total_fraud,
    SUM(CASE WHEN Class = 0 THEN 1 ELSE 0 END) AS total_normal,
    ROUND(AVG(Amount), 2) AS overall_avg_amount,
    ROUND(MAX(Amount), 2) AS highest_transaction,
    ROUND(MIN(Amount), 2) AS lowest_transaction
FROM transactions;
-- Result: Total=1000, Fraud=2, Normal=998
-- Avg Amount=66.43, Max=3828.04, Min=0
-- Key Insight: Fraud rate = 0.2% (2 out of 1000)
-- Dataset successfully analyzed!