-- Create data

DROP TABLE IF EXISTS Company, Lead_Manager, Senior_Manager, Manager, Employee;


CREATE TABLE Company (
    company_code VARCHAR(255),
    founder VARCHAR(255)
);

CREATE TABLE Lead_Manager (
    lead_manager_code VARCHAR(255),
    company_code VARCHAR(255)
);

CREATE TABLE Senior_Manager (
    senior_manager_code VARCHAR(255),
    lead_manager_code VARCHAR(255),
    company_code VARCHAR(255)
);

CREATE TABLE Manager (
    manager_code VARCHAR(255),
    senior_manager_code VARCHAR(255),
    lead_manager_code VARCHAR(255),
    company_code VARCHAR(255)
);

CREATE TABLE Employee (
    employee_code VARCHAR(255),
    manager_code VARCHAR(255),
    senior_manager_code VARCHAR(255),
    lead_manager_code VARCHAR(255),
    company_code VARCHAR(255)
);

/*
Need to move the .csv files to your MySQL DB folder: /var/lib/mysql/<my_db>/
*/
LOAD DATA INFILE "company.csv"
INTO TABLE Company
FIELDS TERMINATED BY ',';

LOAD DATA INFILE "senior_manager.csv"
INTO TABLE Senior_Manager
FIELDS TERMINATED BY ',';

LOAD DATA INFILE "lead_manager.csv"
INTO TABLE Lead_Manager
FIELDS TERMINATED BY ',';

LOAD DATA INFILE "manager.csv"
INTO TABLE Manager
FIELDS TERMINATED BY ',';

-- Note: this table is slightly truncated from the HackerRank version!
LOAD DATA INFILE "employee.csv"
INTO TABLE Employee
FIELDS TERMINATED BY ',';

-- Question

/*
Amber's conglomerate corporation just acquired some new companies.
Each of the companies follows this hierarchy:

Founder -> Lead Manager -> Senior Manager -> Manager -> Employee

Given the table schemas above, write a query to print the company_code,
founder name, total number of lead managers, total number of senior managers,
total number of managers, and total number of employees. Order your output by
ascending company_code.

Note:
    - The tables may contain duplicate records.
    - The company_code is string, so the sorting should not be numeric.
        For example, if the company_codes are C_1, C_2, and C_10,
        then the ascending company_codes will be C_1, C_10, and C_2.
*/

-- Solution

/*
    Join with Company to get founder name
    Count distinct values by company
    Order by company_code (lexically)
*/

SELECT
    e.company_code,
    c.founder,
    COUNT(DISTINCT(lead_manager_code)) AS n_lead_manager,
    COUNT(DISTINCT(senior_manager_code)) as n_senior_manager,
    COUNT(DISTINCT(manager_code)) AS n_manager,
    COUNT(DISTINCT(employee_code)) AS n_employee
FROM
    Employee e
LEFT JOIN
    Company c
ON
    e.company_code = c.company_code
GROUP BY e.company_code, c.founder
ORDER BY e.company_code;
