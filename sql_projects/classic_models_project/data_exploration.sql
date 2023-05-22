# display all tables :
show tables ;

describe customers;

# to check if there is a specific format for phone numbers. ( none found )
select phone
from customers
limit 10;

# total number of unique customers : 122
select distinct count(customerName)
from customers;

# there are 0 NULL rows (if found was to be deleted )
SELECT count(*)
FROM customers
WHERE addressLine2 IS NULL
AND state IS NULL
AND postalCode IS NULL
AND salesRepEmployeeNumber IS NULL
AND creditLimit IS NULL;


# ----------------------------------------------------
select *
from employees;

describe employees;

# total number of employees : 23
select distinct count(*)
from employees;

# only reportsTo has 1 NULL value
SELECT
  COUNT(*) - COUNT(employeeNumber) as Missing_employeeNumber,
  COUNT(*) - COUNT(lastName) as Missing_lastName,
  COUNT(*) - COUNT(firstName) as Missing_firstName,
  COUNT(*) - COUNT(extension) as Missing_extension,
  COUNT(*) - COUNT(email) as Missing_email,
  COUNT(*) - COUNT(officeCode) as Missing_officeCode,
  COUNT(*) - COUNT(reportsTo) as Missing_reportsTo,
  COUNT(*) - COUNT(jobTitle) as Missing_jobTitle
FROM employees;

# -----------------------------------------------------

select *
from offices;

describe offices;

# allow territory to hold null value
alter table offices change territory territory varchar(10) default null;

UPDATE offices
SET territory = IF(territory = 'NA', NULL, territory);

# --------------------------------------------------------------

select *
from orderdetails;

desc orderdetails;



# --------------------------------------------------------------

select *
from orders;

desc orders;

select distinct comments
from orders;


# --------------------------------------------------------------

select *
from payments;

desc payments;

# all payment row has an amount 
select count(*)
from payments
where amount is null;

# --------------------------------------------------------------
select *
from productlines;

select count(*)
from productlines
where htmlDescription is null and image is null; # 7

select count(*)
from productlines; # 7

# it is better to drop those 2 columns
alter table productlines
    drop column htmlDescription,
    drop column image;

# --------------------------------------------------------------
select *
from products;

desc products;