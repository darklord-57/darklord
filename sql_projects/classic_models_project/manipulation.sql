-- Update the phone numbers of all customers from a specific country.
update customers
set phone = replace(phone, '.', '')
where country = 'France';

-- Add a new employee to the system and assign them to an office.
insert into employees (employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
    values (1703, 'Sam','Phillip','x104','samphillip201@gmail.com',4,1102,'Sales Rep');

-- Discontinue a product from the product line.
delete from productlines
where productLine = 'Trains'; -- wont work as this is referenced somewhere else

alter table productlines add column status varchar(10) default null;

# as i realized later that i needed 15 characters instead of 10.
alter table productlines modify column status varchar(15);

update productlines
set status = 'discontinued'
where productLine = 'Trains';

# create a trigger that checks status and only allows new insertions if status is null
delimiter %%
create trigger before_insert_product
    before insert
        on products for each row
    begin
        declare product_line_status varchar(15);
        select status into product_line_status
        from productlines
        where productLine = NEW.productLine;

        IF product_line_status = 'discontinued' THEN
      SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Cannot insert product into a discontinued product line';
    END IF;
end %%
delimiter ;

insert into products (productCode, productName, productLine, productScale, productVendor, productDescription, quantityInStock, buyPrice, MSRP)
    values ('S19_3333','Locomotive','Trains','1:18','Carousel DieCast Legends','just a test train',234,66.5,101.45);
-- [45000][1644] Cannot insert product into a discontinued product line

-- Another method was to use cascading delete, where when we delete a record from productlines, then all instances of that productline in other tables will be deleted in a cascading manner.




