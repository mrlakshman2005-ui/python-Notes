# Create a database named company_db and Use company_db
CREATE DATABASE company_db;
USE COMPANY_DB;

# Create the employees table inside company_db
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    hire_date DATE,
    job_title VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    manager_id INT
);

#Create the departments table with dept_id as primary key and dept_name unique.
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) UNIQUE
);

#Add a column date_of_birth to employees
ALTER TABLE employees
ADD date_of_birth DATE;

#Modify the salary column to store up to 12 digits with 2 decimal places.
ALTER TABLE employees
MODIFY salary DECIMAL(12, 2);

#Drop the column phone_number from employees.
ALTER TABLE employees
DROP COLUMN phone_number;

#Rename the table employees to staff.
ALTER TABLE employees
RENAME TO staff;

#Rename the column first_name to fname in staff.
ALTER TABLE staff
RENAME COLUMN first_name TO fname;

#Add a NOT NULL constraint to last_name in staff.
ALTER TABLE staff
MODIFY last_name VARCHAR(50) NOT NULL;

#Create a copy of staff table as employees_backup (with data).
CREATE TABLE employees_backup AS
SELECT * FROM staff;

#Create a table with the same structure as staff but no data.
CREATE TABLE employees_structure AS
SELECT * FROM staff
WHERE 1=0;

#Drop the departments table.
DROP TABLE departments;

#Create the projects table with project_id as primary key and project_name as NOT NULL.
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL
);

#Recreate departments table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) UNIQUE
);

#Add a foreign key constraint from staff.department to departments.dept_name
ALTER TABLE staff
ADD CONSTRAINT fk_department
FOREIGN KEY (department) REFERENCES departments(dept_name);

#Create a temporary table temp_salaries with columns employee_id, salary.
CREATE TEMPORARY TABLE temp_salaries (
    employee_id INT,
    salary DECIMAL(12,2)
);

#Truncate the temp_salaries table.
TRUNCATE TABLE temp_salaries;

#Create a new table with a composite primary key on (employee_id, department).
CREATE TABLE employee_departments (
    employee_id INT,
    department VARCHAR(50),
    PRIMARY KEY (employee_id, department)
);

#Drop the database company_db.
DROP DATABASE company_db;

#Recreate the database company_db and switch to it
CREATE DATABASE company_db;
USE company_db;

#Recreate the staff table (same structure as before, after all modifications we made):
CREATE TABLE staff (
    employee_id INT PRIMARY KEY,
    fname VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    hire_date DATE,
    job_title VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(12, 2),
    manager_id INT,
    date_of_birth DATE
);

#nsert one new employee into staff.
INSERT INTO staff (employee_id, fname, last_name, email, hire_date, job_title, department, salary, manager_id, date_of_birth)
VALUES
(101, 'Alex', 'Johnson', 'alex.johnson@example.com', '2023-04-10', 'Cloud Engineer', 'IT', 75000.00, 5, '1995-07-21');

#Insert three employees in one query into staff.
INSERT INTO staff (employee_id, fname, last_name, email, hire_date, job_title, department, salary, manager_id, date_of_birth)
VALUES
(102, 'Rachel', 'Adams', 'rachel.adams@example.com', '2023-05-15', 'Frontend Developer', 'IT', 62000.00, 5, '1996-02-11'),
(103, 'Brian', 'Scott', 'brian.scott@example.com', '2023-06-01', 'Data Analyst', 'Analytics', 58000.00, 6, '1994-11-23'),
(104, 'Laura', 'Mitchell', 'laura.mitchell@example.com', '2023-06-20', 'HR Specialist', 'HR', 50000.00, 3, '1993-08-09');

#Show table structure
DESCRIBE staff;

#View all data in staff
SELECT * FROM staff;

#Update salary of employee with ID 1 to 70000
UPDATE staff
SET salary = 70000
WHERE employee_id = 1;

#Increase salary of all IT employees by 5%
UPDATE staff
SET salary = salary * 1.05
WHERE department = 'IT';

