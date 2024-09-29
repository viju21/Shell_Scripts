#author: Vijay Sankar C
#description: This script demonstrates about the repetition of displaying system info periodically
#Script_name: System_info_display.sh

#!/bin/bash
get_username(){
 	whoami
}
get_hostname(){
	hostname
}
get_kernel_version(){
	uname -r
}

display_systeminfo(){
	local username=$(get_username)
	local hostname=$(get_hostname)
	local kernel_version=$(get_kernel_version)

	echo "-----------------------------------"
	echo "System info"
	echo "-----------------------------------"
	echo "$username" 
        echo "$hostname"
        echo "$kernel_version"
	echo "-----------------------------------"
}

while true; do
	display_systeminfo
	echo "$username"
	echo "$hostname"
	echo "$kernel_version"
	sleep 60
done

