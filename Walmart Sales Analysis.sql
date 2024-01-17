create database salesdata;

create table  Sales(
	invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    vat float(6,4) not null,
    total decimal(12,4) not null,
    date datetime not null,
    time time not null,
    payment_method varchar(10) not null,
    cogs decimal(10,2) not null,
    gross_margin_pct float(11,9) not null,
    gross_income decimal(12,4) not null,
    rating float(2,1) 
);



-- -------------------------------------- FEATURE ENGINERRING -----------------------------------------------

-- time of day

select 
	time,
	(case 
		when 'time' between "00:00:00" and "12:00:00" then "Morning"
		when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
		else "evening"
	end
    ) as time_of_date
from Sales;


ALTER TABLE Sales ADD COLUMN time_of_day varchar(20);

update sales
Set time_of_day = (
	case 
		when 'time' between "00:00:00" and "12:00:00" then "Morning"
		when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
		else "evening"
	end
);



-- day_name

select
	date,
    dayname(date)
from Sales;


Alter table Sales add column day_name varchar(10);

update Sales 
set day_name = DAYNAME(date);



-- month_name

select 
	date,
    monthname(date)
from Sales;

alter table Sales Add column month_name Varchar(10);

update Sales
set month_name = monthname(date);


-- ----------------------------------------------------------------------------------------------------------  


-- ---------------------------------- Generic ---------------------------------------------------------------

-- How many unique Cities does the data have 

select 
	distinct city 
from Sales;

--  How many unique branches does the data have

select 
	distinct branch
from Sales;


select 
	distinct city,branch 
from Sales;

-- ----------------------------------------------------------------------------------------------------
-- ------------------------------------- Product ------------------------------------------------------

-- How many unique product does the data have ?
select
	distinct product_line
from Sales;


-- What is the most common payment method?

select
	payment_method,
    count(payment_method) as cnt
from Sales
group by payment_method
order by cnt desc;


-- what is the  most selling product line?

select
	product_line,
    count(product_line) as cnt
from Sales
group by product_line
order by cnt desc;


-- what is the total revenue by month?

select 
	 month_name ,
     sum(total) as total_revenue
from Sales
group by month_name
order by total_revenue desc;


-- what month had the largest cogs ?

select
	month_name as month,
    sum(cogs) as cogs
from Sales
group by month_name
order by sum(cogs) desc
limit 1;
 

-- which product line had the largest revenue ?


select 
	product_line,
    sum(total) as total_revenue
from Sales
group by product_line
order by total_revenue desc
limit 1;

-- what is the city with the largest revenue ?

select 
	branch,
	city,
    sum(total) as total_revenue
from Sales
group by city,branch
order by total_revenue desc
limit 1;

-- what product line had the largest vat ?

select
	product_line,
    sum(vat) as total_vat
from Sales
group by product_line
order by total_vat desc
limit 1;


-- Which branch sold more products than average products sold?

select
	branch,
    sum(quantity) as qty
from Sales
group by branch
having qty > (select avg(quantity) from Sales);

-- what is the most common product line by gender?


select
	gender,
	product_line,
    count(gender) as total_cnt
from Sales
group by gender,product_line
order by count(gender) desc
limit 1;


-- what is the average rating of each product line?

select
	product_line,
    round(avg(rating),2) as average_rating 
from Sales
group by product_line
order by average_rating desc;

-- -------------------------------------------------------------------------------------------
-- ------------------------------ Sales ------------------------------------------------------


-- Number of sales made in each time of the day per weekend

select
	time_of_day,
    count(*) as total_sales
from Sales
where day_name ="Monday"
group by time_of_day
order by total_sales desc;


-- which of the customer types brings the most revenue?

select
	customer_type,
    sum(total) as total_revenue
from Sales
group by 1
order by total_revenue desc
limit 1;
    

-- which city has the largest tax percent / vat (value added tax)?

select
	city,
    sum(vat) as total_vat
from Sales
group by city
order by total_vat desc;


-- which customer type pays the most in vat?

select
	customer_type,
    sum(vat) as total_vat
from Sales
group by customer_type
order by total_vat desc;


-- ------------------------------------------------------------------------------------------
-- ---------------------------------- Customer -------------------------------------------------


-- how many unique customer types does the data have ?

select 
	distinct customer_type 
from Sales;

-- how many unique payment method does the data have?

select 
	distinct payment_method
from Sales;

-- what is the most common customer type ?

select
	customer_type,
    count(customer_type) as cust_count
from Sales
group by 1
order by cust_count desc
limit 1;

-- which  customer type buys the most ?

select
	customer_type,
    count(*) as cust_count
from Sales
group by 1;

  
-- which time of the week has the best avg ratings ?

select 
	day_name ,
    avg(rating)as average_ratings
from Sales
group by day_name
order by average_ratings desc;

 

