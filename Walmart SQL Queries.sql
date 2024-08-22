CREATE DATABASE IF NOT EXISTS walmartSales;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);


-- ---------------------------------Feature Engineering------------------------------------------

-- ----- Time_of Day---------

SELECT 
	time, 
	(CASE 
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
    ) AS time_of_date

FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR (20);

UPDATE sales
SET time_of_day = ( 
CASE 
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
END
);


-- ----- Day_Name -------

SELECT 
	date,
	DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR (10);

UPDATE sales 
SET day_name = DAYNAME(date);

-- ------Month_Name ----------

SELECT 
	date,
	MONTHNAME(date) AS month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR (10);

UPDATE sales 
SET month_name = MONTHNAME(date);

-- ------ Generic Question ------------

-- How many unique cities does the data have?

SELECT 
	DISTINCT city
FROM sales;

SELECT 
	DISTINCT branch
FROM sales;

-- In which city is each branch?
SELECT 
	DISTINCT city,
    branch
FROM sales;

-- ----------Product Questions----------------------------------------------------------------------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT 
	DISTINCT product_line
FROM sales;

-- What is the most common payment method?
SELECT 
	payment,
    COUNT(payment) AS count
FROM sales
GROUP BY payment
ORDER BY count DESC;

-- What is the most selling product line?
SELECT 
	product_line,
    COUNT(product_line) AS count
FROM sales
GROUP BY product_line
ORDER BY count DESC;

--  What is the total revenue by month?
SELECT 
	month_name,
    ROUND(SUM(total), 2) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest COGS?
SELECT 
	month_name AS month,
    ROUND(SUM(cogs), 2) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs DESC;

-- What product line had the largest revenue?
SELECT 
	product_line,
    ROUND(SUM(total), 2) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

--  What is the city with the largest revenue?
SELECT 
	city,
    branch,
    ROUND(SUM(total), 2) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT 
	product_line,
    ROUND(AVG(tax_pct), 2) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

--  Which branch sold more products than average product sold?
SELECT 
    branch,
    ROUND(SUM(quantity), 2) AS qtny
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG (quantity) FROM sales);

-- What is the most common product line by gender?
SELECT 
	gender,
	product_line,
    COUNT(gender) AS count
FROM sales
GROUP BY gender, product_line
ORDER BY count DESC;

-- What is the average rating of each product line?
SELECT 
	ROUND(AVG(rating), 2) AS avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


-- ----------Sales Questions-----------------------------------------------------------------------------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday
SELECT 
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day;

-- Which of the customer types brings the most revenue?
SELECT 
	customer_type,
    ROUND(SUM(total), 2) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Which city has the largest tax percent/ VAT (**Value Added Tax**)?
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- Which customer type pays the most in VAT?
SELECT 
	customer_type,
    ROUND(AVG(tax_pct), 2) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;


-- ----------Sales Questions-------------------------------------------------------------------------------------------------------------------------

-- How many unique customer types does the data have?
SELECT 
	DISTINCT customer_type,
    COUNT(*) AS total_customers
FROM sales
GROUP BY customer_type
ORDER BY total_customers DESC;

-- How many unique payment methods does the data have?
SELECT 
	DISTINCT payment,
    COUNT(*) AS payment_type
FROM sales
GROUP BY payment
ORDER BY payment_type DESC;

-- Which customer type buys the most?
SELECT 
	DISTINCT customer_type,
    COUNT(*) AS total_customers
FROM sales
GROUP BY customer_type
ORDER BY total_customers DESC;

-- What is the gender of most of the customers?
SELECT 
	gender,
    COUNT(*) AS gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC;

-- What is the gender distribution per branch?
SELECT 
	gender,
    COUNT(*) AS gender_count
FROM sales
WHERE branch = "A"
GROUP BY gender
ORDER BY gender_count DESC;

-- Which time of the day do customers give most ratings?
SELECT 
	time_of_day,
    ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT 
	time_of_day,
    ROUND(AVG(rating), 2) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which day fo the week has the best avg ratings?
SELECT 
	day_name,
    ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
    ROUND(AVG(rating), 2) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY day_name
ORDER BY avg_rating DESC;