#Reduce salary of employees in HR by 2000
UPDATE staff
SET salary = salary - 2000
WHERE department = 'HR';

#Change department of employee with ID 4 to 'Analytics'
UPDATE staff
SET department = 'Analytics'
WHERE employee_id = 4;

#Update hire_date of employee with email olivia.garcia@example.com to 2021-01-01
UPDATE staff
SET hire_date = '2021-01-01'
WHERE email = 'olivia.garcia@example.com';

#Delete employee with ID 11
DELETE FROM staff
WHERE employee_id = 11;

#Delete all employees from 'Analytics' department hired before 2020
DELETE FROM staff
WHERE department = 'Analytics' AND hire_date < '2020-01-01';

#Create employees_backup with the same structure as staff
CREATE TABLE employees_backup AS
SELECT * FROM staff
WHERE 1=0;

#Copy all employees from staff to employees_backup
INSERT INTO employees_backup
SELECT * FROM staff;

#Insert into employees_backup only employees from IT department
INSERT INTO employees_backup
SELECT * FROM staff
WHERE department = 'IT';

#Insert an employee without specifying all columns (use defaults)
INSERT INTO staff (employee_id, fname, last_name)
VALUES (105, 'Sam', 'Default');

#Update manager_id of all IT employees to 5
UPDATE staff
SET manager_id = 5
WHERE department = 'IT';

#Update salary of employees earning less than 50000 to 50000
UPDATE staff
SET salary = 50000
WHERE salary < 50000;

#Delete employees whose first name starts with 'M'
DELETE FROM staff
WHERE fname LIKE 'M%';

#Delete all employees except managers (manager_id IS NULL)
DELETE FROM staff
WHERE manager_id IS NOT NULL;

#Insert an employee with NULL values for optional columns
INSERT INTO staff (employee_id, fname, last_name)
VALUES (106, 'Nina', 'Brown');

#Update last_name of all employees to uppercase
UPDATE staff
SET last_name = UPPER(last_name);

#Make employee_id auto-increment temporarily
ALTER TABLE staff MODIFY employee_id INT AUTO_INCREMENT;

#Insert employee records from a SELECT query from employees_backup
INSERT INTO staff (fname, last_name, email, hire_date, job_title, department, salary, manager_id, date_of_birth)
SELECT fname, last_name, email, hire_date, job_title, department, salary, manager_id, date_of_birth
FROM employees_backup;

#Delete duplicate records based on email
DELETE s1
FROM staff s1
INNER JOIN staff s2 
WHERE 
    s1.email = s2.email AND 
    s1.employee_id > s2.employee_id;

#Insert an employee with hire_date as the current date
INSERT INTO staff (fname, last_name, hire_date)
VALUES ('Eli', 'White', CURDATE());

#Update all phone numbers to include country code +1
ALTER TABLE staff
ADD COLUMN phone_number VARCHAR(20);

UPDATE staff
SET phone_number = CONCAT('+1', phone_number);

#Delete all employees with salary over 100000
DELETE FROM staff
WHERE salary > 100000;

#Increase salary of employees hired after 2021 by 10%
UPDATE staff
SET salary = salary * 1.10
WHERE hire_date > '2021-12-31';

#Set all manager_id values to NULL for HR department
UPDATE staff
SET manager_id = NULL
WHERE department = 'HR';

#Delete employees whose department is not IT, Analytics, or HR
DELETE FROM staff
WHERE department NOT IN ('IT', 'Analytics', 'HR');

#Update job_title of 'Junior Developer' to 'Associate Developer'
UPDATE staff
SET job_title = 'Associate Developer'
WHERE job_title = 'Junior Developer';

