--*CLEANING DATA
--Updating the employees' emails from null
--1. Replace the space in employee names with a dot
SELECT
    REPLACE(employee_name, ' ', '.')
from
    employee;
--2. Change all the letters to lowercase
select
	lower(replace(employee_name, ' ', '.'))
FROM
	employee;
--3. Add '@ndogowater.gov' to the above to make it a full email addres
select
	concat(
	lower(replace(employee_name, ' ', '.')), '@ndogowater.gov')
FROM
	employee;
--4. Update the email column with the above
Update employee
set email =	concat(	lower(replace(employee_name, ' ', '.')), '@ndogowater.gov');

--Cleaning the Phone number column that has 13characters(plus a trailing white space) instead of 12
--1. Checking the length
SELECT
    LENGTH(phone_number)
FROM
    employee;
--2. Trimming the white space
SELECT
	TRIM(phone_number)
FROM
	employee;
--3. Update the phone number column
Update employee
	set phone_number = TRIM(phone_number);

--* HONORING WORKERS
--Checking how many employees live in each town
select
	town_name,
    COUNT(employee_name)
From
	employee
group by
	town_name;
--Check employee_ids and use those to get the names, email and phone numbers of the three field surveyors with the most location visits.
--1.Finding the three employee_ids with the most visits
select
	assigned_employee_id,
    sum(visit_count) AS total_visits
from
	visits
group by
	assigned_employee_id
order by
	total_visits DESC
limit 3;
--2. Getting the names, email and phone numbers of the top 3 employees from the above
select
	employee_name,
    phone_number,
    email
from
	employee
WHERE assigned_employee_id IN (1, 30, 34);

--*ANALYZING LOCATIONS
--query that counts the number of records per town
select
	town_name,
    COUNT(location_id) AS records_per_town
FROM
	location
group by
	town_name;
--count the records per province.
select
	province_name,
    COUNT(location_id) AS records_per_province
FROM
	location
group by
	province_name;
--Query that counts the number of records in each province per town in descending order
select
	province_name,
    town_name,
    COUNT(location_id) AS records_per_town
FROM
	location
group by
	province_name,
    town_name
order by
	province_name ASC,
	town_name DESC;
--Query to look at the number of records for each location type
select
	location_type,
    count(location_id) AS number_of_sources
from
	location
group  by
	location_type;

--* ANALYZING WATER SOURCES
--Query to show how many people use the water_sources/in the survey
select
	sum(number_of_people_served) AS total_population
From
	water_source;
--Query to show the different type of water sources
select
	type_of_water_source,
	count(type_of_water_source) AS number_of_water_source
From
	water_source
group by
	type_of_water_source;
--Average number of people served by each water source
select
	type_of_water_source,
	Round(avg(number_of_people_served), 0) AS avg_pop
From
	water_source
group by
	type_of_water_source;
--Total population served by each water source from highest to lowest
select
	type_of_water_source,
	sum(number_of_people_served) AS pop_per_water_source
From
	water_source
group by
	type_of_water_source
order by
	pop_per_water_source DESC;
--Total population served by each water source from highest to lowest as a percentage
select
	type_of_water_source,
	round(
    ((sum(number_of_people_served)) /
    (SELECT sum(number_of_people_served) from water_source) * 100), 0)
    AS per_pop_per_water_source
From
	water_source
group by
	type_of_water_source
order by
	per_pop_per_water_source DESC;

--** START OF SOLUTIONS
--Rank water sources according to the number of people it serves
select
	type_of_water_source,
    sum(number_of_people_served) AS population_served,
    rank() over (order by sum(number_of_people_served) desc) AS rank_pop
From
	water_source
group by
	type_of_water_source
order by
	population_served desc;
--use a window function on the total people served column, converting it into a rank.
select
	source_id,
	type_of_water_source,
    number_of_people_served,
    rank() over (partition by type_of_water_source
    order by sum(number_of_people_served) desc) AS rank_pop
From
	water_source
group by
	source_id,
	type_of_water_source
order by
	type_of_water_source,
	number_of_people_served desc;

--** ANALYZING QUEUES
--Query to calculate how long the survey took place
SELECT
    DATEDIFF(MAX(time_of_record), MIN(time_of_record)) AS survey_duration
FROM
    visits;
--Query to get average queue time
SELECT
    AVG(NULLIF(time_in_queue, 0)) AS avg_queue_time
FROM
    visits;
--Query to find queue times aggregated across the different days of the week.
select
	dayname(time_of_record) AS day_of_week,
    round( avg(nullif(time_in_queue, 0)), 0) AS avg_queuetime
from
	visits
group by
	day_of_week;
--Query to show what time of day people collect water
select
	hour(time_of_record) AS hour_of_day,
    round( avg(nullif(time_in_queue, 0)), 0) AS avg_queuetime
from
	visits
group by
	hour_of_day
order by
	hour_of_day asc;
--Change the format of the hour to like 06:00 in the above query
select
	TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
    round( avg(nullif(time_in_queue, 0)), 0) AS avg_queuetime
from
	visits
group by
	hour_of_day
order by
	hour_of_day asc;
--Query to check the time in queue at different hours for each day
SELECT
TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
-- Sunday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
ELSE NULL
END
),0) AS Sunday,
-- Monday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue
ELSE NULL
END
),0) AS Monday,
-- Tuesday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue
ELSE NULL
END
),0) AS Tuesday,
-- Wednesday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue
ELSE NULL
END
),0) AS Wednesday,
-- Thursday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue
ELSE NULL
END
),0) AS Thursday,
-- Friday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue
ELSE NULL
END
),0) AS Friday,
-- Saturday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue
ELSE NULL
END
),0) AS Saturday
FROM
visits
WHERE
time_in_queue != 0 -- this excludes other sources with 0 queue times
GROUP BY
hour_of_day
ORDER BY
hour_of_day;
