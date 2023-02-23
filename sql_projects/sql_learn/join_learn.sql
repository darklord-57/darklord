CREATE DATABASE customers_and_orders;

CREATE TABLE customers
(
	id INT PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	email VARCHAR(100)
);

CREATE TABLE orders
(
	id INT PRIMARY KEY AUTO_INCREMENT,
	order_date DATE,
 	amount DECIMAL(8,2),
	customer_id INT,
	FOREIGN KEY(customer_id)
	    REFERENCES customers(id)
        on delete CASCADE
);

INSERT INTO customers (first_name, last_name, email)
VALUES ('Boy', 'George', 'george@gmail.com'),
       ('George', 'Michael', 'gm@gmail.com'),
       ('David', 'Bowie', 'david@gmail.com'),
       ('Blue', 'Steele', 'blue@gmail.com'),
       ('Bette', 'Davis', 'bette@aol.com');

INSERT INTO orders (order_date, amount, customer_id)
VALUES ('2016/02/10', 99.99, 1),
       ('2017/11/11', 35.50, 1),
       ('2014/12/12', 800.67, 2),
       ('2015/01/03', 12.50, 2),
       ('1999/04/11', 450.25, 5);

SELECT * FROM customers;
SELECT * FROM orders;

# implicit inner join : (ugly code)
select concat(first_name,' ',last_name) as name,
       email,order_date,amount
from orders , customers c
where c.id = orders.customer_id;

# explicit inner join : (better code)
select concat(first_name,' ',last_name) as name,
       order_date,amount
from orders
    join customers c
        on orders.customer_id = c.id;

# left join :
select concat(first_name,' ',last_name) as name,
       order_date,
       amount
from customers
left join orders o
    on customers.id = o.customer_id;

select first_name,
       last_name,
       ifnull(sum(amount), 0) as total_spent
from customers c
left join orders o
    on c.id = o.customer_id
group by c.id
order by total_spent;

-- right join : (will be same as regular join, as every order
-- has a customer
select concat(first_name,' ',last_name) as name,
       order_date,
       amount
from customers
right join orders o
    on customers.id = o.customer_id;

# cascading delete :
delete from customers where email = 'george@gmail.com';
select * from orders;


create database classroom;
use classroom;

create table students (
    id int primary key auto_increment,
    first_name varchar(20)
);

create table papers (
    title varchar(100),
    grade int,
    student_id int,
    foreign key(student_id)
        references students(id)
        on delete cascade
);

INSERT INTO students (first_name)
VALUES ('Caleb'), ('Samantha'), ('Raj'), ('Carlos'), ('Lisa');

INSERT INTO papers (student_id, title, grade )
VALUES
	(1, 'My First Book Report', 60),
	(1, 'My Second Book Report', 75),
	(2, 'Russian Lit Through The Ages', 94),
	(2, 'De Montaigne and The Art of The Essay', 98),
	(4, 'Borges and Magical Realism', 89);


select first_name, title, grade
from students
    join papers p
        on students.id = p.student_id;

select first_name,
       ifnull(title, 'MISSING'),
       ifnull(grade, 0)
from students
    left join papers p
        on students.id = p.student_id;

select first_name,
       ifnull(avg(grade),0) as average
from students
    left join papers p
        on students.id = p.student_id
group by students.id
order by average desc;


select first_name,
       ifnull(avg(grade),0) as average,
       IF(avg(grade) > 75, 'PASSING', 'FAILING') as status
from students
    left join papers p
        on students.id = p.student_id
group by students.id;

# MANY TO MANY :

create database tv_show;
use tv_show;

CREATE TABLE series
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	title VARCHAR(100),
	released_year YEAR(4),
	genre VARCHAR(100)
);

