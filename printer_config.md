
## Configuring printers

Access to network printers in the FTD is provided via CUPS, which is the standard client-server printing system used on Unix-like systems. It consisting of a server responsible for managing print queues and printers (in this case managed by the PI), and a client allowing users to submit print jobs. The server is installed on the computer or device that the printers are connected to, while the client can be installed on any device that needs to print. The client and server communicate over the network using the Internet Printing Protocol (IPP), providing an efficient way to manage printing tasks on Unix-like systems.

To configure a machine's CUPS client to connect to the PI printer server (`cups.physik.uni-bonn.de`), you should create a `/etc/cups/client.conf` file:

```
touch /etc/cups/client.conf
```

And then edit the empty file, so that is contains the line:

```
echo "ServerName cups.physik.uni-bonn.de"
```

All printers on the FTD network should now be available. To check, you can view a summary of available network printers with the following command:

```
lpstat -t
```

