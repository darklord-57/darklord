-- USE THE NEWLY CREATED SCHEMA
use netflix_prepro;

-- BASIC ANALYSIS -----------------
# view all data:
select *
from netflix_titles;

# find total rows present:
select count(*)
from netflix_titles; # 8805 records

# check for duplicate records :
select count(distinct show_id)
from netflix_titles; # 8805 which matches the count above

# find all unique types :
select distinct type
from netflix_titles; # Movie, TV Show

# find the count of records that is missing its type or title
SELECT COUNT(*)
FROM netflix_titles
WHERE (type IS NULL OR title IS NULL); # 0 , there are no null records

# count of international shows/movies :
select count(*)
from netflix_titles
where (listed_in like '%International%');

# count of Movie/TV show :
select type,count(*)
from netflix_titles
group by type;


# find popular directors based on shows they directed alone:
select director, count(*)
from netflix_titles
where director not like '%,%'
group by director
order by count(*) desc
limit 5;
# this gives us the top 5 directors who have directed the most shows on
# their own.

# top 5 durations for a show/movie
with cte as (
    select (IF(duration like '%Season%', duration, 'movie')) Duration
     from netflix_titles )
select Duration, count(*)
from cte
group by Duration
order by count(*) desc
limit 5;

# update column date_added;  string to datetime
-- Add a new column for the converted date
ALTER TABLE netflix_titles ADD COLUMN added_date DATETIME;

-- Update the new column with the converted values
UPDATE netflix_titles
SET added_date = STR_TO_DATE(date_added, '%M %e, %Y');

-- Drop the original column
ALTER TABLE netflix_titles DROP COLUMN date_added;

-- Rename the new column to the original column name
ALTER TABLE netflix_titles CHANGE added_date date_added DATETIME;


-- ADD A NEW COLUMN ------------------
# Add a new empty column to the table
ALTER TABLE netflix_titles ADD COLUMN duration_hours VARCHAR(255);

#  Update the new column with the converted values
UPDATE netflix_titles
SET duration_hours =
        IF(duration LIKE '%min',
            CONCAT(FLOOR(SUBSTRING_INDEX(duration, ' ', 1) / 60), ' hr ',
            MOD(SUBSTRING_INDEX(duration, ' ', 1), 60), ' min'), duration);

-- REORDER COLUMNS -----------------

# Move the column's around for easier analysis
ALTER TABLE netflix_titles
    MODIFY COLUMN duration VARCHAR(255) AFTER description,
    MODIFY COLUMN country VARCHAR(255) AFTER title,
    MODIFY COLUMN release_year VARCHAR(255) AFTER country,
    MODIFY COLUMN date_added VARCHAR(255) AFTER release_year;
# View the updated table structure
DESCRIBE netflix_titles;

# run this and export the table as a csv file for the next step :
SELECT *
from netflix_titles;


