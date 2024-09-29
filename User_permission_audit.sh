#author: Vijay Sankar C
#description: This script should list all users, their last login time, and check for any files in sensitive directories (like /etc or /var) with permissions that are too permissive (e.g., old-writable files).
#Script_name: User_permission_audit.sh

#!/bin/bash
# You are accessing most permissive Directories. so, use root user privileges to ignore Permission denied messages.
if [ "$(id -u)" -ne 0 ]; then
    echo "You are not logged in as root user."
    exit 1
else
    echo "You are Logged in as a root user."
fi

# Declare sensitive directories array.
Sensitive_Dir=( "/etc" "/var" )

# Display User Login data and last login time
list_user_last_login() {
    echo "Displaying User last login data:"
    echo "--------------------------------"
    lastlog
}

# Check for files in sensitive directories with permission of old writable
check_permission() {
    echo "Checking for Old-Writable files in Sensitive_Dir:"
    echo "-------------------------------------------------"

    for DIR in "${Sensitive_Dir[@]}"; do
        echo "The List of Old-writable files in $DIR:"
        find "$DIR" -type f -perm -o+w
    done
}

# Calling the functions
list_user_last_login
check_permission

echo "Audit Completed..!!"