#Insert new hires for 2023 in bulk
INSERT INTO staff (fname, last_name, email, hire_date, job_title, department, salary, manager_id, date_of_birth)
VALUES
('Anna', 'King', 'anna.king@example.com', '2023-01-15', 'Frontend Developer', 'IT', 60000, 5, '1995-03-22'),
('Tom', 'Harris', 'tom.harris@example.com', '2023-02-10', 'Data Analyst', 'Analytics', 58000, 6, '1994-06-18'),
('Lucy', 'Evans', 'lucy.evans@example.com', '2023-03-05', 'HR Coordinator', 'HR', 50000, 3, '1996-08-30');

#Update department name 'Analytics' to 'Data Analytics'
UPDATE staff
SET department = 'Data Analytics'
WHERE department = 'Analytics';

#Delete employees without an email
DELETE FROM staff
WHERE email IS NULL;

#Increase salary of managers (manager_id IS NULL) by 15%
UPDATE staff
SET salary = salary * 1.15
WHERE manager_id IS NULL;

#Insert an employee by selecting from projects table (matching structure)
CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(100) NOT NULL
);

INSERT INTO projects (project_name)
VALUES ('Project Alpha'), ('Project Beta'), ('Project Gamma');

INSERT INTO staff (fname, last_name, job_title, hire_date, department, salary)
SELECT project_name, 'Temp', project_name, CURDATE(), 'IT', 50000
FROM projects
LIMIT 1;

#Change all NULL manager_id values to -1 (temporary placeholder)
UPDATE staff
SET manager_id = -1
WHERE manager_id IS NULL;

#Delete all employees from the table (no TRUNCATE)
DELETE FROM staff;

#Re-insert sample data into staff from the earlier script
INSERT INTO staff (employee_id, fname, last_name, email, hire_date, job_title, department, salary, manager_id, date_of_birth)
VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '2020-01-15', 'Software Engineer', 'IT', 65000.00, 5, '1990-05-12'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '2019-03-22', 'Data Analyst', 'Data Analytics', 55000.00, 6, '1992-08-20'),
(3, 'Michael', 'Brown', 'michael.brown@example.com', '2018-07-10', 'HR Manager', 'HR', 75000.00, NULL, '1988-11-30'),
(4, 'Emily', 'Davis', 'emily.davis@example.com', '2021-05-18', 'Frontend Developer', 'IT', 60000.00, 5, '1995-02-14'),
(5, 'Robert', 'Wilson', 'robert.wilson@example.com', '2017-11-05', 'IT Manager', 'IT', 90000.00, NULL, '1985-09-01');

#Bulk update salaries using a CASE statement
UPDATE staff
SET salary = CASE
    WHEN department = 'IT' THEN salary * 1.10
    WHEN department = 'HR' THEN salary * 1.05
    ELSE salary * 1.03
END;

#Insert an employee with salary calculated from another employee’s salary
INSERT INTO staff (fname, last_name, email, hire_date, job_title, department, salary, manager_id, date_of_birth)
SELECT 'Alex', 'Reed', 'alex.reed@example.com', CURDATE(), 'Junior Developer', 'IT', salary * 0.9, 5, '1996-04-12'
FROM staff
WHERE employee_id = 1;

#Delete all employees whose first and last names are identical
DELETE FROM staff
WHERE fname = last_name;

#Insert a test employee with fake values for development testing
INSERT INTO staff (fname, last_name, email, hire_date, job_title, department, salary, manager_id, date_of_birth)
VALUES ('Test', 'User', 'test.user@example.com', CURDATE(), 'QA Tester', 'IT', 40000, -1, '1990-01-01');

#Create data_user with a password
CREATE USER 'data_user'@'localhost' IDENTIFIED BY '0000';

#Grant SELECT privilege on staff
GRANT SELECT ON company_db.staff TO 'data_user'@'localhost';

#Grant SELECT privilege on staff to user data_user
GRANT SELECT ON staff TO 'data_user'@'localhost';

#Create the user first
CREATE USER 'intern'@'localhost' IDENTIFIED BY '0000';

#Grant SELECT and INSERT privileges
GRANT SELECT, INSERT ON company_db.staff TO 'intern'@'localhost';

