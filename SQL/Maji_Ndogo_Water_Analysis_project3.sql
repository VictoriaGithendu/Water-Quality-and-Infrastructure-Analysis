USE md_water_services;
-- Create the answers table
CREATE TABLE IF NOT EXISTS sql_integrated_project3 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question VARCHAR(255) NOT NULL,
    answer TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert some answers
INSERT INTO sql_integrated_project3 (question, answer) VALUES 
('What is SQL?', 'SQL stands for Structured Query Language.'),
('What is a primary key?', 'A primary key uniquely identifies each record in a table.');

-- So first, grab the location_id and true_water_source_score columns from auditor_report.
SELECT
	location_id,
    true_water_source_score
FROM
	auditor_report;

-- Now, we join the visits table to the auditor_report table. Make sure to grab subjective_quality_score, record_id and location_id.
SELECT
	auditor_report.location_id AS audit_location,
    auditor_report.true_water_source_score,
    visits.location_id AS visit_location,
    visits.record_id
FROM auditor_report
JOIN visits
ON auditor_report.location_id = visits.location_id;

/**Now that we have the record_id for each location, our next step is to retrieve the corresponding scores from the water_quality table. We
are particularly interested in the subjective_quality_score. To do this, we'll JOIN the visits table and the water_quality table, using the
record_id as the connecting key.**/
SELECT
	auditor_report.location_id AS audit_location,
    auditor_report.true_water_source_score,
    visits.location_id AS visit_location,
    visits.record_id,
    water_quality.subjective_quality_score
FROM
	auditor_report
JOIN
	visits
ON
	auditor_report.location_id = visits.location_id
JOIN
	water_quality
    ON visits.record_id = water_quality.record_id;

/**It doesn't matter if your columns are in a different format, because we are about to clean this up a bit. Since it is a duplicate, we can drop one of
the location_id columns. Let's leave record_id and rename the scores to surveyor_score and auditor_score to make it clear which scores
we're looking at in the results set.**/
SELECT
	auditor_report.location_id,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM
	auditor_report
JOIN
	visits
ON
	auditor_report.location_id = visits.location_id
JOIN
	water_quality
    ON visits.record_id = water_quality.record_id;

/**Since were joining 1620 rows of data, we want to keep track of the number of rows we get each time we run a query. We can either set the
maximum number of rows we want from "Limit to 1000 rows" to a larger number like 10000, or we can force SQL to give us all of the results, using
LIMIT 10000.**/
SELECT
	auditor_report.location_id,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM
	auditor_report
JOIN
	visits
ON
	auditor_report.location_id = visits.location_id
JOIN
	water_quality
    ON visits.record_id = water_quality.record_id
LIMIT 10000;

/**Ok, let's analyse! A good starting point is to check if the auditor's and exployees' scores agree. There are many ways to do it. We can have a
WHERE clause and check if surveyor_score = auditor_score, or we can subtract the two scores and check if the result is 0.**/
SELECT
	auditor_report.location_id,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM
	auditor_report
JOIN
	visits
ON
	auditor_report.location_id = visits.location_id
JOIN
	water_quality
    ON visits.record_id = water_quality.record_id
WHERE auditor_report.true_water_source_score = water_quality.subjective_quality_score
LIMIT 10000;

/**You got 2505 rows right? Some of the locations were visited multiple times, so these records are duplicated here. To fix it, we set visits.visit_count
= 1 in the WHERE clause. Make sure you reference the alias you used for visits in the join.**/
SELECT
	auditor_report.location_id,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM
	auditor_report
JOIN
	visits
ON
	auditor_report.location_id = visits.location_id
JOIN
	water_quality
    ON visits.record_id = water_quality.record_id
WHERE auditor_report.true_water_source_score = water_quality.subjective_quality_score
AND visits.visit_count = 1
LIMIT 10000;

/**With the duplicates removed I now get 1518. What does this mean considering the auditor visited 1620 sites?
But that means that 102 records are incorrect. So let's look at those. You can do it by adding one character in the last query!**/
SELECT
	auditor_report.location_id,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM
	auditor_report
JOIN
	visits
ON
	auditor_report.location_id = visits.location_id
JOIN
	water_quality
    ON visits.record_id = water_quality.record_id
WHERE auditor_report.true_water_source_score != water_quality.subjective_quality_score
AND visits.visit_count = 1
LIMIT 10000;

/**So, to do this, we need to grab the type_of_water_source column from the water_source table and call it survey_source, using the
source_id column to JOIN. Also select the type_of_water_source from the auditor_report table, and call it auditor_source.**/
SELECT
	auditor_report.location_id,
    auditor_report.type_of_water_source AS auditor_source,
    water_source.type_of_water_source AS survey_source,
    visits.record_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM
	auditor_report
JOIN
	visits
ON
	auditor_report.location_id = visits.location_id
JOIN
	water_source
ON
	visits.source_id = water_source.source_id
JOIN
	water_quality
    ON visits.record_id = water_quality.record_id
WHERE auditor_report.true_water_source_score != water_quality.subjective_quality_score
AND visits.visit_count = 1
LIMIT 10000;

/**Once you're done, remove the columns and JOIN statement for water_sources again.In either case, the employees are the source of the errors, so let's JOIN the assigned_employee_id for all the people on our list from the visits
table to our query. Remember, our query shows the shows the 102 incorrect records, so when we join the employee data, we can see which
employees made these incorrect records.**/
SELECT
	auditor_report.location_id,
    visits.record_id,
    employee.assigned_employee_id,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM
	auditor_report
JOIN
	visits
