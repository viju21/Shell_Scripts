#author: Vijay Sankar C
#description: This script demonstrates any changes made to the file that is given as input and provides the time when the modifications are made to it and repeats periodically.
#Script_name: File_watcher.sh

#!/bin/bash
echo "Enter the Filepath:"
read filepath

# Check if the file exists
if [[ ! -f $filepath ]]; then
    echo "File is not found."
    exit 1
else
    echo "File Exists."
fi

# Function to get the modified time (epoch time)
get_modified_time() {
    stat --printf="%Y" "$filepath"
}

# Function to get human-readable modified time in your local timezone
get_human_readable_time() {
    date +"%Y-%m-%d %H:%M:%S" -d "@$(stat --printf="%Y" "$filepath")"
}

# Set initial modified time
initial_modified_time=$(get_modified_time)
human_readable_time=$(get_human_readable_time)
echo "Initial modified time: $human_readable_time"

# Start watching the file for changes
while true; do
    current_modified_time=$(get_modified_time)
    
    # Compare the initial and current modified times
    if [[ $initial_modified_time -ne $current_modified_time ]]; then
        human_readable_time=$(get_human_readable_time)
        echo "!! Changes have been made to your file at $human_readable_time !!"
        # Update the initial modified time to the new one
        initial_modified_time=$current_modified_time
    fi
    
    # Sleep for 60 seconds before checking again
    sleep 5
done

