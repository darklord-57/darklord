# Total Sales by Year :
create view total_sales_by_year as
    select year(paymentDate) as year, sum(amount)
    from payments
    group by year;

# Customers with High Payment Totals :
create view top_customers as
  select customerName, sum(amount) as total_payment
  from customers c
  join payments p on c.customerNumber = p.customerNumber
  group by c.customerNumber
  having total_payment > 50000;