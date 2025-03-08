


CREATE DATABASE IF NOT EXISTS WalMartSale;


-- Create database
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

Select*
from sales
WHERE product_line = 'food and beverages'
order by total asc;


CREATE TABLE sales_staging
LIKE sales
;

INSERT sales_staging
Select*
from sales;

Select*
from sales_staging;

ALTER TABLE sales_staging
ADD time_of_day VARCHAR(10) CHECK (time_of_day IN ('Morning', 'Afternoon', 'Evening'))
;

UPDATE sales_staging
SET time_of_day = CASE
    WHEN time < '12:00:00' THEN 'Morning'
    WHEN time >= '12:00:00' AND time < '18:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END;

ALTER TABLE sales_staging
ADD day_name VARCHAR(20) ;


UPDATE sales_staging
SET day_name = dayname(DATE);

ALTER TABLE sales_staging
ADD month_name VARCHAR(20) ;

UPDATE sales_staging
SET month_name = monthname(date);

----------------------------------------- How many unique cities does the data have? --------------------------------------------------------------------------------------------------

Select distinct city
from sales_staging
ORDER BY city;

----------------------------------------- In which city is each branch? --------------------------------------------------------------------------------------------------------------


Select distinct branch, city
from sales_staging
ORDER BY branch;

----------------------------------------- How many unique product lines does the data have? --------------------------------------------------------------------------------------------

Select distinct product_line
from sales_staging;



----------------------------------------- What is the most common payment method? ------------------------------------------------------------------------------------------------------

SELECT distinct payment, COUNT(*) AS occurrence_count
FROM sales_staging
GROUP BY payment
ORDER BY occurrence_count DESC;

Select*
from sales;

----------------------------------------- What is the most selling product line? -------------------------------------------------------------------------------------------------------

select distinct product_line, count(*) as Most_selling
from sales_staging
group by product_line
order by Most_selling desc;

----------------------------------------- What is the total revenue by month? ----------------------------------------------------------------------------------------------------------


select month_name as month,
SUM(total) as total_revenue
from sales_staging
group by month
order by total_revenue desc;

----------------------------------------- What month had the largest COGS?


select month_name as month,
SUM(cogs) as sum_cogs
from sales_staging
group by month 
order by sum_cogs desc ;

-------------------------------------- What product line had the largest revenue?

select product_line, sum(total) as revenue_total
from sales_staging
group by product_line
order by revenue_total desc;

-------------------------------------- What is the city with the largest revenue? 

select city, sum(total) as revenue_total
from sales_staging
group by city
order by revenue_total desc;

--------------------------------------  What product line had the largest VAT?

select product_line, avg(tax_pct) as tax_total
from sales_staging
group by product_line
order by tax_total desc;

----------------------------- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

select distinct product_line, sum(total)
from sales_staging
group by product_line
;



-------------------------------- Which branch sold more products than average product sold?

select branch, sum(quantity) as qty
from sales_staging
group by branch
having sum(quantity) > (select avg(quantity) from sales);


----------------------------------- What is the most common product line by gender?

select gender, product_line, count(gender) as TT_count
from sales_staging
group by gender, product_line
order by TT_count desc
;

 ----------------------------------- What is the average rating of each product line?

select product_line, round( avg(rating),2) as avg_rate
from sales_staging
group by product_line
order by avg_rate desc ;


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------- SALES -------------------------------------------------------------------------------------------------------------------------------

----------------------------------------- Number of sales made in each time of the day per weekday


SELECT time_of_day, count(*) as total_sales
from sales_staging
where day_name = 'monday'
group by time_of_day
order by total_sales desc ;

-------------------------------- Which of the customer types brings the most revenue?
select customer_type, sum(total) as sum_total
from sales_staging
group by customer_type
order by sum_total desc
 ;

-------------------------------- Which city has the largest tax percent/ VAT (Value Added Tax)?

select city, avg(tax_pct) as vat
from sales_staging
group by city
order by vat desc ;

-------------------------------- Which customer type pays the most in VAT?

select customer_type, avg(tax_pct) as vat
from sales_staging
group by customer_type
order by vat desc ;


-------------------------------- How many unique customer types does the data have?

select distinct customer_type
from sales_staging
;

-------------------------------- How many unique payment methods does the data have?
select distinct payment
from sales_staging
;

-------------------------------- What is the most common customer type?

select distinct customer_type, count(total) as c_tt
from sales_staging
group by customer_type
order by c_tt desc
;

-------------------------------- Which customer type buys the most?

select customer_type, sum(total) as total_sum
from sales_staging
group by customer_type
order by total_sum desc;

-------------------------------- What is the gender of most of the customers?
select gender, count(customer_type)
from sales_staging
group by gender;

-------------------------------- What is the gender distribution per branch?

select gender, count(customer_type)
from sales_staging
where branch =  'B'
group by gender;

-------------------------------- Which time of the day do customers give most ratings?

select avg(rating)
from sales_staging;

select time_of_day, AVG(rating) as avg_rate
from sales_staging
group by time_of_day
order by avg_rate desc
;

----------------------------- Which time of the day do customers give most ratings per branch?

select time_of_day, AVG(rating) as avg_rate
from sales_staging
where branch = 'A'
group by time_of_day
order by avg_rate desc
;

-------------------------------- Which day fo the week has the best avg ratings?


	select day_name, avg(rating) as avg_r
    from sales_staging
    group by day_name
    order by avg_r desc;


-------------------------------- Which day of the week has the best average ratings per branch?

select day_name, avg(rating) as avg_r
    from sales_staging
    where branch = 'C'
    group by day_name
    order by avg_r desc;


















