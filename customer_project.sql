create database customer;

use customer;

select * from customer;

#1
select gender, sum(purchase_amount) as revenue
from customer
group by gender;

#2 customer used a discount but still paid more than the avg amount
select customer_id,purchase_amount
from customer
where discount_applied = 'Yes' and purchase_amount > (select avg(purchase_amount) from customer);

#3 top 5 products with highest average review rating
select item_purchased,avg(review_rating) as 'ag' 
from customer 
group by item_purchased
order by avg(review_rating) desc
limit 5;

#4compare avg purchase amounts between standard and express shipping
select shipping_type, avg(purchase_amount) as 'avg'
from customer
where shipping_type in ('Express','Standard')
group by shipping_type;

#5 do subscribers spend more, compare avg spend and total_revenue between sub and no-sub
select subscription_status, count(customer_id) as 'count',avg(purchase_amount) as 'AVG',sum(purchase_amount) as 'total'
from customer
group by subscription_status;

#6which five products have the highest percentages of purchases with discounts applied
select item_purchased,
round(100 * sum(case when discount_applied = 'yes' then 1 else 0 end)/ count(*),2) as discount_percentage
from customer
group by item_purchased
order by discount_percentage desc
limit 5;

# 7 segment customers into New, returning, and loyal based on their total no ofprevious purchases
#show the count of each segment
with customer_type as (
select customer_id,previous_purchases,
case when previous_purchases = 1 then 'New'
	when previous_purchases <=10 then 'Returning'
    else 'Loyal'
    end as customer_segment
from customer
)
select customer_segment,count(*) as 'No of employees' from customer_type
group by customer_segment;

#8 what are the top 3 most purchased products within each category
select rnk,item_purchased,category,count
from (select item_purchased, category,count(customer_id) as 'count',
row_number() over(partition by category order by count(customer_id) desc) as rnk from customer
group by category,item_purchased)t
where rnk <=3;

#9 Are customers who are repeat buyers(more than 5 previous_purchases) are likely to subscribe
select subscription_status,count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status;

#10 what is the revenue contribution of each age group
select age_group,sum(purchase_amount) as 'Revenue'
from customer
group by age_group
order by revenue desc;