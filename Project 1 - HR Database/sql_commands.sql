CREATE DATABASE tech_abc_hr;

-- Salary table
CREATE TABLE Salary (
    salary_id serial PRIMARY KEY,
    salary int
);
SELECT * FROM Salary;

-- Job Title table
CREATE TABLE Job_Title (
    job_title_id serial PRIMARY KEY,
    job_title_name varchar(100) UNIQUE
);
SELECT * FROM Job_Title;

-- Location table
CREATE TABLE Location (
    location_id serial PRIMARY KEY,
    location_name varchar(100),
    city varchar(100),
    address varchar(100),
    state varchar(100)
);
SELECT * FROM Location;

--Department table
CREATE TABLE Department (
    department_id serial PRIMARY KEY,
    department_name varchar(100) unique
);
SELECT * FROM Department;

-- Education Level table
CREATE TABLE Education_Level (
    education_level_id serial PRIMARY KEY,
    education_level_name varchar(100) UNIQUE
);
SELECT * FROM Education_Level;

--Employee table
CREATE TABLE Employee (
    employee_id varchar(6) PRIMARY KEY,
    name varchar(100),
    email varchar(50),
    hire_date date
);

SELECT * FROM Employee;

--Employee Job table
CREATE TABLE Employee_Job (
    employee_job_id serial,
    employee_id varchar(6),
	salary_id int,
    job_title_id int,
    manager_id varchar(6),
    department_id int,
    location_id int,
    start_date date,
    end_date date,
	education_level_id int,
	PRIMARY KEY (employee_id, start_date)
);
SELECT * FROM Employee_Job;


-- Here I ran on terminal the command below:
-- psql -f /home/workspace/StageTableLoad.sql

SELECT * FROM proj_stg LIMIT 2;

-- create Employee Job FKs
ALTER TABLE Employee_Job
    ADD CONSTRAINT fk_employee_job_employee
    FOREIGN KEY (employee_id)
    REFERENCES Employee (employee_id);
ALTER TABLE Employee_Job
    ADD CONSTRAINT fk_employee_job_job_title
    FOREIGN KEY (job_title_id)
    REFERENCES Job_Title (job_title_id);
ALTER TABLE Employee_Job
    ADD CONSTRAINT fk_employee_job_employee_manager
    FOREIGN KEY (manager_id)
    REFERENCES Employee (employee_id);
ALTER TABLE Employee_Job
    ADD CONSTRAINT fk_employee_job_department
    FOREIGN KEY (department_id)
    REFERENCES Department (department_id);
ALTER TABLE Employee_Job
    ADD CONSTRAINT fk_employee_job_location
    FOREIGN KEY (location_id)
    REFERENCES Location (location_id);
ALTER TABLE Employee_Job
    ADD CONSTRAINT fk_employee_job_education_level
    FOREIGN KEY (education_level_id)
    REFERENCES Education_Level (education_level_id);
ALTER TABLE Employee_Job
    ADD CONSTRAINT fk_employee_job_salary
    FOREIGN KEY (salary_id)
    REFERENCES Salary (salary_id);

--CRUDs
INSERT INTO job_title (job_title_name) SELECT DISTINCT job_title FROM proj_stg;
SELECT * FROM job_title;

INSERT INTO Department (department_name) SELECT DISTINCT department_nm FROM proj_stg;
SELECT * FROM Department;

INSERT INTO Location (location_name, address, city, state) SELECT DISTINCT location, address, city, state FROM proj_stg;
SELECT * FROM Location;

INSERT INTO Salary (salary) SELECT DISTINCT salary FROM proj_stg;
SELECT * FROM Salary;

INSERT INTO Employee (employee_id, name, email, hire_date) SELECT DISTINCT emp_id, emp_nm, email, hire_dt FROM proj_stg;
SELECT * FROM Employee;

INSERT INTO Education_Level (education_level_name) SELECT DISTINCT education_lvl FROM proj_stg;
SELECT * FROM Education_Level;

-- Populate employee_job table
INSERT INTO Employee_Job (employee_id, job_title_id, manager_id, department_id, location_id, start_date, end_date, salary_id, education_level_id)
SELECT emp.employee_id, jt.job_title_id, emp_m.employee_id, dpt.department_id, l.location_id, stg.start_dt, stg.end_dt, s.salary_id, el.education_level_id
FROM proj_stg stg  
JOIN employee emp on emp.employee_id=stg.emp_id
JOIN job_title jt on jt.job_title_name = stg.job_title
JOIN employee emp_m on emp_m.name = stg.manager
JOIN department dpt on dpt.department_name = stg.department_nm
JOIN location l on l.location_name = stg.location
JOIN salary s on s.salary = stg.salary
JOIN education_level el on el.education_level_name = stg.education_lvl;
SELECT * FROM Employee_Job;
    
