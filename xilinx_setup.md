



# Installation on penelope, as asiclab

Following: http://www.diy.ind.in/linux/64-install-xilinx-platform-cable-usb-ii-driver

```
cd /tools/xilinx
dnf install git
sudo git clone git://git.zerfleddert.de/usb-driver
sudo dnf install make gcc glibc-devel
cd usb-driver
sudo nano Makefile    #comment out the line about '-m32', to disable 32bit build
sudo make
```



# On client

The one-time initial setup is as follows

```
sudo dnf install fxload libusb1 libusb1-devel libusb-compat-0.1 libusb-compat-0.1-devel
./setup_pcusb /tools/xilinx/14.7/ISE_DS/ISE
sudo udevadm control --reload-rules
```

Unplug and replug - and you should see a red light.

You may need to set the following env variable after sourcing a settings file (doesn't appear necessary)?

```
export LD_PRELOAD=/opt/Xilinx/usb-driver/libusb-driver.so   #not needed
```

Then finally, from user home directory, or some local work dir:

```
cd [workdir]
source /tools/xilinx/14.7/ISE_DS/settings64.sh
impact &
```

This last block is all to should need to on subsequent use.