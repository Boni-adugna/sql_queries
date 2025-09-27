# to select everything from table and filter our actual column
SELECT * 
FROM parks_and_recreation.employee_demographics;

# to select specific column from table
SELECT employee_id, first_name, gender
FROM parks_and_recreation.employee_demographics;

#PEMDAS  is the order of operations for arithmetic ot math within MySQL
SELECT first_name,
last_name,
age,
(age + 10) * 2 / 4 + age - 10  # PEMDAS rule
FROM parks_and_recreation.employee_demographics;

# DISTINCT is used to select a unique vakues within column
SELECT DISTINCT gender
FROM  parks_and_recreation.employee_demographics;

# WHERE CLAUSE is used to filter our rows of the data
SELECT *
FROM parks_and_recreation.employee_demographics
WHERE first_name = 'April';

# WHERE CLAUSE with comprasion operator
SELECT *
FROM parks_and_recreation.employee_demographics
WHERE age > 38;

SELECT *
FROM parks_and_recreation.employee_salary
WHERE salary <= 50000;

SELECT *
FROM parks_and_recreation.employee_demographics
WHERE gender != 'Male';

SELECT *
FROM parks_and_recreation.employee_demographics
WHERE birth_date > '1987-03-04';

#Logical operator in the WHERE CLAUSE
SELECT *
FROM parks_and_recreation.employee_demographics
WHERE birth_date > '1987-03-04' AND gender = 'Female';

SELECT *
FROM parks_and_recreation.employee_demographics
WHERE age > 35 OR gender = 'Female';

SELECT *
FROM parks_and_recreation.employee_demographics
WHERE birth_date > '1985-01-01' OR gender = 'Male';

SELECT *
FROM parks_and_recreation.employee_demographics
WHERE age < 44 OR NOT gender = 'Male';

SELECT *
FROM parks_and_recreation.employee_demographics
WHERE (first_name = 'Leslie' AND age = 44) OR age > 55;

# LIKE statement: we can look for specific pattern, we're not neccesarily looking for exact match

# LIKE : % (percent sign)  means anything

SELECT *
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE 'Jer%'; # this  means start from jer but then has anything after it

SELECT *
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE '%n%'; # this means anything comes before anything comes after,
                              #we're looking for 'n' somewhere in their name

SELECT *
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE 'a%';   # this means the name have to start from 'a' but then anything comes after.

# LIKE : _ (underscore)  means specific value
SELECT * 
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE 'a__'; # this means start with an 'a' and then it has two characters after it. no more no less

# combine these two special characters

SELECT *
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE '_p__%';

SELECT *
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE 'a___%'; # start with 'a' has three character (underscore(_)),
							  # and then it can have anything after that
                              
SELECT *
FROM parks_and_recreation.employee_demographics
WHERE birth_date LIKE '1989%' AND birth_date LIKE '____%03%';

# GROUP BY: it groups rows that have the same value in one or more columns,
			# so you can apply a function (like SUM, COUNT, AVG) to each group.
SELECT gender, AVG(age)
FROM parks_and_recreation.employee_demographics
GROUP BY gender
;

#Whenever you use GROUP BY, every column in your SELECT that's not inside a function like SUM(),
#must also be in the GROUP BY.
SELECT first_name
FROM parks_and_recreation.employee_demographics
GROUP BY first_name;

# GROUP BY with aggregate function
SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(*)
FROM parks_and_recreation.employee_demographics
GROUP BY gender;

#ORDER BY
SELECT *
FROM parks_and_recreation.employee_demographics
ORDER BY gender, age ASC
;

SELECT *
FROM parks_and_recreation.employee_demographics
ORDER BY gender, age DESC
;
# self expr
SELECT employee_id, first_name, gender, birth_date AS birth_day_greater_than_1985_07_26
FROM parks_and_recreation.employee_demographics
WHERE birth_date > '1985-07-26'
GROUP BY employee_id, first_name, gender, birth_date
;
#end

# WHERE CLAUSE: used to filter rows before any grouping (GROUP BY) is done.
# use WHERE : to filter individual rows from the table
			# before any aggregation(like SUM(), COUNT(), etc.) happens
SELECT *
FROM parks_and_recreation.employee_salary
WHERE salary >= 50000
;

# HAVING CLAUSE: used to filter group after aggregation(GROUP BY) is done
# Use HAVING: to filter aggreagated values(like SUM(). COUNT(), AVG())
			# After GROUP BY
SELECT gender, AVG(age)
FROM parks_and_recreation.employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
;

# combine both WHERE and HAVING clause
SELECT occupation, AVG(salary)
FROM parks_and_recreation.employee_salary
WHERE occupation LIKE '%Manager%'   --  filtered at row level
GROUP BY occupation
HAVING AVG(salary) > 77000  -- filtered at aggregate function level
;
-- this HAVING is only going to work for aggregate function , after the GROUP BY actually runs

# book exercise
SELECT gender, AVG(age), COUNT(gender), MAX(age), MIN(age)
FROM parks_and_recreation.employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
;

