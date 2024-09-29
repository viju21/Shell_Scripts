#Author: Vijay Sankar C
#Script_name: System_resource_monitor.sh
#description: This script monitors CPU, memory, and network usage. Utilize libraries like ncurses to display them in a user-configurable graphical format (e.g., bar charts, gauges). Allow users to choose the refresh rate and potentially switch between different display modes.

#!/bin/bash
#!/bin/bash

# Function to get CPU usage
get_cpu_usage() {
    # Use top command to get CPU usage
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo "$cpu_usage"
}

# Function to get Memory usage
get_mem_usage() {
    # Use free command to get memory usage
    mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    echo "$mem_usage"
}

# Function to get Network usage
# Uses ifstat to get network usage statistics for eth0 interface
get_net_usage() {
    net_usage=$(ifstat -i eth0 1 1 | awk 'NR==3 {print $1, $2}')
    echo "$net_usage"
}

# Retrieve CPU, Memory, and Network usage
cpu_usage=$(get_cpu_usage)
mem_usage=$(get_mem_usage)
net_usage=$(get_net_usage)

# Check if CPU usage is a valid number, if not set to 0
if ! [[ "$cpu_usage" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    cpu_usage=0
fi

# Check if Memory usage is a valid number, if not set to 0
if ! [[ "$mem_usage" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    mem_usage=0
fi

# Check if Network usage is "n/a", if so set TX and RX to 0
if [[ "$net_usage" == "n/a" ]]; then
    net_usage_tx=0
    net_usage_rx=0
else
    # Extract TX and RX values from net_usage
    net_usage_tx=$(echo $net_usage | awk '{print $1}')
    net_usage_rx=$(echo $net_usage | awk '{print $2}')
    
    # Check if TX value is a valid number, if not set to 0
    if ! [[ "$net_usage_tx" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        net_usage_tx=0
    fi
    
    # Check if RX value is a valid number, if not set to 0
    if ! [[ "$net_usage_rx" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        net_usage_rx=0
    fi
fi

# Print the results with two decimal places
printf "CPU Usage: %.2f%%\n" "$cpu_usage"
printf "Mem Usage: %.2f%%\n" "$mem_usage"
printf "Netwk usage: TX %.2f KB/s  RX %.2f KB/s\n" "$net_usage_tx" "$net_usage_rx"

