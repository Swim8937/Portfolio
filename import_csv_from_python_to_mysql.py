import pandas as pd
import mysql.connector
import sqlalchemy
from sqlalchemy import create_engine


# 讀取 CSV 檔案至 DataFrame
df = pd.read_csv('CovidDeaths.csv')

# 建立 MySQL 連接
# 根據 MySQL 資料庫設定進行替換
db_user = 'root'
db_password = 'Aa9955007744!'
db_host = 'localhost'
db_port = '3306'
db_name = 'Portfolio_Project'

db_uri = f"mysql+mysqlconnector://{'root'}:{'Aa9955007744!'}@{'localhost'}:{'3306'}/{'Portfolio_Project'}"

engine = create_engine(db_uri)

# 將 DataFrame 匯入 MySQL 資料庫
table_name = 'coviddeaths'  # 替換為目標資料表名稱
df.to_sql(table_name, con=engine, if_exists='replace', index=False)
