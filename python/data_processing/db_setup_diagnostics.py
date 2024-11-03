def get_db_connection():
    """Create a connection to the PostgreSQL database."""
    return psycopg2.connect(
        dbname="hr_resource_db",
        user="postgres",
        password="1234",
        host="localhost",
        port="5432"
    )

def check_table_constraints():
    """Check existing constraints on tables."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        cur.execute("""
            SELECT tc.table_name, tc.constraint_name, tc.constraint_type
            FROM information_schema.table_constraints tc
            WHERE tc.table_schema = 'public'
            ORDER BY tc.table_name, tc.constraint_name;
        """)
        constraints = cur.fetchall()
        print("\nExisting table constraints:")
        for constraint in constraints:
            print(f"Table: {constraint[0]}, Constraint: {constraint[1]}, Type: {constraint[2]}")
    finally:
        cur.close()
        conn.close()

def check_table_relationships():
    """Check foreign key relationships between tables."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        cur.execute("""
            SELECT
                tc.table_name as table_name,
                kcu.column_name as column_name,
                ccu.table_name AS foreign_table_name,
                ccu.column_name AS foreign_column_name
            FROM information_schema.table_constraints AS tc
            JOIN information_schema.key_column_usage AS kcu
                ON tc.constraint_name = kcu.constraint_name
            JOIN information_schema.constraint_column_usage AS ccu
                ON ccu.constraint_name = tc.constraint_name
            WHERE tc.constraint_type = 'FOREIGN KEY';
        """)
        relationships = cur.fetchall()
        print("\nTable relationships:")
        for rel in relationships:
            print(f"{rel[0]}.{rel[1]} -> {rel[2]}.{rel[3]}")
    finally:
        cur.close()
        conn.close()

def check_data_integrity():
    """Check for potential data integrity issues."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        # Check for orphaned records in metrics tables
        metrics_tables = [
            'performance_metrics', 'sales_metrics', 'hr_metrics',
            'it_support_metrics', 'engineering_metrics',
            'employee_certifications', 'cross_functional_metrics'
        ]
        
        print("\nChecking for orphaned records:")
        for table in metrics_tables:
            cur.execute(f"""
                SELECT COUNT(*) FROM {table} m
                LEFT JOIN employees e ON e.employee_id = m.employee_id
                WHERE e.employee_id IS NULL;
            """)
            orphaned_count = cur.fetchone()[0]
            print(f"{table}: {orphaned_count} orphaned records")

        # Check for duplicate entries in employee_certifications
        cur.execute("""
            SELECT employee_id, certification_name, COUNT(*)
            FROM employee_certifications
            GROUP BY employee_id, certification_name
            HAVING COUNT(*) > 1;
        """)
        duplicates = cur.fetchall()
        if duplicates:
            print("\nDuplicate certifications found:")
            for dup in duplicates:
                print(f"Employee ID: {dup[0]}, Certification: {dup[1]}, Count: {dup[2]}")

        # Check for null values in critical columns
        print("\nChecking for null values in critical columns:")
        critical_columns = {
            'employees': ['name', 'department', 'position', 'hire_date'],
            'performance_metrics': ['employee_id', 'performance_rating'],
            'sales_metrics': ['employee_id', 'quota_attainment'],
            'hr_metrics': ['employee_id', 'employee_satisfaction_score']
        }
        
        for table, columns in critical_columns.items():
            for column in columns:
                cur.execute(f"""
                    SELECT COUNT(*) 
                    FROM {table} 
                    WHERE {column} IS NULL;
                """)
                null_count = cur.fetchone()[0]
                print(f"{table}.{column}: {null_count} null values")

    finally:
        cur.close()
        conn.close()

def perform_data_analysis():
    """Perform basic data analysis on the database."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        # Department distribution
        cur.execute("""
            SELECT department, COUNT(*) as count
            FROM employees
            GROUP BY department
            ORDER BY count DESC;
        """)
        dept_dist = cur.fetchall()
        print("\nEmployee distribution by department:")
        for dept in dept_dist:
            print(f"{dept[0]}: {dept[1]} employees")

        # Average performance metrics by department
        cur.execute("""
            SELECT 
                e.department,
                ROUND(AVG(p.project_completion_rate)::numeric, 2) as avg_completion_rate,
                ROUND(AVG(p.productivity)::numeric, 2) as avg_productivity,
                ROUND(AVG(p.engagement_score)::numeric, 2) as avg_engagement
            FROM employees e
            JOIN performance_metrics p ON e.employee_id = p.employee_id
            GROUP BY e.department;
        """)
        dept_metrics = cur.fetchall()
        print("\nAverage performance metrics by department:")
        for metric in dept_metrics:
            print(f"\nDepartment: {metric[0]}")
            print(f"Avg Completion Rate: {metric[1]}%")
            print(f"Avg Productivity: {metric[2]}")
            print(f"Avg Engagement: {metric[3]}")

    finally:
        cur.close()
        conn.close()

def check_and_setup_database():
    """Main function to check database setup and perform diagnostics."""
    try:
        print("Starting database diagnostic checks...")
        
        # Check table constraints
        check_table_constraints()
        
        # Check table relationships
        check_table_relationships()
        
        # Check data integrity
        check_data_integrity()
        
        # Perform basic data analysis
        perform_data_analysis()
        
        print("\nDatabase diagnostic checks completed successfully!")
        
    except Exception as e:
        print(f"Error during diagnostic checks: {e}")
        sys.exit(1)

if __name__ == "__main__":
    check_and_setup_database()