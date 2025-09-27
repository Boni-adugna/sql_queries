SELECT *, # Calculate the average of salary without consider their dept_id
	(SELECT AVG(salary) FROM employee_salary
    ) AS Avg_salary
FROM employee_salary;
SELECT *,   # Calculate the average of salary without consider their dept_id and ranked their salary
	(SELECT AVG(salary) FROM employee_salary ) AS Avg_salary,
    CASE
		WHEN salary < (SELECT AVG(salary) FROM employee_salary) THEN "Below Average"
        WHEN salary > (SELECT AVG(salary) FROM employee_salary) THEN "Above Average"
        -- WHEN salary = (SELECT AVG(salary) FROM employee_salary) THEN "Equal"
    END AS salary_level
FROM employee_salary;
######################################################################################### take it time
# Calculate the average of salary with consider their dept_id and ranked their salary
SELECT *,
(SELECT AVG(salary) FROM employee_salary AS sal_1
 WHERE sal_1.dept_id = sal_2.dept_id 
) AS avg_salary,

CASE
	WHEN salary > (SELECT AVG(salary) FROM employee_salary AS sal_1
    WHERE sal_1.dept_id = sal_2.dept_id ) THEN "Above Average"
    
    WHEN salary < (SELECT AVG(salary) FROM employee_salary AS sal_1
    WHERE sal_1.dept_id = sal_2.dept_id ) THEN "Below Average"
    
    WHEN salary = (SELECT AVG(salary) FROM employee_salary AS sal_1
    WHERE sal_1.dept_id = sal_2.dept_id ) THEN "Equal to Average"
    
    WHEN (SELECT AVG(salary) FROM employee_salary AS sal_1
    WHERE sal_1.dept_id = sal_2.dept_id ) IS NULL THEN "No dept_id"
END AS ranked_salary
FROM employee_salary AS sal_2;
########################################################################################

SELECT *,    # Calculate the average of salary with consider their dept_id
	(SELECT AVG(salary) FROM employee_salary AS e2
	WHERE e2.dept_id = e1.dept_id
    ) AS Avg_salary_in_dept
FROM employee_salary AS e1;

SELECT *,    # Calculate the average of salary with consider their dept_id and ranked their salary
	(SELECT AVG(salary) FROM employee_salary AS e2
	WHERE e2.dept_id = e1.dept_id
    ) AS Avg_salary_in_dept,
    CASE
		WHEN salary < (SELECT AVG(salary) FROM employee_salary) THEN "Below Average"
        WHEN salary > (SELECT AVG(salary) FROM employee_salary) THEN "Above Average"
        -- WHEN salary = (SELECT AVG(salary) FROM employee_salary) THEN "Equal"
    END AS salary_level
FROM employee_salary AS e1;

SELECT *,   # this query count how emplyee's are in the same department
	( SELECT COUNT(dept_id) FROM employee_salary AS e2
    WHERE e2.dept_id = e1.dept_id
    ) AS Num_people_in_dept
FROM employee_salary AS e1;

SELECT *, # this query find the highest one paid employee's from the table and show it in all employee's row
	( SELECT MAX(salary) FROM employee_salary 
    ) AS highest_paid_person
FROM employee_salary;

SELECT employee_id, first_name, salary, dept_id,  # this query find the highest paid employee's based on their dept_id
	( SELECT MAX(salary) FROM employee_salary AS e2
    WHERE e2.dept_id = e1.dept_id
    ) AS highest_paid_person_dept
FROM employee_salary AS e1;

SELECT * # this query find the three highest paid employee's from table
FROM employee_salary
ORDER BY salary DESC
LIMIT 3
;

SELECT *     # this query find the lowest one paid employee's from table
FROM employee_salary
ORDER BY salary ASC
LIMIT 1;

SELECT *    # this query find the highest one paid employee's from table USING WHERE subquery
FROM employee_salary
WHERE salary = ( SELECT MAX(salary) FROM employee_salary);

SELECT *,  -- for each employee in the employee_salary table : 1, show their own detail
	( SELECT MAX(salary) FROM employee_salary AS e2			-- 2, show their highest salary in their departement id
	WHERE e2.dept_id = e1.dept_id							-- 3, show what percentage of the company's highest salary they earn
    ) AS Top_salary_in_dept,
    ROUND((salary / ( SELECT MAX(salary) FROM employee_salary)) * 100, 2) AS Percent_of_top_salary
FROM employee_salary e1;

