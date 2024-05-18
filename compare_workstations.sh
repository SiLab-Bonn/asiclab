#!/bin/bash

ssh_list=(  asiclab@asiclab000.physik.uni-bonn.de \
            asiclab@asiclab001.physik.uni-bonn.de \
            asiclab@asiclab002.physik.uni-bonn.de \
            asiclab@asiclab003.physik.uni-bonn.de \
            asiclab@asiclab004.physik.uni-bonn.de \
            asiclab@asiclab006.physik.uni-bonn.de \
            asiclab@asiclab007.physik.uni-bonn.de \
	    asiclab@asiclab008.physik.uni-bonn.de \
            asiclab@asiclab011.physik.uni-bonn.de \
   )

#for host in "${ssh_list[@]}"; do ssh $host "hostname"; done

packages=$(for host in "${ssh_list[@]}"; do
    ssh $host "rpm -qa"
done)

echo $packages | tr ' ' '\n' | sort | uniq -c | awk '$1 != 9'
