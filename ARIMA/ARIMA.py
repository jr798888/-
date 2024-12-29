import requests
import json
import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.tsa.arima.model import ARIMA

url = 'https://oss.open-digger.cn/github/microsoft/vscode/openrank.json'
response = requests.get(url)
data = response.json()

time_series_data = {}
for key, value in data.items():
    if '-' in key and key.endswith(('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')):
        date = pd.to_datetime(key, format='%Y-%m')
        time_series_data[date] = value

df = pd.DataFrame.from_dict(time_series_data, orient='index', columns=['count'])
df.index.name = 'date'
df.sort_index(inplace=True) 


df['count'] = pd.to_numeric(df['count'], errors='coerce')


if df.empty:
    print("DataFrame is empty, cannot fit ARIMA model or create forecast index.")
    exit()

model = ARIMA(df['count'], order=(12, 1, 12))
model_fit = model.fit()

print(model_fit.summary())

forecast_steps = 12

if not df.empty:
    forecast_index = pd.date_range(start=df.index[-1], periods=forecast_steps + 1, inclusive='right')[:-1]
    forecast = model_fit.forecast(steps=forecast_steps)
    forecast_series = pd.Series(forecast, index=forecast_index, name='Forecast')

if not df.empty:
    plt.figure(figsize=(14, 7))
    plt.plot(df, label='Observed')
    plt.plot(forecast_series, label='Forecast', color='red')
    plt.xlabel('Year')
    plt.ylabel('Metric Value')
    plt.title('ARIMA Model Forecast')
    plt.legend()
    plt.show()