SELECT *,       -- for each employee in the employee_salary table :
	( SELECT MAX(salary) FROM employee_salary AS e2             --  1, show their own detail
	WHERE e2.dept_id = e1.dept_id                                    -- 2, show their highest salary in their departement id
    ) AS Top_salary_in_dept,
    ROUND((salary / ( SELECT MAX(salary) FROM employee_salary AS e2   -- 3, show what percentage of the dept_id highest salary they earn
    WHERE e2.dept_id = e1.dept_id)) * 100, 2) AS Percent_of_top_salary      
FROM employee_salary e1;


# Subquery in the WHERE clause
SELECT employee_id, first_name, last_name   -- find the names of employees and their employee_id  who work in dept_id 1;
FROM employee_demographics
WHERE employee_id IN 
				(SELECT employee_id FROM employee_salary
                WHERE dept_id = 1);
                
# Subquery in the FROM clause
SELECT dept_id, AVG(salary) AS avg_salary  -- outer query this group the filtered employees by department_id and calculates the average salary for each one
FROM (SELECT employee_id, dept_id, salary FROM employee_salary -- Middle subquery, This filters the employeee_salary table to get only the employee
		WHERE dept_id IN 										-- who work in those department(public and park) and it become temporary table called ny_employees
					( SELECT department_id FROM parks_departments  -- This finds all the department_id from parks departments table, 
                    WHERE department_name = 'parks and recreation' OR department_name = 'Public Works' -- where the departments name is either parks and recreation or public works
                    )
		) AS ny_employees
GROUP BY dept_id;

SELECT dept_id, AVG(salary) AS avg_salary
FROM ( SELECT employee_id, dept_id, salary FROM employee_salary
WHERE dept_id = 1
) AS sub
GROUP BY dept_id
;

SELECT department_id, COUNT(department_id) AS Num_department
FROM ( SELECT department_id FROM parks_departments
		WHERE department_name = 'Parks and Recreation'
     ) AS sub
GROUP BY department_id
;

SELECT AVG(avg_age) AS avg_age, AVG(max_age) AS avg_max_age, AVG(min_age) AS avg_min_age, AVG(count_gender) AS avg_count_gender
FROM 
	(SELECT gender, AVG(age) AS avg_age, MAX(age) AS max_age, MIN(age) AS min_age, COUNT(gender) AS count_gender
	FROM employee_demographics
	GROUP BY gender
    ) AS agg_table

;


 -- 1, Sub query IN WHERE clause 
 -- Use Case Example in Subquery With WHERE clause & FROM clause
#Subquery With WHERE clause
-- Find the employees_id, name and age of all employees whoose salary is greater than the average salary

#The query
SELECT employee_id, first_name, last_name, age
FROM employee_demographics
WHERE first_name IN 
					(SELECT first_name FROM employee_salary
                    WHERE salary > (SELECT AVG(salary) FROM employee_salary)
                    );
-- Inner subquery: SELECT AVG(salary) FROM employee_salary -> calculate the average salary
-- Middle subquery: SELECT employee_id FROM employee_salary WHERE salary > (avg_salary) -> gets first_name of employees earning more than the average
-- Outer query: SELECT employee_id, first_name, last_name, age FROM employee_demographics -> filters employee_demographics to only include those employees

#Subquery in FROM clause
-- Find all dept_id where the average salary of employees is greater than 60,000.
#The query
SELECT dept_id, Avg_Salary
FROM (SELECT dept_id, AVG(salary) AS Avg_Salary
FROM employee_salary
GROUP BY dept_id) AS sub
WHERE Avg_Salary > 60000
;

-- Inner Subquery: (SELECT dept_id, AVG(salary) AS Avg_Salary FROM employee_salary GROUP BY dept_id) -> This part takes employees_salary table
-- and GROUP the data by dept_id, then for each dept_id, it calculates the average salary of all employees in that department
-- Alias the subquery (AS Sub) -> we givename sub to the temporary result from step 1, Now we can use it like a normal table
-- Outer query (SELECT dept_id, Avg_Salary FROM Sub WHERE Avg_Salary > 60,000) -> This filters the row from Sub to only show dept_id where average salary is greater than 60,000


#Subquery in WHERE clause:
-- Find employees who earn more than Leslie Knope
SELECT first_name, salary
FROM employee_salary
WHERE salary > ( SELECT salary FROM employee_salary
				WHERE first_name = 'Leslie');