ON
	auditor_report.location_id = visits.location_id
JOIN
	employee
ON
	visits.assigned_employee_id = employee.assigned_employee_id
JOIN
	water_quality
    ON visits.record_id = water_quality.record_id
WHERE auditor_report.true_water_source_score != water_quality.subjective_quality_score
AND visits.visit_count = 1
LIMIT 10000;

/**So now we can link the incorrect records to the employees who recorded them. The ID's don't help us to identify them. We have employees' names
stored along with their IDs, so let's fetch their names from the employees table instead of the ID's.**/
SELECT
	auditor_report.location_id,
    visits.record_id,
    employee.employee_name,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM
	auditor_report
JOIN
	visits
ON
	auditor_report.location_id = visits.location_id
JOIN
	employee
ON
	visits.assigned_employee_id = employee.assigned_employee_id
JOIN
	water_quality
    ON visits.record_id = water_quality.record_id
WHERE auditor_report.true_water_source_score != water_quality.subjective_quality_score
AND visits.visit_count = 1
LIMIT 10000;

/**Well this query is massive and complex, so maybe it is a good idea to save this as a CTE, so when we do more analysis, we can just call that CTE
like it was a table. Call it something like Incorrect_records. Once you are done, check if this query SELECT * FROM Incorrect_records, gets
the same table back.**/
WITH Incorrect_tables AS (
	SELECT
	auditor_report.location_id,
    visits.record_id,
    employee.employee_name,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM
	auditor_report
JOIN
	visits
ON
	auditor_report.location_id = visits.location_id
JOIN
	employee
ON
	visits.assigned_employee_id = employee.assigned_employee_id
JOIN
	water_quality
    ON visits.record_id = water_quality.record_id
WHERE auditor_report.true_water_source_score != water_quality.subjective_quality_score
AND visits.visit_count = 1
LIMIT 10000
)
SELECT *
FROM Incorrect_tables;

-- Let's first get a unique list of employees from this table. Think back to the start of your SQL journey to answer this one. I got 17 employees.
WITH Incorrect_tables AS (
	SELECT
	auditor_report.location_id,
    visits.record_id,
    employee.employee_name,
    auditor_report.true_water_source_score AS auditor_score,
    water_quality.subjective_quality_score AS surveyor_score
FROM
	auditor_report
JOIN
	visits
ON
	auditor_report.location_id = visits.location_id
JOIN
	employee
ON
	visits.assigned_employee_id = employee.assigned_employee_id
JOIN
	water_quality
    ON visits.record_id = water_quality.record_id
WHERE auditor_report.true_water_source_score != water_quality.subjective_quality_score
AND visits.visit_count = 1
LIMIT 10000
)
SELECT employee_name,
	count(auditor_score) AS err_count
FROM Incorrect_tables
GROUP BY employee_name;

/**So let's try to find all of the employees who have an above-average number of mistakes. Let's break it down into steps first:
1. We have to first calculate the number of times someone's name comes up. (we just did that in the previous query). Let's call it error_count.
2. Then, we need to calculate the average number of mistakes employees made. We can do that by taking the average of the previous query's
results.
3.Finaly we have to compare each employee's error_count with avg_error_count_per_empl. We will call this results set our suspect_list.
Remember that we can't use an aggregate result in WHERE, so we have to use avg_error_count_per_empl as a subquery.**/
WITH Incorrect_tables AS (
    SELECT
        auditor_report.location_id,
        visits.record_id,
        employee.employee_name,
        auditor_report.true_water_source_score AS auditor_score,
        water_quality.subjective_quality_score AS surveyor_score
    FROM
        auditor_report
    JOIN
        visits ON auditor_report.location_id = visits.location_id
    JOIN
        employee ON visits.assigned_employee_id = employee.assigned_employee_id
    JOIN
        water_quality ON visits.record_id = water_quality.record_id
    WHERE
        auditor_report.true_water_source_score != water_quality.subjective_quality_score
    AND visits.visit_count = 1
    LIMIT 10000
),
Error_Counts AS (
    SELECT
        employee_name,
        COUNT(auditor_score) AS err_count
    FROM
        Incorrect_tables
    GROUP BY
        employee_name
),
Avg_Error_Count AS (
    SELECT AVG(err_count) AS avg_err_count_per_empl
    FROM Error_Counts
)
SELECT
    e.employee_name,
    e.err_count
FROM
    Error_Counts e,
    Avg_Error_Count a
WHERE
    e.err_count > a.avg_err_count_per_empl
ORDER BY
    e.err_count DESC;
    
-- So, replace WITH with CREATE VIEW like this, and note that I added the statements column to this table in line 8 too:
CREATE VIEW Incorrect_records AS (
SELECT
auditor_report.location_id,
visits.record_id,
employee.employee_name,
auditor_report.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score,
auditor_report.statements AS statements
FROM
auditor_report
JOIN
visits
ON auditor_report.location_id = visits.location_id
JOIN
water_quality AS wq
ON visits.record_id = wq.record_id
JOIN
employee
ON employee.assigned_employee_id = visits.assigned_employee_id
WHERE
visits.visit_count =1
AND auditor_report.true_water_source_score != wq.subjective_quality_score);

WITH error_count AS ( -- This CTE calculates the number of mistakes each employee made
SELECT
employee_name,
COUNT(employee_name) AS number_of_mistakes
FROM
Incorrect_records
/*
Incorrect_records is a view that joins the audit report to the database
for records where the auditor and
employees scores are different*
/

GROUP BY
employee_name)
-- Query
SELECT * FROM error_count;
