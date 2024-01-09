
#1. Create a database named employee, then import data_science_team.csv proj_table.csv and 
#emp_record_table.csv into the employee database from the given resources.

CREATE DATABASE employee2; 
USE employee2;

#2. Create an ER diagram for the given employee database.
# <<<<<<< In doc >>>>>>>


#3. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT   
#from the employee record table.

SELECT EMP_ID, FIRST_NAME,LAST_NAME, GENDER, DEPT FROM emp_record_table;

#4. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
#less than two greater than four between two and four

#SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT FROM emp_record_table
#WHERE EMP_RATING <2 OR EMP_RATING > 4 OR EMP_RATING BETWEEN 2 AND 4; 

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT FROM emp_record_table
WHERE EMP_RATING <2;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT FROM emp_record_table
WHERE EMP_RATING > 4;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT FROM emp_record_table
WHERE EMP_RATING BETWEEN 2 AND 4;


#5. write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from 
#the employee table and then give the resultant column alias as NAME.

SELECT CONCAT(FIRST_NAME, " ", LAST_NAME) AS NAME , DEPT FROM emp_record_table WHERE DEPT = "FINANCE";

#6. Write a query to list only those employees who have someone reporting to them. 
#Also, show the number of reporters.
SELECT emp.FIRST_NAME, manager.MANAGER_ID, COUNT(*) AS num_of_reporters
FROM emp_record_table manager
JOIN emp_record_table emp ON manager.MANAGER_ID = emp.EMP_ID
GROUP BY emp.FIRST_NAME, MANAGER_ID;

SELECT employee.EMP_ID, CONCAT(employee.FIRST_NAME, " " , employee.LAST_NAME)
AS EMPLOYEE_NAME, MANAGER.MANAGER_ID, CONCAT(MANAGER.FIRST_NAME, " ", MANAGER.LAST_NAME)
AS MANAGER_NAME, MANAGER.ROLE AS ROLE
FROM emp_record_table employee JOIN emp_record_table manager
ON employee.MANAGER_ID = MANAGER.EMP_ID;

#7.	Write a query to list down all the employees from the healthcare and
#finance departments using union. Take data from the employee record table.
SELECT * FROM emp_record_table WHERE DEPT = "HEALTHCARE"
UNION 
SELECT * FROM emp_record_table WHERE DEPT = "FINANCE";


#select dep as dep count(*) as . sum(exp) as .... from employee groulo by dept having num>2 .... 


#8.	Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, 
#DEPARTMENT, and EMP_RATING Order by dept.Also include the respective employee rating 
#along with the max emp rating for the department.

WITH max_ratings_per_dept AS (
    SELECT DEPT, MAX(emp_rating) AS MAX_RATING FROM emp_record_table
    GROUP BY DEPT
)
SELECT EMP_ID, FIRST_NAME, LAST_NAME, DEPT, max_rating, EMP_RATING
FROM emp_record_table JOIN max_ratings_per_dept USING(DEPT)
ORDER BY DEPT;


#9.	Write a query to calculate the minimum and the maximum salary of the employees in each role.
#Take data from the employee record table.

SELECT ROLE, MIN(SALARY) AS MIN_SALARY, MAX(SALARY) AS MAX_SALARY FROM emp_record_table GROUP BY ROLE;


#10. Write a query to assign ranks to each employee based on their experience.
#Take data from the employee record table.

SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EXP, 
DENSE_RANK() OVER (ORDER BY EXP DESC) AS RANKING FROM emp_record_table;



#11. Write a query to create a view that displays employees in various countries 
#whose salary is more than six thousand. Take data from the employee record table.
## needs to get another select in order to display the table. 

CREATE VIEW emp_salary AS SELECT EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, SALARY
FROM emp_record_table WHERE SALARY >6000;

SELECT * FROM emp_salary;



#12. Write a nested query to find employees with experience of more than ten years.
#Take data from the employee record table.
SELECT * FROM emp_record_table
WHERE EXP = 
(SELECT EXP WHERE EXP > 10);


#13. Write a query to create a stored procedure to retrieve the details of the employees whose 
#experience is more than three years. Take data from the employee record table.

DELIMITER $$
CREATE PROCEDURE get_experienced_employee()
BEGIN
SELECT * FROM emp_record_table WHERE EXP > 3; 
END $$
DELIMITER ; 

CALL get_experienced_employee();

#14. Write a query using stored functions in the project table to check whether the job profile assigned 
#to each employee in the data science team matches the organization’s set standard.

DELIMITER $$
CREATE FUNCTION emp_job_profile(EXP int) RETURNS VARCHAR(45)
DETERMINISTIC 
BEGIN
DECLARE emp_job_profile VARCHAR(45);
IF EXP <= 2 THEN SET emp_job_profile = 'JUNIOR DATA SCIENTIST';
ELSEIF EXP BETWEEN 2 AND 5 THEN SET emp_job_profile = 'ASSOCIATE DATA SCIENTIST';
ELSEIF EXP BETWEEN 5 AND 10 THEN SET emp_job_profile = 'SENIOR DATA SCIENTIST';
ELSEIF EXP BETWEEN 10 AND 12 THEN SET emp_job_profile = 'LEAD DATA SCIENTIST';
ELSEIF EXP BETWEEN 12 AND 16 THEN SET emp_job_profile = 'MANAGER';

END IF;
RETURN (emp_job_profile); 
END $$
DELIMITER ;

SELECT
  EMP_ID, FIRST_NAME, LAST_NAME, EXP, ROLE, emp_job_profile(EXP), 
  IF(emp_job_profile(EXP) = ROLE, "MATCH", "NO MATCH") AS CHK, EXP FROM data_science_team;



#15. Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME
 #is ‘Eric’ in the employee table after checking the execution plan.
 CREATE INDEX index_fname2 ON emp_record_table(FIRST_NAME(100));
 SELECT* FROM emp_record_table USE INDEX(index_fname2) WHERE FIRST_NAME = "eric";
 #SHOW INDEXES FROM emp_record_table;
 
 
 
 
 
CREATE INDEX index_lname ON emp_record_table(LAST_NAME(100));
SELECT* FROM emp_record_table USE INDEX(index_lname) WHERE LAST_NAME = "eric";
SHOW INDEXES FROM emp_record_table;

 
 
 #16. Write a query to calculate the bonus for all the employees, based on their ratings and salaries 
 #(Use the formula: 5% of salary * employee rating).
 SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EXP, SALARY, EMP_RATING, (0.05 * SALARY)* EMP_RATING AS Bonus
 FROM emp_record_table;
 
 #17. Write a query to calculate the average salary distribution based on the continent and country. 
 #Take data from the employee record table.
 
 #We are using common table expression " CTE" emp_job_profileextract_table_from_file_name
 WITH avg_salary_per_cont AS (
    SELECT COUNTRY,CONTINENT, AVG(SALARY) as avg_salary FROM emp_record_table
    GROUP BY COUNTRY, CONTINENT
)
SELECT EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, CONTINENT, avg_salary
FROM emp_record_table JOIN avg_salary_per_cont USING(COUNTRY, CONTINENT)
ORDER BY COUNTRY, CONTINENT;


