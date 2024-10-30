import psycopg2
from psycopg2 import sql

def get_db_connection():
    """Create a connection to the PostgreSQL database."""
    return psycopg2.connect(
        dbname="hr_resource_db",
        user="postgres",
        password="1234",
        host="localhost",
        port="5432"
    )

def check_and_setup_database():
    """Check database setup and add missing constraints."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    try:
        # Check and add unique constraint for departments
        cur.execute("""
            DO $$ 
            BEGIN 
                IF NOT EXISTS (
                    SELECT 1 FROM pg_constraint 
                    WHERE conname = 'departments_department_name_key'
                ) THEN
                    ALTER TABLE departments 
                    ADD CONSTRAINT departments_department_name_key UNIQUE (department_name);
                END IF;
            END $$;
        """)
        
        # Check and add unique constraint for positions
        cur.execute("""
            DO $$ 
            BEGIN 
                IF NOT EXISTS (
                    SELECT 1 FROM pg_constraint 
                    WHERE conname = 'positions_position_title_key'
                ) THEN
                    ALTER TABLE positions 
                    ADD CONSTRAINT positions_position_title_key UNIQUE (position_title);
                END IF;
            END $$;
        """)
        
        # Check and add unique constraint for employees email
        cur.execute("""
            DO $$ 
            BEGIN 
                IF NOT EXISTS (
                    SELECT 1 FROM pg_constraint 
                    WHERE conname = 'employees_email_key'
                ) THEN
                    ALTER TABLE employees 
                    ADD CONSTRAINT employees_email_key UNIQUE (email);
                END IF;
            END $$;
        """)
        
        # Check if tables are empty
        tables = ['departments', 'positions', 'employees', 'skills', 'employee_skills', 'leave_requests']
        for table in tables:
            cur.execute(sql.SQL("SELECT COUNT(*) FROM {}").format(sql.Identifier(table)))
            count = cur.fetchone()[0]
            print(f"Table {table} has {count} records")
        
        conn.commit()
        print("Database setup checked and configured successfully!")
        
    except Exception as e:
        conn.rollback()
        print(f"Error occurred: {e}")
        raise
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    check_and_setup_database()