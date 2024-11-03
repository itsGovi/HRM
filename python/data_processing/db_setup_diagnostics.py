import psycopg2
import pandas as pd
from datetime import datetime
import json
import sys

def get_db_connection():
    """Create a connection to the PostgreSQL database."""
    return psycopg2.connect(
        dbname="hr_resource_db",
        user="postgres",
        password="1234",
        host="localhost",
        port="5432"
    )

def check_table_existence_and_structure():
    """Check if all required tables exist and verify their structure."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    expected_tables = [
        'employees', 'performance_metrics', 'sales_metrics', 'hr_metrics',
        'it_support_metrics', 'engineering_metrics', 'employee_certifications',
        'cross_functional_metrics', 'demographic_analysis', 'salary_bands'
    ]
    
    try:
        print("\nChecking table existence and structure:")
        for table in expected_tables:
            # Check if table exists
            cur.execute("""
                SELECT EXISTS (
                    SELECT FROM information_schema.tables 
                    WHERE table_schema = 'public' 
                    AND table_name = %s
                );
            """, (table,))
            exists = cur.fetchone()[0]
            
            if exists:
                # Get column information
                cur.execute("""
                    SELECT column_name, data_type, is_nullable
                    FROM information_schema.columns
                    WHERE table_schema = 'public'
                    AND table_name = %s;
                """, (table,))
                columns = cur.fetchall()
                
                print(f"\n✓ Table '{table}' exists with {len(columns)} columns:")
                for col in columns:
                    print(f"  - {col[0]}: {col[1]} (Nullable: {col[2]})")
            else:
                print(f"✗ Table '{table}' does not exist!")
    finally:
        cur.close()
        conn.close()

def analyze_data_completeness():
    """Analyze data completeness and identify potential issues."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        print("\nAnalyzing data completeness:")
        
        # Check employee counts across tables
        tables = [
            'employees', 'performance_metrics', 'sales_metrics', 'hr_metrics',
            'it_support_metrics', 'engineering_metrics', 'cross_functional_metrics'
        ]
        
        for table in tables:
            cur.execute(f"SELECT COUNT(*) FROM {table}")
            count = cur.fetchone()[0]
            print(f"\n{table}:")
            print(f"  Total records: {count}")
            
            if table != 'employees':
                # Check for employees without metrics
                cur.execute(f"""
                    SELECT COUNT(DISTINCT e.employee_id)
                    FROM employees e
                    LEFT JOIN {table} m ON e.employee_id = m.employee_id
                    WHERE m.employee_id IS NULL
                """)
                missing = cur.fetchone()[0]
                print(f"  Employees without metrics: {missing}")
        
        # Analyze null values in critical columns
        print("\nNull value analysis in critical columns:")
        critical_columns = {
            'employees': ['name', 'department', 'position', 'hire_date', 'salary'],
            'performance_metrics': ['project_completion_rate', 'productivity', 'engagement_score'],
            'sales_metrics': ['quota_attainment', 'deals_closed'],
            'hr_metrics': ['employee_satisfaction_score', 'retention_rate']
        }
        
        for table, columns in critical_columns.items():
            print(f"\n{table}:")
            for column in columns:
                cur.execute(f"""
                    SELECT 
                        COUNT(*) as total_nulls,
                        ROUND(COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM {table}), 0), 2) as null_percentage
                    FROM {table}
                    WHERE {column} IS NULL
                """)
                result = cur.fetchone()
                print(f"  {column}: {result[0]} nulls ({result[1]}%)")
    finally:
        cur.close()
        conn.close()

