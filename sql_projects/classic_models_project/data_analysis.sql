--  total number of payments made by each customer
select p.customerNumber,customerName,
       count(*) as num_of_payments
from payments p
join customers c on c.customerNumber = p.customerNumber
group by customerNumber;

-- Identify the top 5 customers who have made the highest payments.
select c.customerNumber, customerName,
       sum(amount) as total_payments
from payments p
join customers c on c.customerNumber = p.customerNumber
group by c.customerNumber
order by total_payments desc
limit 5 ;

-- Show the product line that sold the most products.
select productLine, sum(quantityOrdered) as total_ordered
from products p
join orderdetails o on p.productCode = o.productCode
group by productLine
order by total_ordered desc
limit 1;

-- Identify the countries with the most customers.
select country, count(*) as num_of_customer
from customers
group by country
order by num_of_customer desc
limit 5;

-- Identify the top 3 employees who have managed the most orders.
select employeeNumber, count(*) as total_orders_managed, sum(quantityOrdered) as total_products_ordered_under
from orders o
join customers c on o.customerNumber = c.customerNumber
join employees e on c.salesRepEmployeeNumber = e.employeeNumber
join orderdetails o2 on o.orderNumber = o2.orderNumber
group by employeeNumber
order by total_orders_managed desc
limit 3;



-- Top 3 year's that had the highest sales?
with cte as
    (select year(paymentDate) as year, amount
    from payments)
select year, sum(amount) as total_sales
from cte
group by year
order by total_sales desc
limit 3;

-- which month had the highest number of orders each year.
WITH cte AS (
  SELECT YEAR(orderDate) AS year,
         MONTH(orderDate) AS month,
         SUM(quantityOrdered) AS total_orders,
         RANK() OVER (PARTITION BY YEAR(orderDate) ORDER BY SUM(quantityOrdered) DESC) AS rank_
  FROM orders o
  JOIN orderdetails od ON o.orderNumber = od.orderNumber
  GROUP BY year, month
)
SELECT year, month, total_orders
FROM cte
WHERE rank_ = 1;


# Top 3 most ordered product in each countries.
with cte as
    (select country,
       productName,
       count(*) as total_ordered,
       dense_rank() over (partition by country order by count(*) desc) as rank_
from orderdetails o
join orders o2 on o2.orderNumber = o.orderNumber
join customers c on o2.customerNumber = c.customerNumber
join products p on o.productCode = p.productCode
group by country, productName)

select country, productName, total_ordered, rank_
from cte
where rank_ in (1,2,3)
order by country, total_ordered desc;

# Unlike DENSE_RANK , RANK skips positions after equal rankings. The number of positions skipped depends on how many rows had an identical ranking. For example, Mary and Lisa sold the same number of products and are both ranked as #2. With RANK , the next position is #4; with DENSE_RANK , the next position is #3.

-- Find the product which had the most orders across all countries.
WITH cte AS (
    SELECT
        p.productName,
        COUNT(*) as total_ordered,
        RANK() OVER (ORDER BY COUNT(*) DESC) as rank_
    FROM orderdetails od
    JOIN orders o ON od.orderNumber = o.orderNumber
    JOIN customers c ON o.customerNumber = c.customerNumber
    JOIN products p ON od.productCode = p.productCode
    GROUP BY p.productName
)

SELECT productName, total_ordered
FROM cte
WHERE rank_ = 1;

-- The reason to use RANK() might come into play when you have a tie for the most ordered product.
-- If i had just used a simple order by and limit 1 then if another product had the same number of orders, it wouldnt be revealed.
-- Both methods are valid, and the choice between them depends on how you want to handle ties for the first place.

-- Identify the top 5 customers who have made the highest payments, for each employee.
with cte as
    (select employeeNumber,
       c.customerName,
       sum(amount) as total_payment,
       dense_rank() over (partition by employeeNumber order by  sum(amount) desc) as rank_
from payments p
join customers c on p.customerNumber = c.customerNumber
join employees e on e.employeeNumber = c.salesRepEmployeeNumber
group by employeeNumber, c.customerNumber)

select *
from cte
where rank_ in (1,2,3,4,5);

# Find out the most popular product (highest number of orders) for each employee.
# Determine the correlation between the number of orders an employee manages and their office's location (country).
# Analyze sales trends by finding out the percentage change in sales month-over-month.
# Calculate the repeat customer rate, i.e., how many customers made more than one order.
# Determine the product line that has the highest average order value.
# Find the top 3 countries that have the highest average customer payments.
# Identify the month with the highest number of orders for each year.