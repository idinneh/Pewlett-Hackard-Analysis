

---------------------------------------------------------------------------------------------------------------------
--Deliverable 1: 
---------------------------------------------------------------------------------------------------------------------

-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);				   
					   
CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);					   
					   
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (dept_no, emp_no)
);


CREATE TABLE titles (
	emp_no INT NOT NULL,
	titles VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL
-- 	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
-- 	PRIMARY KEY (emp_no)
);

--TABLE 1 - Retirement Titles table (January 1, 1952 and December 31, 1955).
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);		


					   
CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);					   
					   
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (dept_no, emp_no)
);


CREATE TABLE titles (
	emp_no INT NOT NULL,
	titles VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL
);
	


-- The Number of Retiring Employees by Title (No Duplicates).

	
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.titles,
	t.from_date,
	t.to_date

--INTO retirees_title
FROM employees AS e
	INNER JOIN titles AS t
		ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC;

SELECT * FROM retirees_title;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
rt.first_name,
rt.last_name,
rt.titles

--INTO unique_titles
FROM retirees_title AS rt
WHERE to_date = '9999-01-01'
ORDER BY rt.emp_no, rt.to_date DESC;

-- The number of employees by their most recent job title who are about to retire.
SELECT COUNT(ut.titles), ut.titles
--INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.titles
ORDER BY count DESC;

-----------------------------------------------------------------------------------------------------------------------------
--Deliverable 2: 
-----------------------------------------------------------------------------------------------------------------------------

--The Employees Eligible for the Mentorship Program
SELECT DISTINCT ON (e.emp_no)
	e.emp_no,
	e.first_name, 
	e.last_name, 
	e.birth_date,
	de.from_date,
	de.to_date,
	t.titles
INTO mentorship_eligibilty
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as t
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no, t.from_date DESC;

-----------------------------------------------------------------------------------------------------------------------------
--Deliverable 3: 
-----------------------------------------------------------------------------------------------------------------------------


--Roles per Staff and Departament: 
SELECT DISTINCT ON (rt.emp_no) 
	rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.titles,
	d.dept_name
--INTO unique_titles_department
FROM retirement_titles as rt
INNER JOIN dept_emp as de
ON (rt.emp_no = de.emp_no)
INNER JOIN departments as d
ON (d.dept_no = de.dept_no)
ORDER BY rt.emp_no, rt.to_date DESC;

-- How many roles will need to be fill per title and department?
SELECT ut.dept_name, ut.titles, COUNT(ut.titles) 
--INTO roles_to_fill
FROM unique_titles_department as ut
GROUP BY ut.dept_name, ut.titles
ORDER BY ut.dept_name DESC;

-- Qualified staff, retirement-ready to mentor next generation.
SELECT ut.dept_name, ut.titles, COUNT(ut.titles) 
INTO qualified_staff
FROM  unique_titles_department as ut
WHERE ut.titles IN ('Senior Engineer', 'Senior Staff', 'Technique Leader', 'Manager')
GROUP BY ut.dept_name, ut.titles
ORDER BY ut.dept_name DESC;