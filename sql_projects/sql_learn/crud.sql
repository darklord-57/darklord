create table cats(
    cat_id int not null auto_increment,
    name varchar(100),
    breed varchar(100),
    age int,
    primary key(cat_id)
);

insert into cats( name, breed, age)
values ('Ringo','Tabby',4),
       ('Cindy','Maine Coon',10),
       ('Dumbledore','Maine Coon',11),
       ('Egg','Persian',4),
       ('Misty','Tabby',13),
       ('George Michael','Ragdoll',9),
       ('Jackson','Sphynx',7);

select * from cats;

# update :

update cats set breed = 'Shorthair'
where breed = 'Tabby';

select * from cats;

update cats set age = 14
where name = 'Misty';

update cats set name = 'jack'
where name = 'jackson';

# delete :

delete from cats where name = 'Egg';

# deletes the table but the shell remains, drop removes the entire table.
delete from cats;

