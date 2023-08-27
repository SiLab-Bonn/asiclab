1. BIOS
2. MBR - loads an executes GRUB boot loader, stored in first sector of /dev/sda/
3. GRUB - loads kernel versions. grub.conf file is stored at /boot/grub/ or /etc/
4. Kernel - mounts root file system listed in grub.conf, executes /sbin/init/
5. init - right before run level programs, detemines run level with /etc/inittab, should pick either RL3 for multi-user.target or RL5 for graphical.target.
6. run level programs


in GRUB, press 'e' to edit kernel parameters
Kernel command line parameters either have the format 'parameter' or 'parameter=value'

`Ctrl + x` to boot

Remove the arguments rhgb quiet and add the arguments loglevel=7 and systemd.log_level=debug instead to change the verbosity to highest level. Press CTRL+x to accept the changes and boot the system. You should see a lot of logs on you screen now.

Instructions: https://www.thegeekdiary.com/centos-rhel-7-how-to-change-the-verbosity-of-debug-logs-during-booting/




# To kill user sessions

https://askubuntu.com/questions/974718/how-do-i-get-the-list-of-the-active-login-sessions

to show the active users and process number

`who -u `

to kill active session

`sudo kill -9 <session-process-number>`