SHOW GRANTS FOR 'intern'@'localhost';

#Revoke INSERT privilege from intern
REVOKE INSERT ON company_db.staff FROM 'intern'@'localhost';

#Grant ALL privileges on database company_db to admin_user
#Create the user if not exists
CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY '0000';

#Grant all privileges on the database
GRANT ALL PRIVILEGES ON company_db.* TO 'admin_user'@'localhost';

#Revoke ALL privileges from admin_user
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'admin_user'@'localhost';

#Grant UPDATE(salary) privilege to hr_manager
#Create the user if not exists
CREATE USER IF NOT EXISTS 'hr_manager'@'localhost' IDENTIFIED BY '0000';

#Grant UPDATE privilege on salary column
GRANT UPDATE (salary) ON company_db.staff TO 'hr_manager'@'localhost';

#Grant DELETE privilege to supervisor
#Create the user if not exists
CREATE USER IF NOT EXISTS 'supervisor'@'localhost' IDENTIFIED BY '0000';

#Grant DELETE privilege on staff table
GRANT DELETE ON company_db.staff TO 'supervisor'@'localhost';

#Revoke DELETE privilege from supervisor
REVOKE DELETE ON company_db.staff FROM 'supervisor'@'localhost';

#Create a new user readonly_user with a password
CREATE USER 'readonly_user'@'localhost' IDENTIFIED BY '0000';

#Grant SELECT on all tables to readonly_user
GRANT SELECT ON company_db.* TO 'readonly_user'@'localhost';

#Drop user readonly_user
DROP USER 'readonly_user'@'localhost';

#Grant CREATE privilege to developer_user
#Create the user if not exists
CREATE USER IF NOT EXISTS 'developer_user'@'localhost' IDENTIFIED BY '0000';
#Grant CREATE privilege on company_db
GRANT CREATE ON company_db.* TO 'developer_user'@'localhost';

#Revoke CREATE privilege from developer_user
REVOKE CREATE ON company_db.* FROM 'developer_user'@'localhost';

#Grant EXECUTE privilege on stored procedures to analyst_user
#Create the user if not exists
CREATE USER IF NOT EXISTS 'analyst_user'@'localhost' IDENTIFIED BY '0000';

#Grant EXECUTE privilege on the database
GRANT EXECUTE ON company_db.* TO 'analyst_user'@'localhost';

#Revoke EXECUTE privilege from analyst_user
REVOKE EXECUTE ON company_db.* FROM 'analyst_user'@'localhost';

#Select all employees
SELECT * FROM staff;

#Select only first_name, last_name, and salary
SELECT fname, last_name, salary
FROM staff;

#Find all employees in IT department
SELECT *
FROM staff
WHERE department = 'IT';

#Find employees earning more than 60000
SELECT *
FROM staff
WHERE salary > 60000;

#Find employees hired after 2020
SELECT *
FROM staff
WHERE hire_date > '2020-12-31';

#List employees sorted by salary descending
SELECT *
FROM staff
ORDER BY salary DESC;

#Find top 5 highest paid employees
SELECT *
FROM staff
ORDER BY salary DESC
LIMIT 5;

#Find employees whose first_name starts with 'J'
SELECT *
FROM staff
WHERE fname LIKE 'J%';

#Find employees whose last_name ends with 'son'
SELECT *
FROM staff
WHERE last_name LIKE '%son';

#Show all employees without a manager
SELECT *
FROM staff
WHERE manager_id IS NULL OR manager_id = -1;

#Find employees in either IT or Data Analytics department
SELECT *
FROM staff
WHERE department IN ('IT', 'Data Analytics');

#Find employees not in HR department
SELECT *
FROM staff
WHERE department <> 'HR';

#Show employees with salary between 50000 and 80000
SELECT *
FROM staff
WHERE salary BETWEEN 50000 AND 80000;

#Count total employees
SELECT COUNT(*) AS total_employees
FROM staff;

