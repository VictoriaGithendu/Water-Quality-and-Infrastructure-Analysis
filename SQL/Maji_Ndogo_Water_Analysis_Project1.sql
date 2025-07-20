CREATE md_water_services;
USE md_water_services;
-- Show tables in the database
SHOW tables;

-- View what is contained in each table
select * from employee;
select * from location;
select * from visits;

--write a SQL query to find all the unique types of water sources.
select distinct type_of_water_source from water_source;

--Write an SQL query that retrieves all records where the time_in_queue is more than some crazy time, say 500 min.
Select * from visits
where time_in_queue > 500;

--Query to find records where the subject_quality_score is 10 -- only looking for home taps -- and where the source was visited a second time.
Select * from water_quality
where subjective_quality_score = 10
AND visit_count = 2;

--Query that checks if the results is Clean but the biological column is > 0.01.
Select * from well_pollution
where results = 'Clean'
AND biological > 0.01;

--Query that checks if the results is Clean but the biological column is > 0.01 and has clean in its description.
Select * from well_pollution
where results = 'Clean'
AND biological > 0.01
AND description LIKE '%Clean%';

--Query to update descriptions that mistakenly mention `Clean Bacteria: E. coli` to `Bacteria: E. coli`
UPDATE well_pollution
SET description = 'Bacteria: E. coli'
WHERE results = 'Clean'
AND description = 'Clean Bacteria: E. coli'
AND biological > 0.01;

--Query to update the descriptions that mistakenly mention `Clean Bacteria: Giardia Lamblia` to `Bacteria: Giardia Lamblia
UPDATE well_pollution
SET description = 'Bacteria: Giardia Lamblia'
WHERE results = 'Clean'
AND description = 'Clean Bacteria: Giardia Lamblia'
AND biological > 0.01;

-- Query to update the `result` to `Contaminated: Biological` where `biological` is greater than 0.01 plus current results is `Clean`
UPDATE well_pollution
SET results = 'Contaminated: Biological'
WHERE results = 'Clean'
AND biological > 0.01;

--What is the address of Bello Azibo?
SELECT address FROM employee
where employee_name = 'Bello Azibo';

--What is the name and phone number of our Microbiologist?
SELECT employee_name, phone_number FROM employee
where position = 'Micro Biologist';

--Query to find the source_id of the water source shared by the most number of people? Hint: Use a comparison operator
select source_id from water_source
where number_of_people_served = (
select max(number_of_people_served)
from water_source
);

--Query to find the  population of Maji Ndogo?
Select pop_n from global_water_access
where name = 'Maji Ndogo';

--Query to return records of employees who are Civil Engineers residing in Dahabu or living on an avenue?
Select * from employee
where position = 'Civil Engineer'
AND (address like '%Avenue%' OR town_name = 'Dahabu');

--Create a query to identify potentially suspicious field workers based on an anonymous tip. This is the description we are given:
    -- The employee’s phone number contained the digits 86 or 11. 
    -- The employee’s last name started with either an A or an M. 
    -- The employee was a Field Surveyor.
SELECT *
FROM employee
WHERE position = 'Field Surveyor'
  AND (phone_number LIKE '%86%' OR phone_number LIKE '%11%')
  AND (
    SUBSTRING_INDEX(employee_name, ' ', -1) LIKE 'A%'
    OR
    SUBSTRING_INDEX(employee_name, ' ', -1) LIKE 'M%'
  );

--Query that shows pollution samples that has biological contamination
ELECT *
FROM well_pollution
WHERE description LIKE 'Clean_%' OR results = 'Clean' AND biological < 0.01;

--Which query will identify the records with a quality score of 10, visited more than once?
Select * from water_quality
where visit_count >= 2
AND subjective_quality_score = 10;

--Query to correct the phone number for the employee named 'Bello Azibo'. The correct number is +99643864786
UPDATE employee
SET phone_number = '+99643864786'
WHERE employee_name = 'Bello Azibo'; 