import pandas as pd
import psycopg2
import os
import sys
from datetime import datetime

def create_hr_database():
    """Create database connection and initialize all tables"""
    try:
        conn = psycopg2.connect(
            dbname="hr_resource_db",
            user="postgres",
            password="1234",
            host="localhost",
            port="5432"
        )
        print("Successfully connected to database")
        cur = conn.cursor()
        
        # Core employee table
        cur.execute("""
            CREATE TABLE IF NOT EXISTS employees (
                employee_id INTEGER PRIMARY KEY,
                full_name VARCHAR(100),
                department VARCHAR(50),
                position VARCHAR(100),
                position_level VARCHAR(20),
                hire_date DATE,
                city VARCHAR(50),
                country VARCHAR(50),
                region VARCHAR(20),
                remote_work_ratio DECIMAL(5,2),
                travel_percentage DECIMAL(5,2),
                primary_specialization VARCHAR(50),
                secondary_specialization VARCHAR(50),
                industry_expertise TEXT
            )
        """)
        
        # Performance and metrics tables
        cur.execute("""
            CREATE TABLE IF NOT EXISTS performance_metrics (
                metric_id SERIAL PRIMARY KEY,
                employee_id INTEGER REFERENCES employees(employee_id),
                performance_score DECIMAL(4,2),
                innovation_score DECIMAL(5,2),
                delivery_quality DECIMAL(5,2),
                engagement_score DECIMAL(4,2),
                knowledge_sharing_score DECIMAL(4,2),
                UNIQUE(employee_id)
            )
        """)
        
        cur.execute("""
            CREATE TABLE IF NOT EXISTS project_metrics (
                project_id SERIAL PRIMARY KEY,
                employee_id INTEGER REFERENCES employees(employee_id),
                active_projects INTEGER,
                avg_project_complexity DECIMAL(3,1),
                avg_project_duration DECIMAL(4,1),
                avg_team_size DECIMAL(4,1),
                projects_on_time DECIMAL(5,2),
                project_satisfaction DECIMAL(3,1),
                team_lead_projects INTEGER,
                UNIQUE(employee_id)
            )
        """)
        
        cur.execute("""
            CREATE TABLE IF NOT EXISTS development_metrics (
                dev_id SERIAL PRIMARY KEY,
                employee_id INTEGER REFERENCES employees(employee_id),
                training_hours INTEGER,
                mentorship_hours INTEGER,
                direct_reports INTEGER,
                UNIQUE(employee_id)
            )
        """)
        
        # Risk and management tables
        cur.execute("""
            CREATE TABLE IF NOT EXISTS risk_assessment (
                risk_id SERIAL PRIMARY KEY,
                employee_id INTEGER REFERENCES employees(employee_id),
                flight_risk INTEGER,
                retention_risk VARCHAR(20),
                promotion_readiness DECIMAL(5,2),
                last_promotion_date DATE,
                risk_factors TEXT[],
                UNIQUE(employee_id)
            )
        """)
        
        cur.execute("""
            CREATE TABLE IF NOT EXISTS management_info (
                employee_id INTEGER PRIMARY KEY REFERENCES employees(employee_id),
                is_manager BOOLEAN,
                management_level VARCHAR(20),
                span_of_control INTEGER,
                management_premium NUMERIC(10,2),
                span_premium NUMERIC(10,2),
                total_comp NUMERIC(10,2)
            )
        """)
        
        # Compensation and certification tables
        cur.execute("""
            CREATE TABLE IF NOT EXISTS compensation_metrics (
                comp_id SERIAL PRIMARY KEY,
                employee_id INTEGER REFERENCES employees(employee_id),
                base_salary NUMERIC(10,2),
                total_comp NUMERIC(10,2),
                billing_rate NUMERIC(10,2),
                salary_percentile DECIMAL(5,2),
                comp_ratio DECIMAL(5,2),
                UNIQUE(employee_id)
            )
        """)
        
        cur.execute("""
            CREATE TABLE IF NOT EXISTS employee_certifications (
                cert_id SERIAL PRIMARY KEY,
                employee_id INTEGER REFERENCES employees(employee_id),
                certification_name VARCHAR(200),
                UNIQUE(employee_id, certification_name)
            )
        """)
        
        return conn, cur
    except psycopg2.Error as e:
        print(f"Database connection error: {e}")
        raise

def safe_numeric(value):
    """Safely convert value to float, handling NULL values"""
    try:
        return float(value) if pd.notna(value) else None
    except:
        return None

def safe_date(value):
    """Safely convert value to date, handling NULL values"""
    if pd.isna(value):
        return None
    try:
        return pd.to_datetime(value).date()
    except:
        return None

