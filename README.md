# Water Quality and Infrastructure Analysis
This project focuses on analyzing water quality data, infrastructure improvements and employee performance for water sources at various locations. The project uses SQL to join and filetr data across multiple tables, identifying problematic sources and track project progress. It also uses Power Bi to visualise the data by showing the water queues composition by gender, consider new crime rate data and report on the various water projects at national and provincial levels. 
# Project Overview
The project is centered on:
  * Evaluating water sources based on pollution results.
  * Identifying infrastructure needs for various water source types.
  * Tracking employee data to assess improvement efforts.
  * Generating recommendations for improvement (e.g installing filters, diagnosing infrastructure issues, etc)
# Database Structure
The project has the following tables;
 * visits: 
    
    * visits: Contains information on visits to each water source, including queue times and assigned employees.
    * well_pollution: Tracks pollution results for well water sources.
    water_source: Stores metadata on each water source, including type and population served.
    location: Stores location-specific information, including town, province, and address.
    Project_progress: Tracks improvement projects for each source, including status and comments.
