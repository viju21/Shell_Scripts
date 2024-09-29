#Author: Vijay Sankar C
#Script_name: Timer_announcer.sh
#Description: This script demonstrates about the greeting an candidate along announcing the timer updated every minute.

#!/bin/bash
read -p "Enter the Name:" name
timer_announcer(){
	local timer=$( date +"%D %T %::z %Z")
	echo "Hi,$name.Today's date and time in(HH:MM:SS) along with timezone is $timer"
}

while true; do
	timer_announcer
	sleep 60	
done




