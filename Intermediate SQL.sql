#INNER JOIN or JOIN
#OUTER JOIN(LEFT, RIGHT, FULL)- FULL OUTER JOIN IS DEFAUlt, achieved through the use of UNION operator
#SELF JOIN
#MULTIPLE JOIN

#1. INNER JOIN
select *
from employee_demographics
inner join employee_salary 
on employee_demographics.employee_id= employee_salary.employee_id
;

select empd.employee_id, empd.first_name, empd.last_name, emps.occupation, emps.salary
from employee_demographics as empd
join employee_salary as emps
on empd.employee_id= emps.employee_id
;

#2. LEFT OUTER JOIN
select empd.employee_id, empd.first_name, empd.last_name, emps.occupation, emps.salary, emps.dept_id
from employee_demographics empd
left outer join employee_salary emps
on empd.employee_id= emps.employee_id
; 

#3. RIGHT OUTER JOIN
select empd.employee_id, empd.first_name, empd.last_name, emps.occupation, emps.salary, emps.dept_id
from employee_demographics empd
right outer join employee_salary emps
	on empd.employee_id= emps.employee_id
; 

#4. SELF JOIN
#Finding Employees with Higher Salary than Their Colleagues
select emps1.first_name as Emp1,
emps1.salary as Sal1,
emps2.first_name as Emp2,
emps2.salary as Sal2
from employee_salary as emps1
join employee_salary as emps2
	on emps1.dept_id = emps2.dept_id
and emps1.salary > emps2.salary
; 


select *
from parks_and_recreation.parks_departments;

# 5 Multiple JOINS
select *
from employee_demographics empd
inner join employee_salary emps
	on empd.employee_id= emps.employee_id
inner join parks_departments as pkd
	on  emps.dept_id= pkd.department_id
;

#UNION
select first_name, last_name
from employee_demographics
union #it gives only distinct values
select first_name, last_name
from employee_salary
order by first_name, last_name
; 


select first_name, last_name
from employee_demographics
union all #it gives all the values
select first_name, last_name
from employee_salary
order by first_name, last_name
;

select first_name, last_name, 'Old Man' as Label
from employee_demographics
where age > 40 and gender = 'Male'
union
select first_name, last_name, 'Old Lady' as Label
from employee_demographics
where age > 40 and gender = 'Female'
union
select first_name, last_name, 'Highly Paid Employee' as Label
from employee_salary
where salary > 70000
order by first_name, last_name;

/*
#String Functions- 
i. LENGTH, 
ii. UPPER, LOWER,
iii.TRIM(LTRIM, RTRIM),
iv. LEFT(string, Num_of_String)
v. RIGHT(Yubaraj, 5) gives baraj

vi. SUBSTRING(string, startposition, num_of_char)
eg: SUBSTRING(Yubaraj, 3, 4) gives baraj

vii. REPLACE(string, to_be_replaced, replaced_with)
viii. LOCATE('r', 'Yubaraj')

ix. CONCAT(first_name, ' ', last_name) as Full_Name

*/


select length('YubarajKarki');
select length('Yubaraj Karki');
select upper('Yubaraj Karki') as UPPERCASE;

select first_name , last_name, upper(first_name) as FIRST_NAME,
UPPER(LAST_NAME) as LAST_NAME,
lower(FIRST_NAME) as first_name1
from employee_demographics;

select trim('    Yubaraj         ') as trimmed;
select ltrim('         Yubaraj                ') as trimmed;
select rtrim('         Yubaraj                ') as trimmed;
select left('Yubaraj', 4) as RightTRIM;
select right(' Yubaraj', 3) as LEFTTRIM;

select birth_date ,
left(birth_date, 4) as Birth_Year
from employee_demographics
;

select birth_date,
substring(birth_date, 6, 2)
from employee_demographics
;

select birth_date,
replace(birth_date, 9, 2)
from employee_demographics
;

select first_name,
replace(first_name, 'a', 'xyz') as replaced
from employee_demographics
;

select LOCATE('j', 'Yubaraj');
select first_name,
locate('c', first_name) as located
from employee_demographics
;

