# 1. What is the total revenue for each category?
select oi.product_id,name,sum(quantity * oi.price)
from order_items oi
join products p on oi.product_id = p.product_id
group by product_id;

# 2. Which customer has the most orders?
select first_name,last_name, count(*) as total_orders
from orders o
join customers c on o.customer_id = c.customer_id
group by o.customer_id
order by total_orders desc
limit 1;

# 3. What is the total spent each customer?
select o.customer_id, first_name, last_name, sum(quantity * price) as avg_spent
from orders o
join customers c on o.customer_id = c.customer_id
join order_items oi on o.order_id = oi.order_id
group by customer_id;

# 4. What is the total revenue for each month ?
select month(order_date) as month,
       sum(quantity * price) as total_revenue
from order_items oi
join orders o on o.order_id = oi.order_id
group by  month
order by month;

# 5. Which products have been ordered the most and how many times?
select name, count(*) as times_ordered
from order_items oi
join products p on oi.product_id = p.product_id
group by oi.product_id;


# 6. Which customers have ordered a particular product and how many times?
select concat(first_name,' ',last_name) as customer,name,
       count(*) as count
from order_items oi
join orders o on o.order_id = oi.order_id
join products p on oi.product_id = p.product_id
join customers c on c.customer_id = o.customer_id
group by c.customer_id, oi.product_id;

# 7. What is the average order value for each month?

-- first we find the total amount per order
select order_id, sum(quantity * price) as total
from order_items
group by order_id;

-- now we need to join orders table to get the date
with tot_per_order as (
    select order_id, sum(quantity * price) as total
    from order_items
    group by order_id
)
select month(order_date) as month,
       avg(total) as avg_order_value
from orders o join
     tot_per_order
         on o.order_id = tot_per_order.order_id
group by month;

# 8. What is the average quantity ordered for each product?
select product_id, avg(quantity)
from order_items
group by product_id;

# 9. Which category has the highest revenue per customer on average?

with cte as
    (select category, o.order_id,customer_id, (quantity * p.price) as total
    from products p
    join order_items oi on p.product_id = oi.product_id
    join orders o on o.order_id = oi.order_id
    WHERE o.status = 'Delivered')

select category, sum(total) / count(distinct customer_id)
from cte
group by category;

# 10. What is the total revenue for each status and month combination?
with  cte as
    (select month(order_date) as month, status, (quantity * price) as tot
    from orders o
    join order_items oi on o.order_id = oi.order_id)
select month, status, sum(tot)
from cte
group by month,status;





