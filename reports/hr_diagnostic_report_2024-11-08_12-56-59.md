# HR Resource Database Diagnostic Report
Generated on: 2024-11-08 12:56:59

## Table Structure and Data Overview

Checking table existence and structure:

[OK] Table 'employees' exists with 42 columns and 1450 rows
  Columns:
    - employee_id (integer)
    - full_name (character varying)
    - department (character varying)
    - position (character varying)
    - level (character varying)
    - hire_date (date)
    - city (character varying)
    - country (character varying)
    - region (character varying)
    - remote_work_ratio (double precision)
    - travel_percentage (double precision)
    - base_salary (double precision)
    - total_comp (double precision)
    - billing_rate (double precision)
    - utilization_target (double precision)
    - actual_utilization (double precision)
    - primary_specialization (character varying)
    - secondary_specialization (character varying)
    - industry_expertise (text)
    - certifications (text)
    - active_projects (integer)
    - avg_project_complexity (double precision)
    - avg_project_duration (double precision)
    - avg_team_size (double precision)
    - projects_on_time (double precision)
    - project_satisfaction (double precision)
    - training_hours (integer)
    - mentorship_hours (integer)
    - knowledge_sharing_score (double precision)
    - promotion_readiness (double precision)
    - engagement_score (double precision)
    - flight_risk (double precision)
    - retention_risk (character varying)
    - performance_score (double precision)
    - innovation_score (double precision)
    - delivery_quality (double precision)
    - manager_id (integer)
    - is_manager (boolean)
    - management_level (character varying)
    - direct_reports (integer)
    - span_of_control (character varying)
    - team_lead_projects (integer)

[OK] Table 'employee_analytics' exists with 8 columns and 1450 rows
  Columns:
    - employee_id (integer)
    - risk_level (character varying)
    - risk_factors (jsonb)
    - readiness_band (character varying)
    - readiness_metrics (jsonb)
    - performance_metrics (jsonb)
    - skill_metrics (jsonb)
    - updated_at (timestamp without time zone)

[OK] Table 'manager_analytics' exists with 7 columns and 130 rows
  Columns:
    - manager_id (integer)
    - management_level (character varying)
    - performance_category (character varying)
    - team_metrics (jsonb)
    - success_metrics (jsonb)
    - department_impact (jsonb)
    - updated_at (timestamp without time zone)

[OK] Table 'department_analytics' exists with 8 columns and 55 rows
  Columns:
    - department (character varying)
    - level (character varying)
    - position (character varying)
    - employee_count (integer)
    - avg_metrics (jsonb)
    - risk_distribution (jsonb)
    - readiness_distribution (jsonb)
    - performance_distribution (jsonb)

[OK] Table 'flight_risk_analysis' exists with 8 columns and 3 rows
  Columns:
    - risk_level (character varying)
    - employee_count (integer)
    - avg_tenure (double precision)
    - avg_performance (double precision)
    - avg_salary (double precision)
    - avg_utilization (double precision)
    - dept_distribution (jsonb)
    - common_specializations (jsonb)

[OK] Table 'manager_performance_insights' exists with 9 columns and 5 rows
  Columns:
    - management_level (character varying)
    - performance_category (character varying)
    - manager_count (integer)
    - avg_team_size (double precision)
    - avg_team_performance (double precision)
    - avg_team_satisfaction (double precision)
    - avg_team_retention (double precision)
    - dept_distribution (jsonb)
    - success_factors (jsonb)

[OK] Table 'promotion_readiness_analysis' exists with 8 columns and 6 rows
  Columns:
    - readiness_band (character varying)
    - level (character varying)
    - employee_count (integer)
    - avg_performance (double precision)
    - avg_knowledge_sharing (double precision)
    - avg_project_complexity (double precision)
    - critical_skills (jsonb)
    - dept_distribution (jsonb)

[OK] Table 'skills_gap_analysis' exists with 7 columns and 0 rows
  Columns:
    - department (character varying)
    - critical_skill (character varying)
    - current_coverage (double precision)
    - required_coverage (double precision)
    - gap_severity (character varying)
    - affected_projects (integer)
    - training_recommendations (jsonb)

[OK] Table 'project_performance_metrics' exists with 8 columns and 0 rows
  Columns:
    - complexity_level (integer)
    - department (character varying)
    - project_count (integer)
    - avg_duration (double precision)
    - success_rate (double precision)
    - avg_team_size (double precision)
    - key_success_factors (jsonb)
    - risk_factors (jsonb)

[OK] Table 'compensation_analysis' exists with 8 columns and 0 rows
  Columns:
    - department (character varying)
    - level (character varying)
    - performance_band (character varying)
    - employee_count (integer)
    - avg_base_salary (double precision)
    - avg_total_comp (double precision)
    - salary_range (jsonb)
    - market_position (double precision)


## Data Quality Analysis