# LIMIT: is just going to specify how many rows you want in your output
SELECT *
FROM parks_and_recreation.employee_demographics
LIMIT 4
;
-- LIMIT with ORDER BY  
SELECT *
FROM parks_and_recreation.employee_demographics
ORDER BY age DESC
LIMIT 4
;

-- LIMIT with one another parameter.
SELECT *
FROM parks_and_recreation.employee_demographics
LIMIT 4, 3 -- This is going to do is we're going to start at position four and then we're going to go three row after it. 
;

-- Aliasing is just a way to change the name of the column
--  AS is a keyword to actually change the name of column

SELECT gender, AVG(age) AS avg_age
FROM parks_and_recreation.employee_demographics
GROUP BY gender
HAVING avg_age > 40
;

-- JOIN allow you to combine two tables or more together if they have common a column
-- that doesn't mean the column name has to be the exact same but @least the data within it are similar that you can use
-- there are several join that we're going to look now
-- INNER JOIN, OUTER JOIN, SELF JOIN

-- INNER JOIN : is going to return rows that are the same in both columns from both tables
-- by default JOIN represent an INNER JOIN 
SELECT *
FROM employee_demographics AS empl_dem
INNER JOIN employee_salary AS empl_sal
	ON empl_dem.employee_id = empl_sal.employee_id
;   -- this query only return rows where there is a matching record in both tables cuz we're used INNER JOIN

-- INNER JOIN with SELECT statement
SELECT empl_dem.employee_id, age, occupation
FROM employee_demographics AS empl_dem
INNER JOIN employee_salary AS empl_sal
	ON empl_dem.employee_id = empl_sal.employee_id
;

# OUTER JOIN : gives me all matching rows between two tables ,
			-- Plus the rows that don't match -and fill the missing side with NULL.
	# SO, it shows:
				-- Matching rows
                -- Unmatched rows too, but fills the missing parts with NULL
	-- The two ways of OUTER JOIN method
    
-- 1, LEFT OUTER JOIN: give me all rows from the LEFT table (employee_demographics), and only matching rows from the RIGHT table(employee_salary)
					-- if no match in the right table, fill with NULL. 
 SELECT *
 FROM employee_demographics AS dem   -- the FROM statement that's our left table
 LEFT JOIN employee_salary AS sal  -- the JOIN that's out right table
	ON dem.employee_id = sal.employee_id
;

-- 2, RIGHT OUTER JOIN: give me all rows from the RIGHT table(employee_salary), and only matching rows from the LEFT table(employee_demographics),
   -- if no match in the left table, fill with NULL

SELECT *
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

#SELF JOIN
# I DON'T UNDERSTAND WHAT IS IT
SELECT emp1.employee_id AS emp_santa,
emp1.first_name AS first_name_santa,
emp1.last_name AS last_name_santa,
emp2.employee_id AS emp_id,
emp2.first_name AS first_name,
emp2.last_name AS last_name
FROM employee_salary AS emp1
JOIN employee_salary AS emp2
	ON emp1.employee_id + 1 = emp2.employee_id
;


-- JOIN Multiple tables together
SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
INNER JOIN parks_departments AS pd
	ON sal.dept_id = pd.department_id
;

-- UNION : allows you to conbine rows together
SELECT first_name, last_name
FROM employee_demographics
UNION    # is will return only a unique value, it remove all dublicate data with in table
SELECT first_name, last_name
FROM employee_salary
;

SELECT first_name, last_name
FROM employee_demographics
UNION  ALL # is will return all data , even if, if there is double data with in table
SELECT first_name, last_name
FROM employee_salary
;

-- Let's look at use case
SELECT first_name, last_name, 'Old Lady' AS label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Old Man' AS label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Highly Paid Employee' AS label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name
;
-- real case END

# String Functions: are built-in function within MySQL that will help us use string and work with strings differently.

# count the length of character
SELECT first_name, LENGTH(first_name) AS length
FROM employee_demographics
ORDER BY length  # SORT the result using the 2nd column , means the one that shows the length of the name
;

# change all character to upper case
SELECT first_name, last_name, UPPER(first_name) AS capital_1st_name,  UPPER(last_name) AS capital_2nd_name
FROM employee_demographics;

# change all character to lower case
SELECT first_name, LOWER(first_name) AS lower_case
FROM employee_demographics;

#TRIM(): is a function used to remove extra spaces from the beginning or end of a text(string)
SELECT TRIM('     boni      ')  AS Remove_space; # for this query spaces are gone from both left and right sides.

# LEFT TRIM()					rvsl stands for remove space left
SELECT LTRIM('          boni')  AS Rvsl; # for this query spaces are gone from left side or beginning of text.

#RIGHT TRIM()					rvsr stands for remove space rigth
SELECT RTRIM('boni          ')  AS Rvsr; # for this query spaces are gone from right side or end of text.

# LEFT String function: this SHOWS the first 3 letters of the first_name
SELECT first_name, LEFT(first_name, 3)
FROM employee_demographics;

