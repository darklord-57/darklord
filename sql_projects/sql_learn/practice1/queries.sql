# find employees whose managers work in the US.
select FIRST_NAME, LAST_NAME
from employees
where manager_id in
         (select distinct e.EMPLOYEE_ID
                from employees e
                join departments d on e.DEPARTMENT_ID = d.DEPARTMENT_ID
                join locations l on d.LOCATION_ID = l.LOCATION_ID
                                 and COUNTRY_ID = 'US')
order by FIRST_NAME;


# for each manager find least paid employee :
select e.MANAGER_ID, EMPLOYEE_ID, min_salary
from employees e
 join (
  select manager_id, min(salary) as min_salary
  from employees
  group by manager_id
    ) e2
   on e.manager_id = e2.manager_id and salary = e2.min_salary;


# find job titles that has a maximum salary greater than 4000.
select JOB_ID, max(SALARY) as max_salary
from employees
group by JOB_ID
having max_salary > 4000;

select DEPARTMENT_ID, count(*) as no_of_emp
from employees
group by DEPARTMENT_ID
having no_of_emp > 10;

select FIRST_NAME, LAST_NAME, SALARY
from employees
where SALARY > (
                select SALARY
                from employees
                where LAST_NAME = 'Bull'
    );

# name of managers :
select FIRST_NAME, LAST_NAME
from employees
where employee_id
          in (select distinct MANAGER_ID
            from employees);

# Find employees whose salary is equal to min salary for their job grade
select FIRST_NAME, LAST_NAME, SALARY
from employees e
join
    (select JOB_ID, MIN_SALARY
     from jobs) as min_sal
on e.JOB_ID = min_sal.JOB_ID and e.SALARY = min_sal.min_salary;

# find employees who earns more than the avg salary and works in any of the
# IT departments.
select FIRST_NAME, SALARY
from employees e
join departments d
    on e.DEPARTMENT_ID = d.DEPARTMENT_ID
where DEPARTMENT_NAME like 'IT%' and salary > (select avg(salary) from employees);


# find employees who have no one reporting them, i.e not managers
select FIRST_NAME, LAST_NAME
from employees
where EMPLOYEE_ID not in (select distinct MANAGER_ID from employees);

# or :

SELECT FIRST_NAME, LAST_NAME
FROM employees b
WHERE not EXISTS (SELECT 'X' FROM employees a
                             WHERE a.manager_id = b.employee_id);

# find emp who's salary is greater than salary of their depts avg.
select employee_id, first_name
from employees e
    join
   (select distinct DEPARTMENT_ID, AVG(SALARY) OVER (PARTITION BY DEPARTMENT_ID) as avg
    from employees) dept_avg
    on e.DEPARTMENT_ID = dept_avg.DEPARTMENT_ID
where SALARY > avg;

# or

SELECT employee_id, first_name
FROM employees AS A
WHERE salary >
    ( SELECT AVG(salary)
         FROM employees
         WHERE department_id = A.department_id);


select EMPLOYEE_ID
from employees
where mod(EMPLOYEE_ID, 2) <> 0;

SET @i = 0;
SELECT i, employee_id
FROM (SELECT @i := @i + 1 AS i, employee_id FROM employees)
a WHERE MOD(a.i, 2) = 0;

# find 5th record :
select *
from employees
order by SALARY desc
limit 5,1;


# find depts who have no employees
SELECT *
FROM departments
WHERE department_id
    NOT IN (select department_id
            FROM employees);

# self join:
select e.employee_id,e.LAST_NAME,m.EMPLOYEE_ID,m.LAST_NAME
from employees e
join employees m
    on e.MANAGER_ID = m.EMPLOYEE_ID;

# find employees hired after Mr.Jones.
select FIRST_NAME, LAST_NAME, HIRE_DATE
from employees
where HIRE_DATE >  (select HIRE_DATE
                    from employees
                    where LAST_NAME = 'Jones'
    );

# find # of emps per dept.
select DEPARTMENT_NAME, count(*)
from employees e
join departments d
    on e.DEPARTMENT_ID = d.DEPARTMENT_ID
group by e.DEPARTMENT_ID;

# find diff between salary and min salary for that job post for each emp
select FIRST_NAME, LAST_NAME, SALARY, (SALARY - j.MIN_SALARY) as diff
from employees e
join jobs J
on e.JOB_ID = J.JOB_ID;

# find job history of all emp who has a salary > 10,000
select *
from employees e
join job_history jh
        on e.EMPLOYEE_ID = jh.EMPLOYEE_ID
where SALARY > 10000;


select *
from employees
where EMPLOYEE_ID % 2 = 0;


use northwind;

# find the customer that orders the most (used cte for code readability) :
with layer as (
    select CustomerID, count(*) as count
from Orders
group by CustomerID
)
select CustomerID
from layer
order by count desc
limit 1;

# window function :
create table sales(
 item int,
 date date,
 price int
);


insert into sales(item, date, price)
values
(1,'2021-05-01', 200),
(1,'2021-06-11', 210),
(1,'2021-06-27', 225),
(1,'2021-08-01', 250),
(2,'2021-02-10', 600),
(2,'2021-04-21', 650),
(2,'2021-06-17', 675),
(2,'2021-07-23', 700);

select *
from sales;

SELECT item, date AS DateStart, price,
        date_sub(LEAD(date, 1, NOW())
           OVER (PARTITION BY item ORDER BY date), interval 1 day)
                        as date_change
FROM sales;

# lead = get the date column value from the next record (cause it is 1),
# if it was 2, then it would select the 2nd row


# cross join :
create table tables (year int, code int, import decimal(5,2));
insert into tables values
(2019,390107,10.00),
(2021,390107,175.00),
(2022,390107,102.00),
(2022,470101,101.00),
(2022,53015101,140.00);

create table years  (year int);
insert into years values
(2018),
(2019),
(2020),
(2021),
(2022);

create table codes (code int);
insert into codes values
(390107),
(470101),
(470103),
(471103),
(53010101),
(53015101);

SELECT Y.year,
       C.code,
    ifnull(T.import, 0) AS import
FROM  years Y
       CROSS JOIN codes C
       LEFT JOIN tables T
       ON T.year = Y.year AND T.code = C.code
order by import desc;