#Count employees per department
SELECT department, COUNT(*) AS employee_count
FROM staff
GROUP BY department;

#Find average salary per department
SELECT department, AVG(salary) AS average_salary
FROM staff
GROUP BY department;

#Find max salary in IT department
SELECT MAX(salary) AS max_salary
FROM staff
WHERE department = 'IT';

#Find min salary in Analytics (Data Analytics) department
SELECT MIN(salary) AS min_salary
FROM staff
WHERE department = 'Data Analytics';

#Show departments with more than 3 employees
SELECT department, COUNT(*) AS employee_count
FROM staff
GROUP BY department
HAVING COUNT(*) > 3;

#Show employees with the same manager_id
SELECT manager_id, GROUP_CONCAT(fname, ' ', last_name) AS employees
FROM staff
WHERE manager_id IS NOT NULL AND manager_id <> -1
GROUP BY manager_id
HAVING COUNT(*) > 1;

#Find all unique job titles
SELECT DISTINCT job_title
FROM staff;

#Show employees hired in 2021
SELECT *
FROM staff
WHERE YEAR(hire_date) = 2021;

#List employees whose email contains 'example.com'
SELECT *
FROM staff
WHERE email LIKE '%example.com%';

#Show salary difference between highest and lowest
SELECT MAX(salary) - MIN(salary) AS salary_difference
FROM staff;

#Show first 10 employees ordered by hire_date
SELECT *
FROM staff
ORDER BY hire_date
LIMIT 10;

#Show employees hired in the last 2 years
SELECT *
FROM staff
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR);

#Show employees whose salary is above department average
SELECT *
FROM staff s
WHERE salary > (
    SELECT AVG(salary)
    FROM staff
    WHERE department = s.department
);

#Show employees who have the same salary as someone else
SELECT *
FROM staff
WHERE salary IN (
    SELECT salary
    FROM staff
    GROUP BY salary
    HAVING COUNT(*) > 1
);

#Group employees by department and show total salary per group
SELECT department, SUM(salary) AS total_salary
FROM staff
GROUP BY department;

#Show employees earning more than their manager
SELECT e.fname, e.last_name, e.salary AS employee_salary, m.fname AS manager_fname, m.last_name AS manager_lname, m.salary AS manager_salary
FROM staff e
JOIN staff m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;

#Show employees and their manager’s name (self join)
SELECT e.fname AS employee_fname, e.last_name AS employee_lname,
       m.fname AS manager_fname, m.last_name AS manager_lname
FROM staff e
LEFT JOIN staff m ON e.manager_id = m.employee_id;

#Find all departments with average salary > 65000
SELECT department, AVG(salary) AS avg_salary
FROM staff
GROUP BY department
HAVING AVG(salary) > 65000;

#Show second highest salary in the company
SELECT MAX(salary) AS second_highest_salary
FROM staff
WHERE salary < (SELECT MAX(salary) FROM staff);

#Show Nth highest salary (parameterized)
SELECT DISTINCT salary AS nth_highest_salary
FROM staff
ORDER BY salary DESC
LIMIT 2, 1;

#Show employees where salary is in top 10% of salaries
SELECT *
FROM staff
WHERE salary >= (
    SELECT salary
    FROM staff s1
    WHERE (
        SELECT COUNT(*) 
        FROM staff s2 
        WHERE s2.salary > s1.salary
    ) < CEIL(0.1 * (SELECT COUNT(*) FROM staff))
);

#Show count of employees by job_title
SELECT job_title, COUNT(*) AS employee_count
FROM staff
GROUP BY job_title;

#Show employees who joined in January
SELECT *
FROM staff
WHERE MONTH(hire_date) = 1;

#Show oldest hire_date in company
SELECT MIN(hire_date) AS oldest_hire_date
FROM staff;

#Show newest hire_date in company
SELECT MAX(hire_date) AS newest_hire_date
FROM staff;

