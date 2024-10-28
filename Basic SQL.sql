select * from parks_and_recreation.employee_demographics;

#This is comment
/*This is multi-line comment */

select distinct 
gender
from parks_and_recreation.employee_demographics;

select count(distinct first_name) 
from employee_demographics;

select * from employee_demographics
where age> 40 and gender= 'male';

select first_name, age
from employee_demographics
where age> 40 and gender= 'male';

select first_name, age
from employee_demographics
where age >= 35 and gender != 'male';

select first_name, birth_date
from employee_demographics
where gender= 'male' and not birth_date > '1980-1-1';

select first_name, birth_date
from employee_demographics
where gender= 'female' or not birth_date > '1980-1-1';

select first_name, birth_date
from employee_demographics
where (gender= 'female' and age > 35) or  birth_date >= '1988-12-01';

select first_name, last_name
from employee_demographics
where first_name like '_e_';

select first_name, last_name
from employee_demographics
where last_name like '%er%';

select first_name, birth_date
from employee_demographics
where birth_date like '198%';
#where birth_date like '198%-12-%';

#GROUP BY
select gender, avg(age), max(age), min(age), count(age)
from employee_demographics
group by gender;

#ORDER BY
select first_name, age
from employee_demographics
order by age desc;

select *
from employee_demographics
order by gender, age desc;

#HAVING VS WHERE
select gender, avg(age)
from employee_demographics
GROUP BY gender
having avg(age)>40;
;

select occupation, avg(salary) 
from employee_salary
where occupation like '%manager%' #filtered at row level
group by occupation
having avg(salary) > 65000 #filtered at aggregated function level
;

#LIMIT
select *
from employee_demographics
order by age desc #Age in descending order
limit 5 #This query gives top 5 age result
;

#Query to fetch 3rd most old aged person
select *
from employee_demographics
order by age desc
limit 2, 3 # 2nd after one is 3rd and (6, 3 - 7th 8th 9th)
#gives 3 result after 2 row
;

#Use can also use offset to start from
select *
from employee_demographics
order by age desc
limit 2 offset 3  #gives 2 result after 3rd row
;

#ALiasing- used to rename column
select gender, avg(age)  as avg_age
from employee_demographics
GROUP BY gender
having avg_age;
;

select gender, avg(age) avg_age #this will also work the same
from employee_demographics
GROUP BY gender
having avg_age;
;

#1. Common Numeric Functions
select abs(-15) as absolute; #gives absolute value of given number
select power(2, 4) as power;#Syntax: power(base, exponent), result=16

#ceil
select ceil(12.4);

#floor
select floor(25.9);

#round
select round(10.008);
select round(10.1128, 2);#ROUND(number, decimal_places)

#mod
select mod(29, 7);#MOD(dividend, divisor)

#2. Date and Time functions 

select now(); #gives current date and time
select curdate();#gives current date only
select current_date();
select current_time();
select current_timestamp();
select current_user();

select date_format(now(), '%y / %m / %d');
select date_format(now(), '%y - %m - %d');

select datediff(now(), '2024-08-09');
select datediff('2025-04-25', '2024-08-09');#Returns the number of days between two dates.

#ADDDATE(date, INTERVAL value DAY)- Adds or subtracts a specified number of days to/from a date.
select adddate('2024-08-09', interval 01 month);
select adddate('2024-08-09', interval 1 year);
select subdate('2024-08-09', interval 10 day);

#EXTRACT(part FROM date)-extracts a part of the date, such as year, month, day, etc.
select extract(year from '2024-08-09');
select extract(month from '2024-08-09');
select extract(day from '2024-08-09');

#3. Converting different data types

#CAST() Function: CAST(value AS type)
select cast('2024-09-10' as date); #converts string to date
select cast('9866' as unsigned); #converts string to number

#CONVERT() Function: CONVERT(value, type)
select convert('2024-09-10',date); #converts string to date
select convert('9866', unsigned); #converts string to number
SELECT IF(CONVERT('2024-09-10', DATE) IS NULL, 'Invalid Conversion', 'Valid Date Conversion') AS Validation;


#DATE() Function to Extracts the date part from a datetime expression.
#DATE(expression)
select DATE('2024-08-23 10:29:40'); #result: '2024-08-23


#TIME() Function:  Extracts the time part from a datetime expression.
 select time('2024-08-23 10:29:40');

#STR_TO_DATE()
select str_to_date('24-09-2021', '%d-%m-%Y'); -- 2021-09-24 %Y 4-digit year This is the correct way Y should be capital it denotes 4 digit years
SELECT STR_TO_DATE('23-08-2024', '%d-%m-%y'); -- 2020-08-23 %y for century: Looks for a two-digit year, but finds 2024. It only reads 20 (ignores 24) because it expects only two digits due to %y.
SELECT STR_TO_DATE('23-08-24', '%d-%m-%y'); -- 2024-08-23
SELECT IF(str_to_date('2024-09-10', '%y-%m-%d') IS NULL, 'Invalid Conversion', 'Valid Date Conversion') AS Validation;
SELECT IF(str_to_date('20-09-2025', '%d-%m-%Y') IS NULL, 'Invalid Conversion', 'Valid Date Conversion') AS Validation;
SELECT STR_TO_DATE('23-08-2024', '%d-%m-%Y');  -- Output: '2024-08-23'