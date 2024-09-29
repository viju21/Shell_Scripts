#author: Vijay Sankar C
#description: This script gives you a random fortune for every iteration.
#script_name: Fortune_teller.sh
#!/bin/bash
Fortunes=(
"You are your best thing."
"Never break a promise to yourself."
"To one who has faith, no explanation is necessary. To one without faith, no explanation is possible."
"So go ahead. Fall down ! The world looks different from the ground."
"A person who never made a mistake never tried anything new."
"Give yourself a chance to see what happens when you don't give up."
"Faith does not eliminate questions. But faith knows where to take them."
"Positive mindset always."
"When it comes to your dreams, no is not an answer."
"Adjust your eyes. See the same things differently."
"Master your worries."
"The quiet speaks volumes."
"Let yourself dream again."
"Embracing chaos might be the journey we take to finding peace."
"The only impossible journey is the one you never begin."
"The More you get compressed is proportionally the heights you reach"
)

display_fortune(){
	local fortune_of_the_day=$((RANDOM % ${#Fortunes[@]}))
	echo "${Fortunes[$fortune_of_the_day]}"
}

while true; do
	display_fortune
	sleep 8
done

