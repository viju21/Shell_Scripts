#author: VS
#Description: This Script demonstrates reading input filepath and displaying the size of the file.
#Script_name: File_size_check.sh
#!/bin/bash

# Prompt user to enter the file path
echo "Please enter the file path:"
read filepath

# Check if the file exists
if [[ -f "$filepath" ]]; then
        echo "File Exists"
        # Get only the file size, suppressing the file path
        filesize=$(du -h "$filepath" | cut -f1)
        echo "Disk Usage of the given file: $filesize"
else
        echo "File Doesn't exist"
fi

echo "---------------------------"
echo "File size check successful"

