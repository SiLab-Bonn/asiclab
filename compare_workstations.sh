#!/bin/bash

host_list=( asiclab@asiclab000.physik.uni-bonn.de \
            asiclab@asiclab001.physik.uni-bonn.de \
            asiclab@asiclab002.physik.uni-bonn.de \
            asiclab@asiclab003.physik.uni-bonn.de \
            asiclab@asiclab004.physik.uni-bonn.de \
            asiclab@asiclab006.physik.uni-bonn.de \
            asiclab@asiclab007.physik.uni-bonn.de \
            asiclab@asiclab008.physik.uni-bonn.de \
            asiclab@asiclab011.physik.uni-bonn.de \
   )

# Count number of hosts
host_count=${#host_list[@]}
# echo "Comparing packages on $host_count workstations..."

# For host in "${host_list[@]}"; do ssh $host "hostname"; done
packages=$(for host in "${host_list[@]}"; do
    ssh $host "rpm -qa"
done)

# Replace all spaces with newlines, group packages and count them. Then report those that aren't on all machines. 
echo $packages | tr ' ' '\n' | sort | uniq -c | awk -v host_count=$host_count '$1 != host_count'