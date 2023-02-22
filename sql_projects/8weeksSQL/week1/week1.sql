# DANNY CASE 1 :
CREATE SCHEMA dannys_diner;
use dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id int
);

INSERT INTO sales
  (customer_id, order_date,product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');


CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');


CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

# What is the total amount each customer spent at the restaurant?
select s.customer_id, sum(price) as tot_spend
from sales s
join menu m2 on s.product_id = m2.product_id
group by s.customer_id;

# How many days has each customer visited the restaurant?
select customer_id, count(distinct order_date) as most_visit_date
from sales
group by customer_id;

# What was the first item from the menu purchased by each customer?
select distinct customer_id, order_date, product_name
from (select customer_id,order_date, product_name,
       rank() over (PARTITION BY customer_id ORDER BY order_date) as date_rank
from sales s
    join menu m on s.product_id = m.product_id)z
WHERE date_rank = 1;

# What is the most purchased item on the menu and how many times was
# it purchased by all customers?
select product_id, count(*) as '# of orders'
from sales
group by product_id
order by count(*) desc
limit 1;


# Which item was the most popular for each customer?
with cte as (
    select customer_id, product_id, count(*) c
    from sales
    group by customer_id, product_id
)

select customer_id, product_id
from (select customer_id, product_id, c,
       rank() over (partition by customer_id order by c desc) pop_rank
from cte)m
where pop_rank = 1;

# Which item was purchased first by the customer after they became a member?
select customer_id,join_date, order_date, product_name
from (select m.customer_id,join_date, order_date, product_name,
       rank() over (partition by m.customer_id order by order_date) as order_rank
from sales s
join members m
    on s.customer_id = m.customer_id
join menu m2
    on s.product_id = m2.product_id
where order_date>= join_date)m
where order_rank = 1;


# Which item was purchased just before the customer became a member?
select customer_id,join_date, order_date, product_name, ranking
from (select m.customer_id,join_date, order_date, product_name,
      rank() over (partition by m.customer_id order by order_date desc) as ranking
from sales s
join members m
    on s.customer_id = m.customer_id
join menu m2
    on s.product_id = m2.product_id
where order_date < join_date)m
where ranking = 1;

# What is the total items and amount spent for each member before
# they became a member?
select m.customer_id,count(*) as total_items, sum(price) as tot_spent
from sales s
join members m
    on s.customer_id = m.customer_id
join menu m2
    on s.product_id = m2.product_id
where order_date < join_date
group by m.customer_id;

# If each $1 spent equates to 10 points and sushi has a 2x points multiplier
#  how many points would each customer have?
with cte as
(select *,
    IF(product_name = 'Sushi', spent_on_product * 2 * 10,
       spent_on_product * 10) as points
from (select customer_id, product_name, sum(price) as spent_on_product
      from sales s
      join menu m2
         on s.product_id = m2.product_id
      group by customer_id, product_name)m)

select customer_id, sum(points) as total_points
from cte
group by customer_id;

# simpler method :
with cte as (select customer_id,
       IF(product_name = 'Sushi', price * 20, price * 10) as points
from sales s
join menu m on s.product_id = m.product_id)
select customer_id, sum(points)
from cte
group by customer_id;



select m.customer_id,
       join_date,
       order_date,
       DATE_ADD(join_date, interval 6 day) last_date,
       sum(case
           when order_date between join_date and  DATE_ADD(join_date, interval 6 day)
             then price * 2 * 10
           when product_name = 'Sushi' then price * 2 * 10
           else price * 10 end) as points
from sales s
join members m
    on s.customer_id = m.customer_id
join menu m2
    on s.product_id = m2.product_id
where order_date < '2021-01-31'
group by m.customer_id;


select *
from insights;

# create table to show some insights and create a new column that shows if a customer
# was a member while making an order.
drop table if exists insights;

create table insights as (
select s.customer_id,order_date, product_name, price,
       case
           when order_date < join_date then 'N'
           when order_date >= join_date then 'Y'
           else 'N' end as member
from sales s
left join menu m on s.product_id = m.product_id
left join members m2 on s.customer_id = m2.customer_id
order by customer_id,order_date
);

# add a ranking column to show the different dates a member has ordered.
drop table if exists ranking;
create table ranking as
    (select *,
       case when member = 'N' then null
            when member = 'Y' then
           rank() over
               (partition by customer_id,member order by order_date)
        end as ranking
    from insights);
select *
from ranking;