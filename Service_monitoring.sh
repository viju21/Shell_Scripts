#author: Vijay Sankar C
#Script name: Service Monitoring Script
#description: This script monitors critical system services (e.g., Apache, SSH, MySQL) and restarts them automatically if they are found to be down. Include logging functionality to record service status changes.

#!/bin/bash
# Declare Global Variables
Services=("ssh" "httpd")
Log_file="$HOME/Service_monitoring.log"
Interval=60

# Function for Log messages
Log_message(){
    local message="$1"
    echo "$(date +"%Y-%m-%d %H:%M:%S") : $message" >> "$Log_file"
}

# Function for checking Service status
Check_service_status(){
    local Service="$1"
    systemctl is-active --quiet "$Service"
}

# Function for restarting the service
Restart_service(){
    local res_service="$1"
    sudo systemctl restart "$res_service"
    if Check_service_status "$res_service"; then
        Log_message "Your Service $res_service is Restarting now !!!"
    else
        Log_message "Your Service $res_service failed to restart"
    fi
}

# Main Loop to iterate it
while true; do
    for Service in "${Services[@]}"; do
        if ! Check_service_status "$Service"; then
            Log_message "Your Service $Service is down. Attempting to restart $Service"
            Restart_service "$Service"
        else
            Log_message "Your Service $Service is running."
        fi
    done
    sleep "$Interval"
done