-- list of employees with Job Titles and Department Names
SELECT DISTINCT emp.name, jt.job_title_name, dpt.department_name
FROM employee_job ej
JOIN employee emp on emp.employee_id = ej.employee_id
JOIN job_title jt on jt.job_title_id = ej.job_title_id
JOIN department dpt on dpt.department_id = ej.department_id;

-- Insert Web Programmer as a new job title
INSERT INTO job_title (job_title_name) VALUES('Web Programmer');
SELECT * FROM job_title WHERE job_title_name ='Web Programmer';

-- Correct the job title from web programmer to web developer
UPDATE job_title SET job_title_name = 'Web Developer'
WHERE job_title_name = 'Web Programmer';
SELECT * FROM job_title WHERE job_title_name ='Web Developer';

--Delete the job title Web Developer from the database
DELETE FROM job_title where job_title_name ='Web Developer';
SELECT * FROM job_title WHERE job_title_name ='Web Developer';

--How many employees are in each department?
SELECT d.department_name, COUNT(DISTINCT ej.employee_id) numbers_employess
FROM employee_job ej 
JOIN department d ON d.department_id = ej.department_id
WHERE end_date >= CAST(CURRENT_TIMESTAMP AS DATE)
GROUP BY 1;

-- Write a query that returns current and past jobs (include employee name, job title, department, manager name, start and end date for position) for employee Toni Lembeck.
SELECT e.name, jt.job_title_name, d.department_name, m.name, ej.start_date, ej.end_date
FROM employee_job ej
JOIN employee e on e.employee_id = ej.employee_id
JOIN job_title jt on jt.job_title_id = ej.job_title_id
JOIN department d on d.department_id = ej.department_id
JOIN employee m on m.employee_id = ej.manager_id
WHERE e.name='Toni Lembeck'
ORDER by ej.start_date;

-- Create a view that returns all employee attributes; results should resemble initial Excel file
CREATE OR REPLACE VIEW vw_intial_data AS 
SELECT e.employee_id AS EMP_ID, 
    e.name AS EMP_NM, 
    e.email AS EMAIL, 
    e.hire_date AS HIRE_DT, 
    jt.job_title_name AS JOB_TITLE,
    s.salary AS SALARY,
    d.department_name AS DEPARTMENT,
    m.name AS MANAGER,
    to_char(ej.start_date, 'DD/MM/YYYY') AS START_DT,
    CASE WHEN ej.end_date>=date('2100-01-01')
        THEN NULL 
        ELSE to_char(ej.end_date, 'DD/MM/YYYY')
    END AS END_DT,
    l.location_name AS LOCATION,
    l.address AS  ADDRESS,
    l.city AS CITY,
    l.state AS STATE,
    el.education_level_name AS EDUCATION_LEVEL
FROM employee_job ej
JOIN employee e on e.employee_id = ej.employee_id
JOIN job_title jt on jt.job_title_id = ej.job_title_id
JOIN department d on d.department_id = ej.department_id
JOIN employee m on m.employee_id = ej.manager_id
JOIN location l on l.location_id = ej.location_id
JOIN education_level el on el.education_level_id = ej.education_level_id
JOIN salary s on s.salary_id = ej.salary_id;

SELECT * FROM vw_intial_data;

-- Create a stored procedure with parameters that returns current and past jobs (include employee name, job title, department, manager name, start and end date for position) when given an employee name.
CREATE OR REPLACE FUNCTION employee_jobs(employee_name varchar) 
RETURNS TABLE(name varchar, job_title_name varchar, department_name varchar, manager varchar, start_date date, end_date date) 
AS $$
    BEGIN
         RETURN QUERY
            SELECT e.name, jt.job_title_name, d.department_name, m.name AS manager, ej.start_date, ej.end_date
            FROM employee_job ej
            JOIN employee e on e.employee_id = ej.employee_id
            JOIN job_title jt on jt.job_title_id = ej.job_title_id
            JOIN department d on d.department_id = ej.department_id
            JOIN employee m on m.employee_id = ej.manager_id
            WHERE e.name=employee_name
            ORDER by ej.start_date;
    END;
$$ LANGUAGE plpgsql;

SELECT * FROM employee_jobs('Toni Lembeck');



