#!/bin/bash

# Script for monitoring, each minute, the below details in a file call `/var/log/memory_usage.csv`
# Timestamp
# TotalMemoryMB, UsedMemoryMB, FreeMemoryMB, BuffersCacheMemoryMB
# TotalSwapMB, UsedSwapMB, FreeSwapMB
# CPUUser%, CPUSystem%, CPUIdle%
# DiskDevice, r/s, w/s
# NetInterface, rxpck/s, txpck/s, rxkB/s, txkB/s

# Start via:
# sudo /home/ascilab/memory_usage_monitor.sh &

# You can see it's running status like so:
# ps aux | grep memory_usage_monitor.sh

# And you can monitor the output log like this:
# tail -f /var/log/memory_usage.csv

LOG_FILE="/var/log/memory_usage.csv"

# Write headers to the CSV file
echo "Timestamp,TotalMemoryMB,UsedMemoryMB,FreeMemoryMB,BuffersCacheMemoryMB,TotalSwapMB,UsedSwapMB,FreeSwapMB,CPUUser%,CPUSystem%,CPUIdle%,DiskDevice,r/s,w/s,NetInterface,rxpck/s,txpck/s,rxkB/s,txkB/s" > $LOG_FILE

# Function to get memory usage
get_memory_usage() {
    free -m | awk 'NR==2{printf "%s,%s,%s,%s", $2, $3, $4, $6}'
}

# Function to get swap usage
get_swap_usage() {
    free -m | awk 'NR==3{printf ",%s,%s,%s", $2, $3, $4}'
}

# Function to get CPU usage
get_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | awk '{printf ",%.2f,%.2f,%.2f", $2, $4, $8}'
}

# Function to get disk I/O statistics
get_disk_io() {
    iostat -dx | awk 'NR>6 {printf ",%s,%s,%s", $1, $4, $5}'
}

# Function to get network I/O statistics
get_network_io() {
    sar -n DEV 1 1 | awk '/Average/ && $2 != "IFACE" {printf ",%s,%s,%s,%s,%s", $2, $3, $4, $5, $6}'
}

# Log memory usage to file
log_memory_usage() {
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    MEMORY_USAGE=$(get_memory_usage)
    SWAP_USAGE=$(get_swap_usage)
    CPU_USAGE=$(get_cpu_usage)
    DISK_IO=$(get_disk_io)
    NETWORK_IO=$(get_network_io)
    echo "$TIMESTAMP,$MEMORY_USAGE$SWAP_USAGE$CPU_USAGE$DISK_IO$NETWORK_IO" >> $LOG_FILE
}

# Main loop to log memory usage every minute
(
    while true; do
        log_memory_usage
        sleep 60
    done
) &
