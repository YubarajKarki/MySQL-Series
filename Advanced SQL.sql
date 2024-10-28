/*
1. CTEs
2. Recursive CTEs
3. Temporary Table
4. Stored Procedure
5. Triggers
6. Events
*/

#CTEs- Common Table Expression
/* 
--> A Common Table Expression is a named temporary result set. 
You create a CTE using a WITH query, then reference it within a SELECT, INSERT, UPDATE, or DELETE statement.
--> A common table expression (CTE) is a named temporary result set that exists within the scope of a single statement 
and that can be referred to later within that statement, possibly multiple times. 
-->used to
i. To write queries without using subqueries (or using fewer subqueries)
ii. To write recursive functions
*/

select gender, avg(salary), min(salary), max(salary), count(salary)
from employee_demographics dem
join employee_salary emps
	on dem.employee_id= emps.employee_id
group by gender
;

-- With CTEs
With CTE_example as
(
select gender, avg(salary), min(salary), max(salary), count(salary)
from employee_demographics dem
join employee_salary emps
	on dem.employee_id= emps.employee_id
group by gender
)
select *
from CTE_example
;


With CTE_example as
(
select gender, avg(salary) avg_sal, min(salary) min_sal, max(salary) max_sal, count(salary) sal_count
from employee_demographics dem
join employee_salary emps
	on dem.employee_id= emps.employee_id
group by gender
)
select avg(avg_sal)
from CTE_example
;

With CTE_example(GENDER,AVG_SAL, MIN_SAL, MAX_SAL, COUNT_SAL) as
(
select gender, avg(salary) avg_sal, min(salary) min_sal, max(salary) max_sal, count(salary) sal_count
from employee_demographics dem
join employee_salary emps
	on dem.employee_id= emps.employee_id
group by gender
)
select *
from CTE_example
;

select avg(avg_sal)
from
(
select gender, avg(salary) avg_sal, min(salary) min_sal, max(salary) max_sal, count(salary) sal_count
from employee_demographics dem
join employee_salary emps
	on dem.employee_id= emps.employee_id
group by gender
) subquery_example
;

WITH CTE_eg1 as
(
	select first_name, employee_id, gender, birth_date
    from employee_demographics
    where birth_date > '1980-04-25'
),
CTE_eg2 as
(
	select employee_id, salary
    from employee_salary
    where salary > 50000
)
select * 
from CTE_eg1
join CTE_eg2
on CTE_eg1.employee_id = CTE_eg2.employee_id 
;



--  Recursive CTE for Hierarchical Data
WITH RECURSIVE NumberSeries AS (
    SELECT 1 AS number
    UNION ALL
    SELECT number + 1
    FROM NumberSeries
    WHERE number < 10
)
SELECT * FROM NumberSeries;


--  find employees whose salaries are higher than the average salary
With CTEAvgSalary as
(
	select avg(salary) avg_salary
    from employee_salary
)
select first_name, last_name, salary
from employee_salary
where salary > (select avg_salary from CTEAvgSalary)
;

/*
Calculate the average salary of employees across departments and
then use that result to find employees who earn more than the average.
*/
with CTE_AvgSal as 
(
	select dept_id, avg(salary) as avg_sal
    from employee_salary
    group by dept_id
)
select emps.first_name, emps.last_name, emps.salary, avgs.avg_sal
from employee_salary emps
join CTE_AvgSal avgs 
on emps.dept_id= avgs.dept_id
where emps.salary > avgs.avg_sal
;

-- Temporary Tables
/*
A Temporary Table is a table that is created in the database temporarily and 
is automatically dropped when the session that created the table ends or explicitly when you drop it. 
Temporary tables are useful when you need to store intermediate results or 
perform complex calculations that require multiple steps.
*/
create temporary table  temp_table
(
	first_name varchar(100),
    last_name varchar(100),
    gender varchar(20) NOT NULL,
    age int NOT NULL
);

insert into temp_table (first_name, last_name, gender, age)
values ('Yubaraj', 'Karki', 'M', 24),
		('Suraj', 'Bhk', 'M', 24),
        ('Melina', 'Rai', 'F', 20);

select * 
from temp_table;

CREATE TEMPORARY TABLE SALARY_OVER_50K
SELECT *
FROM employee_salary
WHERE salary > 50000;

SELECT *
FROM SALARY_OVER_50K; 

-- Stored Procedure
create procedure salary_over_50K()
select *
from employee_salary
where salary > 50000
;
call salary_over_50K();

delimiter $$
create procedure emp_table()
begin
	select *
	from employee_demographics;
	select *
	from employee_salary;
	select *
	from parks_departments;
end $$
delimiter ;

call emp_table();

delimiter $$
create procedure empsal_by_ID(emp_id int)
begin
	select salary
	from employee_salary
    where employee_id = emp_id;
end $$
delimiter ;

call empsal_by_ID(1);

-- Triggers and Events

delimiter $$
create trigger Emp_Insert
	after insert on employee_salary
    for each row
begin
	insert into employee_demographics (employee_id, first_name, last_name)
    values (new.employee_id, new.first_name, new.last_name);
end $$
delimiter ;

insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
values(13, 'Yubaraj', 'Karki', 'Data Analyst', 100000, null);

insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
values (14, 'XYZ', 'RAI', 'Business Analyst', 60000, null);

select *
from employee_salary;

-- Events
delimiter $$
create event delete_retired_emp
on schedule every 30 second	
do
begin
	delete 
    from employee_demographics
    where age > 60;
end $$
delimiter ;

update employee_demographics
set age = 24
where employee_id =13;

update employee_demographics
set age = 66
where employee_id =14;

delimiter $$
CREATE EVENT clean_old_employee
ON SCHEDULE EVERY 1 DAY
STARTS '2024-09-15 00:00:00'
DO
BEGIN
    DELETE FROM employee_demographics 
    WHERE age > 60 ;
END $$
delimiter ;


select *
from employee_demographics;


show variables like 'event%'; -- to check event scheduler is on or off