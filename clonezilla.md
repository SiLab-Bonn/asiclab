## Instructions for operating Clonezilla to restore CentOS7 Image

* in BIOS change boot to legacy

- boot from usb
- deafult clonezilla mode (sometimes gets stuck, displays orange stripes - maybe because of too much RAM. Needs power cycling)
- default language
- keep keyboard layout
- start terminal, 'sudo nano /etc/ssh/ssh_config', and add line 'HostKeyAlgorithms +ssh-rsa,ssh-dss'.
- Save and close. Exit terminal.
- start clonezilla
- mode: device-image
- ssh_server
- choose active network port
- config network
- server name: penelope.physik.uni-bonn.de
- port 22 (default)
- account: root (default)
- dir: /cadence/os/
- confirm login, give password
- begginer mode
- savedisk or restore disk, depending on need
  for restore
- choose image
- select both hdd and ssd
- check before restoring
- choose end action
- after check is done confirm overwrite for all drives
- 
