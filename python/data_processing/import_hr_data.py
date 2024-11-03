import pandas as pd
import psycopg2
from psycopg2 import sql
import sys
from datetime import datetime
import json

def create_hr_database():
    """Create HR database with enhanced tables for better analytics"""
    conn = psycopg2.connect(
        dbname="hr_resource_db",
        user="postgres",
        password="1234",
        host="localhost",
        port="5432"
    )
    cur = conn.cursor()

    # Create main employees table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS employees (
        employee_id INTEGER PRIMARY KEY,
        name VARCHAR(100),
        department VARCHAR(50),
        position VARCHAR(100),
        hire_date DATE,
        termination_date DATE,
        termination_reason VARCHAR(100),
        employment_status VARCHAR(20),
        date_of_birth DATE,
        age INTEGER,
        gender VARCHAR(1),
        ethnicity VARCHAR(50),
        salary NUMERIC(10,2),
        performance_rating VARCHAR(50),
        recruitment_source VARCHAR(50),
        education_level VARCHAR(50),
        years_experience DECIMAL(4,1),
        previous_companies VARCHAR(20),
        remote_work_status VARCHAR(20)
    )
    """)

    # Create performance_metrics table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS performance_metrics (
        performance_id SERIAL PRIMARY KEY,
        employee_id INTEGER REFERENCES employees(employee_id),
        project_completion_rate DECIMAL(5,2),
        work_satisfaction DECIMAL(3,1),
        productivity DECIMAL(5,1),
        engagement_score DECIMAL(3,2),
        absence_days INTEGER,
        last_review_date DATE,
        overtime_hours INTEGER,
        training_hours_completed INTEGER,
        team_size INTEGER,
        projects_completed INTEGER,
        certifications_count INTEGER,
        team_collaboration_score DECIMAL(3,1)
    )
    """)

    # Create sales_metrics table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS sales_metrics (
        sales_id SERIAL PRIMARY KEY,
        employee_id INTEGER REFERENCES employees(employee_id),
        quota_attainment DECIMAL(5,2),
        lead_conversion_rate DECIMAL(4,1),
        client_retention_rate DECIMAL(4,1),
        deals_closed INTEGER,
        average_contract_value DECIMAL(10,2),
        client_satisfaction_score DECIMAL(3,1),
        sales_target_percent DECIMAL(5,2),
        prospecting_hours INTEGER,
        repeat_business_percent DECIMAL(4,1)
    )
    """)

    # Create hr_metrics table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS hr_metrics (
        hr_id SERIAL PRIMARY KEY,
        employee_id INTEGER REFERENCES employees(employee_id),
        time_to_fill DECIMAL(4,1),
        candidates_hired INTEGER,
        retention_rate DECIMAL(4,1),
        employee_satisfaction_score DECIMAL(3,1),
        training_programs_managed INTEGER,
        policy_compliance_rate DECIMAL(4,1),
        disputes_resolved INTEGER,
        onboarding_effectiveness_score DECIMAL(5,2),
        exit_interviews_completed INTEGER,
        benefits_administration_score DECIMAL(4,1),
        recruitment_cost_per_hire DECIMAL(7,2),
        employee_relations_score DECIMAL(3,1)
    )
    """)

    # Create it_support_metrics table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS it_support_metrics (
        it_id SERIAL PRIMARY KEY,
        employee_id INTEGER REFERENCES employees(employee_id),
        tickets_resolved INTEGER,
        average_resolution_time DECIMAL(3,1),
        first_call_resolution_rate DECIMAL(4,1),
        system_uptime_managed DECIMAL(5,2),
        security_incidents_handled INTEGER,
        customer_satisfaction_score DECIMAL(3,1)
    )
    """)

    # Create engineering_metrics table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS engineering_metrics (
        engineering_id SERIAL PRIMARY KEY,
        employee_id INTEGER REFERENCES employees(employee_id),
        bugs_per_project DECIMAL(3,1),
        code_review_scores TEXT,
        commits_per_week INTEGER,
        pull_requests_opened INTEGER,
        pull_requests_accepted INTEGER,
        technical_debt_score DECIMAL(3,1),
        documentation_contribution DECIMAL(4,1),
        system_uptime DECIMAL(5,2),
        on_call_incidents INTEGER,
        deployment_frequency INTEGER,
        code_coverage DECIMAL(4,1)
    )
    """)

    # Create employee_certifications table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS employee_certifications (
        cert_id SERIAL PRIMARY KEY,
        employee_id INTEGER,
        certification_name VARCHAR(100),
        UNIQUE(employee_id, certification_name),
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
    )
    """)

    # Create cross_functional_metrics table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS cross_functional_metrics (
        cross_func_id SERIAL PRIMARY KEY,
        employee_id INTEGER REFERENCES employees(employee_id),
        cross_team_projects INTEGER,
        peer_reviews_completed INTEGER,
        mentoring_hours INTEGER
    )
    """)

    # Create demographic_analysis table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS demographic_analysis (
        analysis_id SERIAL PRIMARY KEY,
        department VARCHAR(50),
        gender_ratio NUMERIC(5,2),
        avg_age NUMERIC(5,2),
        diversity_index NUMERIC(5,2),
        avg_tenure NUMERIC(5,2),
        generation_distribution JSON,
        updated_at TIMESTAMP
    )
    """)

    # Create salary_bands table
    cur.execute("""
    CREATE TABLE IF NOT EXISTS salary_bands (
        band_id SERIAL PRIMARY KEY,
        department VARCHAR(50),
        position_level VARCHAR(50),
        min_salary NUMERIC(10,2),
        max_salary NUMERIC(10,2),
        median_salary NUMERIC(10,2),
        percentile_25 NUMERIC(10,2),
        percentile_75 NUMERIC(10,2)
    )
    """)

    conn.commit()
    return conn, cur

def safe_numeric(value):
    """Safely convert to numeric, handling NaN values."""
    try:
        return float(value) if pd.notna(value) else None
    except:
        return None

def safe_date(value):
    """Safely convert date values."""
    if pd.isna(value) or value == 'N/A-StillEmployed':
        return None
    return value

def insert_data(sheets, conn):
    """Insert data into all tables"""
    cur = conn.cursor()
    
    # Insert into employees table
    for _, row in sheets['employees'].iterrows():
        try:
            cur.execute("""
                INSERT INTO employees (
                    employee_id, name, department, position, hire_date,
                    termination_date, termination_reason, employment_status,
                    date_of_birth, age, gender, ethnicity, salary,
                    performance_rating, recruitment_source, education_level,
                    years_experience, previous_companies, remote_work_status
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 
                         %s, %s, %s, %s, %s, %s)
                ON CONFLICT (employee_id) DO NOTHING
            """, (
                int(row['employee_id']),
                row['name'],
                row['department'],
                row['position'],
                safe_date(row['hire_date']),
                safe_date(row['termination_date']),
                row.get('termination_reason'),
                row['employment_status'],
                safe_date(row['date_of_birth']),
                int(row['age']) if pd.notna(row['age']) else None,
                row['gender'],
                row['ethnicity'],
                safe_numeric(row['salary']),
                row.get('performance_rating'),
                row.get('recruitment_source'),
                row.get('education_level'),
                safe_numeric(row.get('years_experience')),
                row.get('previous_companies'),
                row.get('remote_work_status')
            ))
        except Exception as e:
            print(f"Error inserting employee {row['employee_id']}: {e}")

    # Insert data for each metrics table
    table_mappings = {
        'performance_metrics': performance_metrics,
        'sales_metrics': sales_metrics,
        'hr_metrics': hr_metrics,
        'it_support_metrics': it_support_metrics,
        'engineering_metrics': engineering_metrics,
        'employee_certifications': employee_certifications,
        'cross_functional_metrics': cross_functional_metrics
    }

    for table_name, df in sheets.items():
        if table_name in table_mappings:
            try:
                table_mappings[table_name](df, cur)
            except Exception as e:
                print(f"Error inserting {table_name}: {e}")

    conn.commit()
    cur.close()

def performance_metrics(df, cur):
    for _, row in df.iterrows():
        cur.execute("""
            INSERT INTO performance_metrics (
                employee_id, project_completion_rate, work_satisfaction,
                productivity, engagement_score, absence_days, last_review_date,
                overtime_hours, training_hours_completed, team_size,
                projects_completed, certifications_count, team_collaboration_score
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            int(row['employee_id']),
            safe_numeric(row['project_completion_rate']),
            safe_numeric(row['work_satisfaction']),
            safe_numeric(row['productivity']),
            safe_numeric(row['engagement_score']),
            safe_numeric(row['absence_days']),
            safe_date(row['last_review_date']),
            safe_numeric(row['overtime_hours']),
            safe_numeric(row['training_hours_completed']),
            safe_numeric(row['team_size']),
            safe_numeric(row['projects_completed']),
            safe_numeric(row['certifications_count']),
            safe_numeric(row['team_collaboration_score'])
        ))