-- Find people who earn less than the average salary in their department __and show their name and age
SELECT employee_id, first_name, age
FROM employee_demographics
WHERE first_name IN 
					( SELECT first_name FROM employee_salary s1
						WHERE salary < (SELECT AVG(salary) FROM employee_salary s2
										WHERE s2.dept_id = s1.dept_id )
                    );
-- Inner Subquery  (SELECT AVG(salary) FROM employee_salary s2 WHERE s2.dept_id = s1.dept_id ) This part:
					-- Calculate the avearage salary in the same department of each employees
-- Middle Subquery  (SELECT first_name FROM employee_salary s1 WHERE salary < (avg_salary in their department))  This part:
					-- For each employee, it Check: "Is their salary less than the average salary in their department?"
                    -- if yes, then keeps their first_name
-- Outer Query (SELECT employee_id, first_name, age FROM employee_demographics WHERE first_name IN): it looks inside the employee_demographics table and finds: 
							-- The age of the employees Whose names came from step 2

-- Get all male employees who earn more than the highest-paid female employees
SELECT *
FROM employee_demographics
WHERE gender = "Male"
AND first_name IN 
	( SELECT first_name FROM employee_salary
    WHERE salary > ( SELECT MAX(salary) FROM employee_salary
    WHERE first_name IN  (SELECT first_name FROM employee_demographics
						WHERE gender = "Female")
					)
    );
 
# SELECT *
#FROM employee_demographics 
-- This is selecting the first_name of employees from the table called employee_demographics

# WHERE gender = "Male" : This is filtering the list so it only includes male employees

-- so up to here: We are selecting male employees only

# AND first_name IN 
#(SELECT first_name 
# FROM employee_salary
-- We are checking which of these males also exist in the employee_salary table and meet some salary condition.
-- we are saying :
		-- "Only include this male if his name is found among those who have a salary greater than the highest-paid Female"

#WHERE salary > ( SELECT MAX(salary) FROM employee_salary
   # WHERE first_name IN  (SELECT first_name FROM employee_demographics
		#				WHERE gender = "Female")
		#			)
    #);  Let's break that:
    
-- Inner-most subquery

#SELECT first_name 
#FROM employee_demographics
# WHERE gender = "Female"
-- Gets the names of all female employees

-- Middle subquery
#SELECT MAX(salary) FROM employee_salary
# WHERE first_name IN  (.....female names)
-- Finds the highest salary among those females
-- for example: if Leslie = 70,000 and Ann = 60,000 -> MAX = 70,000

-- Outer part:
#SELECT first_name FROM employee_salary
# WHERE salary > (70,000)

-- Gets the names of people (any gender) Who earn more than 70, 00

-- Final part:
# SELECT first_name
# FROM employee_demographics
# WHERE gender = "Male"
# AND first_name IN (those earning more than highest-paid female)
-- Now we only keep males from that result.

-- Summary in plain english
	-- step-by-step summary
-- 1. find all female employees
-- 2. from those, find the highest salary
-- 3. Get all employees who earn more than that salary
-- 4. from them, select only the males

