# Trigger: is sth that happen Automatically When you make changes to table -like when you insert, update, or delete data
      -- "think of it like: if something happens in the table then do this"
      -- When a change happens, it Automatically run some code
      -- real_life example: imagine this:
								-- you walk into a supermarket.  
								-- The automatic door opens for you  
								  -- you didn't open the door by hand. the door opened automatically because you walked in
										    -- The door opening is like a Trigger 
                                            -- it respinds to your action (walking in)
	-- in MySQL: let's say we have a table called employee_demographics.
    -- if you add a new employee, a trigger can:
										-- Authomatically save their name to another table
                                        -- or send a message
                                        -- or record the time
		-- You don't have to run extra commands. The trigger does it automatically
			-- Trigger Structure in MySQL:
                       -- CREATE TRIGGER trigger_name
                       -- {BEFORE | AFTER} {INSERT | UPDATE | DELETE}
                       -- c
                       -- FOR EACH ROW
                       -- BEGIN
							 -- Your SQL code here
                       -- END;
        
        -- explantion for the structure:
			 -- CREATE TRIGGER trigger_name: You are creating a trigger and naming it what every you want but try to make it sense
			--  {BEFORE | AFTER}: Do you want it (trigger) to run before or after the action?
           --  {INSERT | UPDATE | DELETE}: which action should activate the trigger
		   -- ON table_name: which table does this trigger apply to
           -- FOR EACH ROW: it runs once per row
			-- BEGIN .... END: write the SQL action here
		
	# whenver a new employee is added to the employee_demographics table, Automatically add their name into another tbale called employee_log.
      -- Step 1: create a log table
     
            CREATE TABLE employee_log     -- This creates a new table called employee_log
						(
							log_id INT AUTO_INCREMENT PRIMARY KEY,   -- This is the log number. it increase automatically for each new row
                            employee_id INT,                        -- This store the employee's id
                            first_name VARCHAR(50),                 -- This store first_name of employee's
                            last_name VARCHAR(50),                  -- This store last_name of employee's
                            log_time DATETIME                      -- This will store the date and time the log was created
                        );
      -- step 2: create the trigger
                 DELIMITER $$
				 CREATE TRIGGER log_new_employee -- You are creating a trigger and naming it log_new_employee
                 AFTER INSERT                   --  This means: "Run this trigger after a new row is inserted in to employee_demographics"
                 ON employee_demographics        -- 
                 FOR EACH ROW                    -- This means: "Run the code for every new row that is added"
                 BEGIN                          -- BEGIN ... END. : everything inside this is the action the trigger wil perform. 
						INSERT INTO employee_log (employee_id, first_name, last_name, log_time)   -- This line adds a row in to the employee_log
                        VALUES (NEW.employee_id, NEW.first_name, NEW.last_name, NOW());    -- NEW.employee_id: The ID of the newly added employee. the same for the first_name and last_name
                 END $$																		-- NOW(): saves the current date and time
                 DELIMITER ;
		-- step 2 : add new employee in to employee_demographics
					INSERT INTO employee_demographics
					(employee_id, first_name, last_name, age, gender, birth_date)
                    VALUES (13, "Micah", "Mark", 32, "Male", "1990-01-09"),
                          (14, "Sophia ", "Davis", 27, "Female", "1998-04-9");
  
SELECT *
FROM employee_demographics;
    
SELECT *
FROM employee_log;

###########################################################################################
                                  
# An Event: is a task that MySQL does Automatically at a scheduled time, like every day, week or month
         -- think of it like: "At this time, do this."
         -- imagine: you set an alarm for 7:00 AM every day.
         -- When it's 7:00 AM, the alarm rings.
				-- you didn't press anything -- it happens by itself at that time.
				-- That alarm ringing is like an Event.
                -- it works by time, not by your action
                
	-- in MySQL:  let's say you want to:
                                -- Delete old employees every week.
                                -- send a report every day
                                -- Update some data every month
		-- You create an Event that runs at that time automatically 
                
                -- An EVENT Structure in MySQL:
							-- CREATE EVENT event_name
							-- ON SCEDULE
                            -- AT timestamp
                            -- OR
                            -- EVERY intervel
						-- DO
							-- Your SQL code here
		-- Explanation: 
              -- CREATE EVENT event_name: You are create event and named it
            -- ON SCHEDULE: Define the time to run the event.
            -- AT timestamp: One_time run.
            -- EVERY intervel: Repeating (e.g. every day)
            -- DO: What action to perfom
            -- BEGIN .... END
    
SELECT *
FROM employee_demographics;

DELIMITER $$
CREATE EVENT Old_employees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER ;

           
SELECT *
FROM employee_demographics;
           
DELIMITER $$

CREATE EVENT Old_employees_2
ON SCHEDULE EVERY 30 SECOND
DO
  DELETE FROM employee_demographics WHERE age >= 60;

$$

DELIMITER ;

SELECT *
FROM employee_demographics;
           