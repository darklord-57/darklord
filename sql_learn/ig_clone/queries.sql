# find 5 oldest users
select username,
       TIMESTAMPDIFF(YEAR,created_at, CURRENT_DATE()) as years_passed,
       created_at
from users
order by created_at
limit 5;

# week where most users registered for a new account :
select dayname(created_at) as week, count(*)
from users
group by week
order by count(*) desc
limit 2;

# identify inactive users :
select u.id,u.username as name
from users u
left join photos p
    on u.id = p.user_id
where p.id is null;


# most popular post and who posted it :
select p.id as 'photo_id' , u.username, count(*) as '# of likes'
from photos p
join likes l on p.id = l.photo_id
join users u on u.id = p.user_id
group by photo_id
order by count(*) desc;

# average number of posts per user:
select
    (select count(*)
     from photos )
    /
    (select count(*)
    from users) as avg;

# random query, this is how we find the sum of a resulting column
SELECT SUM(count_rows) as 'total_photos'
FROM (
  SELECT COUNT(*) as count_rows
  FROM users u
  JOIN photos p ON u.id = p.user_id
  GROUP BY u.id
) as t;


# 5 most popular hashtags :
select tag_name, count(*) as 'times used'
from photo_tags pt
join tags t on t.id = pt.tag_id
group by tag_id
order by count(*) desc
limit 7;

# find users that liked all the posts : (possible bots)
select username,
       user_id,
       count(*) as num_likes
from users u
join likes l
    on u.id = l.user_id
group by l.user_id
having num_likes = (select count(*) from photos);


select p.id as photo_id,
       l.user_id as liked_user,
       username as posted_by
from photos p
join likes l on p.id = l.photo_id
join users u on u.id = p.user_id;

# for a given user, find the user that has liked the most pictures.
SELECT u_owner.username as posted_by,
       u_liker.username as liked_by,
       count(*) as num_of_likes
FROM photos p
JOIN likes l ON p.id = l.photo_id
join users u_owner on u_owner.id = p.user_id
join users u_liker on u_liker.id = l.user_id
WHERE p.user_id = 23
GROUP BY l.user_id
order by count(*) desc
limit 1;

# for every user, find the user that has liked the most pictures.
select *
from (SELECT u_owner.username as posted_by,
       u_liker.username as liked_by,
        count(*)
        FROM photos p
        JOIN likes l ON p.id = l.photo_id
        join users u_owner on u_owner.id = p.user_id
        join users u_liker on u_liker.id = l.user_id
        group by posted_by, liked_by
        order by count(*) desc ) as t
group by posted_by;

# random question :
INSERT INTO person (person, group_name, age)
VALUES
('Bob', 1, 32),
('Jill', 1, 34),
('Shawn', 1, 42),
('Jake', 2, 29),
('Paul', 2, 36),
('Laura', 2, 39);

select *
from person;

select person, group_name, max(age)
from person
group by group_name;

select person, p.group_name, age
from person p
join(
SELECT group_name, MAX(Age) AS MaxAge
  FROM person
  GROUP BY group_name) as p1
where p.group_name = p1.group_name and age = MaxAge;

