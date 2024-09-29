#Author: Vijay Sankar C
#Script_name: db_backup_restore.sh
#Description:script that automates the backup and restore process for databases such as MySQL or PostgreSQL. The script should dump the database contents, compress them, and store them securely. It should also be able to restore databases from backup files.

#!/bin/bash

echo "PostgreSQL Database Backup and Restore Tool"
echo "1. Backup Database"
echo "2. Restore Database"
echo "3. Exit"
read -p "Enter your choice: " choice

case $choice in
    1)
        read -p "Enter the database name: " dbname
        read -p "Enter the backup file name: " backupfile
        read -s -p "Password: " PGPASSWORD
        echo
        export PGPASSWORD
        pg_dump -U postgres -h localhost -F c -b -v -f "${backupfile}.backup" "$dbname"
        if [ $? -eq 0 ]; then
            echo "Backup successful."
        else
            echo "Error: Failed to backup the database."
        fi
        unset PGPASSWORD
        ;;
    2)
        read -p "Enter the database name: " dbname
        read -p "Enter the backup file name: " backupfile
        read -s -p "Password: " PGPASSWORD
        echo
        export PGPASSWORD
        pg_restore -U postgres -h localhost -d "$dbname" -v "${backupfile}.backup"
        if [ $? -eq 0 ]; then
            echo "Restore successful."
        else
            echo "Error: Failed to restore the database."
        fi
        unset PGPASSWORD
        ;;
    3)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo "Invalid choice."
        ;;
esac

