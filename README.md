# ☕ Coffee Shop Sales Analysis  

## 📌 Overview  
This project analyzes **raw transactional data** from a coffee shop system using **SQL**. The dataset is messy, requiring significant data cleaning before meaningful insights can be extracted. Using SQL queries, we explore trends in sales, order volume, and customer behavior to provide **actionable business insights**.  

## 🔍 Key Challenges in Raw Data  
- **Unstructured Data** – Transaction dates and times are not properly formatted.  
- **Messy Column Names** – Some column names contain encoding issues and need renaming.  
- **Lack of Readability** – No predefined structure to analyze performance trends easily.

## 🛠 SQL Techniques Used  
- **Data Cleaning**: `STR_TO_DATE`, `ALTER TABLE`, `CHANGE COLUMN`  
- **Sales Analysis**: `SUM`, `COUNT`, `AVG`, `GROUP BY`, `ORDER BY`  
- **Performance Trends**: `LAG()`, `CASE`, `WINDOW FUNCTIONS`, `CTE`  

## 📊 Business Insights Extracted  
📌 **Which months generate the highest revenue?** 📈  
📌 **Are sales increasing or decreasing over time?**  
📌 **Which store locations perform best?** 🏪  
📌 **What are the top 10 best-selling products?** ☕  
📌 **Do weekends bring more sales than weekdays?**  
📌 **Which hours of the day see peak sales?** ⏰  

## 📈📉 Visualization 
- Connect MySQL with PowerBI through ODBC
- Create insightful charts based on key metrics above

## 📂 Check out the full SQL script in this repository! 🛠️  
