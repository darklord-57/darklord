show tables ;

# pivot
create table Employee (
 id int  primary key auto_increment,
 name varchar(255),
 paymenttype varchar(255),
 payment bigint
);

insert into Employee (name, paymenttype, payment)
values
('John  ',       'Salary' ,     100),
('Peter ',       'Salary' ,     100),
('John  ',       'Bonus ' ,     20 ),
('Russel',       'Salary' ,     100),
('Bill  ',       'Salary' ,     100),
('Bill  ',       'Bonus ' ,     40 ),
('John  ',       'Salary' ,     100);

select name,
       sum(IF(paymenttype = 'Salary', payment, 0)) as salary,
       sum(IF(paymenttype = 'Salary', payment, 0)) as bonus
from Employee
group by Employee.name;

# identify node type in a binary tree :
create table bst (
    n int,
    p int
);

insert into bst(n, p)
    VALUES (1,2) , (3,2), (6,8),
           (9,8), (2,5),(8,5),(5,null);


select *
from bst;

SELECT N,
       CASE
         WHEN P IS NULL THEN 'Root'
         WHEN N NOT IN (SELECT DISTINCT P FROM BST where p is not null )
             THEN 'Leaf'
         ELSE 'Inner'
       END AS PLACE
FROM BST
ORDER BY N;

# indexes :
show index from countries;

select *
from countries;

# create index :
create index c_name on countries(COUNTRY_NAME);
show index from countries;

# delete index :
drop index c_name on countries;
show index from countries;

# procedure:

delimiter //
create procedure get_country_code()
    begin
        select concat(COUNTRY_ID,'_',COUNTRY_NAME)
            from countries;
    end //
delimiter ;

call get_country_code();


# function : (performs function for each id and name )
delimiter //
create function get_country_code1(c_id varchar(20),c_name varchar(50))
    returns varchar(30)
    reads sql data
    begin
        return concat(c_id,'_',c_name);
    end //
delimiter ;

select COUNTRY_ID,COUNTRY_NAME, get_country_code1(COUNTRY_ID,COUNTRY_NAME)
from countries;

show procedure status where Definer like "root%";

# transactions :

start transaction ;

insert into employees(employee_id, first_name, last_name, email, phone_number,
                      hire_date, job_id, salary, commission_pct, manager_id, department_id)
    VALUES (207, 'Alen','Jose','alen@email','07748298','1999-03-29','SA_REP',1200,0.20,145,80);
update jobs
set MIN_SALARY = 1200
where JOB_ID = 'SA_REP'
and MIN_SALARY > 1200;

commit;


start transaction ;
insert into employees(employee_id, first_name, last_name, email, phone_number,
                      hire_date, job_id, salary, commission_pct, manager_id, department_id)
    VALUES (210, 'baran','Jose','barlan@email','074445298','1995-03-20','SA_REP',1200,0.20,145,80);
rollback ;

select *
from employees;

DELIMITER $$

CREATE PROCEDURE calculate_factorial(IN num INT, OUT factorial INT, OUT elapsed_time DOUBLE)
BEGIN
    DECLARE start_time TIMESTAMP;
    SET start_time = CURRENT_TIMESTAMP();

    SET factorial = 1;
    WHILE num > 0 DO
        SET factorial = factorial * num;
        SET num = num - 1;
    END WHILE;

    SET elapsed_time = TIMESTAMPDIFF(MICROSECOND, start_time, CURRENT_TIMESTAMP())/1000;
END $$

DELIMITER ;

CALL calculate_factorial(10, @factorial, @elapsed_time);
SELECT @factorial AS factorial, @elapsed_time AS elapsed_time;


create table widgetCustomer (
    id integer auto_increment primary key ,
    name varchar(64),
    last_order_id int
);

create table widgetOrder (
    id integer auto_increment primary key ,
    item_id int ,
    customer_id int,
    price int
);

insert into widgetCustomer(name) values
            ('Bob'), ('Sally'), ('Fred');

select *
from widgetCustomer;

delimiter //
create trigger newOrder
    after insert on widgetOrder
    for each row
    begin
        update widgetCustomer set last_order_id = NEW.id
                where widgetCustomer.id = new.customer_id;
    end //
delimiter ;

insert into widgetOrder(item_id, customer_id, price)
    values (23, 1, 2000),
           (12, 3, 1500),
           (5, 2, 3000),
           (33,2,3000);

select *
from widgetOrder wo
left join widgetCustomer wc
    on wo.customer_id = wc.id;

select *
from widgetCustomer;

use random;

create table customer (
    id int auto_increment primary key ,
    name varchar(20)
);

create table sale (
    id int primary key auto_increment,
    item_id int,
    customer_id int,
    index cust_id (customer_id),
    constraint cust_id foreign key cust_id(customer_id) references customer(id)
                  on update cascade
                  on delete set null
);

alter table sale drop foreign key cust_id; -- cust_id wont work here
alter table sale add constraint
    foreign key (customer_id) references customer(id)
        on update restrict
        on delete set null ;

drop table sale;
show create table sale;

use northwind;

with sub as (
select *
from Customers
limit 2)
select *
from sub;

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


use random;

CREATE TABLE task_dates (
  task_id INT,
  start DATE,
  end DATE
);

INSERT INTO task_dates (task_id, start, end)
VALUES
  (1, '2015-10-01', '2015-10-02'),
  (24, '2015-10-02', '2015-10-03'),
  (2, '2015-10-03', '2015-10-04'),
  (23, '2015-10-04', '2015-10-05'),
  (3, '2015-10-11', '2015-10-12'),
  (22, '2015-10-12', '2015-10-13'),
  (4, '2015-10-15', '2015-10-16'),
  (21, '2015-10-17', '2015-10-18'),
  (5, '2015-10-19', '2015-10-20'),
  (20, '2015-10-21', '2015-10-22'),
  (6, '2015-10-25', '2015-10-26'),
  (19, '2015-10-26', '2015-10-27'),
  (7, '2015-10-27', '2015-10-28'),
  (18, '2015-10-28', '2015-10-29'),
  (8, '2015-10-29', '2015-10-30'),
  (17, '2015-10-30', '2015-10-31'),
  (9, '2015-11-01', '2015-11-02'),
  (16, '2015-11-04', '2015-11-05'),
  (10, '2015-11-07', '2015-11-08'),
  (15, '2015-11-06', '2015-11-07'),
  (11, '2015-11-05', '2015-11-06'),
  (14, '2015-11-11', '2015-11-12'),
  (12, '2015-11-12', '2015-11-13'),
  (13, '2015-11-17', '2015-11-18');


SELECT start, MIN(end), DATEDIFF(MIN(end), start)
FROM(SELECT start
     FROM task_dates
     WHERE start NOT IN
           (SELECT end FROM task_dates)) AS s,
    (SELECT end
     FROM task_dates
     WHERE end NOT IN
           (SELECT start
            FROM task_dates)) AS e
WHERE start < end
GROUP BY start
ORDER BY DATEDIFF(MIN(end), start), start;

select *
from (SELECT start
     FROM task_dates
     WHERE start NOT IN
           (SELECT end FROM task_dates)) AS s,
    (SELECT end
     FROM task_dates
     WHERE end NOT IN
           (SELECT start
            FROM task_dates)) AS e
WHERE start < end

select *
from task_dates;


WITH RECURSIVE factorial (n, result) AS (
SELECT 1, 1 -- base case
UNION ALL
SELECT n + 1, (n + 1) * result
FROM factorial
WHERE n < 10 -- stop condition
)
SELECT result
FROM factorial
WHERE n = 10;

