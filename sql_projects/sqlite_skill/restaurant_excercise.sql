select FirstName, LastName, Email
from Customers
order by 2;

-- create a table to store response of people attending the party and their # of plus-ones.
create table customer_response
(
    customerID integer,
    no_of_people integer
);

select *
from Dishes
order by Price;

select *
from Dishes
where Type in ("Appetizer", "Beverage")
order by type;

select *
from Dishes
where type <> "Beverage"
order by type;

insert into Customers(firstname, lastname, email, address, city, state, phone, birthday, favoritedish)
            values("alan","ruse","allan31@gmail.com","lark rise","hatfield","hertfordshire","031-991-8480","1989-09-12",12);

select * from Customers order by CustomerID desc limit 1;