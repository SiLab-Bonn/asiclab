First, I made sure the MATE Desktop was installed with:

yum groupinstall "MATE Desktop"

next I check to make sure the default target for UI was graphical:

sudo systemctl get-default

then I tried to start the desktop, with:

sudo systemctl isolate graphical.target

This brought me back to TTY1, and the lightdm service showed, but then it crashed:

Inspecting the logs, I can see this is the case:

sudo journalctl -b -u lightdm.service
-- Logs begin at Wed 2022-07-20 13:39:36 CEST, end at Wed 2022-07-20 14:02:38 CEST. --
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: Starting Light Display Manager...
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: Started Light Display Manager.
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service: main process exited, code=exited, status=1/FAILURE
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: Unit lightdm.service entered failed state.
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: Triggering OnFailure= dependencies of lightdm.service.
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service failed.
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service holdoff time over, scheduling restart.
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: Stopped Light Display Manager.
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: Starting Light Display Manager...
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: Started Light Display Manager.
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service: main process exited, code=exited, status=1/FAILURE
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: Unit lightdm.service entered failed state.
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: Triggering OnFailure= dependencies of lightdm.service.
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service failed.
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service holdoff time over, scheduling restart.
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: Stopped Light Display Manager.
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: Starting Light Display Manager...
Jul 20 13:57:58 asiclab008.physik.uni-bonn.de systemd[1]: Started Light Display Manager.
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service: main process exited, code=exited, status=1/FAILURE
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: Unit lightdm.service entered failed state.
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: Triggering OnFailure= dependencies of lightdm.service.
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service failed.
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service holdoff time over, scheduling restart.
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: Stopped Light Display Manager.
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: Starting Light Display Manager...
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: Started Light Display Manager.
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service: main process exited, code=exited, status=1/FAILURE
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: Unit lightdm.service entered failed state.
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: Triggering OnFailure= dependencies of lightdm.service.
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service failed.
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service holdoff time over, scheduling restart.
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: Stopped Light Display Manager.
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: Starting Light Display Manager...
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: Started Light Display Manager.
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service: main process exited, code=exited, status=1/FAILURE
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: Unit lightdm.service entered failed state.
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: Triggering OnFailure= dependencies of lightdm.service.
Jul 20 13:57:59 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service failed.
Jul 20 13:58:00 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service holdoff time over, scheduling restart.
Jul 20 13:58:00 asiclab008.physik.uni-bonn.de systemd[1]: Stopped Light Display Manager.
Jul 20 13:58:00 asiclab008.physik.uni-bonn.de systemd[1]: start request repeated too quickly for lightdm.service
Jul 20 13:58:00 asiclab008.physik.uni-bonn.de systemd[1]: Failed to start Light Display Manager.
Jul 20 13:58:00 asiclab008.physik.uni-bonn.de systemd[1]: Unit lightdm.service entered failed state.
Jul 20 13:58:00 asiclab008.physik.uni-bonn.de systemd[1]: Triggering OnFailure= dependencies of lightdm.service.
Jul 20 13:58:00 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service failed.
Jul 20 13:58:31 asiclab008.physik.uni-bonn.de systemd[1]: Starting Light Display Manager...
Jul 20 13:58:31 asiclab008.physik.uni-bonn.de systemd[1]: Started Light Display Manager.
Jul 20 13:58:31 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service: main process exited, code=exited, status=1/FAILURE
Jul 20 13:58:31 asiclab008.physik.uni-bonn.de systemd[1]: Unit lightdm.service entered failed state.
Jul 20 13:58:31 asiclab008.physik.uni-bonn.de systemd[1]: Triggering OnFailure= dependencies of lightdm.service.
Jul 20 13:58:31 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service failed.
Jul 20 13:58:31 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service holdoff time over, scheduling restart.
Jul 20 13:58:31 asiclab008.physik.uni-bonn.de systemd[1]: Stopped Light Display Manager.
Jul 20 13:58:31 asiclab008.physik.uni-bonn.de systemd[1]: Starting Light Display Manager...
Jul 20 13:58:31 asiclab008.physik.uni-bonn.de systemd[1]: Started Light Display Manager.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service: main process exited, code=exited, status=1/FAILURE
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Unit lightdm.service entered failed state.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Triggering OnFailure= dependencies of lightdm.service.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service failed.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service holdoff time over, scheduling restart.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Stopped Light Display Manager.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Starting Light Display Manager...
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Started Light Display Manager.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service: main process exited, code=exited, status=1/FAILURE
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Unit lightdm.service entered failed state.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Triggering OnFailure= dependencies of lightdm.service.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service failed.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service holdoff time over, scheduling restart.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Stopped Light Display Manager.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Starting Light Display Manager...
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Started Light Display Manager.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service: main process exited, code=exited, status=1/FAILURE
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Unit lightdm.service entered failed state.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Triggering OnFailure= dependencies of lightdm.service.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service failed.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service holdoff time over, scheduling restart.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Stopped Light Display Manager.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Starting Light Display Manager...
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Started Light Display Manager.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service: main process exited, code=exited, status=1/FAILURE
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Unit lightdm.service entered failed state.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: Triggering OnFailure= dependencies of lightdm.service.
Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service failed.
Jul 20 13:58:33 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service holdoff time over, scheduling restart.
Jul 20 13:58:33 asiclab008.physik.uni-bonn.de systemd[1]: Stopped Light Display Manager.
Jul 20 13:58:33 asiclab008.physik.uni-bonn.de systemd[1]: start request repeated too quickly for lightdm.service
Jul 20 13:58:33 asiclab008.physik.uni-bonn.de systemd[1]: Failed to start Light Display Manager.
Jul 20 13:58:33 asiclab008.physik.uni-bonn.de systemd[1]: Unit lightdm.service entered failed state.
Jul 20 13:58:33 asiclab008.physik.uni-bonn.de systemd[1]: Triggering OnFailure= dependencies of lightdm.service.
Jul 20 13:58:33 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service failed.

