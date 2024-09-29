#Author: Vijay Sankar C
#Description: This Script demonstrates about the system uptime monitoring and updating it every 5 seconds.
#script_name: System_uptime_monitor.sh

#!/bin/bash
display_uptime(){
	local sysup=$(uptime)
	echo "Displaying System Uptime and refreshing it every 5 seconds:$sysup"
}

#while true; do
#	display_uptime
#	sleep 5
#done

until false; do
	display_uptime
	sleep 5
done

