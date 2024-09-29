#author: VS
#description: This Script demonstrates a countdown timer with user input.
#Script_name: countdown_with_user.sh
#!/bin/bash
echo "Enter the duration of the timer"
read duration

if [[ $duration -gt 0 ]]; then
	echo "The Timer Starts"
else 
	echo "Please enter an Valid integer"
fi

#until [[ $duration -eq 0 ]]; do
#	echo "$duration seconds remaining"
#	sleep 1
#	(( duration-- ))
#done

while [[ $duration -gt 0 ]]; do
	echo "$duration seconds remaining"
	(( duration--))
	sleep 1
done

echo "Time is up!!!!"

