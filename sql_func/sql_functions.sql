
-- CREATE TABLE financial_transactions (
--     transaction_id VARCHAR(20),
--     timestamp TIMESTAMP,
--     sender_account VARCHAR(20),
--     receiver_account VARCHAR(20),
--     amount NUMERIC,
--     transaction_type VARCHAR(20),
--     merchant_category VARCHAR(20),
--     location VARCHAR(20),
--     device_used VARCHAR(10),
--     is_fraud BOOLEAN,
--     fraud_type VARCHAR(50),
--     time_since_last_transaction NUMERIC,
--     spending_deviation_score NUMERIC,
--     velocity_score INTEGER,
--     geo_anomaly_score NUMERIC,
--     payment_channel VARCHAR(20),
--     ip_address VARCHAR(20),
--     device_hash VARCHAR(20)
-- );

-- COPY financial_transactions
-- FROM 'C:/financial_fraud_detection_dataset.csv'
-- DELIMITER ','
-- CSV HEADER;



SELECT 
    COUNT(*) - COUNT(transaction_id) AS transaction_id_nulls,
    COUNT(*) - COUNT(timestamp) AS timestamp_nulls,
    COUNT(*) - COUNT(sender_account) AS sender_account_nulls,
    COUNT(*) - COUNT(receiver_account) AS receiver_account_nulls,
    COUNT(*) - COUNT(amount) AS amount_nulls,
    COUNT(*) - COUNT(transaction_type) AS transaction_type_nulls,
    COUNT(*) - COUNT(merchant_category) AS merchant_category_nulls,
    COUNT(*) - COUNT(location) AS location_nulls,
    COUNT(*) - COUNT(device_used) AS device_used_nulls,
    COUNT(*) - COUNT(is_fraud) AS is_fraud_nulls,
    COUNT(*) - COUNT(fraud_type) AS fraud_type_nulls,
    COUNT(*) - COUNT(time_since_last_transaction) AS time_since_last_nulls,
    COUNT(*) - COUNT(spending_deviation_score) AS spending_deviation_nulls,
    COUNT(*) - COUNT(velocity_score) AS velocity_score_nulls,
    COUNT(*) - COUNT(geo_anomaly_score) AS geo_anomaly_nulls,
    COUNT(*) - COUNT(payment_channel) AS payment_channel_nulls,
    COUNT(*) - COUNT(ip_address) AS ip_address_nulls,
    COUNT(*) - COUNT(device_hash) AS device_hash_nulls
FROM financial_transactions;                 



SELECT transaction_id, timestamp, sender_account, receiver_account, amount, transaction_type,
		merchant_category, location, device_used, is_fraud, fraud_type, time_since_last_transaction, 
		spending_deviation_score, velocity_score, geo_anomaly_score, payment_channel, ip_address, device_hash,
		COUNT (*) AS dublicate_count
FROM financial_transactions
GROUP BY transaction_id, timestamp, sender_account, receiver_account, amount, transaction_type,
		merchant_category, location, device_used, is_fraud, fraud_type, time_since_last_transaction, 
		spending_deviation_score, velocity_score, geo_anomaly_score, payment_channel, ip_address, device_hash
HAVING COUNT (*) > 1
ORDER BY dublicate_count DESC; 




SELECT 
    ROUND(SUM(amount)) AS sum_amount,
    transaction_type
FROM financial_transactions
GROUP BY transaction_type
ORDER BY sum_amount DESC;




SELECT 
    ROUND(AVG(amount)) AS avg_amount,
    merchant_category
FROM financial_transactions
GROUP BY merchant_category
ORDER BY avg_amount DESC;





SELECT
    location,
    COUNT(fraud_type) AS cnt_fraud,
    COUNT(*) AS total_transactions,
    ROUND(
        COUNT(fraud_type) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate
FROM financial_transactions
GROUP BY location
ORDER BY fraud_rate DESC;






SELECT
    device_used,
	COUNT(fraud_type) AS cnt_fraud,
	COUNT(*) AS total_transactions,
	ROUND(
        COUNT(fraud_type) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate
FROM financial_transactions
GROUP BY device_used
ORDER BY fraud_rate DESC;


SELECT 
    SUM(amount) AS sum_amount,
    sender_account,
	transaction_type
FROM financial_transactions
GROUP BY sender_account, transaction_type
ORDER BY sum_amount DESC
LIMIT 10;



SELECT 
    amount,
	sender_account,
	is_fraud
FROM financial_transactions
WHERE amount > (
	SELECT 
		ROUND(AVG(amount))
	FROM financial_transactions 
)
	AND  is_fraud IS True
GROUP BY is_fraud, sender_account, amount
ORDER BY amount DESC;




SELECT
    location,
    DATE_TRUNC('month', timestamp) AS month,
    SUM(amount) AS monthly_amount,
    SUM(SUM(amount)) OVER (
        PARTITION BY location
        ORDER BY DATE_TRUNC('month', timestamp)
    ) AS running_total
FROM financial_transactions
GROUP BY location, DATE_TRUNC('month', timestamp)
ORDER BY location, month;



SELECT                                        // ??????
    merchant_category,
    COUNT(fraud_type) AS cnt_fraud,
    COUNT(*) AS total_transactions,
    ROUND(
        COUNT(fraud_type) * 100.0 / COUNT(*),
        2
    ) AS fraud_rate
FROM financial_transactions
GROUP BY merchant_category
ORDER BY fraud_rate DESC;



SELECT 
    amount,
	merchant_category,
	transaction_id,
	sender_account
FROM financial_transactions
WHERE amount > (
	SELECT 
		ROUND(AVG(amount))
	FROM financial_transactions 
)
GROUP BY merchant_category, amount, transaction_id, sender_account
ORDER BY amount DESC;
-- LIMIT 200;




SELECT
    DATE_TRUNC('month', timestamp) AS month,
    SUM(amount) AS monthly_amount,
    SUM(SUM(amount)) OVER (
        ORDER BY DATE_TRUNC('month', timestamp)
    ) AS running_total,
	COUNT(amount) AS count_of_transactions
FROM financial_transactions
GROUP BY DATE_TRUNC('month', timestamp)
ORDER BY month ASC;





SELECT * 
FROM financial_transactions
LIMIT 20