# Window Function: is a special type of function in SQL that lets you:
								-- Do calculation for each row while still looking at other rows (a group or '"Window" of rows).
                                -- it doesn't remove any row from your result --it add extra info (like ranks, total, avearge, etc) to each row
# How is it different from GROUP BY ?
				-- GROUP BY:
							-- Groups rows together (by department, name, salart, etc)
                            -- Group data and return 1 row per group
                            -- Shows only on row per group 
				-- Window Function:
							-- Looks at each row one by one
                            -- calculates the average/sum/ramk/etc.for the group
                            -- keeps all rows means does not hide any row
                            -- Adds extra info (ranking total, average)

SELECT dept_id, AVG(salary) AS avg_salary
FROM employee_salary
GROUP BY dept_id
; # names are  gone

SELECT employee_id, first_name, salary, dept_id,   --  PARTITION BY   dept_id  says:
		AVG(salary) OVER(PARTITION BY dept_id)  AS avg_in_dept   -- Calculate the average for each dept_id, but show it for every person
FROM employee_salary;                                        # You see each employee, and also the average salary of their department

SELECT employee_id, first_name, salary, dept_id,
		ROW_NUMBER ()  OVER (PARTITION BY dept_id     # Group rows by dept_id
							ORDER BY salary DESC    # Orders salaries from highest to lowest
						    ) AS rank_in_dept  # Gives each row a Unique row number starting from 1 in each department 
FROM employee_salary;							-- If we want same rank for those employees in the same dept_id and the same salary:
                                                          -- we can use RANK () instead of ROW_NUMBER () but the next rank skips (no rank 6 in dept_id = 1)
-- How to use a Window Function ?                              -- We can use DENSE_RANK () for same rank, but no skipping OR no gaps in numbering
# Every Window Function follows this format
# SQL query
--  FUNCTION_NAME () OVER ( PARTITION BY something -- optional
				          -- ORDER BY something -- optional
					   -- )
#      Part                          Meaning
-- FUNCTION ()             What you want to calculate (e.g. AVG, SUM, ROW_NUMBER)
-- OVER ()                 Tells SQL: "this is a window function"
-- PARTITION BY            Divide rows into gruops (like by dept_id)  
-- 					       when you use use a window function with PARTITION BY, SQL:
--                         Looks at each row one by one
--                         Calculates the avearge/Sum/rank, etc.for the group
--                         Does not hide any row
-- ORDER BY                Decide the row order (like by salary or score)

SELECT employee_id, first_name, salary, dept_id,
	  LAG(salary)  OVER (ORDER BY salary) AS previous_salary   #  LAG(salary) looks at the previous row's salary
FROM employee_salary;   # the result: shows the previous employees's salary for each row
						-- the first row has null because there's no previous salary before andy

SELECT employee_id, first_name, salary, dept_id,-- Now you're telling SQL to divide the data by dept_id (PARTITION BY dept_id ) 
	  LAG(salary)  OVER (PARTITION BY dept_id   --  before apply the order by salary then sort the salary from lowest to high
						ORDER BY salary) AS lg  -- then it find the previous salary only within that dept_id
FROM employee_salary;

SELECT employee_id, first_name, salary, dept_id,    #LEAD(salary) is a window function that returns the next row's salary (not previous like LAG)
	  LEAD(salary)  OVER (ORDER BY salary) AS next_salary   # OVER (ORDER BY salary) Means the rows are order by salary, and LEAD is applied in that order
FROM employee_salary;  -- the result is a column showing the salary of the next employee in the sorted list

-- LEAD(column) -> gets the next row's value
-- LAG(column) -> gets the previous row's value

SELECT employee_id, first_name, salary, dept_id, 
		LEAD(salary) OVER (PARTITION BY dept_id
							ORDER BY salary
                         ) AS next_salary_dept
FROM employee_salary;  # the same as previous query which is  LAG Function WITH PARTITION so take that query as reference

#  join tables without window function 
SELECT gender, AVG(salary)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
;  # using GROUP BY code 1.0

#  join tables with window function 
SELECT dem.first_name, gender, AVG(salary) OVER(PARTITION BY gender) AS avg_salary_gender
FROM employee_demographics AS dem
JOIN employee_salary  AS sal
	ON dem.employee_id = sal.employee_id
;  # using window function code 1.1

SELECT gender, SUM(salary)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
;  # using GROUP BY code 2.0

SELECT dem.first_name, gender, 
SUM(salary) OVER(PARTITION BY gender) AS sum_salary_gender
FROM employee_demographics AS dem
JOIN employee_salary  AS sal
	ON dem.employee_id = sal.employee_id
;    # using Window Function code 2.1

SELECT dem.first_name, gender, salary, SUM(salary) OVER (PARTITION BY gender 
								ORDER BY dem.first_name) AS rolling_total
FROM employee_demographics AS dem  -- this query joins two tables and then:  display each employees_id, employees name, and their salary
JOIN employee_salary AS sal   -- A rolling (running) total of salary, but only within each gneder group
	ON dem.employee_id = sal.employee_id  -- rolling (running) total: it keeps adding salary row by row
; # using Window Function code 2.2			# PARTITION BY gender -> This splits the data into two groups
									-- one for male employees and one for female employees
                                    -- within each gender group, it calculates the running total of salaries, orde by their first_name

SELECT dem.employee_id, dem.first_name, salary, SUM(salary) OVER (ORDER BY dem.employee_id) AS rolling_total
FROM employee_demographics AS dem  -- this query joins two tables and then:  display each employees_id, employees name, and their salary
JOIN employee_salary AS sal  -- calculates a rolling (running) total of salary, order by employees_id
	ON dem.employee_id = sal.employee_id -- 
; # total using window function  2.3

# row_number, rank and dense_rank in window function:
SELECT dem.employee_id, dem.first_name, gender, salary,
RANK () OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
ROW_NUMBER () OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
DENSE_RANK () OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_num

FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id;
######################################################################################################

# HOW TO CREATE REGULAR TABLE
DROP TABLE IF EXISTS employee_info;
CREATE TABLE employee_info 
( log_in INT AUTO_INCREMENT PRIMARY KEY,
  first_name varchar(50),
  last_name VARCHAR(50),
  age INT
);

INSERT INTO employee_info (first_name, last_name, age) 
VALUES ("BONTU", "ADUGNA", 21),
	   ("HAWI", "ADUGNA", 24),
       ("NATI", "ADUGNA", 14)
;

SELECT *
FROM employee_info;

                   -- CTE Advanced level
      --         ADVANCED LEVEL
# CTEs: stands for Common Table Expression
		-- it is like a temporary table that you create inside your SQL query
        -- is a temporary table you create in a query to make your code easier to read
		-- when we create a CTE You have to use it immeditely after we create the cte
        
-- You use it to:
			-- Make your query easier to read
            -- Avoid repeation the same code
            -- Organize complex logic step by step

			-- Basic structure of a CTE:
	-- WITH cte_name AS (
	--                   SELECT ...........
    -- 					 FROM   ...........
    -- 					 WHERE ...........  )
    -- SELECT *
    -- FROM cte_name;

--            Parts                              Meaning
--            WITH                           key word to define CTE
--            cte_name                   Name of your CTE (temporary result)
--           AS (SELECT ....)            Query that build the result
--        SELECT * FROM cte_name        use CTE like a table and select every row from that cte 
  
-- let see common and easy example
# Let's say you want to get all employees who earns more than 550,000

-- Without CTE: 
SELECT employee_id, first_name, salary, dept_id
FROM employee_salary
WHERE salary > 55000
;   -- code 1.0

-- With CTE: 
WITH high_salary AS (
						SELECT employee_id, first_name, salary, dept_id
                        FROM employee_salary
                        WHERE salary > 55000
					)
SELECT *
FROM high_salary;   -- code 1.1

#withou cte
SELECT COUNT(*) AS total_count
FROM employee_salary
WHERE salary >= 50000
;  -- code 2.0

#with cte
WITH high_salary  AS (
						SELECT *
                        FROM employee_salary
                        WHERE salary >= 50000
					)
SELECT COUNT(*) AS Total_count
FROM high_salary;  -- code 2.1

SELECT first_name, age, gender, birth_date
FROM employee_demographics
WHERE birth_date > "1979-09-25"
;   -- code 3.0

WITH older_employees AS (
							SELECT first_name, age, gender, birth_date
                            FROM employee_demographics
                            WHERE birth_date > "1979-09-25"
						)
SELECT *
FROM older_employees
;  -- code 3.1

WITH high_salary AS (
					SELECT employee_id, first_name, salary, dept_id
                    FROM employee_salary
                    WHERE salary > 55000
					)
SELECT hg.employee_id, hg.first_name, dem.last_name, gender, age, salary, dept_id
FROM high_salary AS hg
JOIN employee_demographics dem
	ON hg.employee_id = dem.employee_id
;  -- JOIN CTE with employee_demographics table
 
  WITH women_high_earner AS (
							SELECT *
                            FROM employee_salary
                            WHERE salary > 50000
							)
SELECT wh.employee_id, dem.first_name, dem.last_name, gender, age, salary
FROM women_high_earner AS wh
JOIN employee_demographics AS dem
	ON wh.employee_id = dem.employee_id
WHERE gender = "Female" 
;  -- find Female employees with salary > 50000 by using CTE 

# join two CTE together:

WITH women AS (
						SELECT *
                        FROM employee_demographics
                        WHERE gender = "Female"
                   ),
high_salary AS (
					SELECT *
                    FROM employee_salary
                    WHERE salary >= 55000
				)
 
SELECT hg.employee_id, wm.first_name, wm.last_name, gender, occupation, salary, dept_id
FROM women AS wm
JOIN high_salary AS hg
	ON wm.employee_id = hg.employee_id
;

# CTE (COMMON TABLE EXPRESSION)

SELECT gender, AVG(salary) AS avg_salary, MAX(age) AS max_age, MIN(age) AS min_age, COUNT(*) AS count_total
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender; -- Code 1.0

WITH cte_example AS (
SELECT gender, AVG(salary) AS avg_salary, MAX(salary) AS max_sal, MIN(salary) AS min_salary, MAX(age) AS max_age, MIN(age) AS min_age, COUNT(*) AS count_total
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_salary) AS avg_salary, AVG(max_sal) AS max_avg_salary, AVG(min_salary) AS min_avg_salary
FROM cte_example
;  -- Code 1.1

WITH cte_example AS (
SELECT gender, AVG(salary) AS avg_salary, MAX(salary) AS max_sal, MIN(salary) AS min_salary, MAX(age) AS max_age, MIN(age) AS min_age, COUNT(*) AS count_total
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM cte_example
; -- Code 1.2

WITH cte_names AS
(
	SELECT employee_id, first_name, last_name, occupation, salary, dept_id
	FROM employee_salary
	WHERE salary > 50000
),
cte_names_2 AS
(
	SELECT employee_id, first_name, last_name, gender, age
	FROM employee_demographics
	WHERE gender = "Female"
)

SELECT cte_1.employee_id, cte_1.first_name, cte_1.last_name, gender, age, occupation, salary, dept_id
FROM cte_names AS cte_1
JOIN cte_names_2 AS cte_2
	ON cte_1.employee_id = cte_2.employee_id
-- WHERE dept_id = 1
;


					-- TEMP TABLE
# TEMP TABLE: Is like a regular table, but it only exists for the duration of your session.
			-- is a short-term table in MySQL that:
									-- is created to store data for a short time
                                    -- only you (your session) can use it
                                    -- delete itself automatically when you close the database or your workspace is done
					-- BASIC structure of temp table
			-- 1st way: 	CREATE TEMPORARY TABLE table_name (
														-- column1 datatype
                                                        -- column1 datatype
												-- )
			
		    -- 2nd way: CREATE TEMPORARY TABLE name_tabel: select data from the exist table
							-- SELECT *
                            -- FROM employee_salary
                            -- WHERE salary > 50000;
                            
                            -- SELECT *
                            -- FROM name_table;
-- let's say we want to store employee names and salary temporarily:

DROP TEMPORARY TABLE IF EXISTS employ_info;  -- delete the temporary table called employ_info-- only if it exists, this delete the old one, so you can create a new one
CREATE TEMPORARY TABLE employ_info
SELECT gender, MAX(age) AS max_age, MIN(age) AS min_age,
AVG(salary) AS avg_sal, MAX(salary) AS max_sal,
MIN(salary)AS min_sal, COUNT(*) AS total_employees
FROM employee_demographics AS dem
JOIN  employee_salary AS sal 
	ON dem.employee_id = sal.employee_id
GROUP BY gender
;

SELECT *
FROM employ_info;

#####################################################################################################
						-- Stored procedure
		-- A saved block of SQL code (like SELECT, INSERT, UPGATE, etc.) that you write once, give it a name , and call it anytime when you need it.
        -- a stored procedure is like a ready-made function in the database
		          -- why use a Stored Procedure?
						   -- Reuse your SQL code
						   -- Run many SQL statement with one command
						   -- Save time and make your code clean
				
                 -- BASIC Structure of a Stored procedure
                        -- here is the most basic form:
									-- DELIMITER $$
                                    -- CREATE PROCEDURE procedure_name()
                                    -- BEGIN
                                    -- 		Your SQL code here
									-- END $$  : this implies this is the end!
									-- DELIMITER ;
					-- CALL procedure_name();   # Write these query if you want to call and use the created procedure
		-- what each part means:
					        -- Parts                                        Meaning
                    -- DELIMITER $$                  Temporarily changes the end line symbol from ; to $$
                    -- CREATE PROCEDURE              The keyword to create Procedure means: tells MySQL you are creating a procedure
                    -- procedure_name()              The name of the procedure (you choose it)
                    -- BEGIN ..... END               The block of SQL code that will be run
					-- END $$                      
                    --  DELIMITER ;                  Returns to normal SQL command ending with ;
    --  see example
    DROP PROCEDURE IF EXISTS employe_info;
    DELIMITER $$
    CREATE  PROCEDURE employe_info ()
    BEGIN
		SELECT *
		FROM employee_salary
		WHERE salary > 55000;
		SELECT *
		FROM employee_salary
		WHERE dept_id = 1;
    END $$
	DELIMITER ;
    
CALL employe_info ();
                    
-- Parameter: are variables that are passed as an input in to a store procedure and allow the store procedure to accept an input value 
			-- and place it into your code.
        
DROP PROCEDURE IF EXISTS employe_info_1;
    DELIMITER $$
    CREATE  PROCEDURE employe_info_1(p_employee_id INT)
    BEGIN
		SELECT employee_id, first_name, occupation, salary, dept_id
		FROM employee_salary
		WHERE employee_id = p_employee_id;
    END $$
	DELIMITER ;
    
CALL employe_info_1(1);
        
        
        