def sales_metrics(df, cur):
    for _, row in df.iterrows():
        cur.execute("""
            INSERT INTO sales_metrics (
                employee_id, quota_attainment, lead_conversion_rate,
                client_retention_rate, deals_closed, average_contract_value,
                client_satisfaction_score, sales_target_percent,
                prospecting_hours, repeat_business_percent
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            int(row['employee_id']),
            safe_numeric(row['quota_attainment']),
            safe_numeric(row['lead_conversion_rate']),
            safe_numeric(row['client_retention_rate']),
            safe_numeric(row['deals_closed']),
            safe_numeric(row['average_contract_value']),
            safe_numeric(row['client_satisfaction_score']),
            safe_numeric(row['sales_target_percent']),
            safe_numeric(row['prospecting_hours']),
            safe_numeric(row['repeat_business_percent'])
        ))

def hr_metrics(df, cur):
    for _, row in df.iterrows():
        cur.execute("""
            INSERT INTO hr_metrics (
                employee_id, time_to_fill, candidates_hired, retention_rate,
                employee_satisfaction_score, training_programs_managed,
                policy_compliance_rate, disputes_resolved,
                onboarding_effectiveness_score, exit_interviews_completed,
                benefits_administration_score, recruitment_cost_per_hire,
                employee_relations_score
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            int(row['employee_id']),
            safe_numeric(row['time_to_fill']),
            safe_numeric(row['candidates_hired']),
            safe_numeric(row['retention_rate']),
            safe_numeric(row['employee_satisfaction_score']),
            safe_numeric(row['training_programs_managed']),
            safe_numeric(row['policy_compliance_rate']),
            safe_numeric(row['disputes_resolved']),
            safe_numeric(row['onboarding_effectiveness_score']),
            safe_numeric(row['exit_interviews_completed']),
            safe_numeric(row['benefits_administration_score']),
            safe_numeric(row['recruitment_cost_per_hire']),
            safe_numeric(row['employee_relations_score'])
        ))

