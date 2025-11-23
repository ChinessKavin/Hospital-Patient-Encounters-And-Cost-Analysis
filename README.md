# Hospital Patient Encounters And Cost Analysis Using SQL

This project explores hospital patient encounters, costs, and behavior trends using SQL. The goal is to extract actionable insights from hospital encounter and procedure data to understand utilization patterns, cost distribution, and patient behavior over time.

## Analytical Thought Process

### 1. Encounters Overview

 - Calculate the total encounters per year to understand hospital volume trends.
 - Analyze percentage of encounters by type (ambulatory, outpatient, wellness, urgent care, emergency, inpatient) to identify which services dominate.
 - Determine percentage of encounters lasting over 24 hours, highlighting inpatient versus short visits.

### 2. Cost & Coverage Insights

  - Identify encounters with zero payer coverage to evaluate financial exposure.
  - Find the most frequent procedures and calculate average base cost to spot high-volume services.
  - Identify highest cost procedures to understand resource-intensive treatments.
  - Calculate average claim costs by payer to evaluate coverage and reimbursement patterns.

### 3. Patient Behavior Analysis

  - Track unique patient admissions per quarter to visualize trends over time.
  - Analyze readmissions within 30 days to monitor quality of care and follow-up effectiveness.
  - Identify patients with the most readmissions to highlight potential chronic cases or care gaps.

### SQL Approach

  - Utilized aggregations (COUNT, SUM, AVG) and conditional logic (CASE WHEN) for calculating percentages and counts.
  - Leveraged window functions (LEAD) for tracking patient readmissions.
  - Designed queries to be portable across different SQL databases while remaining clear and professional.

## Outcome
This analysis provides a comprehensive view of hospital operations, costs, and patient behavior, and demonstrates strong analytical thinking and SQL skills suitable for healthcare analytics or business intelligence projects.
