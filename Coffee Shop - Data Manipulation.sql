DESCRIBE coffee_shop

#Turn off safe update mode
SET SQL_SAFE_UPDATES = 0

#Format properly column transaction_date 
UPDATE coffee_shop
SET transaction_date = STR_TO_DATE(transaction_date,'%m/%d/%Y')

ALTER TABLE coffee_shop
MODIFY COLUMN transaction_date DATE

#Format properly column transaction_time 
UPDATE coffee_shop
SET transaction_time = STR_TO_DATE(transaction_time,'%H:%i:%s')

ALTER TABLE coffee_shop
MODIFY COLUMN transaction_time TIME

#Change the name of column transaction_id using backtick ``
ALTER TABLE coffee_shop
CHANGE COLUMN `ï»¿transaction_id` transaction_id INT

#Total sales for each respective month 
SELECT MONTH(transaction_date) as month , round(SUM(transaction_qty * unit_price),2) as total_sales
FROM coffee_shop
GROUP BY MONTH(transaction_date)

#Month-on-month sales difference
SELECT MONTH(transaction_date) as month, round(SUM(transaction_qty * unit_price),2) as total_sales, 
(SUM(transaction_qty * unit_price) - LAG(SUM(transaction_qty * unit_price),1) OVER (ORDER BY MONTH(transaction_date)))/LAG(SUM(transaction_qty * unit_price),1) OVER (ORDER BY MONTH(transaction_date))*100 as mom_pct
FROM coffee_shop
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date)

#Total number of orders for each respective month 
SELECT MONTH(transaction_date), COUNT(transaction_id)
FROM coffee_shop
GROUP BY MONTH(transaction_date)

#Month-on-month number of orders difference
SELECT MONTH(transaction_date), COUNT(transaction_id), 
(COUNT(transaction_id) - LAG(COUNT(transaction_id),1) OVER (ORDER BY MONTH(transaction_date)))/LAG(COUNT(transaction_id),1) OVER (ORDER BY MONTH(transaction_date))*100 AS mom_ord_pct
FROM coffee_shop
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date)

#Total quantity sold 
SELECT MONTH(transaction_date), SUM(transaction_qty) as total_qty
FROM coffee_shop
GROUP BY MONTH(transaction_date)

#Month-on-month quantity sold difference
SELECT MONTH(transaction_date), SUM(transaction_qty) as total_qty, 
(SUM(transaction_qty) - LAG(SUM(transaction_qty),1) OVER (ORDER BY MONTH(transaction_date)))/LAG(SUM(transaction_qty),1) OVER (ORDER BY MONTH(transaction_date))*100 AS mom_qty_pct
FROM coffee_shop
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date)

#Performance KPI
SELECT 
    CONCAT(ROUND(SUM(unit_price * transaction_qty) / 1000, 1),'K') AS total_sales,
    CONCAT(ROUND(COUNT(transaction_id) / 1000, 1),'K') AS total_orders,
    CONCAT(ROUND(SUM(transaction_qty) / 1000, 1),'K') AS total_quantity_sold
FROM coffee_shop

#Daily sales trend over a period 
WITH cte_trend as 
(SELECT DAY(transaction_date), SUM(unit_price * transaction_qty) AS total_sales
FROM coffee_shop
WHERE MONTH(transaction_date) = 5  -- Filter for a period 
GROUP BY DAY(transaction_date))

SELECT AVG(total_sales)
FROM cte_trend 

#Compare daily sales with avg of the month 
SELECT day_of_month, total_sales, 
    CASE WHEN total_sales > avg_sales THEN 'Above Average'
        WHEN total_sales < avg_sales THEN 'Below Average'
        ELSE 'Average' END AS sales_status
FROM (
    SELECT 
        DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
    FROM coffee_shop
    WHERE MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY DAY(transaction_date)
) AS sales_data
ORDER BY day_of_month

#Compare Sales by weekday vs weekend
SELECT 
    CASE WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays' END AS day_type,
    ROUND(SUM(unit_price * transaction_qty),2) AS total_sales
FROM coffee_shop
GROUP BY 
    CASE WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays' END;

#Sales by store location 
SELECT store_id, store_location, ROUND(SUM(unit_price * transaction_qty),2) AS total_sales
FROM coffee_shop
GROUP BY store_id, store_location
ORDER BY total_sales ASC

#Sales by product category 
SELECT product_category, ROUND(SUM(unit_price * transaction_qty),2) AS total_sales
FROM coffee_shop
GROUP BY product_category
ORDER BY total_sales ASC

#Sales by product (Top 10)
SELECT product_type, ROUND(SUM(unit_price * transaction_qty),2) AS total_sales
FROM coffee_shop
GROUP BY product_type
ORDER BY total_sales DESC
LIMIT 10 

#Sales by Day 
SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday' END AS Day_of_Week,
	ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM coffee_shop
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday' END;

#Sales by Hour 
SELECT 
    HOUR(transaction_time) AS Hour_of_Day,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM coffee_shop
GROUP BY HOUR(transaction_time)
ORDER BY HOUR(transaction_time)


SELECT *
FROM coffee_shop