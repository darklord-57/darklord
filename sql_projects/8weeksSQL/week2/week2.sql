#
# CREATE SCHEMA pizza_runner;
# use pizza_runner;
# DROP TABLE IF EXISTS runners;
# CREATE TABLE runners (
#   runner_id int,
#   registration_date datetime(6)
# );
#
# INSERT INTO runners
#   (runner_id, registration_date)
# VALUES
#   (1, '2021-01-01'),
#   (2, '2021-01-03'),
#   (3, '2021-01-08'),
#   (4, '2021-01-15');
#
#
# DROP TABLE IF EXISTS customer_orders;
# CREATE TABLE customer_orders (
#   order_id int,
#   customer_id int,
#   pizza_id int,
#   exclusions VARCHAR(4),
#   extras VARCHAR(4),
#   order_time timestamp
# );
#
# INSERT INTO customer_orders
#   (order_id, customer_id, pizza_id, exclusions, extras, order_time)
# VALUES
#   ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
#   ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
#   ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
#   ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
#   ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
#   ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
#   ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
#   ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
#   ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
#   ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
#   ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
#   ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
#   ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
#   ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
#
#
# DROP TABLE IF EXISTS runner_orders;
# CREATE TABLE runner_orders (
#   order_id int,
#   runner_id int,
#   pickup_time VARCHAR(19),
#   distance VARCHAR(7),
#   duration VARCHAR(10),
#   cancellation VARCHAR(23)
# );
#
# INSERT INTO runner_orders
#   (order_id, runner_id, pickup_time, distance, duration, cancellation)
# VALUES
#   ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
#   ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
#   ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
#   ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
#   ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
#   ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
#   ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
#   ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
#   ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
#   ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');
#
#
# DROP TABLE IF EXISTS pizza_names;
# CREATE TABLE pizza_names (
#   pizza_id int,
#   pizza_name varchar(20)
# );
# INSERT INTO pizza_names
#   (pizza_id, pizza_name)
# VALUES
#   (1, 'Meatlovers'),
#   (2, 'Vegetarian');
#
#
# DROP TABLE IF EXISTS pizza_recipes;
# CREATE TABLE pizza_recipes (
#   pizza_id int,
#   toppings varchar(30)
# );
# INSERT INTO pizza_recipes
#   (pizza_id, toppings)
# VALUES
#   (1, '1, 2, 3, 4, 5, 6, 8, 10'),
#   (2, '4, 6, 7, 9, 11, 12');
#
#
# DROP TABLE IF EXISTS pizza_toppings;
# CREATE TABLE pizza_toppings (
#   topping_id INTEGER,
#   topping_name TEXT
# );
# INSERT INTO pizza_toppings
#   (topping_id, topping_name)
# VALUES
#   (1, 'Bacon'),
#   (2, 'BBQ Sauce'),
#   (3, 'Beef'),
#   (4, 'Cheese'),
#   (5, 'Chicken'),
#   (6, 'Mushrooms'),
#   (7, 'Onions'),
#   (8, 'Pepperoni'),
#   (9, 'Peppers'),
#   (10, 'Salami'),
#   (11, 'Tomatoes'),
#   (12, 'Tomato Sauce');


use pizza_runner;

CREATE TABLE runner_orders_c AS SELECT * FROM runner_orders;

select *
from runner_orders_c;

# fix duration column
UPDATE runner_orders_c
SET duration = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(duration, ' minutes', ''), ' mins', ''), ' minute', ''), 'mins', ''), 'minute', ''), ' ', ''), '"', '');

UPDATE runner_orders_c
SET duration = REPLACE(duration,'s','');

UPDATE runner_orders_c
SET duration = IF(duration = 'null', NULL, duration);

alter table runner_orders_c modify column duration int;

# fix distance column :
-- remove km from distances :
update runner_orders_c
set distance = replace(distance,'km','');

UPDATE runner_orders_c
SET distance = IF(distance = 'null', NULL, distance);

alter table runner_orders_c modify column distance int;

# fix pickup_time :
UPDATE runner_orders_c
SET pickup_time = IF(pickup_time = 'null', NULL, pickup_time);

UPDATE runner_orders_c
SET pickup_time = IF(pickup_time = '',
                    NULL,
                    str_to_date(pickup_time, '%Y-%m-%d %H:%i:%s'));

desc runner_orders_c; # pickup_time is still varchar

alter table runner_orders_c modify column pickup_time datetime;

# remove 'null' string from cancellations :
update runner_orders_c
set cancellation = if(cancellation = '',null,cancellation);

# confirm changes
desc runner_orders_c;

# read final table
select *
from runner_orders_c;


# now the customer_orders table :
CREATE TABLE customer_orders_c AS SELECT * FROM customer_orders;

select *
from customer_orders_c;

desc customer_orders_c;

update customer_orders_c
set exclusions = if(exclusions = 'null',null,exclusions);
update customer_orders_c
set exclusions = if(exclusions = '',null,exclusions);

update customer_orders_c
set extras = if(extras = 'null',null,extras);

update customer_orders_c
set extras = if(extras = '',null,extras);

# QUESTIONS :
# A. Pizza Metrics

# How many pizzas were ordered?
select count(*)
from customer_orders_c; # 14 orders

# How many unique customer orders were made?
select count(distinct order_id)
from customer_orders_c; # 10 unique orders

# How many successful orders were delivered by each runner?
select runner_id, count(*) as tot_orders
from runner_orders_c
where cancellation is null
group by runner_id;


# How many of each type of pizza was delivered?
select pn.pizza_id,pizza_name, count(*)
from customer_orders_c
join runner_orders_c roc on customer_orders_c.order_id = roc.order_id
join pizza_names pn on customer_orders_c.pizza_id = pn.pizza_id
where cancellation is null
group by pizza_id;


#   How many Vegetarian and Meatlovers were ordered by each customer?
select customer_id, sum(if(pizza_id = 1,1,0)) as meatlovers,
       sum(if(pizza_id = 2,1,0)) as vegetarian
from customer_orders_c
group by customer_id
order by customer_id;

#  What was the maximum number of pizzas delivered in a single order?
select c.order_id, count(*) as total_pizzas_ordered
from customer_orders_c c
join runner_orders ro on c.order_id = ro.order_id
where cancellation is null
group by order_id
order by count(*) desc
limit 1;

# For each customer, how many delivered pizzas had at least 1
# change and how many had no changes?

select customer_id,
    sum(if(exclusions is null and extras is null,1,0)) as no_changes,
    sum(if(exclusions is not null or extras is not null ,1,0)) as changes
from customer_orders_c c
join runner_orders_c roc on c.order_id = roc.order_id
where cancellation is null
group by customer_id;

# How many pizzas were delivered that had both exclusions and extras?
select *
from customer_orders_c c
join runner_orders_c ro on c.order_id = ro.order_id
where extras is not null and exclusions is not null and cancellation is null;

# What was the total volume of pizzas ordered for each hour of the day?
select hour(order_time) as hour_ordered, count(*)
from customer_orders_c
group by hour_ordered
order by hour_ordered;

# What was the volume of orders for each day of the week?
select dayname(order_time) as dayOfWeek, count(*)
from customer_orders_c
group by dayOfWeek;


# How many runners signed up for each 1 week period?
# (i.e. week starts 2021-01-01)

select *
from runners;

SELECT
  CONCAT(DATE_FORMAT(registration_date, '%b'), '-', FLOOR((WEEK(registration_date, 1) - WEEK(DATE_FORMAT(registration_date, '%Y-%m-01'), 1))/4) + 1) AS period
FROM runners;


select *
from runner_orders;

