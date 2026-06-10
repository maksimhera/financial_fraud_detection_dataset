# financial_fraud_detection_dataset
Full-stack data analysis project: SQL → Python → Power BI → Excel Dataset: 5,000,000 financial transactions with fraud labels
🛠 Tools & Stack

ToolVersionPurposePostgreSQL18Data cleaning + analytical queriesPython3.xEDA, anomaly detection, visualizationPower BILatestInteractive executive dashboardExcelMicrosoft 365What-If financial modeling

!! DATA !!

https://www.kaggle.com/datasets/aryan208/financial-transactions-dataset-for-fraud-detection


Step 1 — SQL

Goal: data cleaning + 10 analytical queries

Data Cleaning


Check NULL values in: transaction_id, amount, is_fraud, fraud_type
Check duplicates by transaction_id
Validate data types: timestamp → TIMESTAMP, amount → NUMERIC, is_fraud → BOOLEAN


Analytical Queries


Total transaction volume by transaction_type
Average transaction amount by merchant_category
Fraud rate by city (location)
Fraud rate by device (device_used)
Top-10 accounts by transaction volume (sender_account)
CTE — high-risk accounts: SUM(amount) above average AND is_fraud = TRUE
Window function — running total by location by month
Window function — % fraudulent transactions within each merchant_category
Subquery — transactions above average within their merchant_category
Monthly dynamics — COUNT and SUM by month (2023–2024)



Step 2 — Python

Goal: time series analysis + anomaly detection

Libraries

pythonpandas, numpy, matplotlib, seaborn, scipy

Data Cleaning

pythondf['timestamp'] = pd.to_datetime(df['timestamp'], format='ISO8601')
df['year']        = df['timestamp'].dt.year
df['month']       = df['timestamp'].dt.month
df['hour']        = df['timestamp'].dt.hour
df['day_of_week'] = df['timestamp'].dt.dayofweek

Analysis


Time series — monthly COUNT and SUM(amount) dynamics
Anomaly detection Z-score — threshold > 3
Anomaly detection IQR — compare results with Z-score
Correlation — spending_deviation_score, velocity_score, geo_anomaly_score vs is_fraud


Charts (5 unique visualizations)

#TypeX axisY axis1Line chartyear_monthtotal_amount2Histogram / KDEamountcount (hue: is_fraud)3Scatter plotamountz_score (hue: is_anomaly)4Bar chartmerchant_categoryavg amount5Bar chartlocationfraud rate %


Step 3 — Power BI

Goal: interactive executive dashboard (3 pages)

DAX Measures

daxTotal Transactions = COUNTROWS(financial_transactions)
Total Amount = SUM(financial_transactions[amount])
Fraud Count = CALCULATE(COUNTROWS(financial_transactions), financial_transactions[is_fraud] = TRUE())
Fraud Rate % = DIVIDE([Fraud Count], [Total Transactions]) * 100
Avg Transaction Amount = AVERAGE(financial_transactions[amount])

Page 1 — Overview


KPI cards: Total Transactions, Total Amount, Fraud Rate %, Avg Amount
Line chart: YearMonth → Total Transactions + Total Amount
Bar chart: transaction_type → Total Amount
Slicer: Year


Page 2 — Fraud Analysis


Map: location → Fraud Rate %
Bar chart: device_used → Fraud Rate %
Bar chart: merchant_category → Fraud Rate %
Bar chart: payment_channel → Fraud Count
KPI: top city by Fraud Rate %


Page 3 — Account Analysis


Bar chart: top-10 sender_account by Total Amount
Scatter plot: velocity_score vs amount (legend: is_fraud)
Scatter plot: geo_anomaly_score vs spending_deviation_score (legend: is_fraud)
Slicers: location, transaction_type, Year



Step 4 — Excel

Goal: what-if scenario modeling of bank losses

Sheet 1 — Raw Summary


Pivot Table: rows location, columns transaction_type, values SUM(amount)
Conditional formatting: color scale on amounts
Slicers: transaction_type, device_used, is_fraud


Sheet 2 — Fraud Impact Model

VariableFormulaFraud Rate %=COUNTIF(data!J:J,TRUE)/COUNTA(data!J2:J100001)Avg Fraud Amount=AVERAGEIF(data!J:J,TRUE,data!E:E)Total Transactions=COUNTA(data!A2:A100001)Losses=Total * FraudRate * AvgAmount

Scenarios (Data Table):

Fraud RateLosses0.10%auto0.50%auto1%auto2%auto5%auto

Sheet 3 — Executive Summary


KPI block: total volume, fraud rate, top city, top device
Bar chart: fraud rate by city
Pie chart: transaction distribution by type
Key findings for management (3–5 observations)


📈 Key Findings

Fraud rate in dataset: ~1.01%
Total fraudulent transactions: ~50,690 out of 5,000,000
Fraud is evenly distributed across all cities and devices (synthetic dataset)
spending_deviation_score, velocity_score, geo_anomaly_score show near-zero correlation with is_fraud (r ≈ 0.0002–0.0004)
Z-score anomalies (threshold > 3): 77,785 transactions
IQR anomalies: 412,449 transactions