def it_support_metrics(df, cur):
    for _, row in df.iterrows():
        cur.execute("""
            INSERT INTO it_support_metrics (
                employee_id, tickets_resolved, average_resolution_time,
                first_call_resolution_rate, system_uptime_managed,
                security_incidents_handled, customer_satisfaction_score
            ) VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (
            int(row['employee_id']),
            safe_numeric(row['tickets_resolved']),
            safe_numeric(row['average_resolution_time']),
            safe_numeric(row['first_call_resolution_rate']),
            safe_numeric(row['system_uptime_managed']),
            safe_numeric(row['security_incidents_handled']),
            safe_numeric(row['customer_satisfaction_score'])
        ))

def engineering_metrics(df, cur):
    for _, row in df.iterrows():
        cur.execute("""
            INSERT INTO engineering_metrics (
                employee_id, bugs_per_project, code_review_scores,
                commits_per_week, pull_requests_opened, pull_requests_accepted,
                technical_debt_score, documentation_contribution, system_uptime,
                on_call_incidents, deployment_frequency, code_coverage
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            int(row['employee_id']),
            safe_numeric(row['bugs_per_project']),
            row['code_review_scores'],
            safe_numeric(row['commits_per_week']),
            safe_numeric(row['pull_requests_opened']),
            safe_numeric(row['pull_requests_accepted']),
            safe_numeric(row['technical_debt_score']),
            safe_numeric(row['documentation_contribution']),
            safe_numeric(row['system_uptime']),
            safe_numeric(row['on_call_incidents']),
            safe_numeric(row['deployment_frequency']),
            safe_numeric(row['code_coverage'])
        ))

def employee_certifications(df, cur):
    for _, row in df.iterrows():
        cur.execute("""
            INSERT INTO employee_certifications (
                employee_id, certification_name
            ) VALUES (%s, %s)
            ON CONFLICT (employee_id, certification_name) DO NOTHING
        """, (
            int(row['employee_id']),
            row['certification_name']
        ))

def cross_functional_metrics(df, cur):
    for _, row in df.iterrows():
        cur.execute("""
            INSERT INTO cross_functional_metrics (
                employee_id, cross_team_projects,
                peer_reviews_completed, mentoring_hours
            ) VALUES (%s, %s, %s, %s)
        """, (
            int(row['employee_id']),
            safe_numeric(row['cross_team_projects']),
            safe_numeric(row['peer_reviews_completed']),
            safe_numeric(row['mentoring_hours'])
        ))

if __name__ == "__main__":
    try:
        print("Starting enhanced HR data import process...")

        # Create database and tables
        conn, cur = create_hr_database()

        # Read Excel data
        excel_file = "C:/Users/govar/OneDrive/Documents/HRM/data/raw/hr_data.xlsx"
        sheets = {
            'employees': pd.read_excel(excel_file, sheet_name='employees'),
            'performance_metrics': pd.read_excel(excel_file, sheet_name='performance_metrics'),
            'sales_metrics': pd.read_excel(excel_file, sheet_name='sales_metrics'),
            'hr_metrics': pd.read_excel(excel_file, sheet_name='hr_metrics'),
            'it_support_metrics': pd.read_excel(excel_file, sheet_name='it_support_metrics'),
            'engineering_metrics': pd.read_excel(excel_file, sheet_name='engineering_metrics'),
            'employee_certifications': pd.read_excel(excel_file, sheet_name='employee_certifications'),
            'cross_functional_metrics': pd.read_excel(excel_file, sheet_name='cross_functional_metrics')
        }
        
        # Insert data into tables
        insert_data(sheets, conn)
        
        print("\nHR data import process completed successfully!")

    except Exception as e:
        print(f"Error during import process: {e}")
        sys.exit(1)
    finally:
        if 'conn' in locals():
            conn.close()