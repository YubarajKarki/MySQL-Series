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


 
#Practice Questions with Subqueries:
#1. Find the First Name and Last Name of employees who earn more than the average salary of all employees.
select first_name, last_name
from employee_salary
where salary > ( 
	select avg(salary) from employee_salary
);


#2. List the First Name, Last Name, and Department Name of employees whose salary is the highest in their respective department.
select dept_id, first_name, last_name, pkd.department_name
from employee_salary emps
join  parks_departments as pkd
on emps.dept_id= pkd.department_id
where salary= (
 select max(salary)
 from employee_salary
 where dept_id = emps.dept_id
)
;

select * 
from employee_demographics;
select *
from employee_salary;
select *
from parks_departments;


#3. Find the names of employees who are younger than the average age of all employees.
select first_name, age
from employee_demographics
where age <
(
	select avg(age)
    from employee_demographics
)
;

#4. Retrieve the Department Name for employees who do not work in the same department as 'Ann Perkins'.
select department_name, department_id
from parks_departments
where department_id in (
	select dept_id
    from employee_salary
    where employee_id not in (
		select employee_id
        from employee_demographics
        where first_name = 'Ann' and last_name = 'Perkins'
    )
)
;

#5. Find the names of employees who were born after the oldest employee in the company.
select first_name, last_name
from employee_demographics
where birth_date > 
(
	select min(birth_date)
    from employee_demographics
)
;
#6. List all departments that have at least one employee earning less than $30,000.
select department_name
from parks_departments
where department_id in 
(
	select dept_id
    from employee_salary
    where salary < 50000
)
;



#Practice Questions with Window Functions:
#1. Assign a row number to each employee based on their salary in descending order.
select first_name, last_name,employee_id, dept_id,
row_number() over (order by salary desc)
from employee_salary
;

#2. Calculate the running total of salaries by department.
select dept_id, first_name, last_name, salary,  
sum(salary) over(partition by dept_id order by salary desc) as running_total
from employee_salary
;
#3. Rank employees within each department by their salary. Display employee ID, name, department, and rank.
select dept_id, first_name, last_name, salary, dept_id,
rank() over(partition by dept_id order by salary desc) as salary_rank
from employee_salary
;
select *
from employee_salary
;
#4. Calculate the difference in salary between each employee and the highest-paid employee in their department.
select dept_id, first_name, last_name, salary,
max(salary) over(partition by dept_id)- salary as salary_difference
from employee_salary
;
#5. Find the average salary by department and display each employee's salary along with the department's average salary.
select dept_id, first_name, last_name, salary,
avg(salary) over(partition by dept_id ) as avg_dept_salary
from employee_salary
;
#6. List employees whose salary is higher than the average salary of their department.
select employee_id, first_name, last_name, salary, dept_id
from (
select employee_id, first_name, last_name, salary, dept_id,
avg(salary) over(partition by dept_id ) as avg_dept_salary
from employee_salary
) as subquery
where salary > avg_dept_salary
;



#Write a query to display the full name (first name and last name) and salary of each employee, along with their department name.
select dem.first_name, dem.last_name, concat(dem.first_name, " ", dem.last_name) as Full_Name, department_name
from employee_demographics as dem
inner join employee_salary as emps
on dem.employee_id = emps.employee_id
inner join parks_departments as pd
on emps.dept_id = pd.department_id
;

select * from  employee_demographics;
select * from employee_salary;
select * from parks_departments;

#Write a query to find all male employees and all employees earning more than 60,000 using a UNION operator.
select first_name, last_name
from employee_demographics
where gender = 'Male'
union
select first_name, last_name
from employee_salary
where salary >= 70000
;


#Write a query to display each employee's full name in uppercase letters
select first_name, last_name, upper(concat(first_name, ' ', last_name)) as Full_Name
from employee_demographics
;

#Write a query to display the full name of employees, 
#their salary, and a label that categorizes their salary as "High" if it's above 60,000, "Medium" 
#if it's between 30,000 and 60,000, and "Low" if below 30,000.
select dem.first_name, 
dem.last_name, 
concat(dem.first_name, " ", dem.last_name) as Full_Name, 
salary,
case
	when salary > 60000 then 'High'
    when salary between 30000 and 60000 then 'Medium'
    else 'Low'
end as salary_label
from employee_salary as emps
inner join  employee_demographics as dem
on dem.employee_id = emps.employee_id
;

#Write a query to find employees who earn more than the average salary of their department.
select empd.first_name,
empd.last_name,
emps.salary,
pd.department_name
from employee_salary as emps

inner join employee_demographics as empd
on empd. employee_id = emps.employee_id

inner join parks_departments as pd
on emps.dept_id = pd.department_id

where emps.salary >
(
	select avg(salary)
    from employee_salary
    where dept_id = emps.dept_id
)
;
#Write a query to display the full name (in the format: "Last Name, First Name") and birth date of employees who work in the 'IT' department.
select empd.first_name, empd.last_name, 
concat(empd.last_name, ' ', empd.first_name) as name_full,
empd.birth_date
from employee_demographics as empd

inner join employee_salary as emps
on empd. employee_id = emps.employee_id
inner join parks_departments as pd
on emps.dept_id = pd.department_id
where pd.department_name= 'Parks and Recreation'
;

#Write a query to calculate the cumulative sum of salaries for employees, 
#ordered by their hire date (assuming birth_date as hire date for the sake of this example).
select empd.first_name, 
empd.last_name, 
emps.salary,
sum(emps.salary) over(order by empd.birth_date) as cummulative_salary
from employee_demographics as empd
inner join employee_salary as emps
on empd.employee_id = emps.employee_id
;

#Write a query to find the second highest salary in each department.
select dept_id, salary
from(
	select dept_id, salary,
	row_number() over(partition by dept_id order by salary desc) as Salary_Rank
    from employee_salary
) as Ranked_Salaries
where Salary_Rank = 2;
;

#Write a query to find the names of departments with employees whose salary is above the overall average salary of all departments.
select distinct pd.department_name
from employee_salary as emps
inner join parks_departments as pd
on emps.dept_id = pd.department_id
where emps.salary >
(
	select avg(salary) 
	from employee_salary
)
;

 