def calculate_risk_factors(row):
    """Calculate risk factors based on various metrics"""
    risk_factors = []
    if safe_numeric(row.get('engagement_score', 0)) < 7.0:
        risk_factors.append('low_engagement')
    if safe_numeric(row.get('performance_score', 0)) < 3.5:
        risk_factors.append('low_performance')
    if safe_numeric(row.get('actual_utilization', 0)) < safe_numeric(row.get('utilization_target', 0)) * 0.8:
        risk_factors.append('low_utilization')
    if safe_numeric(row.get('promotion_readiness', 0)) > 70 and row.get('position_level', '').lower() != 'senior':
        risk_factors.append('promotion_due')
    if safe_numeric(row.get('project_satisfaction', 0)) < 4.0:
        risk_factors.append('low_satisfaction')
    return risk_factors

def insert_employee_data(df, conn, cur):
    """Insert core employee data"""
    for _, row in df.iterrows():
        try:
            industry_expertise = ', '.join(str(row['industry_expertise']).split(', ')) if pd.notna(row.get('industry_expertise')) else None
            cur.execute("""
                INSERT INTO employees (
                    employee_id, full_name, department, position, position_level,
                    hire_date, city, country, region, remote_work_ratio,
                    travel_percentage, primary_specialization, secondary_specialization,
                    industry_expertise
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (employee_id) DO UPDATE SET
                    full_name = EXCLUDED.full_name,
                    department = EXCLUDED.department,
                    position = EXCLUDED.position
            """, (
                int(row['employee_id']), row['full_name'], row['department'],
                row['position'], row['position_level'], safe_date(row['hire_date']),
                row['city'], row['country'], row['region'],
                safe_numeric(row['remote_work_ratio']),
                safe_numeric(row['travel_percentage']),
                row['primary_specialization'], row['secondary_specialization'],
                industry_expertise
            ))
        except Exception as e:
            print(f"Error inserting employee {row['employee_id']}: {e}")

def insert_performance_and_project_data(df, conn, cur):
    """Insert performance and project-related metrics"""
    for _, row in df.iterrows():
        try:
            # Performance metrics
            cur.execute("""
                INSERT INTO performance_metrics (
                    employee_id, performance_score, innovation_score,
                    delivery_quality, engagement_score, knowledge_sharing_score
                ) VALUES (%s, %s, %s, %s, %s, %s)
                ON CONFLICT (employee_id) DO UPDATE SET
                    performance_score = EXCLUDED.performance_score,
                    innovation_score = EXCLUDED.innovation_score,
                    delivery_quality = EXCLUDED.delivery_quality,
                    engagement_score = EXCLUDED.engagement_score,
                    knowledge_sharing_score = EXCLUDED.knowledge_sharing_score
            """, (
                int(row['employee_id']), safe_numeric(row['performance_score']),
                safe_numeric(row['innovation_score']), safe_numeric(row['delivery_quality']),
                safe_numeric(row['engagement_score']), safe_numeric(row['knowledge_sharing_score'])
            ))
            
            # Project metrics
            cur.execute("""
                INSERT INTO project_metrics (
                    employee_id, active_projects, avg_project_complexity,
                    avg_project_duration, avg_team_size, projects_on_time,
                    project_satisfaction, team_lead_projects
                ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (employee_id) DO UPDATE SET
                    active_projects = EXCLUDED.active_projects,
                    avg_project_complexity = EXCLUDED.avg_project_complexity,
                    projects_on_time = EXCLUDED.projects_on_time
            """, (
                int(row['employee_id']), safe_numeric(row['active_projects']),
                safe_numeric(row['avg_project_complexity']),
                safe_numeric(row['avg_project_duration']),
                safe_numeric(row['avg_team_size']),
                safe_numeric(row['projects_on_time']),
                safe_numeric(row['project_satisfaction']),
                safe_numeric(row['team_lead_projects'])
            ))
        except Exception as e:
            print(f"Error inserting metrics for employee {row['employee_id']}: {e}")

def insert_risk_and_management_data(df, conn, cur):
    """Insert risk assessment and management information"""
    for _, row in df.iterrows():
        try:
            # Risk assessment
            risk_factors = calculate_risk_factors(row)
            cur.execute("""
                INSERT INTO risk_assessment (
                    employee_id, flight_risk, retention_risk,
                    promotion_readiness, risk_factors
                ) VALUES (%s, %s, %s, %s, %s)
                ON CONFLICT (employee_id) DO UPDATE SET
                    flight_risk = EXCLUDED.flight_risk,
                    retention_risk = EXCLUDED.retention_risk,
                    risk_factors = EXCLUDED.risk_factors
            """, (
                int(row['employee_id']), safe_numeric(row['flight_risk']),
                row['retention_risk'], safe_numeric(row['promotion_readiness']),
                risk_factors
            ))
            
            # Management info
            if row.get('is_manager'):
                cur.execute("""
                    INSERT INTO management_info (
                        employee_id, is_manager, management_level,
                        span_of_control, management_premium, span_premium,
                        total_comp
                    ) VALUES (%s, %s, %s, %s, %s, %s, %s)
                    ON CONFLICT (employee_id) DO UPDATE SET
                        management_level = EXCLUDED.management_level,
                        span_of_control = EXCLUDED.span_of_control
                """, (
                    int(row['employee_id']), row['is_manager'],
                    row['management_level'], safe_numeric(row['span_of_control']),
                    safe_numeric(row['management_premium']),
                    safe_numeric(row['span_premium']),
                    safe_numeric(row['total_comp'])
                ))
        except Exception as e:
            print(f"Error inserting risk/management data for employee {row['employee_id']}: {e}")

