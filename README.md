# Analysis of Hospital Patient Encounters and Cost Metrics Using SQL
![SQL Badge](https://img.shields.io/badge/SQL-MySQL-blue) 

## About
This project explores hospital patient encounters, cost metrics, and patient behavior trends using SQL. The analysis focuses on understanding utilization patterns, cost distribution, and readmission trends to inform healthcare operational decisions.  

See my **Medium blog post** for a more concise, narrative-style report: [Medium Blog](https://medium.com/@happinesskanife)  

Inspired by Maven Analytics, all SQL code and analysis were done independently.

## Analytical Thought Process

## 1. Encounters Overview

###  How many total encounters occurred each year?
- **Importance:** Identifies hospital volume trends over time, helping in staffing and resource planning.  
- **SQL Approach:** Used `COUNT(*)` grouped by `YEAR(start)`.

### For each year, what percentage of all encounters belonged to each encounter class?
- **Importance:** Highlights the most common types of hospital services (ambulatory, outpatient, wellness, urgent care, emergency, inpatient).  
- **SQL Approach:** Used `SUM(CASE WHEN encounterclass = ... THEN 1 ELSE 0 END) / COUNT(*) * 100`.

### What percentage of encounters were over 24 hours versus under 24 hours?
- **Importance:** Distinguishes between short visits and inpatient stays, useful for resource allocation and operational planning.  
- **SQL Approach:** Calculated `TIMESTAMPDIFF(HOUR, start, stop)` with conditional `CASE WHEN` and percentages.

---

## 2. Cost & Coverage Insights

### How many encounters had zero payer coverage, and what percentage of total encounters does this represent?
- **Importance:** Identifies financial exposure due to uninsured or self-pay patients.  
- **SQL Approach:** Used `SUM(CASE WHEN PAYER_COVERAGE = 0 THEN 1 ELSE 0 END)` and divided by total encounters.

### What are the top 10 most frequent procedures performed and the average base cost for each?
- **Importance:** Shows which procedures are most common and their average costs — helpful for inventory, staffing, and budgeting.  
- **SQL Approach:** Used `COUNT(*)` and `AVG(base_cost)` grouped by `code, description` and limited to top 10.

### What are the top 10 procedures with the highest average base cost and the number of times they were performed?
- **Importance:** Identifies resource-intensive and high-cost procedures for cost management and strategic planning.  
- **SQL Approach:** Similar aggregation but ordered by `AVG(base_cost)` descending.

### What is the average total claim cost for encounters, broken down by payer?
- **Importance:** Evaluates reimbursement patterns and identifies payers with higher/lower average claims.  
- **SQL Approach:** Joined `encounters` and `payers`, calculated `AVG(total_claim_cost)` grouped by payer.

---

## 3. Patient Behavior Analysis

### How many unique patients were admitted each quarter over time?
- **Importance:** Tracks patient admissions trends and seasonal patterns for operational planning.  
- **SQL Approach:** Used `COUNT(DISTINCT patient)` grouped by `YEAR(start)` and `QUARTER(start)`.

### How many patients were readmitted within 30 days of a previous encounter?
- **Importance:** Identifies potential quality-of-care issues or chronic patients needing follow-up.  
- **SQL Approach:** Used a CTE with `LEAD()` to find next admission dates and filtered by `DATEDIFF(next_date, stop) < 30`.

### Which patients had the most readmissions?
- **Importance:** Pinpoints patients with frequent hospitalizations to guide care management programs.  
- **SQL Approach:** Extended the previous CTE to join with patient names, grouped by patient, and counted readmissions.

---

## SQL Techniques Used
- **Aggregations:** `COUNT`, `SUM`, `AVG`  
- **Conditional logic:** `CASE WHEN` for percentages and conditional counts  
- **Window functions:** `LEAD()` for analyzing readmissions  
- **Joins:** `JOIN` for combining encounters with payers and patients  
- **Grouping & ordering:** `GROUP BY`, `ORDER BY` for trends and top-N queries  
- **NULL safety & rounding:** `ROUND()` and `NULLIF()` for clean percentages

---

## Key Insights
- Hospital volume trends vary year by year and by encounter type.  
- Most procedures are low-cost, high-frequency, while some are high-cost but less frequent.  
- Readmissions within 30 days reveal potential care gaps and highlight patients needing attention.  
- Payer analysis identifies cost distribution across insurance providers.
