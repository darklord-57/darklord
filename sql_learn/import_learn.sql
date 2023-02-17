select count(*) as '# of books'
from books;

select count(distinct author_fname,author_lname) as '# of authors'
from books;

select count(*)
from books
where title like "%the%";

select author_fname,author_lname, count(*) as '# of books'
from books
group by 1,2;

select released_year, count(*)
from books
group by released_year;

select concat(author_fname,' ',author_lname) as author_name
      ,min(released_year) as 'first_book',
       sum(pages) as 'total pages written',
       avg(pages) as 'average pages per book'
from books
group by author_name;

select released_year,avg(stock_quantity) as avg_stock
from books
group by released_year;

select concat(author_fname,' ',author_lname) as name, avg(released_year)
from books
group by name;

select concat(author_fname,' ',author_lname) as full_name
from books
where pages = (select max(pages) from books);

select released_year,
       count(*) as '# books',
       cast(avg(pages) as dec(5,1)) as avg_pages
from books
group by released_year;

select *
from books;

desc books;

create table people (
    name varchar(100),
    birthday date,
    birthtime time,
    birth_dt datetime
    );

insert into people(name, birthday, birthtime, birth_dt)
 VALUES ('Padma','1983-11-11','10:07:35','1983-11-11 10:07:35'),
        ('Larry', '1943-12-25','04:10:42','1943-12-25 04:10:42');

insert into people(name, birthday, birthtime, birth_dt)
 VALUES('Toaster', '2017-04-21','19:12:43','2017-04-21 19:12:43');

insert into people(name, birthday, birthtime, birth_dt)
            values ('Microwave', curdate(), curtime(), now());

select * from people;

select name,birth_dt, day(birth_dt),dayname(birth_dt) from people;

SELECT DATE_FORMAT(birth_dt, '%W %M %Y') as formatted_date FROM people;

SELECT YEAR(NOW()) - YEAR(birthday) as years_passed
FROM people;


create table people1 (
    name varchar(20),
    date_created timestamp
        default current_timestamp -- sets current time as default
        on update current_timestamp -- sets to time when updation occured
);

insert into people1(name) values ('alen');

update people1 set name = 'Allen Jose' where name = 'Allen';

select * from people1;

select title, author_lname, released_year
from books
where author_lname = 'Eggers' AND released_year > 2010;

select title,released_year
from books
where released_year between 2004 and 2015;

select title, released_year
from books
where released_year % 2 <> 0;

select title, released_year ,
       case
           when released_year > 1999 then 'Modern Lit'
           when released_year < 1999 then '20th Century Lit'
           end as GENRE
from books;

select author_fname,author_lname,
       case
           when count(*) = 1 then '1 book'
            else concat(count(*), ' books')
            end as COUNT
from books
group by author_fname,author_lname;


