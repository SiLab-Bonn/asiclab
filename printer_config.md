
## adding a printer:
Configure the CUPS client to use one of the following CUPS servers:
cups.physik.uni-bonn.de (PI network)

To do this, create a file /etc/cups/client.conf  with the contents:
`ServerName cups.physik.uni-bonn.de`


setting up wireguard:
https://confluence.team.uni-bonn.de/display/PHYIT/WireGuard+VPN#tab-Linux

To check the port of service:
`cat /etc/service | less`