#Show employees with the same last name
SELECT last_name, GROUP_CONCAT(fname SEPARATOR ', ') AS employees
FROM staff
GROUP BY last_name
HAVING COUNT(*) > 1;

#Show employees where first name length > 5 characters
SELECT *
FROM staff
WHERE CHAR_LENGTH(fname) > 5;

#Step 25: Show employees whose salary is divisible by 5000
SELECT *
FROM staff
WHERE MOD(salary, 5000) = 0;

#Show employees hired before their manager
SELECT e.fname AS employee_fname, e.last_name AS employee_lname,
       e.hire_date AS employee_hire_date,
       m.fname AS manager_fname, m.last_name AS manager_lname,
       m.hire_date AS manager_hire_date
FROM staff e
JOIN staff m ON e.manager_id = m.employee_id
WHERE e.hire_date < m.hire_date;

#Find all departments that don’t have managers
SELECT department
FROM staff
GROUP BY department
HAVING SUM(CASE WHEN manager_id IS NULL OR manager_id = -1 THEN 1 ELSE 0 END) = COUNT(*);

#Show total number of managers
SELECT COUNT(*) AS total_managers
FROM staff
WHERE employee_id IN (SELECT DISTINCT manager_id 
FROM staff 
WHERE manager_id IS NOT NULL AND manager_id <> -1);

#Show percentage of employees in each department
SELECT department,
       COUNT(*) AS employee_count,
       ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM staff), 2) AS percentage
FROM staff
GROUP BY department;

#Show employees with highest salary in each department
SELECT s1.*
FROM staff s1
JOIN (
    SELECT department, MAX(salary) AS max_salary
    FROM staff
    GROUP BY department
) s2 ON s1.department = s2.department AND s1.salary = s2.max_salary;

#Show employees with lowest salary in each department
SELECT s1.*
FROM staff s1
JOIN (
    SELECT department, MIN(salary) AS min_salary
    FROM staff
    GROUP BY department
) s2 ON s1.department = s2.department AND s1.salary = s2.min_salary;

#Show employees with duplicate phone numbers
SELECT phone_number, GROUP_CONCAT(fname, ' ', last_name) AS employees
FROM staff
WHERE phone_number IS NOT NULL
GROUP BY phone_number
HAVING COUNT(*) > 1;

#Show employees who are not assigned to a project
CREATE TABLE projects_assignments (
    employee_id INT,
    project_id INT,
    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id) REFERENCES staff(employee_id)
);

#Find median salary in the company
SELECT DISTINCT AVG(salary) OVER() AS median_salary
FROM (
    SELECT salary,
           ROW_NUMBER() OVER (ORDER BY salary) AS rn,
           COUNT(*) OVER() AS total_count
    FROM staff
) AS ranked_salaries
WHERE rn IN (FLOOR((total_count + 1)/2), CEIL((total_count + 1)/2));

#Show employees ordered by last name and then first name
SELECT *
FROM staff
ORDER BY last_name ASC, fname ASC;

#Show all employees but mask email addresses
SELECT fname, last_name,
       CONCAT(LEFT(email, 2), '****', SUBSTRING_INDEX(email, '@', -1)) AS masked_email,
       hire_date, job_title, department, salary, manager_id
FROM staff;

#Show employees whose department name length is > 8
SELECT *
FROM staff
WHERE CHAR_LENGTH(department) > 8;

#Show employees where first_name contains letter 'a' twice
SELECT *
FROM staff
WHERE (LENGTH(fname) - LENGTH(REPLACE(LOWER(fname), 'a', ''))) = 2;

#Show employees who have no vowels in last name

SELECT *
FROM staff
WHERE last_name NOT REGEXP '[aeiouAEIOU]';

#Show employees who share a manager but are in different departments
SELECT e1.employee_id, e1.fname AS employee1_fname, e1.last_name AS employee1_lname,
       e2.employee_id, e2.fname AS employee2_fname, e2.last_name AS employee2_lname,
       e1.manager_id