select first_name, last_name,
concat(first_name, ' ', last_name) as FULL_NAME
from employee_demographics
;

-- CASE STATEMENT
select first_name, 
last_name, 
age,
CASE
	when age < 30 then 'Young'
    when age between 30 and 44 then 'Adult'
    when age > 44 then 'Old'
END as Age_Label
from employee_demographics
;

select first_name, last_name, salary,
CASE
	when salary <= 50000 then salary + (salary * 0.05) #5% salary_hike
    when salary > 50000 then salary + 1.07 #7% salary_hike
END as New_Salary,
CASE
	when dept_id = 6 then salary + .10 #10% bonus for finance department
END as Bonus
from employee_salary
; 

-- SUBQUERIES
#Find the First Name and Last Name of employees who earn more than the average salary of all employees.
select first_name, last_name, salary
from employee_salary
where salary > 
(
	select avg(salary)
    from employee_salary
)
;

select first_name, last_name, salary,
(
select avg(salary)
    from employee_salary
) as Avg_Salary    
from employee_salary
;

select * 
from employee_demographics
where employee_id in 
(
	select employee_id
    from employee_salary
    where dept_id= 1
)
;

select gender, avg(age), max(age), min(age), sum(age), count(age)
from employee_demographics
group by gender
;

select avg(`max(age)`)#, avg(min_age) 
from
(
select gender, 
avg(age), 
max(age), 
min(age) as min_age, 
sum(age) as sum_age, 
count(age)
from employee_demographics
group by gender
) as Aggregated_table
#group by gender
;

#Window function
/*
-performs calculation in row level
-unlike aggregate function, it does not group rows into a single row.
-maintains the original no. of rows and add result to each row.

ROW_NUMBER(): Assigns a unique number to each row within a partition.
RANK(): Provides a ranking within a partition with gaps in the ranking.
DENSE_RANK(): Similar to RANK(), but without gaps.
SUM(), AVG(), MIN(), MAX(), etc., can be used as window functions.
LEAD(), LAG(): Accesses data from the subsequent or previous row in the result set.

SELECT column_name,
       window_function() OVER (
           PARTITION BY column_name
           ORDER BY column_name
       ) AS alias_name
FROM table_name;

*/

select gender, avg(salary) as Avg_Salary, count(gender)
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
group by gender;
;

select gender, avg(salary) over()
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
;

select dem.first_name, dem.last_name, gender, 
avg(salary) over(partition by gender) as AvgSalary_by_Gender
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
;

select dem.first_name, dem.last_name, gender,
sal.salary, 
sum(salary) over(partition by gender order by dem.employee_id) as Cummulative_Salary_Gender #Cummulative salary by gender ordered by employee_id
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id
;

select dem.employee_id, dem.first_name, dem.last_name, gender,
salary,
#row_number() over() as Count_Row
row_number() over(partition by gender order by salary desc) as row_num, #Count Row by Gender orderd by salary in decending order
rank() over(partition by gender order by salary desc) as row_num, #it skips position number
dense_rank() over(partition by gender order by salary desc) as row_num # it doesnt skip position
from employee_demographics dem
join employee_salary sal
	on dem.employee_id = sal.employee_id;

#LAG() is used to look back at previous records in the dataset, which is useful for comparisons and calculations involving past data.
SELECT employee_id, first_name, last_name, salary,
       LAG(salary, 1, 0) OVER (ORDER BY salary) AS previous_salary,
       salary - LAG(salary, 1, 0) OVER (ORDER BY salary) AS salary_difference
FROM Employee_salary;

#LAG(column_name, offset, default_value) OVER (PARTITION BY partition_column ORDER BY order_column)
#offset: The number of rows back from the current row. Default is 1.
#default_value: The value returned if the offset goes beyond the table. This is optional.

#LEAD() is used to look forward to subsequent records, enabling comparisons and calculations that involve future data.
SELECT employee_id, first_name, last_name, salary,
       LEAD(salary, 1, 0) OVER (ORDER BY salary) AS next_salary,
       LEAD(salary, 1, 0) OVER (ORDER BY salary) - salary AS salary_difference
FROM Employee_salary;