# RIGHT String function: this SHOWS the last 3 letters of the first_name
SELECT first_name, RIGHT(first_name, 3)
FROM employee_demographics;

#SUBSTRING (): is going to allow us to do a few different things
SELECT first_name, SUBSTRING(first_name, 2, 3)  -- 2 is the position where it start from, 3 is how many character we want to show 
FROM employee_demographics;

-- use case
SELECT first_name, last_name, birth_date,
SUBSTRING(birth_date, 6, 2) AS birth_month
FROM employee_demographics;

# REPLACE (): now replace will replace the specific characters with a different character that you want,
--  we need to specify two parameter with in bracket : 1, what we want to replace
													-- 2, what we want to replace it with
SELECT first_name, REPLACE(first_name, 'e' ,'i')  -- e is what we want to replace or want remove, 'i' is what we want to replace the instead of 'e'
FROM employee_demographics;

SELECT first_name, salary, REPLACE(salary, 70000, 71000) AS salary_replace
FROM employee_salary;

# LOCATE
SELECT LOCATE('n', 'boni'); -- it locate that sequence that we're looking for

SELECT first_name, LOCATE('nn', first_name)
FROM employee_demographics;

# CONCATENATION : used to combine multiple column to single column.
SELECT first_name, last_name,
CONCAT(first_name,'  ', last_name) AS Full_name
FROM employee_demographics;

SELECT first_name, age, birth_date,
CONCAT(birth_date,'    age: ', age) AS birth_age
FROM employee_demographics;

SELECT first_name, last_name, occupation,
CONCAT(first_name,':  ' , occupation) AS name_and_role 
FROM employee_salary;

-- CASE Statements: allows you to ADD LOGIC in your select statement

SELECT first_name, last_name, age,
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 39 THEN 'Old'
    WHEN age BETWEEN 40 AND 50 THEN 'Middle-aged'
    WHEN age > 51 THEN 'Older Adult'
END AS Age_Bracket
FROM employee_demographics;

SELECT first_name, last_name, occupation, salary,
CASE
	WHEN salary < 50000 THEN 'Lowest paid'
    WHEN salary BETWEEN 50000 AND 69000 THEN 'middle paid'
    WHEN salary >= 70000 THEN 'Highest paid'
END AS salary_rank
FROM employee_salary;

-- use case 
-- Pay Increase and bonus
	-- < 50000 = 5%
    -- > 70000 = 7%
-- Finance dept = 10%

SELECT *
FROM employee_salary;

SELECT employee_id, first_name, last_name, occupation, salary, dept_id,
CASE
	WHEN salary < 50000 THEN salary * 1.05
    WHEN salary BETWEEN 50000 AND 70000 THEN salary * 1.07
    WHEN salary > 70000 THEN salary * 1.09
END AS Update_salary,
CASE
	WHEN dept_id = 6 THEN salary * 0.1
END AS bonus_dept_6
FROM employee_salary;
-- end for use case

# Subquery: subquey is a query inside another query, also called nested query
-- where can you use a subquery
-- 1, IN SELECT clause: to calculate a value ans display it as column 
-- in the SELECT subquery , Only one value is expected

SELECT *,
( SELECT AVG(salary) 
FROM employee_salary
) AS Avg_salary --  this give the average salary of all employees, and show it that value in all rows
FROM employee_salary;

SELECT employee_id, first_name, occupation, salary, dept_id,
(SELECT  MAX(salary)
FROM employee_salary
WHERE dept_id = 1
) AS max_salary_in_dept_1  -- for every row in the table: shows employee_id, 1st_name, last_name, occupation, salary, dept_id of the employee and ...
FROM employee_salary;    -- And also shows the MAX salary in dept_id of 1 , this MAX salary in dept_id of 1 show also in all rows of employees

-- Why same value in all rows?
-- B/C the subquery: returns one fixed salary (max salary in dept 1),
				-- : it doesn't depend on the outer row (no correlation)
                
# Now let;s move on to a correlated subquery-- the one where the subqeury depends on each row of the outer query
# what is a correlated Subqeury..? A correlated subquery is a subquery that:
					-- refers to column from the outer, means the subquery is using data from the rows the outer query is looking at right now
                    -- so, it runs once for each row in the outer query , means the subquery is not run just once. instead, it run again and again,
                    -- one times for each row, because it uses the  value of that row
                    
# difference from a regular (non-correlated) subquery
#    type               subquery runs.....                   depends on outer row?                output changes per row?
-- Non-correlated	      only once								    No                                      No
-- Correlated             once for each row                         Yes                                     Yes

# Example of correlated subquery
-- let's say you want to show;
# Each employee's first_name, last_name, occupation, salary
# And also the MAXIMUM salary in their Own department

SELECT *,
	( SELECT MAX(salary) FROM employee_salary AS e2
    WHERE e2.dept_id = e1.dept_id
    ) AS Max_salary_in_dept
FROM employee_salary AS e1 ;
 






