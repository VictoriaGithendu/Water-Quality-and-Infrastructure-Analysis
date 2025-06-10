-- Create the answers table
USE md_water_services;
CREATE TABLE IF NOT EXISTS sql_integrated_project2 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question VARCHAR(255) NOT NULL,
    answer TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Which SQL query will produce the date format "DD Month YYYY" from the time_of_record column in the visits table, as a single column? Note: Monthname() acts in a similar way to DAYNAME().
SELECT CONCAT(day(time_of_record), " ", monthname(time_of_record), " ", year(time_of_record)) FROM visits; 


-- What are the names of the two worst-performing employees who visited the fewest sites, and how many sites did the worst-performing employee visit? Modify your queries from the “Honouring the workers” section.
SELECT
    e.employee_name,
    v.assigned_employee_id,
    COUNT(v.visit_count) AS site_visit
FROM
    visits v
JOIN
    employee e ON v.assigned_employee_id = e.assigned_employee_id
GROUP BY
    v.assigned_employee_id, e.employee_name
ORDER BY
    site_visit ASC
LIMIT 2;


/**One of our employees, Farai Nia, lives at 33 Angelique Kidjo Avenue. What would be the result if we TRIM() her address?
TRIM('33 Angelique Kidjo Avenue  ')**/
SELECT
	TRIM('33 Angelique Kidjo Avenue  ')
FROM employee;


-- How many employees live in Dahabu? Rely on one of the queries we used in the project to answer this
SELECT
	count(*) AS no_town_name
FROM employee
WHERE town_name LIKE '%Dahabu%';


-- How many employees live in Harare, Kilimani? Modify one of your queries from the project to answer this question.
SELECT COUNT(*) AS num_employees_in_harare_kilimani
FROM employee
WHERE province_name = 'Kilimani'
AND town_name = 'Harare';

-- How many people share a well on average? Round your answer to 0 decimals.
SELECT ROUND(SUM(number_of_people_served) / COUNT(source_id), 0) AS avg_people_per_well
FROM water_source
WHERE type_of_water_source = 'well';



