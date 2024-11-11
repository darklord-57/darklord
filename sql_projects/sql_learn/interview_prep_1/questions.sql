use interv_prep_1;

# Find the top 3 customers by total spending, excluding any orders that have been canceled.
# Include their total spending and the number of orders.
with customers_cte (customer_id, total_sales, num_of_orders) as (
select customer_id,sum(total_amount), count(*)
from orders
where status <> 'Cancelled'
group by customer_id)

select name, c_cte.total_sales, c_cte.num_of_orders
from customers_cte c_cte
    join customers c
    on c.customer_id = c_cte.customer_id
limit 3;

# Identify the customer(s) with the highest number of completed orders.
# Display the customer’s name, email, and count of completed orders.

select c.name, c.email, count(*)
from orders o join customers c on o.customer_id = c.customer_id
where status = 'Completed'
group by o.customer_id;

# Calculate the total revenue generated from each product category for orders
# completed in 2023. Include category, total revenue, and the total quantity sold.
select p.category, sum(p.price * oi.quantity) as total_rev, count(distinct oi.order_id) as total_orders
from orders o join order_items oi on o.order_id = oi.order_id
    join products p on oi.product_id = p.product_id
where year(order_date) = 2023
group by p.category;

# List the total number of products purchased by each customer per region. Only include customers who have completed
# at least one order in 2023. Show customer name, region, and total products purchased.

# customers with atleast 1 order in 2023
WITH customers_2023 AS (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE status = 'Completed' AND YEAR(order_date) = 2023
)
SELECT
    c.customer_id,
    c.name,
    c.region,
    SUM(oi.quantity) AS total_products_purchased
FROM
    customers c
JOIN
    customers_2023 c2023 ON c.customer_id = c2023.customer_id
JOIN
    orders o ON c.customer_id = o.customer_id
JOIN
    order_items oi ON o.order_id = oi.order_id
WHERE
    o.status = 'Completed'
GROUP BY
    c.customer_id, c.name, c.region;

select *
from customers;

# For each customer, find the time (in days) between their first and last completed order.
# Only include customers with at least two completed orders.

select customer_id, min(order_date) as min_date, max(order_date) as max_date, datediff(max(order_date), min(order_date)) as diff
from orders
where customer_id in (select customer_id
                      from orders
                      where status = 'Completed'
                      group by customer_id
                      having count(*) > 1
    )
group by customer_id;

# Identify the top 2 most sold products in each category for completed orders.
# Show the product name, category, and total quantity sold.

WITH cte AS (
    SELECT
        p.category,
        p.name,
        SUM(oi.quantity) AS total_quantity
    FROM
        orders o
    JOIN
        order_items oi ON o.order_id = oi.order_id
    JOIN
        products p ON p.product_id = oi.product_id
    WHERE
        o.status = 'Completed'
    GROUP BY
        p.category, p.name
),
ranked_products AS (
    SELECT
        category,
        name,
        total_quantity,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY total_quantity DESC) AS rank_
    FROM
        cte
)
SELECT
    category,
    name,
    total_quantity,
    rank_
FROM
    ranked_products
WHERE
    rank_ <= 2
ORDER BY
    category, rank_ ASC;

# Determine which customers have spent above the average spending per customer
# for the entire customer base. Include customer name, email, and their total spending.

with cte_1 as (
select customer_id, sum(total_amount) as total_spent
from orders
WHERE status = 'Completed'
group by customer_id ),
 cte_2 as (
     select avg(total_spent) as avg_spent  -- 283.33
     from cte_1
 )

select c.customer_id, c.name, c.email, cte_1.total_spent, (select avg_spent from cte_2) as avg_spent
from cte_1
join customers c on c.customer_id = cte_1.customer_id
where total_spent > (select * from cte_2);

with cte as (
    SELECT order_id, SUM(price * quantity) AS order_total
     FROM order_items oi
     JOIN products p ON oi.product_id = p.product_id
     GROUP BY oi.order_id
)
SELECT
    MONTH(order_date) AS Month,
    COUNT(DISTINCT o.order_id) AS num_of_orders,
    AVG(order_total) AS avg_order_value
FROM
    orders o
JOIN cte on o.order_id = cte.order_id
WHERE
    YEAR(order_date) = 2023 AND
    status = 'Completed'
GROUP BY
    MONTH(order_date)
ORDER BY
    Month;

