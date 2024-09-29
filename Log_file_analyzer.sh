#author: Vijay Sankar C
#description: This script analyzes a specific log_file and extract specific information such as most frequent IP addressand request URL's and identify 404 and 500 error codes and count their occurences.
#script_name: Log_file_analyzer.sh

#!/bin/bash
#check if the log_file is provided
if [ -z $1 ]; then
	echo "usage:$0 <log_file>"
	exit 1
fi

LogFile=$1
#this provides you flexibility whenever the file is needed in the script.

if [[ ! -f $LogFile ]];  then
	echo "File doesn't exist !!!!!!"
else  
	echo "File exist."
fi

#Fetching IP Addresses
echo "Printing the Frequent IP addresses:"
awk '{print $1}' "$LogFile" | sort | uniq -c  | sort -nr 
#Fetching Request URL's
echo "Printing Request URL's"
awk '{print $7}' "$LogFile" | sort | uniq -c | sort -nr

#Grep the 404 and 500 error codes and their count
echo "Printing 404 error logs:"
grep '404' "$LogFile" | wc -l
echo "--------------------------"
echo "Printing 500 error logs"
grep '500' "$LogFile" | sort | uniq | wc -l

