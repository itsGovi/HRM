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
        'employees', 'flight_risk_analysis', 'manager_performance_insights',
        'promotion_readiness_analysis', 'skills_gap_analysis',
        'project_performance_metrics', 'compensation_analysis'
    ]
    
    try:
        print("\nChecking table existence and structure:")
        for table in expected_tables:
            cur.execute("""
                SELECT EXISTS (
                    SELECT FROM information_schema.tables 
                    WHERE table_schema = 'public' 
                    AND table_name = %s
                );
            """, (table,))
            exists = cur.fetchone()[0]
            
            if exists:
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

def analyze_data_quality():
    """Analyze data quality and completeness."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        print("\nAnalyzing data quality:")
        
        # Check employee data completeness
        print("\nEmployee data completeness:")
        critical_columns = [
            'full_name', 'department', 'position', 'level', 'hire_date',
            'base_salary', 'total_comp', 'primary_specialization',
            'actual_utilization', 'performance_score'
        ]
        
        for column in critical_columns:
            cur.execute(f"""
                SELECT 
                    COUNT(*) as total_nulls,
                    ROUND(COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM employees), 0), 2) as null_percentage
                FROM employees
                WHERE {column} IS NULL
            """)
            result = cur.fetchone()
            print(f"  {column}: {result[0]} nulls ({result[1]}%)")
        
        # Analyze numeric field ranges
        print("\nNumeric field analysis:")
        numeric_fields = [
            'remote_work_ratio', 'travel_percentage', 'utilization_target',
            'actual_utilization', 'performance_score', 'flight_risk'
        ]
        
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
            result = cur.fetchone()
            print(f"\n  {field}:")
            print(f"    Range: {result[0]} to {result[1]}")
            print(f"    Average: {result[2]:.2f}")
            print(f"    Out of range values: {result[3]}")
    finally:
        cur.close()
        conn.close()

def check_analytical_tables_consistency():
    """Check consistency between main and analytical tables."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        print("\nChecking analytical tables consistency:")
        
        # Check flight risk analysis coverage
        cur.execute("""
            SELECT 
                COUNT(DISTINCT risk_level) as risk_levels,
                COUNT(*) as total_records
            FROM flight_risk_analysis
        """)
        result = cur.fetchone()
        print(f"\nFlight Risk Analysis:")
        print(f"  Risk levels: {result[0]}")
        print(f"  Total records: {result[1]}")
        
        # Check manager insights coverage
        cur.execute("""
            SELECT 
                COUNT(DISTINCT management_level) as mgmt_levels,
                COUNT(DISTINCT performance_category) as perf_categories,
                COUNT(*) as total_records
            FROM manager_performance_insights
        """)
        result = cur.fetchone()
        print(f"\nManager Performance Insights:")
        print(f"  Management levels: {result[0]}")
        print(f"  Performance categories: {result[1]}")
        print(f"  Total records: {result[2]}")
        
        # Check promotion readiness coverage
        cur.execute("""
            SELECT 
                COUNT(DISTINCT readiness_band) as readiness_bands,
                COUNT(DISTINCT level) as levels,
                COUNT(*) as total_records
            FROM promotion_readiness_analysis
        """)
        result = cur.fetchone()
        print(f"\nPromotion Readiness Analysis:")
        print(f"  Readiness bands: {result[0]}")
        print(f"  Levels: {result[1]}")
        print(f"  Total records: {result[2]}")
    finally:
        cur.close()
        conn.close()

def analyze_organizational_metrics():
    """Analyze key organizational metrics."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        print("\nAnalyzing organizational metrics:")
        
        # Department distribution
        cur.execute("""
            SELECT 
                department,
                COUNT(*) as count,
                ROUND(AVG(base_salary)::numeric, 2) as avg_salary,
                ROUND(AVG(performance_score)::numeric, 2) as avg_performance,
                ROUND(AVG(flight_risk)::numeric, 2) as avg_flight_risk
            FROM employees
            GROUP BY department
            ORDER BY count DESC
        """)
        results = cur.fetchall()
        print("\nDepartment Analysis:")
        for r in results:
            print(f"\n  {r[0]}:")
            print(f"    Employees: {r[1]}")
            print(f"    Avg Salary: ${r[2]:,.2f}")
            print(f"    Avg Performance: {r[3]:.2f}")
            print(f"    Avg Flight Risk: {r[4]:.2f}%")
        
        # Management structure
        cur.execute("""
            SELECT 
                management_level,
                COUNT(*) as manager_count,
                ROUND(AVG(direct_reports)::numeric, 2) as avg_direct_reports,
                ROUND(AVG(team_lead_projects)::numeric, 2) as avg_projects
            FROM employees
            WHERE is_manager = true
            GROUP BY management_level
            ORDER BY manager_count DESC
        """)
        results = cur.fetchall()
        print("\nManagement Structure:")
        for r in results:
            print(f"\n  {r[0]}:")
            print(f"    Managers: {r[1]}")
            print(f"    Avg Direct Reports: {r[2]}")
            print(f"    Avg Projects Led: {r[3]}")
    finally:
        cur.close()
        conn.close()

def generate_diagnostic_report():
    """Generate a comprehensive diagnostic report."""
    try:
        print("Starting HR Resource Database diagnostics...\n")
        
        # Run all diagnostic checks
        check_table_existence_and_structure()
        analyze_data_quality()
        check_analytical_tables_consistency()
        analyze_organizational_metrics()
        
        print("\nDiagnostic report completed successfully!")
        
    except Exception as e:
        print(f"Error during diagnostic process: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    generate_diagnostic_report()