def insert_compensation_and_development_data(df, conn, cur):
    """Insert compensation metrics and development data"""
    for _, row in df.iterrows():
        try:
            # Compensation metrics
            salary_percentile = 50.0  # Placeholder - could be calculated based on department/level
            comp_ratio = (safe_numeric(row['total_comp']) / safe_numeric(row['base_salary'])) * 100 if pd.notna(row.get('base_salary')) and float(row['base_salary']) > 0 else None
            
            cur.execute("""
                INSERT INTO compensation_metrics (
                    employee_id, base_salary, total_comp, billing_rate,
                    salary_percentile, comp_ratio
                ) VALUES (%s, %s, %s, %s, %s, %s)
                ON CONFLICT (employee_id) DO UPDATE SET
                    base_salary = EXCLUDED.base_salary,
                    total_comp = EXCLUDED.total_comp
            """, (
                int(row['employee_id']), safe_numeric(row['base_salary']),
                safe_numeric(row['total_comp']), safe_numeric(row['billing_rate']),
                salary_percentile, comp_ratio
            ))
            
            # Development metrics
            cur.execute("""
                INSERT INTO development_metrics (
                    employee_id, training_hours, mentorship_hours, direct_reports
                ) VALUES (%s, %s, %s, %s)
                ON CONFLICT (employee_id) DO UPDATE SET
                    training_hours = EXCLUDED.training_hours,
                    mentorship_hours = EXCLUDED.mentorship_hours
            """, (
                int(row['employee_id']), safe_numeric(row['training_hours']),
                safe_numeric(row['mentorship_hours']), safe_numeric(row['direct_reports'])
            ))
        except Exception as e:
            print(f"Error inserting compensation/development data for employee {row['employee_id']}: {e}")

def insert_certifications(df, conn, cur):
    """Insert employee certifications"""
    for _, row in df.iterrows():
        if pd.notna(row.get('certifications')):
            certs = str(row['certifications']).split(',')
            for cert in certs:
                try:
                    cur.execute("""
                        INSERT INTO employee_certifications (employee_id, certification_name)
                        VALUES (%s, %s)
                        ON CONFLICT (employee_id, certification_name) DO NOTHING
                    """, (int(row['employee_id']), cert.strip()))
                except Exception as e:
                    print(f"Error inserting certification for employee {row['employee_id']}: {e}")

def main():
    try:
        print("Starting comprehensive HR data import process...")
        conn, cur = create_hr_database()
        
        # Configure input file path
        excel_file = "path/to/your/hr_data.xlsx"
        if not os.path.exists(excel_file):
            print(f"Error: Excel file not found at {excel_file}")
            sys.exit(1)
            
        print(f"Reading Excel file from: {excel_file}")
        df = pd.read_excel(excel_file)
        print(f"\nDataframe shape: {df.shape}")
        print(f"Columns found: {', '.join(df.columns)}")
        
        if len(df) == 0:
            print("Warning: Excel file contains no data!")
            sys.exit(1)
            
        print("\nInserting data into tables...")
        
        # Insert data in logical order
        insert_employee_data(df, conn, cur)
        insert_performance_and_project_data(df, conn, cur)
        insert_risk_and_management_data(df, conn, cur)
        insert_compensation_and_development_data(df, conn, cur)
        insert_certifications(df, conn, cur)
        
        conn.commit()
        
        # Verify data insertion
        tables = [
            'employees', 'performance_metrics', 'project_metrics',
            'development_metrics', 'risk_assessment', 'management_info',
            'compensation_metrics', 'employee_certifications'
         ]
        print("\nVerifying data insertion:")
        for table in tables:
            cur.execute(f"SELECT COUNT(*) FROM {table}")
            count = cur.fetchone()[0]
            print(f"{table}: {count} rows")
            
        print("\nHR data import process completed successfully!")
        
    except Exception as e:
        print(f"Error during import process: {str(e)}")
        print(f"Error type: {type(e).__name__}")
        sys.exit(1)
    finally:
        if 'conn' in locals():
            conn.close()

if __name__ == "__main__":
    main()