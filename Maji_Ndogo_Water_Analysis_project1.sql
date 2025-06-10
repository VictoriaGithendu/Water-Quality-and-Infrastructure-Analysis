-- Create the answers table
CREATE TABLE IF NOT EXISTS sql_integrated_project1 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question VARCHAR(255) NOT NULL,
    answer TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- What is the address of Bello Azibo?
SELECT employee_name, address FROM md_water_services.employee
WHERE employee_name = 'Bello Azibo';

-- What is the name and phone number of our Microbiologist?
SELECT employee_name, phone_number FROM md_water_services.employee
WHERE position = 'Micro Biologist';

-- What is the source_id of the water source shared by the most number of people? Hint: Use a comparison operator.**/
SELECT source_id FROM md_water_services.water_source
WHERE number_of_people_served = (
    SELECT MAX(number_of_people_served)
    FROM water_source
);

/** What is the population of Maji Ndogo? 
Hint: Start by searching the data_dictionary table for the word 'population'.**/
SELECT * FROM md_water_services.data_dictionary
WHERE column_name = 'pop_n';

SELECT * FROM md_water_services.global_water_access;

SELECT name, pop_n FROM md_water_services.global_water_access
WHERE name = 'Maji Ndogo';

 -- Which SQL query returns records of employees who are Civil Engineers residing in Dahabu or living on an avenue?
 SELECT *
FROM employee
WHERE position = 'Civil Engineer' AND (province_name = 'Dahabu' OR address LIKE '%Avenue%'); 

 /**Create a query to identify potentially suspicious field workers based on an anonymous tip. This is the description we are given:
    The employee’s phone number contained the digits 86 or 11. 
    The employee’s last name started with either an A or an M. 
    The employee was a Field Surveyor.**/
    SELECT * FROM md_water_services.employee
WHERE position = 'Field Surveyor'
  AND (phone_number LIKE '%86%' OR phone_number LIKE '%11%')
  AND (SUBSTRING_INDEX(employee_name, ' ', -1) LIKE 'A%' OR SUBSTRING_INDEX(employee_name, ' ', -1) LIKE 'M%');

-- What is the result of the following query? Choose the most appropriate description of the results set.
SELECT *
FROM well_pollution
WHERE description LIKE 'Clean_%' OR results = 'Clean' AND biological < 0.01;

/**You have ben given a task to correct the phone number for the employee named 'Bello Azibo'.
 The correct number is +99643864786. Write the SQL query to accomplish this. Note:
 Running these queries on the employee table may create issues later, so use the knowledge you have learned to avoid that**/
  SELECT * 
FROM well_pollution
WHERE description
IN ('Parasite: Cryptosporidium', 'biologically contaminated')
OR (results = 'Clean' AND biological > 0.01);
