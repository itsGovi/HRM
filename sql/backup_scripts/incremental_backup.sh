#!/bin/bash

# Configuration
export PGPASSWORD='1234'
BACKUP_DIR="./data/backup_records"
DB_NAME="hr_resource_db"
DB_USER="postgres"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Correct the weekly date range to cover Monday to Sunday
WEEK_START=$(date -d 'last-monday' +%Y-%m-%d)
WEEK_END=$(date -d "$WEEK_START +6 days" +%Y-%m-%d)
FILE_NAME="${WEEK_START}_to_${WEEK_END}.sql"
CURRENT_DATE=$(date '+%Y-%m-%d')

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

# Check if today's changes have already been recorded in this week's file
if ! grep -q "### Changes for $CURRENT_DATE ###" "$BACKUP_DIR/$FILE_NAME"; then
    # Add a daily header for today's changes if it doesn't already exist
    echo -e "\n\n### Changes for $CURRENT_DATE ###" >> "$BACKUP_DIR/$FILE_NAME"
fi

# Function to backup modified data from a table
backup_modified_table() {
    local table=$1
    echo "-- Modified records in $table on $CURRENT_DATE" >> "$BACKUP_DIR/$FILE_NAME"
    
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

# Add a commit statement to finalize the transaction block
echo "COMMIT;" >> "$BACKUP_DIR/$FILE_NAME"

# Update last backup date for future reference
date '+%Y-%m-%d %H:%M:%S' > "$BACKUP_DIR/last_backup_date"

# Remove PGPASSWORD from environment
unset PGPASSWORD

# Confirmation message
echo "Incremental backup completed for $CURRENT_DATE and saved in $FILE_NAME."