● lightdm.service - Light Display Manager
   Loaded: loaded (/usr/lib/systemd/system/lightdm.service; disabled; vendor preset: enabled)
   Active: failed (Result: start-limit) since Wed 2022-07-20 13:58:33 CEST; 9min ago
     Docs: man:lightdm(1)
  Process: 7518 ExecStart=/usr/sbin/lightdm (code=exited, status=1/FAILURE)
 Main PID: 7518 (code=exited, status=1/FAILURE)

Jul 20 13:58:32 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service failed.
Jul 20 13:58:33 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service holdoff time over, scheduling restart.
Jul 20 13:58:33 asiclab008.physik.uni-bonn.de systemd[1]: Stopped Light Display Manager.
Jul 20 13:58:33 asiclab008.physik.uni-bonn.de systemd[1]: start request repeated too quickly for lightdm.service
Jul 20 13:58:33 asiclab008.physik.uni-bonn.de systemd[1]: Failed to start Light Display Manager.
Jul 20 13:58:33 asiclab008.physik.uni-bonn.de systemd[1]: Unit lightdm.service entered failed state.
Jul 20 13:58:33 asiclab008.physik.uni-bonn.de systemd[1]: Triggering OnFailure= dependencies of lightdm.service.
Jul 20 13:58:33 asiclab008.physik.uni-bonn.de systemd[1]: lightdm.service failed.
figured I should just bypass lightdm, and try starting X display server myself
sudo systemctl disable lightdm.service

Then running startx, I get an error that no screens are found. Inspecting the log '/var/log/Xorg.O.log':