def check_data_consistency():
    """Check for data consistency and referential integrity."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        print("\nChecking data consistency:")
        
        # Check for orphaned records
        metric_tables = [
            'performance_metrics', 'sales_metrics', 'hr_metrics',
            'it_support_metrics', 'engineering_metrics', 'cross_functional_metrics'
        ]
        
        for table in metric_tables:
            cur.execute(f"""
                SELECT COUNT(*)
                FROM {table} m
                LEFT JOIN employees e ON e.employee_id = m.employee_id
                WHERE e.employee_id IS NULL
            """)
            orphaned = cur.fetchone()[0]
            print(f"\n{table}:")
            print(f"  Orphaned records: {orphaned}")
        
        # Check for duplicate certifications
        cur.execute("""
            SELECT 
                employee_id, 
                certification_name, 
                COUNT(*) as occurrences
            FROM employee_certifications
            GROUP BY employee_id, certification_name
            HAVING COUNT(*) > 1
        """)
        duplicates = cur.fetchall()
        if duplicates:
            print("\nDuplicate certifications found:")
            for dup in duplicates:
                print(f"  Employee {dup[0]}: {dup[1]} ({dup[2]} occurrences)")
        
        # Check date consistency
        print("\nChecking date consistency:")
        cur.execute("""
            SELECT 
                COUNT(*) as inconsistent_dates
            FROM employees
            WHERE 
                (termination_date IS NOT NULL AND termination_date < hire_date)
                OR
                (date_of_birth IS NOT NULL AND hire_date < date_of_birth)
        """)
        inconsistent_dates = cur.fetchone()[0]
        print(f"  Records with inconsistent dates: {inconsistent_dates}")
    finally:
        cur.close()
        conn.close()

def analyze_metrics_distribution():
    """Analyze the distribution of various metrics."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        print("\nAnalyzing metrics distribution:")
        
        # Department distribution
        cur.execute("""
            SELECT 
                department,
                COUNT(*) as count,
                ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees), 2) as percentage
            FROM employees
            GROUP BY department
            ORDER BY count DESC
        """)
        dept_dist = cur.fetchall()
        print("\nEmployee distribution by department:")
        for dept in dept_dist:
            print(f"  {dept[0]}: {dept[1]} employees ({dept[2]}%)")
        
        # Performance metrics by department
        cur.execute("""
            SELECT 
                e.department,
                ROUND(AVG(p.project_completion_rate)::numeric, 2) as avg_completion_rate,
                ROUND(AVG(p.productivity)::numeric, 2) as avg_productivity,
                ROUND(AVG(p.engagement_score)::numeric, 2) as avg_engagement,
                COUNT(*) as sample_size
            FROM employees e
            JOIN performance_metrics p ON e.employee_id = p.employee_id
            GROUP BY e.department
            ORDER BY avg_productivity DESC
        """)
        performance_dist = cur.fetchall()
        print("\nPerformance metrics by department:")
        for perf in performance_dist:
            print(f"\n  {perf[0]} (Sample size: {perf[4]}):")
            print(f"    Avg Completion Rate: {perf[1]}%")
            print(f"    Avg Productivity: {perf[2]}")
            print(f"    Avg Engagement: {perf[3]}")
        
        # Salary distribution
        cur.execute("""
            SELECT 
                department,
                ROUND(MIN(salary)::numeric, 2) as min_salary,
                ROUND(AVG(salary)::numeric, 2) as avg_salary,
                ROUND(MAX(salary)::numeric, 2) as max_salary
            FROM employees
            WHERE salary IS NOT NULL
            GROUP BY department
            ORDER BY avg_salary DESC
        """)
        salary_dist = cur.fetchall()
        print("\nSalary distribution by department:")
        for sal in salary_dist:
            print(f"\n  {sal[0]}:")
            print(f"    Min: ${sal[1]:,.2f}")
            print(f"    Avg: ${sal[2]:,.2f}")
            print(f"    Max: ${sal[3]:,.2f}")
    finally:
        cur.close()
        conn.close()

def generate_diagnostic_report():
    """Generate a comprehensive diagnostic report."""
    try:
        print("Starting comprehensive HR database diagnostics...\n")
        
        # Run all diagnostic checks
        check_table_existence_and_structure()
        analyze_data_completeness()
        check_data_consistency()
        analyze_metrics_distribution()
        
        print("\nDiagnostic report completed successfully!")
        
    except Exception as e:
        print(f"Error during diagnostic process: {e}")
        sys.exit(1)

if __name__ == "__main__":
    generate_diagnostic_report()