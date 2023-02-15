
## Configuring printers

To configure a machine's CUPS client to connect to the PI `cups.physik.uni-bonn.de` printer server, you can create `/etc/cups/client.conf` file:

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
