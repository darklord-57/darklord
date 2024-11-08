select *
from employee_demographics;

select *
from employee_salary;

# find missing emp from demo (1 record missing - ron)
select *
from employee_demographics right join employee_salary es on employee_demographics.employee_id = es.employee_id;

# total male and female count
select gender, count(*)
from employee_demographics
group by gender;

# avg salary bu gender
select gender, avg(salary)
from employee_salary join employee_demographics ed on employee_salary.employee_id = ed.employee_id
group by gender;

# all employees earning above 60,000$
select first_name, last_name, age
from employee_demographics
where employee_id in (select employee_id
                     from employee_salary
                     where salary > 60000);

# all manager positions, that have a total salary > than 60,000$
select occupation, sum(salary) as total_sal
from employee_salary
where occupation like '%manager%' # where can be used to filter by row level, before aggregation is performed
group by occupation
having total_sal > 60000 # used to filter after grouping
order by total_sal;

# Top 3 oldest employees
select *
from employee_demographics
order by age desc
limit 3;


select *
from Parks_and_Recreation.employee_demographics
where gender = "Female" and age > 30 and birth_date > '1978-01-01';

# joining 3 tables
select ed.employee_id, ed.first_name, ed.last_name, es.salary, pd.department_name
from employee_demographics ed
    join employee_salary es on ed.employee_id = es.employee_id
    join parks_departments pd on es.dept_id = pd.department_id;

# layoffs criteria (old and high paid emps)
select concat(first_name,' ',last_name)  as name, 'senior emps' as status
from employee_demographics
where age > 45
union
select concat(first_name,' ',last_name) as name, 'high paid emps' as status
from employee_salary
where salary > 70000;

select (upper(concat(first_name,' ', last_name))) as name,
       upper(concat(
           left(first_name,3),
           "_",
           left(last_name,3),
           "_",employee_id)) as emp_code,
       substring(birth_date,6,2) as month
from employee_demographics
order by month;


# pay increase by salary and bonus by department
select first_name, last_name, salary,
    case
        when salary <= 50000 then salary + (salary * 0.05)
        when salary > 50000 then salary + (salary * 0.07)
    end as new_sal,

       IF(dept_id in
          (select department_id
           from parks_departments
           where department_name = 'Finance'), (salary * .1), 0) as bonus

from employee_salary;

select gender, avg(salary)
from employee_salary es
    join employee_demographics ed on es.employee_id = ed.employee_id
group by gender;

# here window function was used so we could display names as well, which we coudnt for group by as it will only have male and female rows
select es.first_name, es.last_name, left(gender,1) as gender,
         floor(avg(salary) over(partition by gender)) as avg_sal_by_gender
from employee_salary es
    join employee_demographics ed on es.employee_id = ed.employee_id;

# no partition, just rollover sum ordered by id
select es.employee_id, ed.first_name, ed.last_name, gender, salary,
       sum(salary) over(order by ed.employee_id) as rolling_Sal
from employee_salary es
join employee_demographics ed on es.employee_id = ed.employee_id;

# rolling sum of salary by gender (ordered by emp id seperately for male and female and then rollover sum)
select es.employee_id, ed.first_name, ed.last_name, gender, salary,
       sum(salary) over(partition by gender order by ed.employee_id) as rolling_Sal
from employee_salary es
join employee_demographics ed on es.employee_id = ed.employee_id;

# row number,rank, dense_rank
select es.employee_id, ed.first_name, ed.last_name, gender, salary,
       row_number() over (partition by gender order by salary desc) as row_num,
       rank() over (partition by gender order by salary desc) as rank_num,
       dense_rank() over (partition by gender order by salary desc) as dense_rank_num
from employee_salary es
join employee_demographics ed on es.employee_id = ed.employee_id;

# avaerage of all employees salary
select avg(salary) as avg_sal
from employee_salary;

# avg of avg of male and female.
with cte_ex (Gender, AVG_Sal) as (
    select gender, avg(salary)
    from employee_demographics ed
        join employee_salary es on ed.employee_id = es.employee_id
    group by gender
)

select *, avg(AVG_Sal) over () avg_of_avg_sal
from cte_ex;

# large salary stored procedure
delimiter $$
create procedure large_sal ()
begin
    select *
    from employee_salary
    where salary >= 50000;
    select *
    from employee_salary
    where salary > 10000;
end $$
delimiter ;

call large_sal();

# stored proc with parameter

delimiter $$
create procedure retr_sal (emp_id int)
begin
    select salary
    from employee_salary
    where employee_id = emp_id;
end $$
delimiter ;

call retr_sal(1);


# trigger to insert emp id, f_name and l_name into emp_demo while new rows added to emp_salary
delimiter $$
create trigger emp_insert
    after insert on employee_salary
    for each row
    begin
        insert into employee_demographics (employee_id, first_name, last_name)
            values (new.employee_id, new.first_name, new.last_name);
    end $$
delimiter ;

insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
                VALUES (13, 'Alen', 'Jose', 'Data Analyst', 24000000, null);


# event that deletes emps with age >= 60

delimiter $$
create event delete_older_emps
    on schedule every 30 second
    do
        begin
            delete
            from employee_demographics
            where age >= 60;
        end $$
delimiter ;

# check event scheduler
show variables like 'event%';