Analyzing employee data quality:
  full_name: 0 nulls (0.00%)
  department: 0 nulls (0.00%)
  position: 0 nulls (0.00%)
  level: 0 nulls (0.00%)
  hire_date: 0 nulls (0.00%)
  base_salary: 0 nulls (0.00%)
  total_comp: 0 nulls (0.00%)
  primary_specialization: 0 nulls (0.00%)
  actual_utilization: 0 nulls (0.00%)
  performance_score: 0 nulls (0.00%)
  manager_id: 0 nulls (0.00%)

Numeric field ranges:

  remote_work_ratio:
    Range: 10.10 to 50.00
    Average: 28.52
    Out of range values: 0

  travel_percentage:
    Range: 0.00 to 54.90
    Average: 20.09
    Out of range values: 0

  utilization_target:
    Range: 50.00 to 90.00
    Average: 76.07
    Out of range values: 0

  actual_utilization:
    Range: 50.00 to 95.00
    Average: 71.57
    Out of range values: 0

  performance_score:
    Range: 2.50 to 4.50
    Average: 3.69
    Out of range values: 0

  flight_risk:
    Range: 15.00 to 93.00
    Average: 32.78
    Out of range values: 0

  promotion_readiness:
    Range: 0.00 to 92.00
    Average: 46.18
    Out of range values: 0

  knowledge_sharing_score:
    Range: 2.60 to 9.50
    Average: 6.51
    Out of range values: 0


## Analytics Consistency Check

Checking analytics consistency:

Employee Analytics:
  Total records: 1450
  Risk levels: 3
  Readiness bands: 4

Manager Analytics:
  Total records: 130
  Management levels: 2
  Performance categories: 3

Department Analytics:
  Total records: 55
  Unique departments: 5
  Unique levels: 3

Cross-table consistency checks:
  Employee coverage: 1450/1450 (100.00%)
  Manager coverage: 130/130 (100.00%)


## Metrics Distribution Analysis

Analyzing metrics distribution:

Client Services:
  entry:
    Employees: 20
    Avg Performance: 3.58
    Avg Salary: $103,700.00
    High Risk Employees: 0
    Ready for Promotion: 0
  entry:
    Employees: 28
    Avg Performance: 3.63
    Avg Salary: $101,678.57
    High Risk Employees: 0
    Ready for Promotion: 0
  entry:
    Employees: 15
    Avg Performance: 3.56
    Avg Salary: $109,466.67
    High Risk Employees: 0
    Ready for Promotion: 0
  mid:
    Employees: 28
    Avg Performance: 3.77
    Avg Salary: $172,892.86
    High Risk Employees: 0
    Ready for Promotion: 1
  mid:
    Employees: 39
    Avg Performance: 3.76
    Avg Salary: $180,384.62
    High Risk Employees: 0
    Ready for Promotion: 2
  mid:
    Employees: 38
    Avg Performance: 3.69
    Avg Salary: $187,605.26
    High Risk Employees: 0
    Ready for Promotion: 1
  senior:
    Employees: 18
    Avg Performance: 3.61
    Avg Salary: $331,944.44
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 1
    Avg Performance: 3.60
    Avg Salary: $384,000.00
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 24
    Avg Performance: 3.57
    Avg Salary: $328,916.67
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 23
    Avg Performance: 3.76
    Avg Salary: $322,043.48
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 1
    Avg Performance: 3.35
    Avg Salary: $397,000.00
    High Risk Employees: 0
    Ready for Promotion: 0

Design & UX:
  entry:
    Employees: 40
    Avg Performance: 3.77
    Avg Salary: $111,150.00
    High Risk Employees: 0
    Ready for Promotion: 0
  entry:
    Employees: 35
    Avg Performance: 3.67
    Avg Salary: $109,400.00
    High Risk Employees: 0
    Ready for Promotion: 0
  entry:
    Employees: 40
    Avg Performance: 3.66
    Avg Salary: $108,750.00
    High Risk Employees: 0
    Ready for Promotion: 0
  mid:
    Employees: 38
    Avg Performance: 3.69
    Avg Salary: $183,394.74
    High Risk Employees: 0
    Ready for Promotion: 1
  mid:
    Employees: 40
    Avg Performance: 3.68
    Avg Salary: $189,950.00
    High Risk Employees: 0
    Ready for Promotion: 1
  mid:
    Employees: 44
    Avg Performance: 3.77
    Avg Salary: $180,113.64
    High Risk Employees: 0
    Ready for Promotion: 1
  senior:
    Employees: 1
    Avg Performance: 3.64
    Avg Salary: $364,000.00
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 1
    Avg Performance: 3.92
    Avg Salary: $357,000.00
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 22
    Avg Performance: 3.67
    Avg Salary: $354,000.00
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 14
    Avg Performance: 3.71
    Avg Salary: $358,214.29
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 17
    Avg Performance: 3.56
    Avg Salary: $354,647.06
    High Risk Employees: 0
    Ready for Promotion: 0

