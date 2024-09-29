#!/bin/bash

# Author: Vijay Sankar C
# Script_name: traffic_monitor.sh
# Description: This script runs every 5 minutes to collect network traffic statistics.
# If the incoming traffic exceeds a certain threshold for three consecutive checks,
# send an email alert to the network administrator.

# Configuration
INTERFACE="enX0"  # Replace with the correct network interface
THRESHOLD=3  # Threshold in KB/s
EMAIL="vijayviju900@gmail.com"
LOG_FILE="/var/log/traffic_monitor.log"
TMP_FILE="/tmp/traffic_tmp.txt"

# Check for required tools
for cmd in ifstat awk bc mail; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd could not be found. Please install it."
        exit 1
    fi
done

# Function to get incoming traffic
get_incoming_traffic(){
    net_Rx=$(ifstat -i $INTERFACE 1 1 | awk 'NR==3 {print $1}')
    if [[ $net_Rx =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        net_rx=$(printf "%.2f" "$net_Rx")
    else
        net_rx="0.00"
    fi
    echo "$net_rx"
}

# Function to log the traffic data
log_traffic(){
    echo "$(date): $1 KB/s" >> "$LOG_FILE"
}

# Function to send an email alert
send_alert(){
    echo "High incoming traffic detected: $1 KB/s for three consecutive checks." | mail -s "Traffic Alert" "$EMAIL"
}

# Main logic
incoming_traffic=$(get_incoming_traffic)
log_traffic "$incoming_traffic"

# Debugging: Print current traffic
echo "Current traffic: $incoming_traffic KB/s"

# Read the previous two traffic readings from the temporary file
if [[ -f $TMP_FILE ]]; then
    prev1=$(sed -n '1p' "$TMP_FILE")
    prev2=$(sed -n '2p' "$TMP_FILE")
else
    prev1="0.00"
    prev2="0.00"
fi

# Debugging: Print previous traffic readings
echo "Previous traffic readings: $prev1 KB/s, $prev2 KB/s"

# Update the temporary file
echo "$incoming_traffic" > "$TMP_FILE"
echo "$prev1" >> "$TMP_FILE"

# Convert readings to numbers for comparison
incoming_traffic_num=$(echo "$incoming_traffic" | bc)
prev1_num=$(echo "$prev1" | bc)
prev2_num=$(echo "$prev2" | bc)

# Print numeric values
echo "Numeric values: incoming_traffic=$incoming_traffic_num, prev1=$prev1_num, prev2=$prev2_num"

# Check if the threshold is exceeded for three consecutive checks
if (( $(echo "$incoming_traffic_num > $THRESHOLD" | bc -l) )) && 
   (( $(echo "$prev1_num > $THRESHOLD" | bc -l) )) && 
   (( $(echo "$prev2_num > $THRESHOLD" | bc -l) )); then
    send_alert "$incoming_traffic"
fi

