SELECT * FROM valentine.valentine_purchases;

-- Checking the total number of records
SELECT COUNT(*) AS total_records FROM valentine_purchases;

-- Checking for duplicate records
SELECT purchase_id, COUNT(*)
FROM valentine_purchases
GROUP BY purchase_id
HAVING COUNT(*) > 1;

-- Checking for missing values
SELECT
	COUNT(*) - COUNT(date) AS missing_dates,
    COUNT(*) - COUNT(item) AS missing_items,
	COUNT(*) - COUNT(price_usd) AS missing_prices,
	COUNT(*) - COUNT(gender) AS missing_genders,
    COUNT(*) - COUNT(age) AS missing_ages,
    COUNT(*) - COUNT(searchItems) AS missing_searchItems,
    COUNT(*) - COUNT(salesmade) AS missing_salesmade,
    COUNT(*) - COUNT(totalsales) AS missing_totalsales,
    COUNT(*) - COUNT(meetup_points) AS missing_meetup_points
FROM valentine_purchases;

-- Checking the date format
DESC valentine_purchases;

-- new date column
ALTER TABLE valentine_purchases
ADD COLUMN new_date DATE;

-- Coverting the date format
UPDATE valentine_purchases
SET new_date = STR_TO_DATE(date, '%m/%d/%Y')
WHERE date IS NOT NULL;

-- Dropping the old date column
ALTER TABLE valentine_purchases DROP COLUMN date;

-- Renaming the new_date column to date
ALTER TABLE valentine_purchases CHANGE new_date date DATE;

-- Reorder date column to the second place after purchase_id column
ALTER TABLE valentine_purchases
MODIFY COLUMN date DATE AFTER purchase_id;




-- Total revenue generated
SELECT SUM(totalsales) AS total_revenue_usd FROM valentine_purchases;

-- Most expensive and cheapest items
SELECT item, price_usd FROM valentine_purchases 
ORDER BY price_usd ASC LIMIT 1;

SELECT item, price_usd FROM valentine_purchases
ORDER BY price_usd DESC LIMIT 1;

-- Total items sold and average sales per item
SELECT 
	SUM(salesmade) AS total_items_sold, 
    ROUND(AVG(salesmade), 2) AS avg_sales_per_item
FROM valentine_purchases;


-- Purchases by gender
SELECT 
	gender, 
    COUNT(*) AS Total_purchases 
FROM valentine_purchases
GROUP BY gender;

-- Age-Based Purchasing Behavior
SELECT
	age,
    COUNT(*) AS purchases
FROM valentine_purchases
GROUP BY age 
ORDER BY age;

-- Customer segmentation by age group
SELECT
	CASE
		WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
	END AS age_group,
    COUNT(*) AS total_purchases
FROM valentine_purchases
GROUP BY age_group
ORDER BY age_group;


-- Most active shopping days
SELECT 
	DAYNAME(date) AS day_of_week, 
    COUNT(*) AS purchases 
FROM valentine_purchases 
GROUP BY  day_of_week 
ORDER BY purchases DESC;

-- Daily sales trends before valentine's day
SELECT date,
	DAYNAME(date) as day_of_week,
	SUM(totalsales) AS total_sales
FROM valentine_purchases
WHERE date BETWEEN '2025-02-01' AND '2025-02-14'
GROUP BY date ORDER BY date;



-- Best selling and least selling items
SELECT
	item,
    SUM(salesmade) AS total_sold
FROM valentine_purchases
GROUP BY item ORDER BY total_sold DESC;

-- Top earning items
SELECT 
	item, 
    SUM(totalsales) AS revenue 
FROM valentine_purchases 
GROUP BY item ORDER BY revenue DESC;



-- Most common search terms
SELECT 
	searchItems,
    COUNT(*) AS search_frequency
FROM valentine_purchases
GROUP BY searchItems
ORDER BY search_frequency DESC;

-- Search Term conversion rates
SELECT
	searchItems,
    SUM(salesmade) AS total_sold
FROM valentine_purchases
GROUP BY searchItems
ORDER BY total_sold DESC;



-- Most and least profitable meetup points
SELECT 
	meetup_points,
    FORMAT(SUM(totalsales), 2) AS revenue
FROM valentine_purchases
GROUP BY meetup_points
ORDER BY revenue DESC;



-- High-spending customers
SELECT
	age,
    gender,
    FORMAT(SUM(totalsales), 2) AS total_spent_usd
FROM valentine_purchases
GROUP BY age, gender
ORDER BY total_spent_usd DESC;

-- High-spending age group
SELECT
	CASE
		WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
	END AS age_group,
    FORMAT(SUM(totalsales), 2) AS total_spent_usd
FROM valentine_purchases
GROUP BY age_group
ORDER BY total_spent_usd;

-- Customer lifetime value estimation
SELECT
	age,
    gender,
    COUNT(*) AS purchases,
    ROUND(SUM(totalsales), 2) AS total_spent
FROM valentine_purchases
GROUP BY age, gender
ORDER BY total_spent DESC;


-- Final dataset
SELECT * FROM valentine_purchases;























