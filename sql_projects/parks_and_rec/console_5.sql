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


select ed.employee_id, ed.first_name, ed.last_name, es.salary, pd.department_name
from employee_demographics ed
    join employee_salary es on ed.employee_id = es.employee_id
    join parks_departments pd on es.dept_id = pd.department_id;

