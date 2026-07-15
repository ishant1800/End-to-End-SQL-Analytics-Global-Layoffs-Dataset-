-- Data Cleaning
-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null values or blank values
-- 4. Remove any columns if necessary 


-- Removing duplicates

Select *
From layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

Select *
From layoffs_staging;

Insert layoffs_staging
Select *
From layoffs;


Select * ,
ROW_NUMBER() OVER(
Partition By company , industry , total_laid_off , percentage_laid_off , `date`) AS Row_num
From layoffs_staging;


WITH duplicate_cte AS
(
Select * ,
ROW_NUMBER() OVER(
Partition By company , location , industry , total_laid_off , percentage_laid_off , `date`, stage , country , funds_raised_millions) AS Row_num
From layoffs_staging
)
Select *
From duplicate_cte
Where row_num > 1;

Select *
From layoffs_staging
Where company ='Casper';


WITH duplicate_cte AS
(
Select * ,
ROW_NUMBER() OVER(
Partition By company , location , industry , total_laid_off , percentage_laid_off , `date`, stage , country , funds_raised_millions) AS Row_num
From layoffs_staging
)
DELETE 
From duplicate_cte
Where row_num > 1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` Int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select *
From layoffs_staging2;

Insert Into layoffs_staging2
Select * ,
ROW_NUMBER() OVER(
Partition By company , location , industry , total_laid_off , percentage_laid_off , `date`, stage , country , funds_raised_millions) AS Row_num
From layoffs_staging;

Select *
From layoffs_staging2
Where row_num > 1;

DELETE
From layoffs_staging2
Where row_num > 1;

Select *
From layoffs_staging2;


-- Standardizing data

Select company , TRIM(company)
From layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

Select DISTINCT industry
From layoffs_staging2
Order by 1;

Select *
From layoffs_staging2
Where industry Like 'Crypto%';

Update layoffs_staging2
SET industry = 'Crypto'
Where industry LIKE 'Crypto%';

Select Distinct location
From layoffs_staging2
Order by 1;

Select Distinct country
From layoffs_staging2
Order by 1;

Select *
From layoffs_staging2
Where country LIKE 'United States%'
Order by 1;

Select distinct country , trim(Trailing '.' from country)
From layoffs_staging2
Order by 1;

Update layoffs_staging2
Set country = trim(Trailing '.' from country)
Where country LIKE 'United States%';

Select `date`,
str_to_date(`date` , '%m/%d/%Y')
From layoffs_staging2;

Select `date`
from layoffs_staging2;

update layoffs_staging2
Set `date` = str_to_date(`date` , '%m/%d/%Y');

Alter Table layoffs_staging2
Modify Column `date` DATE;

Select *
From layoffs_staging2;


-- Null and blank Values

Select *
From layoffs_staging2
Where total_laid_off is Null
AND percentage_laid_off is null;

Update layoffs_staging2
Set industry = Null
where industry = '';

Select *
From layoffs_staging2
Where industry is Null
or industry = '';

Select *
From layoffs_staging2
Where company = 'Airbnb';

Select *
From layoffs_staging2 t1
Join layoffs_staging2 t2
	on t1.company = t2.company
    And t1.location = t2.location
Where (t1.industry is null or t1.industry = '')
And t2.industry is not null;

Update layoffs_staging2 t1
Join layoffs_staging2 t2
	on t1.company = t2.company
Set t1.industry = t2.industry
Where t1.industry is null 
And t2.industry is not null;

Select *
From layoffs_staging2
Where company Like 'Bally%';

Select *
From layoffs_staging2;

Select *
From layoffs_staging2
Where total_laid_off is null
And percentage_laid_off is null;

Delete
From layoffs_staging2
Where total_laid_off is null
And percentage_laid_off is null;

Select *
From layoffs_staging2;

Alter table layoffs_staging2;
Drop column row_num;




-- Exploratory Data Analysis (EDA)

Select *
From layoffs_staging2;

Select MAX(total_laid_off) , MAX(percentage_laid_off)
From layoffs_staging2;

Select *
From layoffs_staging2
Where percentage_laid_off = 1
-- order by total_laid_off Desc;
order by funds_raised_millions Desc;

Select company, Sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 Desc;

Select industry, Sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 Desc;

Select MIN(`Date`) , MAX(`date`)
from layoffs_staging2;

Select country, Sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 Desc;

Select `date`, Sum(total_laid_off)
from layoffs_staging2
group by `date`
order by 2 Desc;

Select Year(`date`), Sum(total_laid_off)
from layoffs_staging2
group by Year(`date`)
order by 1 Desc;

Select stage, Sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 Desc;

Select company, AVG(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 Desc;

Select substring(`date`,6,2) As `Month`, Sum(total_laid_off)
From layoffs_staging2
group by `Month`
Order by 1 Asc;

With Rolling_total as(
Select substring(`date`,1,7) As `Month`, Sum(total_laid_off) as total_off
From layoffs_staging2
Where substring(`date`,1,7) is not null
group by `Month`
Order by 1 Asc
)
Select `Month` , total_off, Sum(total_off) Over(Order by `Month`) as Month_Total
From Rolling_total;

Select company , Year(`date`), Sum(total_laid_off)
from layoffs_staging2
group by company ,Year(`date`)
order by 3 desc;

With Company_year (company , years , total_laid_off) As
(
Select company , Year(`date`), Sum(total_laid_off)
from layoffs_staging2
group by company ,Year(`date`)
), Company_year_rank As
(Select * ,
dense_rank() Over(Partition by years Order by total_laid_off Desc) as Ranking
From Company_year
where years is not null
)
Select *
from Company_year_rank
Where Ranking <=5;













