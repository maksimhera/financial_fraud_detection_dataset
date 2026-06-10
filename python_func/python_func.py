import numpy as np
import pandas as pd
import matplotlib.pyplot as plt 
import seaborn as sns
from scipy import stats


df = pd.read_csv('financial_fraud_detection_dataset.csv')


df['timestamp'] = pd.to_datetime(df['timestamp'], format='ISO8601')
df['year']        = df['timestamp'].dt.year
df['month']       = df['timestamp'].dt.month
df['hour']        = df['timestamp'].dt.hour
df['day_of_week'] = df['timestamp'].dt.dayofweek  


df['is_fraud_int'] = df['is_fraud'].astype(int)


df['z_score'] = np.abs(stats.zscore(df['amount']))
df['is_anomaly_zscore'] = df['z_score'] > 3
print(f"Z-score anomaly sum: {df['is_anomaly_zscore'].sum()}")

Q1 = df['amount'].quantile(0.25)
Q3 = df['amount'].quantile(0.75)
IQR = Q3 - Q1
df['is_outlier_iqr'] = ((df['amount'] < (Q1 - 1.5 * IQR)) | (df['amount'] > (Q3 + 1.5 * IQR))).astype(int)
print(f"IQR anomaly sum: {df['is_outlier_iqr'].sum()}")


df_sample = df.sample(n=50000, random_state=42)


fraud_rates = df_sample.groupby('location')['is_fraud'].mean().sort_values(ascending=False)
plt.figure(figsize=(12, 6))
plt.bar(fraud_rates.index, fraud_rates.values)
plt.title('Fraud Rates by Location')
plt.xlabel('Location')
plt.ylabel('Fraud Rate')
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()


avg_amount_for_category = df_sample.groupby('merchant_category')['amount'].mean().sort_values(ascending=False)
plt.figure(figsize=(12, 6))
plt.bar(avg_amount_for_category.index, avg_amount_for_category.values)
plt.title('Average Transaction Amount by Merchant')
plt.xlabel('Merchant Category')
plt.ylabel('Average Amount')
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()


df_sample = df_sample.copy()
df_sample['z_score'] = df['z_score'].loc[df_sample.index]
plt.figure(figsize=(12, 6))
sns.scatterplot(x='amount', y='z_score', hue='is_fraud', data=df_sample)
plt.title('Amount vs Z-score Colored by Fraud')
plt.xlabel('Amount')
plt.ylabel('Z-score')
plt.legend(title='Is Fraud')
plt.tight_layout()
plt.show()


plt.figure(figsize=(12, 6))
sns.histplot(data=df_sample, x='amount', hue='is_fraud', bins=50, kde=True)
plt.title('Amount Distribution for Fraud and Non-Fraud Transactions')
plt.xlabel('Amount')
plt.ylabel('Count')
plt.tight_layout()
plt.show()


amount_statistics = df_sample.groupby('month')['amount'].agg(['count', 'mean'])
plt.figure(figsize=(12, 6))
plt.plot(amount_statistics.index, amount_statistics['mean'], marker='o')
plt.title('Average Transaction Amount by Month')
plt.xlabel('Month')
plt.ylabel('Average Amount')
plt.xticks(amount_statistics.index)
plt.grid()
plt.tight_layout()
plt.show()