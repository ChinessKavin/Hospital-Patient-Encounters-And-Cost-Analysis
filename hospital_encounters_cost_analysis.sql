USE hospital_db;

-- **ENCOUNTERS OVERVIEW**

-- 1. How many total encounters occurred each year?
SELECT 
    YEAR(start) AS year, 
    COUNT(id) AS total_encounters
FROM
    encounters
GROUP BY year
ORDER BY year;

-- 2. For each year, what percentage of all encounters belonged to each encounter class
-- (ambulatory, outpatient, wellness, urgent care, emergency, and inpatient)?
SELECT YEAR(start) AS year, 
		ROUND(SUM(CASE WHEN encounterclass = 'ambulatory' THEN 1 ELSE 0 END)/ COUNT(*) * 100,1) AS ambulatory,
        ROUND(SUM(CASE WHEN encounterclass = 'outpatient' THEN 1 ELSE 0 END)/ COUNT(*) * 100,1) AS outpatient,
        ROUND(SUM(CASE WHEN encounterclass = 'wellness' THEN 1 ELSE 0 END)/ COUNT(*) * 100,1) AS wellness,
        ROUND(SUM(CASE WHEN encounterclass = 'urgentcare' THEN 1 ELSE 0 END)/ COUNT(*) * 100,1) AS urgent_care,
        ROUND(SUM(CASE WHEN encounterclass = 'emergency' THEN 1 ELSE 0 END)/ COUNT(*) * 100,1) AS emergency,
        ROUND(SUM(CASE WHEN encounterclass = 'inpatient' THEN 1 ELSE 0 END)/ COUNT(*) * 100,1) AS inpatient
FROM 
	    encounters
GROUP BY year
ORDER BY year;


-- 3. What percentage of encounters were over 24 hours versus under 24 hours?
SELECT 
   ROUND ( SUM(CASE WHEN TIMESTAMPDIFF(HOUR, start, stop) < 24 THEN 1 ELSE 0 END)/ COUNT(*)  * 100, 1 )  AS pct_less_24,
   ROUND ( SUM(CASE WHEN TIMESTAMPDIFF(HOUR, start, stop) >= 24 THEN 1 ELSE 0 END)/ COUNT(*) * 100, 1 )  AS pct_greater_24
FROM
    encounters;
    

-- **COST & COVERAGE INSIGHTS**

-- a. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?
SELECT SUM(CASE WHEN  payer_coverage = 0 THEN 1 ELSE 0 END) AS total_zero_payer_coverage,
	   COUNT(*) AS total_player_coverage,
	   ROUND ( SUM(CASE WHEN payer_coverage = 0  THEN 1 ELSE 0 END)/ COUNT(*)  * 100, 1 )  AS pct_zero_payer_covarage
FROM 
	   encounters;



-- b. What are the top 10 most frequent procedures performed and the average base cost for each?
SELECT 
    code,
    description,
    COUNT(*) AS procedure_count,
    ROUND(AVG(base_cost), 2) AS avg_base_cost
FROM
    procedures
GROUP BY code , description
ORDER BY procedure_count DESC
LIMIT 10;


-- c. What are the top 10 procedures with the highest average base cost and the number of times they were performed?

SELECT 
    code,
    description,
    ROUND(AVG(base_cost), 2) AS avg_base_cost,
    COUNT(*) AS procedure_count
FROM
    procedures
GROUP BY code , description
ORDER BY avg_base_cost DESC
LIMIT 10;

-- d. What is the average total claim cost for encounters, broken down by payer?
SELECT 
    p.name, 
    ROUND(AVG(e.total_claim_cost), 2) AS avg_total_claim_cost
FROM
    encounters e
        JOIN
    payers p ON e.payer = p.id
GROUP BY p.name;

--  **PATIENT BEHAVIOR ANALYSIS**

-- a. How many unique patients were admitted each quarter over time?
SELECT 
    YEAR(start) AS year,
    QUARTER(start) AS quarter,
    COUNT(DISTINCT patient) AS unique_patients
FROM
    encounters
GROUP BY YEAR(start) , QUARTER(start)
ORDER BY year ASC;

-- b. How many patients were readmitted within 30 days of a previous encounter?

WITH next_date_cte AS ( SELECT patient,
	   start,
       stop,
       LEAD(start) OVER (PARTITION BY patient ORDER BY start) AS next_date
FROM encounters
ORDER BY patient,start)

SELECT COUNT(DISTINCT patient) AS total_readmitted_in_30days
FROM next_date_cte
WHERE next_date IS NOT NULL AND DATEDIFF(next_date, stop) < 30;

-- c. Which patients had the most readmissions?
WITH next_date_cte AS ( SELECT CONCAT(first, ' ', last)  AS patient_name,
	   patient,
	   start,
       stop,
       LEAD(start) OVER (PARTITION BY patient ORDER BY start) AS next_date
FROM encounters e 
JOIN patients p
ON e.patient = p.id
ORDER BY patient,start)

SELECT patient_name ,COUNT(*) AS num_readmissions
FROM next_date_cte
WHERE next_date IS NOT NULL AND DATEDIFF(next_date, stop) < 30
GROUP BY paitent_name
ORDER BY num_readmissions DESC;