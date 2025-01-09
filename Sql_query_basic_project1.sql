-- SQL Retail Sales Data Analysis-- Project_1
CREATE DATABASE sql_project1;

-- Which database to use
USE sql_project1;

-- Creating the table
CREATE TABLE retail_sales (
transactions_id	INT,
sale_date	DATE,
sale_time	TIME,
customer_id	INT,
gender	VARCHAR(15),
age	INT,
category VARCHAR(15),	
quantiy	INT,
price_per_unit	FLOAT,
cogs	FLOAT,
total_sale Float
);
-- Querying the table
select * from retail_sales;

-- Imported the data from Excel file

-- Checking if the imported data as per excel records
select count(*) from retail_sales; 

-- Total entries 1987 which do not match so correct the data and import properly
Truncate table retail_sales;


-- Data Cleaning
-- Checking the data if we have any null in the transaction_id
select * from retail_sales 
where 
transactions_id is null
or sale_date is null 
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

-- delete the rows with null values
delete from retail_sales 
where 
transactions_id is null
or sale_date is null 
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

-- Data Exploration
-- How many sales we have?
select count(*) as total_sales from retail_sales ;
-- How many customers we have?
select count(distinct(customer_id)) as total_customers from retail_sales;
-- How many categories we have?
select count(distinct(category)) as total_category from retail_sales;


-- Data Analysis & Business key Problems & Answers

-- My Analysis and findings

-- 1) Write a SQL query to retrive all the columns for the sale made on '2022-12-18'.
select * from retail_sales where sale_date='2022-12-18';
-- 2) Write a SQL Query to retrive all the transactions where category is "Clothing" and 
-- the quanity sold is more than 4 in the month of "nov-2022"
select * from retail_sales where category='Clothing' and (sale_date>='2022-11-01' and sale_date<'2022-12-01') and quantiy>=4;

-- 3) Write a sql query to calculate the total sales (total_sales) for each category
select category,sum(total_sale) as total_sales from retail_sales group by category;

-- 4) Write a query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as average_age from retail_sales where category='Beauty';

-- 5) Write a sql query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale>1000;

-- 6) Write a sql query to find out the total number of transactions(transaction_id) made by each gender in each category.
select category,gender,count(transactions_id) as total_transactions from retail_sales group by category,gender order by category;

-- 7) Write a query to calculate the average sale for each month. Find out the best selling month in the year.
select years,months,avg_sale from (select year(sale_date) as years,month(sale_date) as months,
round(avg(total_sale),2) as avg_sale,
rank() over (partition by year(sale_date) order by avg(total_sale) desc) as rank1 from retail_sales group by 1,2) as t1 where rank1=1;

-- 8) Write a Sql query to find the top 5 customers based on the highest total sales
select customer_id,sum(total_sale) as totalsale from retail_sales group by 1 order by 2 desc limit 5; 

-- 9) Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct(customer_id)) as customers from retail_sales group by category ;

-- 10) Write a SQL qeury to create each shift and number of orders (Example Morning <12,afternoon between 12 & 17, Evening >17)
with hourly_sale 
as
(select *,
case
	when hour(sale_time)<12 then "Morning"
    when hour(sale_time) between 12 and 17 then "Afternoon"
    else "Evening"
    end as shift
from retail_sales) 
select shift,Count(*) as totalorders from hourly_sale group by shift;

-- End of the project
