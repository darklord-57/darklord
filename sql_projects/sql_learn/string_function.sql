select concat_ws('-',author_fname,author_lname)
from books;

select concat(substring(author_fname,1,1),'.',
               author_lname) as full_name
from books;

select replace(title, 'e', '3') from books;


select
    replace(title, " ", '->')
from books;

select * from books;

select distinct author_fname, author_lname
from books;

select book_id,author_fname,author_lname
from books
order by 2,3; -- 2 means 'author_fname'.

select * from books limit 5,3131311311;
-- large number gives all results from 5 to the end!

select * from books
where author_fname like "%Da%";

select * from books
where title like "%the%";

select title,stock_quantity from books
where stock_quantity like '___';

select * from books
where author_lname like "% %";
