#!/bin/bash

# Configuration
BACKUP_DIR="./data/backup_records"
DB_NAME="hr_resource_db"
DB_USER="postgres"
PGPASSWORD="1234"
REPO_ROOT=$(git rev-parse --show-toplevel)
DATE_FORMAT="+%Y-%m-%d"
CURRENT_DATE=$(date "$DATE_FORMAT")

# Create backup directory structure
mkdir -p "$BACKUP_DIR/code_changes"
mkdir -p "$BACKUP_DIR/database_changes"

# Function to backup modified files in repository
backup_modified_files() {
    echo "Backing up modified files..."
    
    # Get list of staged files
    STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACMR)
    
    if [ -n "$STAGED_FILES" ]; then
        # Create a dated directory for today's changes
        BACKUP_PATH="$BACKUP_DIR/code_changes/$CURRENT_DATE"
        mkdir -p "$BACKUP_PATH"
        
        # Copy each modified file to backup directory with its full path structure
        for file in $STAGED_FILES; do
            if [ -f "$file" ]; then
                # Create directory structure
                mkdir -p "$BACKUP_PATH/$(dirname "$file")"
                # Copy file with its changes
                cp "$file" "$BACKUP_PATH/$file"
                echo "Backed up: $file"
            fi
        done
        
        # Create a change log
        echo "Changes for $CURRENT_DATE:" > "$BACKUP_PATH/changelog.txt"
        git diff --cached --name-status >> "$BACKUP_PATH/changelog.txt"
    fi
}

# Function to backup modified database tables
backup_modified_tables() {
    echo "Backing up database changes..."
    
    # Create dated SQL file
    DB_BACKUP_FILE="$BACKUP_DIR/database_changes/${CURRENT_DATE}_db_changes.sql"
    
    # Get list of modified tables (you'll need to implement your own logic here)
    MODIFIED_TABLES="employees employee_analytics manager_analytics department_analytics"
    
    for table in $MODIFIED_TABLES; do
        echo "-- Backup of $table on $CURRENT_DATE" >> "$DB_BACKUP_FILE"
        PGPASSWORD=$PGPASSWORD pg_dump -U $DB_USER -d $DB_NAME \
            --table="$table" \
            --data-only \
            --column-inserts >> "$DB_BACKUP_FILE"
    done
}

# Function to create a summary report
create_backup_report() {
    REPORT_FILE="$BACKUP_DIR/backup_report_${CURRENT_DATE}.txt"
    
    echo "Backup Report - $CURRENT_DATE" > "$REPORT_FILE"
    echo "================================" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    # Code changes summary
    echo "Code Changes:" >> "$REPORT_FILE"
    echo "-------------" >> "$REPORT_FILE"
    git diff --cached --name-status >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    # Database changes summary
    echo "Database Changes:" >> "$REPORT_FILE"
    echo "-----------------" >> "$REPORT_FILE"
    echo "Modified tables backed up: $MODIFIED_TABLES" >> "$REPORT_FILE"
}

# Main execution
echo "Starting backup process..."

# Backup code changes
backup_modified_files

# Backup database changes
backup_modified_tables

# Create report
create_backup_report

echo "Backup completed successfully!"