FROM staff e1
JOIN staff e2 
    ON e1.manager_id = e2.manager_id 
    AND e1.department <> e2.department
    AND e1.employee_id < e2.employee_id;

#Show employees hired on weekends
SELECT *
FROM staff
WHERE DAYOFWEEK(hire_date) IN (1, 7);

#Show employees with palindromic first names
SELECT *
FROM staff
WHERE fname = REVERSE(fname);

#Show all employees but replace NULL manager_id with 'No Manager'
SELECT employee_id, fname, last_name, 
       department, job_title, salary, hire_date,
       IFNULL(manager_id, 'No Manager') AS manager
FROM staff;

#Start a transaction, insert a new employee, and commit

START TRANSACTION;
INSERT INTO staff (employee_id, fname, last_name, email, hire_date, job_title, department, salary, manager_id)
VALUES (201, 'Test', 'Employee', 'test.employee@example.com', CURDATE(), 'Intern', 'IT', 40000, 5);
COMMIT;

#Start a transaction, insert a new employee, and rollback
START TRANSACTION;
INSERT INTO staff (employee_id, fname, last_name, email, hire_date, job_title, department, salary, manager_id)
VALUES (202, 'Rollback', 'Test', 'rollback.test@example.com', CURDATE(), 'Intern', 'IT', 40000, 5);
ROLLBACK;

#Start a transaction, update salary for employee ID 1, commit
START TRANSACTION;
UPDATE staff
SET salary = 75000
WHERE employee_id = 1;
COMMIT;

#Start a transaction, delete employee ID 5, rollback
START TRANSACTION;
DELETE FROM staff
WHERE employee_id = 5;
ROLLBACK;

#Start a transaction, update department of employee ID 2 to 'IT', commit
START TRANSACTION;
UPDATE staff
SET department = 'IT'
WHERE employee_id = 2;
COMMIT;

#Assign a row number to each employee ordered by hire_date (earliest first)
SELECT employee_id, fname, last_name, hire_date,
       ROW_NUMBER() OVER (ORDER BY hire_date ASC) AS row_num
FROM staff;

#Rank employees by salary (highest first)
SELECT employee_id, fname, last_name, salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM staff;

#Show dense rank of employees’ salaries within each department
SELECT employee_id, fname, last_name, department, salary,
       DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_salary_rank
FROM staff;

#For each employee, display their salary and the average salary of their department
SELECT employee_id, fname, last_name, department, salary,
       AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
FROM staff;

#For each employee, show the difference between their salary and the highest salary in their department
SELECT employee_id, fname, last_name, department, salary,
       MAX(salary) OVER (PARTITION BY department) - salary AS diff_from_dept_max
FROM staff;

#Show the previous employee’s salary for each employee (based on hire_date) using LAG()
SELECT employee_id, fname, last_name, hire_date, salary,
       LAG(salary) OVER (ORDER BY hire_date) AS previous_salary
FROM staff;

#Show the next employee’s salary for each employee (based on hire_date) using LEAD()
SELECT employee_id, fname, last_name, hire_date, salary,
       LEAD(salary) OVER (ORDER BY hire_date) AS next_salary
FROM staff;

#For each department, show the cumulative total salary ordered by hire_date

SELECT employee_id, fname, last_name, department, hire_date, salary,
       SUM(salary) OVER (PARTITION BY department ORDER BY hire_date) AS cumulative_salary
FROM staff;

#Show employees whose salary is above the department average (using window function)
SELECT *
FROM (
    SELECT employee_id, fname, last_name, department, salary,
           AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
    FROM staff
) AS sub
WHERE salary > dept_avg_salary;

#Find the top 3 highest-paid employees in each department (using DENSE_RANK)
SELECT employee_id, fname, last_name, department, salary, dept_rank
FROM (
    SELECT employee_id, fname, last_name, department, salary,
           DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank
    FROM staff
) AS ranked_salaries
WHERE dept_rank <= 3;