import psycopg2
import pandas as pd
import json
from datetime import datetime

def get_db_connection():
    """Create a connection to the PostgreSQL database."""
    return psycopg2.connect(
        dbname="hr_resource_db",
        user="postgres",
        password="1234",
        host="localhost",
        port="5432"
    )

def import_hr_data(file_path):
    """Import HR data from JSON file into PostgreSQL database."""
    # Load JSON file
    print("Loading JSON data...")
    with open(file_path, 'r') as f:
        data = json.load(f)
    df = pd.DataFrame(data)
    
    # Connect to database
    conn = get_db_connection()
    cur = conn.cursor()

    try:
        # Create the comprehensive EmployeeInfo table
        print("Creating the EmployeeInfo table...")
        cur.execute("""
            CREATE TABLE IF NOT EXISTS EmployeeInfo (
                emp_id INT PRIMARY KEY,
                employee_name VARCHAR(100),
                department VARCHAR(50),
                position VARCHAR(50),
                hire_date DATE,
                termination_date DATE,
                term_reason VARCHAR(100),
                salary FLOAT,
                employment_status VARCHAR(50),
                gender VARCHAR(10),
                age INT,
                race VARCHAR(50),
                marital_status VARCHAR(20),
                state VARCHAR(2),
                zip_code INT,
                engagement_survey FLOAT,
                emp_satisfaction INT,
                special_projects_count INT,
                last_performance_review DATE,
                days_late_last_30 INT,
                absences INT
            )
        """)
        conn.commit()

        # Insert data into the EmployeeInfo table
        print("Inserting data into EmployeeInfo table...")
        for _, row in df.iterrows():
            hire_date = pd.to_datetime(row.get('DateofHire'), errors='coerce').date() if pd.notnull(row.get('DateofHire')) else None
            term_date = pd.to_datetime(row.get('DateofTermination'), errors='coerce').date() if pd.notnull(row.get('DateofTermination')) else None
            last_review = pd.to_datetime(row.get('LastPerformanceReview_Date'), errors='coerce').date() if pd.notnull(row.get('LastPerformanceReview_Date')) else None

            cur.execute("""
                INSERT INTO EmployeeInfo (
                    emp_id, employee_name, department, position, hire_date, termination_date,
                    term_reason, salary, employment_status, gender, age, race, marital_status,
                    state, zip_code, engagement_survey, emp_satisfaction, special_projects_count,
                    last_performance_review, days_late_last_30, absences
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (emp_id) DO NOTHING
            """, (
                row['EmpID'],
                row['Employee_Name'],
                row['Department'].strip(),
                row['Position'],
                hire_date,
                term_date,
                row.get('TermReason'),
                row['Salary'],
                row.get('EmploymentStatus'),
                row.get('Sex').strip(),
                datetime.now().year - pd.to_datetime(row['DOB']).year if pd.notnull(row['DOB']) else None,
                row.get('RaceDesc'),
                row.get('MaritalDesc'),
                row.get('State'),
                row.get('Zip'),
                row.get('EngagementSurvey'),
                row.get('EmpSatisfaction'),
                row.get('SpecialProjectsCount'),
                last_review,
                row.get('DaysLateLast30'),
                row.get('Absences')
            ))
            conn.commit()

        print("Data import into EmployeeInfo table completed.")

        # Create linked tables (e.g., Departments, Positions, PerformanceScores)
        print("Creating linked tables for Departments, Positions, PerformanceScores...")
        cur.execute("""
            CREATE TABLE IF NOT EXISTS Departments (
                dept_id SERIAL PRIMARY KEY,
                department_name VARCHAR(50) UNIQUE
            );
        """)
        cur.execute("""
            CREATE TABLE IF NOT EXISTS Positions (
                position_id SERIAL PRIMARY KEY,
                position_name VARCHAR(50) UNIQUE
            );
        """)
        cur.execute("""
            CREATE TABLE IF NOT EXISTS PerformanceScores (
                score_id SERIAL PRIMARY KEY,
                performance_score VARCHAR(50) UNIQUE
            );
        """)
        conn.commit()

        # Populate linked tables if necessary
        departments = df['Department'].str.strip().unique()
        positions = df['Position'].unique()
        performance_scores = df['PerformanceScore'].unique()

        for dept in departments:
            cur.execute("INSERT INTO Departments (department_name) VALUES (%s) ON CONFLICT (department_name) DO NOTHING", (dept,))
        for pos in positions:
            cur.execute("INSERT INTO Positions (position_name) VALUES (%s) ON CONFLICT (position_name) DO NOTHING", (pos,))
        for score in performance_scores:
            cur.execute("INSERT INTO PerformanceScores (performance_score) VALUES (%s) ON CONFLICT (performance_score) DO NOTHING", (score,))
        conn.commit()

        print("Linked tables created and populated with initial values.")
    
    except Exception as e:
        conn.rollback()
        print(f"An error occurred: {e}")
    finally:
        cur.close()
        conn.close()
        print("Database connection closed.")

if __name__ == "__main__":
    file_path = "C:/Users/govar/OneDrive/Documents/HRM/data/raw/HRDataset_v14_json.json"
    import_hr_data(file_path)