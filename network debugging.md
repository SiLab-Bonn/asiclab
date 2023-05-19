`hostnamectl`
shows info about the machines network characteristics, and can be used to change host name

`ethtool [em1]`
prob status of different interfaces, where em1 is example interface

`visudo`
edit the sudoers file

`su -`
switch user to to the root user

`ip -br link show`
show network interfaces, in simple format

`ip -s link show [em1]`
show statistics on specific interface, where em1 example is interface name

`ip link set [em1] up`
enable network interfaces if they are down, but will not always work, if there is a real problem with the hardware. em1 is example interface name

`ip addr`
shows address of all the network interfaces in the machine

the above is primarily for the physical layer
more advice for the data link layer and networking layer can be found here:
https://www.redhat.com/sysadmin/beginners-guide-network-troubleshooting-linux