#!/bin/bash
export PGPASSWORD='1234'
pg_dump -U postgres -d hr_resource_db > "C:/Users/govar/OneDrive/Documents/HRM/data/processed/db_backup.sql"
unset PGPASSWORD
