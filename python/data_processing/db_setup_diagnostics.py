import psycopg2
import sys
from datetime import datetime
from io import StringIO
import os
from dotenv import load_dotenv

load_dotenv()  # Load environment variables from.env file

def get_db_connection():
    return psycopg2.connect(
        dbname= os.getenv("DB_NAME"),
        user= os.getenv("DB_USER"),
        password= os.getenv("DB_PASSWORD"),
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT")
    )

def capture_output(func):
    """Decorator to capture print output"""
    def wrapper(*args, **kwargs):
        stdout = StringIO()
        sys.stdout = stdout
        func(*args, **kwargs)
        sys.stdout = sys.__stdout__
        return stdout.getvalue()
    return wrapper

@capture_output
def check_table_existence_and_structure():
    conn = get_db_connection()
    cur = conn.cursor()
    
    expected_tables = [
        'employees',
        'employee_analytics',
        'manager_analytics',
        'department_analytics',
        'flight_risk_analysis',
        'manager_performance_insights',
        'promotion_readiness_analysis',
        'skills_gap_analysis',
        'project_performance_metrics',
        'compensation_analysis'
    ]
    
    try:
        print("\nChecking table existence and structure:")
        for table in expected_tables:
            cur.execute("""
                SELECT column_name, data_type 
                FROM information_schema.columns 
                WHERE table_schema = 'public' AND table_name = %s
            """, (table,))
            columns = cur.fetchall()
            
            cur.execute("""
                SELECT COUNT(*) 
                FROM {}
            """.format(table))
            row_count = cur.fetchone()[0]
            
            if columns:
                print(f"\n[OK] Table '{table}' exists with {len(columns)} columns and {row_count} rows")
                print("  Columns:")
                for col_name, col_type in columns:
                    print(f"    - {col_name} ({col_type})")
            else:
                print(f"[X] Table '{table}' does not exist!")
    finally:
        cur.close()
        conn.close()

@capture_output
def analyze_employee_data_quality():
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        print("\nAnalyzing employee data quality:")
        
        critical_columns = [
            'full_name', 'department', 'position', 'level', 'hire_date',
            'base_salary', 'total_comp', 'primary_specialization',
            'actual_utilization', 'performance_score', 'manager_id'
        ]
        
        for column in critical_columns:
            cur.execute(f"""
                SELECT 
                    COUNT(*) as total_nulls,
                    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees), 2) as null_percentage
                FROM employees 
                WHERE {column} IS NULL
            """)
            nulls, percentage = cur.fetchone()
            print(f"  {column}: {nulls} nulls ({percentage}%)")
        
        numeric_fields = [
            'remote_work_ratio', 'travel_percentage', 'utilization_target',
            'actual_utilization', 'performance_score', 'flight_risk',
            'promotion_readiness', 'knowledge_sharing_score'
        ]
        
        print("\nNumeric field ranges:")
        for field in numeric_fields:
            cur.execute(f"""
                SELECT 
                    MIN({field}) as min_val,
                    MAX({field}) as max_val,
                    AVG({field}) as avg_val,
                    COUNT(*) FILTER (WHERE {field} < 0 OR {field} > 100) as out_of_range
                FROM employees 
                WHERE {field} IS NOT NULL
            """)
            min_val, max_val, avg_val, out_of_range = cur.fetchone()
            print(f"\n  {field}:")
            print(f"    Range: {min_val:.2f} to {max_val:.2f}")
            print(f"    Average: {avg_val:.2f}")
            print(f"    Out of range values: {out_of_range}")
            
    finally:
        cur.close()
        conn.close()

