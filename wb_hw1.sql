/*ДЗ по SQL: Sorting and grouping*/
/*Часть 1*/
/* №1 */
select city, age, count(id) as cnt from users
group by city, age
order by city, cnt DESC

/* №2 */
select category, round(AVG(price)::numeric,2) as avg_price from products
where LOWER(name) like '%hair%' or LOWER(name) like '%home%'
group by category



/*Часть 1*/
/* №1 */
select seller_id, count(category) as total_categ, round(avg(rating)::numeric, 1) as avg_rating, 
				  sum(revenue) as total_revenue, case 
				  								 when sum(revenue) > 50000 then 'rich'
												 else 'poor'
												 end seller_type  from sellers										 
where category != 'Bedding'
group by seller_id
having count(distinct category) > 1


/* №2 */
with t as(
select seller_id, MIN(date_reg) as date_reg, MIN(delivery_days) as min_delivery_days, MAX(delivery_days) as max_delivery_days, 
count(category) as total_categ, round(avg(rating)::numeric, 1) as avg_rating, 
				  sum(revenue) as total_revenue, case 
				  								 when sum(revenue) > 50000 then 'rich'
												 else 'poor'
												 end seller_type  from sellers										 
where category != 'Bedding'
group by seller_id
having count(distinct category) > 1 
),
poor_sellers as(
select * from t
where seller_type = 'poor'
)

select seller_id, (NOW()::date - date_reg) / 30  as month_from_registration, 
(SELECT max(max_delivery_days) from poor_sellers) -  (SELECT min(min_delivery_days) from poor_sellers) as max_delivery_difference	 
from poor_sellers
order by seller_id


/* №3 */
with t as(
select seller_id, MIN(date_reg) as date_reg, count(distinct category) as count_categoy, 
											sum(revenue) as total_revenue from sellers
where extract(year from date_reg) = 2022
group by seller_id
having count(distinct category) = 2 and sum(revenue) > 75000 
)

select seller_id, STRING_AGG(category, '-') from sellers
where seller_id in (SELECT seller_id from t)
group by seller_id
order by seller_id









