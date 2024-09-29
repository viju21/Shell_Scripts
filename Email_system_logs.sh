#!/bin/bash

# Author: Vijay Sankar C
# Script_name: log_manager.sh
# Description: Compress system logs daily at 2:30 AM, delete compressed log files older than 30 days, and email a report of successful and failed compressions to the system administrator.

# Configuration
LOG_DIR="/var/log"
EMAIL="vijayviju900@gmail.com"
REPORT="$HOME/log_compression_report.txt"

# Check for required tools
for cmd in gzip rm mail; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd could not be found. Please install it."
        exit 1
    fi
done

# Ensure the report directory is writable
if [ ! -w "$(dirname $REPORT)" ]; then
    echo "$(dirname $REPORT) is not writable. Please check permissions."
    exit 1
fi

# Function to compress logs
compress_logs(){
    find $LOG_DIR -type f -name "*.log" | while read -r log_file; do
        if [ -f "$log_file.gz" ]; then
            echo "File $log_file.gz already exists; not overwritten" >> $REPORT
        else
            gzip "$log_file"
            if [[ $? -eq 0 ]]; then
                echo "Successfully compressed: $log_file" >> $REPORT
            else
                echo "Failed to compress: $log_file" >> $REPORT
            fi
        fi
    done
}

# Function to delete old compressed logs
delete_old_logs(){
    find $LOG_DIR -type f -name "*.gz" -mtime +30 -exec rm {} \;
    if [[ $? -eq 0 ]]; then
        echo "Successfully deleted logs older than 30 days." >> $REPORT
    else
        echo "Failed to delete some old logs." >> $REPORT
    fi
}

# Function to send email report
send_report(){
    if [ -s $REPORT ]; then
        mail -s "Daily Log Compression Report" "$EMAIL" < "$REPORT"
    else
        echo "No log compression activity detected." | mail -s "Daily Log Compression Report" "$EMAIL"
    fi
}

# Main logic
echo "Log Compression Report - $(date)" > $REPORT
compress_logs
delete_old_logs
send_report

# Clean up
rm "$REPORT"