[   372.991] 
X.Org X Server 1.20.4
X Protocol Version 11, Revision 0
[   372.998] Build Operating System:  3.10.0-957.1.3.el7.x86_64 
[   373.000] Current Operating System: Linux asiclab008.physik.uni-bonn.de 4.20.2-1.el7.elrepo.x86_64 #1 SMP Sun Jan 13 09:57:55 EST 2019 x86_64
[   373.000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.20.2-1.el7.elrepo.x86_64 root=UUID=339a2a54-dc5c-4814-8221-3cc37f1827c7 ro crashkernel=auto rhgb quiet nouveau.modeset=0
[   373.004] Build Date: 04 January 2022  05:44:44PM
[   373.005] Build ID: xorg-x11-server 1.20.4-17.el7_9 
[   373.007] Current version of pixman: 0.34.0
[   373.011] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[   373.011] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[   373.018] (==) Log file: "/var/log/Xorg.0.log", Time: Wed Jul 20 15:50:16 2022
[   373.020] (==) Using config file: "/etc/X11/xorg.conf"
[   373.021] (==) Using config directory: "/etc/X11/xorg.conf.d"
[   373.023] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[   373.023] (==) ServerLayout "Layout0"
[   373.023] (**) |-->Screen "Screen0" (0)
[   373.023] (**) |   |-->Monitor "Monitor0"
[   373.023] (**) |   |-->Device "Device0"
[   373.023] (**) |-->Input Device "Keyboard0"
[   373.023] (**) |-->Input Device "Mouse0"
[   373.023] (==) Automatically adding devices
[   373.023] (==) Automatically enabling devices
[   373.023] (==) Automatically adding GPU devices
[   373.023] (==) Automatically binding GPU devices
[   373.023] (==) Max clients allowed: 256, resource mask: 0x1fffff
[   373.024] (WW) `fonts.dir' not found (or not valid) in "/usr/share/fonts/default/Type1".
[   373.024] 	Entry deleted from font path.
[   373.024] 	(Run 'mkfontdir' on "/usr/share/fonts/default/Type1").
[   373.024] (**) FontPath set to:
	catalogue:/etc/X11/fontpath.d,
	built-ins
[   373.024] (==) ModulePath set to "/usr/lib64/xorg/modules"
[   373.024] (WW) Hotplugging is on, devices using drivers 'kbd', 'mouse' or 'vmmouse' will be disabled.
[   373.024] (WW) Disabling Keyboard0
[   373.024] (WW) Disabling Mouse0
[   373.024] (II) Loader magic: 0x55d15023d020
[   373.024] (II) Module ABI versions:
[   373.024] 	X.Org ANSI C Emulation: 0.4
[   373.024] 	X.Org Video Driver: 24.0
[   373.024] 	X.Org XInput driver : 24.1
[   373.024] 	X.Org Server Extension : 10.0
[   373.024] (II) xfree86: Adding drm device (/dev/dri/card0)
[   373.024] (II) Platform probe for /sys/devices/pci0000:00/0000:00:02.0/drm/card0
[   373.030] (--) PCI:*(0@0:2:0) 8086:3e92:1028:085a rev 0, Mem @ 0x90000000/16777216, 0x80000000/268435456, I/O @ 0x00003000/64, BIOS @ 0x????????/131072
[   373.030] (II) LoadModule: "glx"
[   373.031] (II) Loading /usr/lib64/xorg/modules/extensions/libglx.so
[   373.054] (II) Module glx: vendor="X.Org Foundation"
[   373.054] 	compiled for 1.20.4, module version = 1.0.0
[   373.054] 	ABI class: X.Org Server Extension, version 10.0
[   373.054] (II) LoadModule: "nvidia"
[   373.055] (II) Loading /usr/lib64/xorg/modules/drivers/nvidia_drv.so
[   373.057] (II) Module nvidia: vendor="NVIDIA Corporation"
[   373.057] 	compiled for 1.6.99.901, module version = 1.0.0
[   373.057] 	Module class: X.Org Video Driver
[   373.058] (II) NVIDIA dlloader X Driver  430.40  Sun Jul 21 05:01:54 CDT 2019
[   373.058] (II) NVIDIA Unified Driver for all Supported NVIDIA GPUs
[   373.058] (++) using VT number 1

[   373.058] (EE) No devices detected.
[   373.058] (EE) 
Fatal server error:
[   373.058] (EE) no screens found(EE) 
[   373.058] (EE) 
Please consult the The X.Org Foundation support 
	 at http://wiki.x.org
 for help. 
[   373.058] (EE) Please also check the log file at "/var/log/Xorg.0.log" for additional information.
[   373.058] (EE) 
[   373.104] (EE) Server terminated with error (1). Closing log file.


Inspecting the the Xconf file '/etc/X11.xorg.conf' I see:


# nvidia-xconfig: X configuration file generated by nvidia-xconfig
# nvidia-xconfig:  version 430.40

Section "ServerLayout"
    Identifier     "Layout0"
    Screen      0  "Screen0"
    InputDevice    "Keyboard0" "CoreKeyboard"
    InputDevice    "Mouse0" "CorePointer"
EndSection

Section "Files"
    FontPath        "/usr/share/fonts/default/Type1"
EndSection

Section "InputDevice"
    # generated from default
    Identifier     "Mouse0"
    Driver         "mouse"
    Option         "Protocol" "auto"
    Option         "Device" "/dev/input/mice"
    Option         "Emulate3Buttons" "no"
    Option         "ZAxisMapping" "4 5"
EndSection

Section "InputDevice"
    # generated from default
    Identifier     "Keyboard0"
    Driver         "kbd"
EndSection

Section "Monitor"
    Identifier     "Monitor0"
    VendorName     "Unknown"
    ModelName      "Unknown"
    Option         "DPMS"
EndSection

Section "Device"
    Identifier     "Device0"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
EndSection

Section "Screen"
    Identifier     "Screen0"
    Device         "Device0"
    Monitor        "Monitor0"
    DefaultDepth    24
    SubSection     "Display"
        Depth       24
    EndSubSection
EndSection


Let plug back in my graphics card, because it's obviously trying to use it!

I tried plugging it in, but this didn't fix the problem. Therefore my best solution is to uninstall the nvidia drivers, and try to startx without any reference to Nvidia.



# Two days later:

before spinning wheel of lightdm:
"a TPM error occured during the self test"
"failed to enable AA"


dracut emergency shell

"could not boot"
"/dev/disk/by-uuid/########## does not exist"
"starting Dracut Emergency Shell"
"Entering emergency mode. Exit the shell to continue"
"Type jounalctl to view system logs."



booting with an emergency kernel has not effect
I should try booting with the verbose kernel options in grub

--------------------------

order of booting:

1. BIOS
2. MBR - loads an executes GRUB boot loader, stored in first sector of /dev/sda/
3. GRUB - loads kernel versions. grub.conf file is stored at /boot/grub/ or /etc/
4. Kernel - mounts root file system listed in grub.conf, executes /sbin/init/
5. init - right before run level programs, detemines run level with /etc/inittab, should pick either RL3 for multi-user.target or RL5 for graphical.target.
6. run level programs



in GRUB, press 'e' to edit kernel parameters
Kernel command line parameters either have the format 'parameter' or 'parameter=value'

Ctrl + x to boot

Remove the arguments rhgb quiet and add the arguments loglevel=7 and systemd.log_level=debug instead to change the verbosity to highest level. Press CTRL+x to accept the changes and boot the system. You should see a lot of logs on you screen now.

Instructions: https://www.thegeekdiary.com/centos-rhel-7-how-to-change-the-verbosity-of-debug-logs-during-booting/


# and then, 3 days after that:

commands learned:


hostnamectl
shows info about the machines network characteristics, and can be used to change host name

ethtool [em1]
prob status of different interfaces, where em1 is example interface

visudo
edit the sudoers file

su -
switch user to to the root user

ip -br link show
show network interfaces, in simple format

ip -s link show [em1]
show statistics on specific interface, where em1 example is interface name

ip link set [em1] up
enable network interfaces if they are down, but will not always work, if there is a real problem with the hardware. em1 is example interface name

ip addr
shows address of all the network interfaces in the machine

the above is primarily for the physical layer
more advice for the data link layer and networking layer can be found here:
https://www.redhat.com/sysadmin/beginners-guide-network-troubleshooting-linux



# To kill user sessions

https://askubuntu.com/questions/974718/how-do-i-get-the-list-of-the-active-login-sessions

to show the active users and process number
`who -u `

to kill active session
`sudo kill -9 <session-process-number>`