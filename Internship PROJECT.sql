CREATE TABLE fraud_data (
    transaction_id TEXT,
    customer_id TEXT,
    merchant_name TEXT,
    transaction_date TIMESTAMP,
    transaction_amount_inr NUMERIC,
    fraud_risk TEXT,
    fraud_type TEXT,
    state TEXT,
    card_type TEXT,
    bank TEXT,
    isfraud INT,
    fraud_score NUMERIC,
    transaction_category TEXT,
    merchant_location TEXT
);

SELECT * FROM fraud_data LIMIT 10;

SELECT COUNT(*) FROM fraud_data;

SELECT DISTINCT state FROM fraud_data;

SELECT DISTINCT bank FROM fraud_data;

--Data Analysis--
--1. Total Transactions + Fraud--
SELECT 
    COUNT(*) AS total_transactions,
    SUM(isfraud) AS total_frauds
FROM fraud_data;

--2. Fraud Percentage--
SELECT 
    ROUND(SUM(isfraud)*100.0 / COUNT(*), 2) AS fraud_percentage
FROM fraud_data;

--3. State-wise Fraud--
SELECT 
    state,
    COUNT(*) AS total_transactions,
    SUM(isfraud) AS fraud_cases
FROM fraud_data
GROUP BY state
ORDER BY fraud_cases DESC;

--1. Bank-wise Fraud Rate--
SELECT 
    bank,
    COUNT(*) AS total_txn,
    SUM(isfraud) AS frauds,
    ROUND(SUM(isfraud)*100.0/COUNT(*),2) AS fraud_rate
FROM fraud_data
GROUP BY bank
ORDER BY fraud_rate DESC;

--2. Card Type Analysis--
SELECT 
    card_type,
    COUNT(*) total_txn,
    SUM(isfraud) frauds,
    ROUND(SUM(isfraud)*100.0/COUNT(*),2) fraud_rate
FROM fraud_data
GROUP BY card_type;

--3. Fraud Risk vs Actual Fraud--
SELECT 
    fraud_risk,
    COUNT(*) total,
    SUM(isfraud) frauds
FROM fraud_data
GROUP BY fraud_risk;

--4. Top Fraud States--
SELECT 
    state,
    SUM(isfraud) fraud_cases
FROM fraud_data
GROUP BY state
ORDER BY fraud_cases DESC
LIMIT 5;

--5. Fraud by Transaction Category--
SELECT 
    transaction_category,
    COUNT(*) total,
    SUM(isfraud) frauds
FROM fraud_data
GROUP BY transaction_category
ORDER BY frauds DESC;

--6. Monthly Fraud Trend--
SELECT 
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) total_txn,
    SUM(isfraud) frauds
FROM fraud_data
GROUP BY month
ORDER BY month;

--7. High Risk Transactions--
SELECT *
FROM fraud_data
WHERE fraud_score > 80
ORDER BY fraud_score DESC;

--View 1: Bank Fraud--
CREATE VIEW bank_fraud_analysis AS
SELECT 
    bank,
    COUNT(*) total_txn,
    SUM(isfraud) frauds,
    ROUND(SUM(isfraud)*100.0/COUNT(*),2) fraud_rate
FROM fraud_data
GROUP BY bank;

--View 2: State Fraud--
CREATE VIEW state_fraud_analysis AS
SELECT 
    state,
    COUNT(*) total_txn,
    SUM(isfraud) frauds
FROM fraud_data
GROUP BY state;

--View 3: Monthly Trend--
CREATE VIEW monthly_fraud_trend AS
SELECT 
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) total_txn,
    SUM(isfraud) frauds
FROM fraud_data
GROUP BY month;