INSERT INTO series (title, released_year, genre) VALUES
    ('Archer', 2009, 'Animation'),
    ('Arrested Development', 2003, 'Comedy'),
    ("Bob's Burgers", 2011, 'Animation'),
    ('Bojack Horseman', 2014, 'Animation'),
    ("Breaking Bad", 2008, 'Drama'),
    ('Curb Your Enthusiasm', 2000, 'Comedy'),
    ("Fargo", 2014, 'Drama'),
    ('Freaks and Geeks', 1999, 'Comedy'),
    ('General Hospital', 1963, 'Drama'),
    ('Halt and Catch Fire', 2014, 'Drama'),
    ('Malcolm In The Middle', 2000, 'Comedy'),
    ('Pushing Daisies', 2007, 'Comedy'),
    ('Seinfeld', 1989, 'Comedy'),
    ('Stranger Things', 2016, 'Drama');

CREATE TABLE reviewers
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100)
);

INSERT INTO reviewers (first_name, last_name) VALUES
    ('Thomas', 'Stoneman'),
    ('Wyatt', 'Skaggs'),
    ('Kimbra', 'Masters'),
    ('Domingo', 'Cortes'),
    ('Colt', 'Steele'),
    ('Pinkie', 'Petit'),
    ('Marlon', 'Crafford');

CREATE TABLE reviews
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	rating DECIMAL(2,1),
	series_id INT,
	reviewer_id INT,
	FOREIGN KEY(series_id) REFERENCES series(id),
	FOREIGN KEY(reviewer_id) REFERENCES reviewers(id)
);

INSERT INTO reviews(series_id, reviewer_id, rating) VALUES
    (1,1,8.0),(1,2,7.5),(1,3,8.5),(1,4,7.7),(1,5,8.9),
    (2,1,8.1),(2,4,6.0),(2,3,8.0),(2,6,8.4),(2,5,9.9),
    (3,1,7.0),(3,6,7.5),(3,4,8.0),(3,3,7.1),(3,5,8.0),
    (4,1,7.5),(4,3,7.8),(4,4,8.3),(4,2,7.6),(4,5,8.5),
    (5,1,9.5),(5,3,9.0),(5,4,9.1),(5,2,9.3),(5,5,9.9),
    (6,2,6.5),(6,3,7.8),(6,4,8.8),(6,2,8.4),(6,5,9.1),
    (7,2,9.1),(7,5,9.7),
    (8,4,8.5),(8,2,7.8),(8,6,8.8),(8,5,9.3),
    (9,2,5.5),(9,3,6.8),(9,4,5.8),(9,6,4.3),(9,5,4.5),
    (10,5,9.9),
    (13,3,8.0),(13,4,7.2),
    (14,2,8.5),(14,3,8.9),(14,4,8.9);

select * from series;
select * from reviews;
select * from reviewers;

select title,
       round(avg(rating),2) as avg_rating
from series s
    join reviews r on s.id = r.series_id
group by s.id
order by avg_rating;

select concat(first_name,' ', last_name) as reviewer,
       round(avg(rating),2) as avg_rating
from reviewers u
join reviews r
    on u.id = r.reviewer_id
group by reviewer;

# un-reviewed series:
select title
from series s
left join reviews r
    on s.id = r.series_id
where rating is null;


select * from reviewers;
select * from reviews;
select * from series;

select genre,
       round(avg(rating), 2) as avg_rating
from series s
join reviews r
    on s.id = r.series_id
group by genre;

select concat(first_name,' ', last_name) as name,
       count(rating),
       ifnull(min(rating),0) as min,
       ifnull(max(rating),0) as max,
       ifnull(round(avg(rating),2),0) as avg,
      if(count(rating) = 0,'inactive',"active") as status
from reviewers
left join reviews r on reviewers.id = r.reviewer_id
group by reviewers.id;

select title, rating, concat(first_name,' ', last_name) as reviewer
from reviews r
join series s
    on r.series_id = s.id
join reviewers r2
    on r.reviewer_id = r2.id
order by title;

# ----- OR ---------------------------

select title, rating, concat(first_name,' ', last_name) as reviewer
from reviewers r
join reviews r1
    on r.id = r1.reviewer_id
join series s
    on s.id = r1.series_id;
