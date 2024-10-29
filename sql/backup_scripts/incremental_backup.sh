#!/bin/bash

# Configuration
export PGPASSWORD='1234'
BACKUP_DIR="./data/backup_records"
DB_NAME="hr_resource_db"
DB_USER="postgres"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Get the date range for the current week
WEEK_START=$(date -d "monday" +%Y-%m-%d)
WEEK_END=$(date -d "sunday" +%Y-%m-%d)
FILE_NAME="${WEEK_START}_to_${WEEK_END}.sql"

# Function to get the last backup date
get_last_backup_date() {
    if [ -f "$BACKUP_DIR/last_backup_date" ]; then
        cat "$BACKUP_DIR/last_backup_date"
    else
        echo "1970-01-01 00:00:00"
    fi
}

# Get last backup date
LAST_BACKUP=$(get_last_backup_date)

# Create the backup file with header comments
cat > "$BACKUP_DIR/$FILE_NAME" << EOF
-- Incremental Backup
-- Period: $WEEK_START to $WEEK_END
-- Generated: $(date '+%Y-%m-%d %H:%M:%S')
-- Only includes changes since: $LAST_BACKUP

BEGIN;

EOF

# Function to backup modified data from a table
backup_modified_table() {
    local table=$1
    echo "-- Modified records in $table" >> "$BACKUP_DIR/$FILE_NAME"
    
    pg_dump -U "$DB_USER" -d "$DB_NAME" \
        --data-only \
        --table="$table" \
        --where="updated_at > '$LAST_BACKUP'" \
        >> "$BACKUP_DIR/$FILE_NAME"
}

# Backup modified data from each table
tables=("departments" "positions" "employees" "skills" "employee_skills" "leave_requests")

for table in "${tables[@]}"; do
    backup_modified_table "$table"
done

# Add transaction commit
echo "COMMIT;" >> "$BACKUP_DIR/$FILE_NAME"

# Update last backup date
date '+%Y-%m-%d %H:%M:%S' > "$BACKUP_DIR/last_backup_date"

# Remove PGPASSWORD from environment
unset PGPASSWORD

# Create a summary file
cat > "$BACKUP_DIR/${FILE_NAME%.sql}_summary.txt" << EOF
Backup Summary
-------------
Date Range: $WEEK_START to $WEEK_END
Generated: $(date '+%Y-%m-%d %H:%M:%S')
Previous Backup: $LAST_BACKUP

Modified Records:
$(for table in "${tables[@]}"; do
    count=$(grep -c "INSERT INTO $table" "$BACKUP_DIR/$FILE_NAME" || echo "0")
    echo "- $table: $count records"
done)
EOF

echo "Weekly incremental backup completed successfully!"
echo "Backup files saved in: $BACKUP_DIR"
