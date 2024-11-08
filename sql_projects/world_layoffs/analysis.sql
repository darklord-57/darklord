
# exploratory data analysis

use world_layoffs;

select *
from layoffs_staging2;

# max value of total laid off and perc laid off in a day
select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

# sum of total_laid_off by company
select company, sum(total_laid_off) as sum_tot_laid_off
from layoffs_staging2
group by company
order by 2 desc;

# range of data by year
select min(Date), max(date)
from layoffs_staging2;

# lay_off by indusrty
select industry, sum(total_laid_off) as sum_tot_laid_off
from layoffs_staging2
group by industry
order by 2 desc;

# nb: more data points in USA (could affect analysis)
select country, sum(total_laid_off), count(*)
from layoffs_staging2
group by country
order by 2 desc;

# lay off by year
select year(Date), sum(total_laid_off), count(*)
from layoffs_staging2
group by year(Date)
order by 2 desc;

select stage, sum(total_laid_off), count(*)
from layoffs_staging2
group by stage
order by 2 desc;

# rolling sum of lay off
select substring(Date, 1,7) as  Month, sum(total_laid_off)
from layoffs_staging2
where substring(Date, 1,7) is not null
group by 1
order by 1;

with rolling_cte as (
    select substring(Date, 1,7) as  Month, sum(total_laid_off) as tot_off
    from layoffs_staging2
    where substring(Date, 1,7) is not null
    group by 1
    order by 1
)

select Month, tot_off, sum(tot_off) over (order by Month) as rolling_total
from rolling_cte;

# group by company and year to see total laid off
select company, year(Date), sum(total_laid_off)
from layoffs_staging2
group by company, year(Date)
order by 1,2 ;

# ranking of total laid off by year
WITH ranked_layoffs AS (
    SELECT
        company,
        YEAR(Date) AS year,
        SUM(total_laid_off) AS total_laid_off,
        DENSE_RANK() OVER (PARTITION BY YEAR(Date) ORDER BY SUM(total_laid_off) DESC) AS rank_
    FROM layoffs_staging2
    WHERE YEAR(Date) IS NOT NULL
    GROUP BY company, YEAR(Date)
)
SELECT *
FROM ranked_layoffs
WHERE rank_ <= 5  -- cte had to be used to filter the rank
ORDER BY year, rank_;


# check correlation between funds raised and layoffs
SELECT
    industry,
    AVG(funds_raised_millions) AS avg_funds_raised,
    AVG(total_laid_off) AS avg_laid_off
FROM layoffs_staging2
GROUP BY industry;


