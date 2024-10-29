import pandas as pd
import psycopg2
from psycopg2.extras import execute_batch
from datetime import datetime
import numpy as np

def get_db_connection():
    """Create a connection to the PostgreSQL database."""
    return psycopg2.connect(
        dbname="hr_resource_db",
        user="postgres",
        password="1234",
        host="localhost",
        port="5432"
    )

def clean_salary(salary_str):
    """Clean salary values by removing currency symbols and converting to float."""
    if pd.isna(salary_str):
        return 0.0
    if isinstance(salary_str, str):
        return float(salary_str.replace('$', '').replace(',', ''))
    return float(salary_str)

def import_hr_data(file_path):
    """Import HR data from Excel file into PostgreSQL database."""
    # Read the Excel file
    print("Reading Excel file...")
    df = pd.read_excel(file_path)
    
    # Connect to database
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        # 1. Import departments
        print("Importing departments...")
        departments = pd.DataFrame(df['Department'].unique(), columns=['department_name'])
        for _, row in departments.iterrows():
            cur.execute("""
                INSERT INTO departments (department_name)
                VALUES (%s)
                ON CONFLICT (department_name) DO NOTHING
                RETURNING department_id
                """, (row['department_name'],))
            conn.commit()  # Commit after each department
        
        # 2. Import positions
        print("Importing positions...")
        positions = pd.DataFrame(df['Position'].unique(), columns=['position_title'])
        for _, row in positions.iterrows():
            cur.execute("""
                INSERT INTO positions (position_title, min_salary, max_salary)
                VALUES (%s, 0, 0)
                ON CONFLICT (position_title) DO NOTHING
                RETURNING position_id
                """, (row['position_title'],))
            conn.commit()  # Commit after each position
        
        # 3. Import employees
        print("Importing employees...")
        
        # Create a mapping of department names to IDs
        cur.execute("SELECT department_id, department_name FROM departments")
        dept_mapping = dict(cur.fetchall())
        
        # Create a mapping of position titles to IDs
        cur.execute("SELECT position_id, position_title FROM positions")
        pos_mapping = dict(cur.fetchall())
        
        # Process each employee
        for _, row in df.iterrows():
            try:
                # Split name into first and last name
                full_name = row['Employee_Name'].split(',') if ',' in row['Employee_Name'] else row['Employee_Name'].split()
                last_name = full_name[0].strip()
                first_name = full_name[1].strip() if len(full_name) > 1 else ''
                
                # Clean and prepare data
                email = f"{first_name.lower()}.{last_name.lower()}@company.com".replace(' ', '')
                hire_date = pd.to_datetime(row.get('DateofHire')).date() if pd.notnull(row.get('DateofHire')) else datetime.now().date()
                salary = clean_salary(row.get('Salary', 0))
                
                # Insert employee
                cur.execute("""
                    INSERT INTO employees (
                        first_name, last_name, email, hire_date,
                        department_id, position_id, salary, status
                    )
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                    ON CONFLICT (email) 
                    DO UPDATE SET
                        first_name = EXCLUDED.first_name,
                        last_name = EXCLUDED.last_name,
                        hire_date = EXCLUDED.hire_date,
                        department_id = EXCLUDED.department_id,
                        position_id = EXCLUDED.position_id,
                        salary = EXCLUDED.salary
                    """,
                    (
                        first_name,
                        last_name,
                        email,
                        hire_date,
                        dept_mapping.get(row['Department']),
                        pos_mapping.get(row['Position']),
                        salary,
                        'ACTIVE'
                    )
                )
                conn.commit()  # Commit after each employee
                
            except Exception as e:
                print(f"Error processing employee {row['Employee_Name']}: {e}")
                continue
        
        print("Data import completed successfully!")
        
    except Exception as e:
        conn.rollback()
        print(f"Error occurred: {e}")
        raise
    
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    file_path = "C:/Users/govar/OneDrive/Documents/HRM/data/raw/HRDataset_v14.xlsx"
    import_hr_data(file_path)