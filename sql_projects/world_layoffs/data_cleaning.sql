# create schema world_layoffs;
use world_layoffs;

select *
from layoffs;

# create a staging table (preserve raw data incase we need it)
create table layoffs_staging
like layoffs;

# only skeleton with no values
select *
from layoffs_staging;

# populate staging table
insert layoffs_staging
select *
from layoffs;

select *
from layoffs_staging;

# 1. remove duplicates
with duplicate_cte as (
    select *,
       row_number() over ( partition by company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as ras
from layoffs_staging
)

select *
from duplicate_cte
where ras <> 1;

select *
from layoffs_staging
where company = 'Cazoo';

# to delete, we need to create a new table and then delete from that.
# create a modified staging table with extra column for row_num
create table layoffs_staging2
(
    company               text null,
    location              text null,
    industry              text null,
    total_laid_off        text null,
    percentage_laid_off   text null,
    date                  text null,
    stage                 text null,
    country               text null,
    funds_raised_millions text null,
    row_num text null
);

select *
from layoffs_staging2;

insert into layoffs_staging2
       select *,
       row_number() over ( partition by company,location, industry, total_laid_off,
                                        percentage_laid_off, `date`, stage, country,
                                        funds_raised_millions) as ras
       from layoffs_staging;

select *
from layoffs_staging2;

# drop rows where row_num is not 1
delete
from layoffs_staging2
where row_num > 1;

select *
from layoffs_staging2
where row_num > 1;

# 2. standardize the data

# exploring company column
select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

# exploring industry column
select distinct industry
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where industry like "%Crypto%";

update layoffs_staging2
set industry = 'Crypto'
where industry like "%Crypto%";

# found issue with country
select distinct country
from layoffs_staging2
where country like "%United States%";

# finding a method to remove the .
select distinct country, trim(trailing '.' from country)
from layoffs_staging2
where country like "%United States%";

# actually updating the country names
update layoffs_staging2
set country = trim(trailing '.' from country)
where country like "%United States%";

# updating date column from text to date. (also renaming column)
alter table layoffs_staging2
change `date` `Date` text;

# testing string to date
select Date, str_to_date(Date, '%m/%d/%Y')
from layoffs_staging2;

# handle nulls while fixing date
UPDATE layoffs_staging2
SET `Date` = STR_TO_DATE(`Date`, '%m/%d/%Y')
WHERE `Date` IS NOT NULL and `Date` != '' and `Date` != 'NULL';

# set datatype of column to date
UPDATE layoffs_staging2
SET Date = NULL
WHERE Date = 'NULL' OR Date = '';

alter table layoffs_staging2
modify column Date date;

select Date
from layoffs_staging2;

# converting the columns to int
ALTER TABLE layoffs_staging2
MODIFY COLUMN total_laid_off INT;

ALTER TABLE layoffs_staging2
MODIFY COLUMN funds_raised_millions INT;

ALTER TABLE layoffs_staging2
MODIFY COLUMN percentage_laid_off INT;


# 3. null or blank values

select *
from layoffs_staging2
where total_laid_off ='NULL' and percentage_laid_off = 'NULL';

# industry column
select company, industry
from layoffs_staging2
where industry is null or industry = 'NULL' or industry = '';

# this allows us to find industry, if other columns match the company
with null_indusrty as (
select *
from layoffs_staging2
where industry is null or industry = 'NULL' or industry = ''
)
select company, industry
from layoffs_staging2
where company in (select null_indusrty.company from null_indusrty);

# replacing industry based on rows where industry is not null
SELECT target.company,
       target.industry AS original_industry,
       source.industry AS new_industry
FROM layoffs_staging2 AS target
JOIN (
    SELECT company, MAX(industry) AS industry
    FROM layoffs_staging2
    WHERE industry IS NOT NULL AND industry != 'NULL' AND industry != ''
    GROUP BY company
) AS source
ON target.company = source.company
WHERE target.industry IS NULL OR target.industry = 'NULL' OR target.industry = '';

# updating the nulls with suitable industry
UPDATE layoffs_staging2 AS target
JOIN (
    SELECT company, MAX(industry) AS industry
    FROM layoffs_staging2
    WHERE industry IS NOT NULL AND industry != 'NULL' AND industry != ''
    GROUP BY company
) AS source
ON target.company = source.company
SET target.industry = source.industry
WHERE target.industry IS NULL OR target.industry = 'NULL' OR target.industry = '';

update layoffs_staging2
set industry = NULL
where industry = 'NULL';

select *
from layoffs_staging2
where industry is NULL or industry = 'NULL' OR industry='';

# set all 'NULL' string to null in all columns

UPDATE layoffs_staging2
SET
    industry = IF(industry = 'NULL', NULL, industry),
    location = IF(location = 'NULL', NULL, location),
    stage = IF(stage = 'NULL', NULL, stage),
    country = IF(country = 'NULL', NULL, country),
    company = IF(company = 'NULL', NULL, company),
#     `Date` = IF(`Date` = 'NULL', NULL, `Date`), already fixed date earlier
    percentage_laid_off = IF(percentage_laid_off = 'NULL', NULL, percentage_laid_off),
    total_laid_off = IF(total_laid_off = 'NULL', NULL, total_laid_off),
    funds_raised_millions = IF(funds_raised_millions = 'NULL', NULL, funds_raised_millions);

# checking conversion (success)
SELECT *
FROM layoffs_staging2
WHERE industry = 'NULL'
   OR location = 'NULL'
   OR stage = 'NULL'
   OR country = 'NULL'
   OR funds_raised_millions = 'NULL';

# checking blanks (none found)
SELECT *
FROM layoffs_staging2
WHERE industry = ''
   OR location = ''
   OR stage = ''
   OR country = ''
   OR funds_raised_millions = '';

# 4. remove unwanted columns

# if both null, then client said its useless
select *
from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

# deleting them
delete
from layoffs_staging2
where total_laid_off is null and percentage_laid_off is null;

# drop the row_num col as its no longer needed.
alter table layoffs_staging2
drop column row_num;