@capture_output
def check_analytics_consistency():
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        print("\nChecking analytics consistency:")
        
        cur.execute("""
            SELECT 
                COUNT(*) as total_records,
                COUNT(DISTINCT risk_level) as risk_levels,
                COUNT(DISTINCT readiness_band) as readiness_bands
            FROM employee_analytics
        """)
        total, risk_levels, readiness_bands = cur.fetchone()
        print(f"\nEmployee Analytics:")
        print(f"  Total records: {total}")
        print(f"  Risk levels: {risk_levels}")
        print(f"  Readiness bands: {readiness_bands}")
        
        cur.execute("""
            SELECT 
                COUNT(*) as total_records,
                COUNT(DISTINCT management_level) as mgmt_levels,
                COUNT(DISTINCT performance_category) as perf_categories
            FROM manager_analytics
        """)
        total, mgmt_levels, perf_cats = cur.fetchone()
        print(f"\nManager Analytics:")
        print(f"  Total records: {total}")
        print(f"  Management levels: {mgmt_levels}")
        print(f"  Performance categories: {perf_cats}")
        
        cur.execute("""
            SELECT 
                COUNT(*) as total_records,
                COUNT(DISTINCT department) as departments,
                COUNT(DISTINCT level) as levels
            FROM department_analytics
        """)
        total, depts, levels = cur.fetchone()
        print(f"\nDepartment Analytics:")
        print(f"  Total records: {total}")
        print(f"  Unique departments: {depts}")
        print(f"  Unique levels: {levels}")
        
        print("\nCross-table consistency checks:")
        
        cur.execute("""
            SELECT 
                (SELECT COUNT(*) FROM employees) as total_employees,
                (SELECT COUNT(*) FROM employee_analytics) as total_analytics
        """)
        total_emp, total_analytics = cur.fetchone()
        print(f"  Employee coverage: {total_analytics}/{total_emp} ({(total_analytics/total_emp*100):.2f}%)")
        
        cur.execute("""
            SELECT 
                (SELECT COUNT(*) FROM employees WHERE is_manager = true) as total_managers,
                (SELECT COUNT(*) FROM manager_analytics) as total_manager_analytics
        """)
        total_mgr, total_mgr_analytics = cur.fetchone()
        print(f"  Manager coverage: {total_mgr_analytics}/{total_mgr} ({(total_mgr_analytics/total_mgr*100):.2f}%)")
        
    finally:
        cur.close()
        conn.close()

@capture_output
def analyze_metrics_distribution():
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        print("\nAnalyzing metrics distribution:")
        
        cur.execute("""
            SELECT 
                department,
                level,
                employee_count,
                avg_metrics->>'avg_performance' as avg_performance,
                avg_metrics->>'avg_salary' as avg_salary,
                risk_distribution->>'high_risk' as high_risk_count,
                readiness_distribution->>'ready_now' as ready_now_count
            FROM department_analytics
            ORDER BY department, level
        """)
        
        current_dept = None
        for row in cur.fetchall():
            dept, level, count, perf, salary, high_risk, ready = row
            if dept != current_dept:
                print(f"\n{dept}:")
                current_dept = dept
            print(f"  {level}:")
            print(f"    Employees: {count}")
            print(f"    Avg Performance: {float(perf):.2f}")
            print(f"    Avg Salary: ${float(salary):,.2f}")
            print(f"    High Risk Employees: {high_risk}")
            print(f"    Ready for Promotion: {ready}")
        
        print("\nManager Level Distribution:")
        cur.execute("""
            SELECT 
                management_level,
                performance_category,
                COUNT(*) as count,
                AVG((team_metrics->>'avg_team_performance')::float) as avg_team_perf
            FROM manager_analytics
            GROUP BY management_level, performance_category
            ORDER BY management_level, performance_category
        """)
        
        current_level = None
        for row in cur.fetchall():
            level, category, count, team_perf = row
            if level != current_level:
                print(f"\n  {level}:")
                current_level = level
            print(f"    {category}: {count} managers (Avg Team Perf: {team_perf:.2f})")
            
    finally:
        cur.close()
        conn.close()

def create_markdown_report(outputs):
    """Create a markdown report from the diagnostic outputs"""
    timestamp = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    report_content = f"""# HR Resource Database Diagnostic Report
Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## Table Structure and Data Overview
{outputs['table_structure']}

## Data Quality Analysis
{outputs['data_quality']}

## Analytics Consistency Check
{outputs['analytics']}

## Metrics Distribution Analysis
{outputs['metrics']}
"""
    
    # Create reports directory if it doesn't exist
    os.makedirs('reports', exist_ok=True)
    
    # Save the report with UTF-8 encoding
    filename = f'reports/hr_diagnostic_report_{timestamp}.md'
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(report_content)
    
    return filename

def generate_diagnostic_report():
    try:
        print(f"Starting HR Resource Database diagnostics at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}...\n")
        
        # Collect outputs from each function
        outputs = {
            'table_structure': check_table_existence_and_structure(),
            'data_quality': analyze_employee_data_quality(),
            'analytics': check_analytics_consistency(),
            'metrics': analyze_metrics_distribution()
        }
        
        # Create markdown report
        report_file = create_markdown_report(outputs)
        
        print(f"\nDiagnostic report completed successfully!")
        print(f"Report saved to: {report_file}")
        
        # Also print to terminal for immediate viewing
        for output in outputs.values():
            print(output)
        
    except Exception as e:
        print(f"Error during diagnostic process: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    generate_diagnostic_report()