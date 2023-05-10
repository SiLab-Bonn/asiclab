



# Installation on penelope, as asiclab

Following: http://www.diy.ind.in/linux/64-install-xilinx-platform-cable-usb-ii-driver

```
cd /tools/xilinx
dnf install git
sudo git clone git://git.zerfleddert.de/usb-driver
sudo dnf install make gcc glibc-devel
cd usb-driver

sudo nano Makefile
 #comment -m32
```



# On client

```
sudo dnf install fxload libusb1 libusb1-devel libusb-compat-0.1 libusb-compat-0.1-devel
./setup_pcusb /opt/Xilinx/14.7/ISE_DS/ISE
sudo udevadm control --reload-rules
```

Unplug and replug - and you should see a red light.

You may need to set the following env variable after sourcing a settings file.

`export LD_PRELOAD=/opt/Xilinx/usb-driver/libusb-driver.so`

Then finally, from user home directory, or some local work dir:

```
cd ~
source /tools/xilinx/14.7/ISE_DS/settings64.sh
impact &
```