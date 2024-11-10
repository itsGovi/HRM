-- deleting all tables to build a fresh schema

DO $$ 
DECLARE 
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = current_schema()) 
    LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END $$;



/*
import psycopg2

def create_connection():
    return psycopg2.connect(
        dbname="hr_resource_db",
        user="postgres",
        password="1234",
        host="localhost",
        port="5432"
    )

def get_all_employees(conn):
    with conn.cursor() as cur:
        # Execute a query
        cur.execute("SELECT * FROM employees;")
        
        # Fetch all results
        results = cur.fetchall()
        
        # Print each row
        for row in results:
            print(row)

# Example usage
conn = create_connection()
get_all_employees(conn)
conn.close()  # Close the connection after you're done

*/