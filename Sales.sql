create table retail_sales 
			(
			transactions_id	int primary key,
			sale_date date,	
			sale_time	time,
			customer_id	int,
			gender	varchar(15),
			age	int,
			category	varchar(15),
			quantiy int,
			price_per_unit	float,
			cogs	float,
			total_sale float
			);
select * from retail_sales
limit 10;

--Data Cleaning

select * from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

delete from  retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

select count(*) from retail_sales

--Data Exploration

-- total sales

select count(*) as total_sales from retail_sales;

-- num of customers, catagory, quantity

select count(distinct customer_id) as customers  from retail_sales;
select distinct category  from retail_sales;
select distinct quantiy  from retail_sales;

--Data Analysis


--sales made on 2022-11-05

select * from retail_sales where sale_date = '2022-11-05';

--catogery clothing and quantity sold more than 10 in month nov-2022

select * from retail_sales
			where
			category ='Clothing'  and quantiy >= 3 and to_char(sale_date, 'YYYY-MM') = '2022-11';

-- calculate total sales for each category

select category,sum(total_sale) as total_sales from retail_sales group by 1;

-- avg age of cus who purchase from beauty

select round(avg(age),2) as AvgAge from retail_sales where category = 'Beauty';

-- show all transactions where total sales > 1000

select * from retail_sales where total_sale >= 1000;

-- total transaction made by each gender in each catagory

select count(*) as total_tr, gender,category from retail_sales group by gender, category order by 3;

-- avg sale of each month and best selling month in each year

select * from (
select extract(year from sale_date) as year, 
		extract(month from sale_date) as month,
		avg(total_sale)as avgsale,
		rank()over(partition by extract(year from sale_date) order by avg(total_sale))as rank
		from retail_sales
		group by 1,2) as t1
where rank =1

-- top 5 cus based on highest total sales

select customer_id, sum(total_sale) as total_s from retail_sales group by customer_id order by 2 desc limit 5;


-- unique cust who purchase items from each category

select count(distinct customer_id),category from retail_sales  group by 2;

-- to create each shift and num of columns

with hr_shift
as
(select *,
		case 
			when extract(hour from sale_time) <12 then 'Morning'
			when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
			else 'Evening'
		end as shifts
	from retail_sales)
select shifts, count(*) as total_orders from hr_shift group by shifts;
		
