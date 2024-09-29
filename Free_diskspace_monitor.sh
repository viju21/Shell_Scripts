#author: Vijay Sankar C 
#Description: This script checks the free disk space along with the partition and displays the available space in MB or GB and updated periodicaally.
#Script_name: Free_diskspace_monitor.sh

#!/bin/bash
Display_DiskSpace(){
	free -h 
	du -h 
}

while true; do
	echo "The Disk space in this system:"
	Display_DiskSpace
	sleep 5
done

echo "Diskspace display done successfully"