Engineering Delivery:
  entry:
    Employees: 72
    Avg Performance: 3.60
    Avg Salary: $115,305.56
    High Risk Employees: 0
    Ready for Promotion: 0
  entry:
    Employees: 73
    Avg Performance: 3.62
    Avg Salary: $111,424.66
    High Risk Employees: 0
    Ready for Promotion: 0
  entry:
    Employees: 73
    Avg Performance: 3.70
    Avg Salary: $117,219.18
    High Risk Employees: 0
    Ready for Promotion: 0
  mid:
    Employees: 46
    Avg Performance: 3.72
    Avg Salary: $190,000.00
    High Risk Employees: 6
    Ready for Promotion: 2
  mid:
    Employees: 45
    Avg Performance: 3.77
    Avg Salary: $197,800.00
    High Risk Employees: 0
    Ready for Promotion: 1
  mid:
    Employees: 54
    Avg Performance: 3.72
    Avg Salary: $189,518.52
    High Risk Employees: 2
    Ready for Promotion: 1
  senior:
    Employees: 1
    Avg Performance: 3.53
    Avg Salary: $322,000.00
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 29
    Avg Performance: 3.72
    Avg Salary: $357,620.69
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 21
    Avg Performance: 3.76
    Avg Salary: $359,523.81
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 1
    Avg Performance: 3.96
    Avg Salary: $368,000.00
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 23
    Avg Performance: 3.58
    Avg Salary: $371,478.26
    High Risk Employees: 1
    Ready for Promotion: 0

Product Architecture:
  entry:
    Employees: 35
    Avg Performance: 3.60
    Avg Salary: $122,685.71
    High Risk Employees: 1
    Ready for Promotion: 0
  entry:
    Employees: 21
    Avg Performance: 3.73
    Avg Salary: $124,714.29
    High Risk Employees: 0
    Ready for Promotion: 0
  entry:
    Employees: 22
    Avg Performance: 3.76
    Avg Salary: $113,409.09
    High Risk Employees: 0
    Ready for Promotion: 0
  mid:
    Employees: 51
    Avg Performance: 3.64
    Avg Salary: $200,784.31
    High Risk Employees: 0
    Ready for Promotion: 3
  mid:
    Employees: 53
    Avg Performance: 3.69
    Avg Salary: $202,830.19
    High Risk Employees: 1
    Ready for Promotion: 1
  mid:
    Employees: 42
    Avg Performance: 3.71
    Avg Salary: $202,047.62
    High Risk Employees: 1
    Ready for Promotion: 1
  senior:
    Employees: 11
    Avg Performance: 3.59
    Avg Salary: $346,272.73
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 1
    Avg Performance: 3.67
    Avg Salary: $328,000.00
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 1
    Avg Performance: 3.81
    Avg Salary: $444,000.00
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 22
    Avg Performance: 3.70
    Avg Salary: $355,227.27
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 18
    Avg Performance: 3.76
    Avg Salary: $379,500.00
    High Risk Employees: 1
    Ready for Promotion: 0

Product Strategy:
  entry:
    Employees: 22
    Avg Performance: 3.86
    Avg Salary: $113,227.27
    High Risk Employees: 0
    Ready for Promotion: 0
  entry:
    Employees: 20
    Avg Performance: 3.87
    Avg Salary: $112,850.00
    High Risk Employees: 0
    Ready for Promotion: 0
  entry:
    Employees: 22
    Avg Performance: 3.59
    Avg Salary: $114,636.36
    High Risk Employees: 0
    Ready for Promotion: 0
  mid:
    Employees: 29
    Avg Performance: 3.70
    Avg Salary: $196,862.07
    High Risk Employees: 0
    Ready for Promotion: 2
  mid:
    Employees: 28
    Avg Performance: 3.66
    Avg Salary: $195,571.43
    High Risk Employees: 0
    Ready for Promotion: 0
  mid:
    Employees: 20
    Avg Performance: 3.60
    Avg Salary: $199,650.00
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 27
    Avg Performance: 3.73
    Avg Salary: $357,592.59
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 20
    Avg Performance: 3.76
    Avg Salary: $361,000.00
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 1
    Avg Performance: 3.61
    Avg Salary: $331,000.00
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 18
    Avg Performance: 3.86
    Avg Salary: $372,944.44
    High Risk Employees: 0
    Ready for Promotion: 0
  senior:
    Employees: 1
    Avg Performance: 3.95
    Avg Salary: $408,000.00
    High Risk Employees: 0
    Ready for Promotion: 0

Manager Level Distribution:

  mid:
    Average: 82 managers (Avg Team Perf: 3.56)
    Below: 9 managers (Avg Team Perf: 3.76)
    Top: 10 managers (Avg Team Perf: 3.76)

  senior:
    Average: 25 managers (Avg Team Perf: 3.61)
    Top: 4 managers (Avg Team Perf: 3.73)

