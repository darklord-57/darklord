create database shirts_db;
use shirts_db;

drop table shirts;

CREATE TABLE shirts (
  shirt_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  article VARCHAR(20) NOT NULL,
  color VARCHAR(20) NOT NULL,
  shirt_size VARCHAR(1) NOT NULL,
  last_worn INT NOT NULL
);


alter table shirts
modify column shirt_size varchar(100);

INSERT INTO
  shirts (article, color, shirt_size, last_worn)
VALUES
  ('t-shirt', 'white', 'S', 10),
  ('t-shirt', 'green', 'S', 200),
  ('polo shirt', 'black', 'M', 10),
  ('tank top', 'blue', 'S', 50),
  ('t-shirt', 'pink', 'S', 0),
  ('polo shirt', 'red', 'M', 5),
  ('tank top', 'white', 'S', 200),
  ('tank top', 'blue', 'M', 15);

INSERT INTO
  shirts (color, article, shirt_size, last_worn)
VALUES
  ('purple', 'polo shirt', 'M', 50);

desc shirts;

select * from shirts;

update shirts set shirt_size = 'L'
where article = 'Polo shirt';

update shirts set last_worn = 0
where last_worn = 15;

update shirts set shirt_size = 'XS', color = 'off white'
where color = 'white';

delete
from shirts
where last_worn = 200;


delete from shirts;

drop table shirts;

drop database shirts_db;



