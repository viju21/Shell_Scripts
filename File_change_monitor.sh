#author: Vijay Sankar C
#description: This script should notice you the time and the user who made the changes of file
# Script_name: File_change_monitor.sh

#!/bin/bash
echo "Give the FilePath to read:"
read filepath

# Check if the file exists
if [[ ! -f "$filepath" ]]; then
    echo "File Doesn't Exist...!!"
    exit 1
else
    echo "File Exists."
fi

# Function to get the modification time (epoch time)
get_modification_time(){
    stat -c %Y "$filepath"
}

# Function to get the last modification time in human-readable format
get_human_readable_modification_time(){
    stat -c %y "$filepath" | cut -d'.' -f1  # Removing milliseconds for cleaner output
}

# Function to get the user who last modified the file
get_modifying_user(){
    stat -c %U "$filepath"
}

# Get the initial modification time
initial_modification_time=$(get_modification_time)

while true; do
    # Get the current modification time
    current_modification_time=$(get_modification_time)

    # If modification time has changed, display the details
    if [[ "$current_modification_time" -ne "$initial_modification_time" ]]; then
        modification_time=$(get_human_readable_modification_time)
        modifying_user=$(get_modifying_user)
        
        echo "The file $filepath has been modified at $modification_time by user: $modifying_user."

        # Update the initial modification time
        initial_modification_time=$current_modification_time
    fi

    # Wait for 5 seconds before checking again
    sleep 5
done

