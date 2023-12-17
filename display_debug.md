# at the kernel level
kms (Kernel mode setting)
drm (Direct rendering manager)


# In dmesg | grep drm

- eDP is being 'disabled', and giving referenced to a PCIe bus addes as the i915 driver?
- fbcon (frame buffer controller) is referecing fb0 as the 'primary device', and is then relating this to i915 and the same address 0000:00:02:0
- nouveau, at address 0000:001:00.0, can't find any device
- then systemd is reporting DRM kernel module sucessfully started.

Note: DRM is 'direct rendering manager', which is part of the kernel?


# udevadm monitor

stands for userspace /dev, and it manager the virtual `/dev` directory

`udev` is part of `systemd`, but responds to kernel 'uevents'. It replaces `devfsd` and `hotplug`.

Concretely, it's run as `systemd-udevd.service`, so it's a daemon, plus the `udevadm` manager tool.

I can see uevents being generated here

From arch wiki:

udev rules written by the administrator go in /etc/udev/rules.d/, their file name has to end with .rules. The udev rules shipped with various packages are found in /usr/lib/udev/rules.d/. If there are two files by the same name under /usr/lib and /etc, the ones in /etc take precedence.

Running `sudo udevadm monitor`:

unplug 1:
```
KERNEL[920.660497] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)
UDEV  [920.666026] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)
```

replug 1:

```
KERNEL[924.803333] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)
UDEV  [924.807285] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)
```

unplug 1+2:

```
KERNEL[955.564511] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)
UDEV  [955.568427] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)
KERNEL[957.001857] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)
UDEV  [957.003971] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)
```

replug 1+2:

Nothing on Alma, but on Fedora, I get the replug events!


udev maps the contents of /dev

contents of /sys/class/drm point to different devices under /sys/devices



The DRM module is responsible for the `/sys/class/` subtree in SysFS. You can browse the source code for that in the kernal at `drivers/gpu/drm/drm_sysfs.c`.

The subdirectories are per-connector, with a name of the form `card%d-%s` with `%d` replaced by an index (that I know nothing about) and `%s` replaced with the connector name.

Five files per device should show up:

    Connection status
    Enabled (or not)
    DPMS state
    Mode list
    EDID

For some devices, you'll get extra information for sub-connectors too.


```bash
$ ls -la /sys/class/drm

total 0
drwxr-xr-x.  2 root root    0 Dec 15 17:07 .
drwxr-xr-x. 69 root root    0 Dec 15 17:07 ..
lrwxrwxrwx.  1 root root    0 Dec 15 17:07 card0 -> ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card0
lrwxrwxrwx.  1 root root    0 Dec 15 17:07 card0-DVI-D-1 -> ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card0/card0-DVI-D-1
lrwxrwxrwx.  1 root root    0 Dec 15 17:07 card0-HDMI-A-4 -> ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card0/card0-HDMI-A-4
lrwxrwxrwx.  1 root root    0 Dec 15 17:07 card0-VGA-1 -> ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card0/card0-VGA-1
lrwxrwxrwx.  1 root root    0 Dec 15 17:07 card1 -> ../../devices/pci0000:00/0000:00:02.0/drm/card1
lrwxrwxrwx.  1 root root    0 Dec 15 17:07 card1-DP-1 -> ../../devices/pci0000:00/0000:00:02.0/drm/card1/card1-DP-1
lrwxrwxrwx.  1 root root    0 Dec 15 17:07 card1-DP-2 -> ../../devices/pci0000:00/0000:00:02.0/drm/card1/card1-DP-2
lrwxrwxrwx.  1 root root    0 Dec 15 17:07 card1-DP-3 -> ../../devices/pci0000:00/0000:00:02.0/drm/card1/card1-DP-3
lrwxrwxrwx.  1 root root    0 Dec 15 17:07 card1-HDMI-A-1 -> ../../devices/pci0000:00/0000:00:02.0/drm/card1/card1-HDMI-A-1
lrwxrwxrwx.  1 root root    0 Dec 15 17:07 card1-HDMI-A-2 -> ../../devices/pci0000:00/0000:00:02.0/drm/card1/card1-HDMI-A-2
lrwxrwxrwx.  1 root root    0 Dec 15 17:07 card1-HDMI-A-3 -> ../../devices/pci0000:00/0000:00:02.0/drm/card1/card1-HDMI-A-3
lrwxrwxrwx.  1 root root    0 Dec 15 17:07 renderD128 -> ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/drm/renderD128
lrwxrwxrwx.  1 root root    0 Dec 15 17:07 renderD129 -> ../../devices/pci0000:00/0000:00:02.0/drm/renderD129
-r--r--r--.  1 root root 4096 Dec 15 17:08 version
```


From this, we can see that `card1` is the built in graphics devices, with two display ports. It is directly on the main PCI bus. This is the devices that uevents are being generated about:

```/pci0000:00/0000:00:02.0/drm/card1```

And `card0` os the Nvidia GPU, which is connected through the `00:01.0` PCI bridge, then appearing as `01:00.1`. We can ignore that, as we're not using it.

```/pci0000:00/0000:00:01.0/0000:01:00.0/drm/card0```

# Futher steps

Now, as `/sys/class/drm/` is just a collection of symlinks at `/sys/devices/`, we should examine:

With the computer screen off, I see:

```bash
$ cat /sys/devices/pci0000:00/0000:00:02.0/drm/card1/card1-DP-1/enabled 
disabled
$ cat /sys/devices/pci0000:00/0000:00:02.0/drm/card1/card1-DP-2/enabled 
disabled
$ cat /sys/devices/pci0000:00/0000:00:02.0/drm/card1/card1-DP-3/enabled 
disabled
```

But after wiggling the mouse, I see:

```bash
$ cat /sys/devices/pci0000:00/0000:00:02.0/drm/card1/card1-DP-1/enabled 
enabled
$ cat /sys/devices/pci0000:00/0000:00:02.0/drm/card1/card1-DP-2/enabled 
enabled
$ cat /sys/devices/pci0000:00/0000:00:02.0/drm/card1/card1-DP-3/enabled 
disabled
```

If I unplug the power cable from the monitor, or unplug either end of the DisplayPort cable, I now notice that this file reads `disabled` on all 3 ports.

I still see all the ports for `card1` in `/sys/class/drm`.
Also, `dmesg` doesn't have any post boot messages. So the only hint so far is the lack of `uevents` see with `udevadm`.

At load time, the PCIe display driver is recognized:

```bash
$ dmesg | grep -e i915 -e drm -e fb
[    0.279786] pci 0000:00:02.0: BAR 2: assigned to efifb
[    0.293841] pci 0000:00:1f.4: reg 0x20: [io  0xefa0-0xefbf]
[    0.513273] efifb: probing for efifb
[    0.513278] efifb: framebuffer at 0x80000000, using 9000k, total 9000k
[    0.513279] efifb: mode is 1920x1200x32, linelength=7680, pages=1
[    0.513280] efifb: scrolling: redraw
[    0.513280] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.516284] fb0: EFI VGA frame buffer device
[    1.574776] ACPI: bus type drm_connector registered
[    2.203002] i915 0000:00:02.0: vgaarb: deactivate vga console
[    2.205099] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=none:owns=io+mem
[    2.205731] i915 0000:00:02.0: [drm] Finished loading DMC firmware i915/kbl_dmc_ver1_04.bin (v1.4)
[    2.232079] nouveau 0000:01:00.0: fb: 2048 MiB DDR3
[    2.559100] i915 0000:00:02.0: [drm] [ENCODER:94:DDI A/PHY A] failed to retrieve link info, disabling eDP
[    2.610578] [drm] Initialized i915 1.6.0 20201103 for 0000:00:02.0 on minor 1
[    2.668271] fbcon: i915drmfb (fb0) is primary device
[    2.742207] i915 0000:00:02.0: [drm] fb0: i915drmfb frame buffer device
[    2.904841] [drm] Initialized nouveau 1.3.1 20120801 for 0000:01:00.0 on minor 0
[    2.918028] nouveau 0000:01:00.0: [drm] Cannot find any crtc or sizes
[    2.931200] nouveau 0000:01:00.0: [drm] Cannot find any crtc or sizes
[    2.944302] nouveau 0000:01:00.0: [drm] Cannot find any crtc or sizes
[    2.958451] nouveau 0000:01:00.0: [drm] Cannot find any crtc or sizes
[    2.971534] nouveau 0000:01:00.0: [drm] Cannot find any crtc or sizes
[    3.464823] systemd[1]: Starting Load Kernel Module drm...
[    3.474984] systemd[1]: modprobe@drm.service: Deactivated successfully.
[    3.475063] systemd[1]: Finished Load Kernel Module drm.
[    3.882978] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
```

Examining my loaded kernel modules, I see this, which doesn't change after hotplug:

```bash
$ lsmod | grep -e drm -e i915
i915                 3796992  10
drm_buddy              20480  1 i915
intel_gtt              28672  1 i915
drm_ttm_helper         16384  1 nouveau
drm_display_helper    200704  2 i915,nouveau
drm_kms_helper        245760  4 drm_display_helper,i915,nouveau
syscopyarea            16384  1 drm_kms_helper
sysfillrect            16384  1 drm_kms_helper
sysimgblt              16384  1 drm_kms_helper
cec                    69632  2 drm_display_helper,i915
ttm                    98304  3 drm_ttm_helper,i915,nouveau
drm                   704512  12 drm_kms_helper,drm_display_helper,drm_buddy,drm_ttm_helper,i915,ttm,nouveau
i2c_algo_bit           16384  3 igb,i915,nouveau
video                  73728  3 dell_wmi,i915,nouveau
```

```bash
$ uname -srv
Linux 5.14.0-362.8.1.el9_3.x86_64 #1 SMP PREEMPT_DYNAMIC Tue Nov 7 14:54:22 EST 2023
```

```bash
$ lspci
00:00.0 Host bridge: Intel Corporation 8th Gen Core Processor Host Bridge/DRAM Registers (rev 07)
00:01.0 PCI bridge: Intel Corporation 6th-10th Gen Core Processor PCIe Controller (x16) (rev 07)
00:02.0 VGA compatible controller: Intel Corporation CoffeeLake-S GT2 [UHD Graphics 630]
00:08.0 System peripheral: Intel Corporation Xeon E3-1200 v5/v6 / E3-1500 v5 / 6th/7th/8th Gen Core Processor Gaussian Mixture Model
00:12.0 Signal processing controller: Intel Corporation Cannon Lake PCH Thermal Controller (rev 10)
00:14.0 USB controller: Intel Corporation Cannon Lake PCH USB 3.1 xHCI Host Controller (rev 10)
00:14.2 RAM memory: Intel Corporation Cannon Lake PCH Shared SRAM (rev 10)
00:15.0 Serial bus controller: Intel Corporation Cannon Lake PCH Serial IO I2C Controller #0 (rev 10)
00:16.0 Communication controller: Intel Corporation Cannon Lake PCH HECI Controller (rev 10)
00:17.0 SATA controller: Intel Corporation Cannon Lake PCH SATA AHCI Controller (rev 10)
00:1b.0 PCI bridge: Intel Corporation Cannon Lake PCH PCI Express Root Port #17 (rev f0)
00:1d.0 PCI bridge: Intel Corporation Cannon Lake PCH PCI Express Root Port #9 (rev f0)
00:1f.0 ISA bridge: Intel Corporation Q370 Chipset LPC/eSPI Controller (rev 10)
00:1f.3 Audio device: Intel Corporation Cannon Lake PCH cAVS (rev 10)
00:1f.4 SMBus: Intel Corporation Cannon Lake PCH SMBus Controller (rev 10)
00:1f.5 Serial bus controller: Intel Corporation Cannon Lake PCH SPI Controller (rev 10)
00:1f.6 Ethernet controller: Intel Corporation Ethernet Connection (7) I219-LM (rev 10)
01:00.0 VGA compatible controller: NVIDIA Corporation GK208B [GeForce GT 710] (rev a1)
01:00.1 Audio device: NVIDIA Corporation GK208 HDMI/DP Audio Controller (rev a1)
02:00.0 Non-Volatile memory controller: SK hynix PC401 NVMe Solid State Drive 256GB
03:00.0 Ethernet controller: Intel Corporation I210 Gigabit Network Connection (rev 03)
```

Systems are booting with these command line parameters:

```bash
$ cat /proc/cmdline
BOOT_IMAGE=(hd1,gpt2)/vmlinuz-5.14.0-362.8.1.el9_3.x86_64 root=UUID=fba9b961-aaa4-4ae2-8ab1-0051c443c757 ro crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M resume=UUID=720f1edd-941c-449e-8d17-a6d0433d8d82 rhgb quiet
```

The DisplayPort jack is coming from a PCIe device on the mother board, which is identified as: `00:02.0 VGA compatible controller: Intel Corporation CoffeeLake-S GT2 [UHD Graphics 630]`.

The PCIe device is recognized and assigned in `dmesg` as `drm fb0`. It's using the i915 driver.

When I unplug the cable, I see a`udevadm` uevent, but then when I replug it, I don't see any uevent.

After this hotplug, there are no relevant messages in `dmesg`.








# Message

Hi there, I'm currently having some issues with display hotplugging with DisplayPort, and was someone here might have some advice on what to try next.

I have several Dell OptiPlex 7060 workstations, running version EL9.3 with kernel version `5.14.0-362`. They each have 2 DP connectors on the motherboard, connected to 1-2 external monitors. If I unplug the 1080p monitors, and then hotplug them back in, the graphical display doesn't return and monitors read 'No signal'.

The issue:

- Happens when unplugging either the DP cable or the AC cable of the display monitors, or when switching away from the display with a KVM switch.
- Only happens when 'last' monitor is unplugged. (If there are dual displays, unplugging just one doesn't cause an issue).
- Does not occur when turning off the monitor normally with the power buttom.
- Happens regardless of GNOME vs KDE, or Wayland vs X11.
- Happens even in a basic Linux console, with graphical target disabled via `systemctl set-target multi-user.target`
- Happens on 3 identical machines, all with the same OS config.
- Does not happen on a 4th identical machine which is running Fedora 38.

I've gather the following infomation to try and debug these machines:

1. I can still `ssh` into the machine, and see my processes running via `top` and the graphical user logged in via `who`.

1. The PCIe device which is driving these two DP connectors is `00:02.0 VGA compatible controller: Intel Corporation CoffeeLake-S GT2 [UHD Graphics 630]`

1. Running `sudo udevadm monitor`, I checked to make sure uevents were properly being generated by the kernel.

When I have two monitors plugged, and I just unplug one, I see a kernel uevent and a matching `udev` rule being triggered:

```
KERNEL[920.660497] change   /devices/pci0000:00/0000:00:02.0/drm/card0 (drm)
UDEV  [920.666026] change   /devices/pci0000:00/0000:00:02.0/drm/card0 (drm)
```

Then when I replug it, the display returns and I see another pair of events:

```
KERNEL[924.803333] change   /devices/pci0000:00/0000:00:02.0/drm/card0 (drm)
UDEV  [924.807285] change   /devices/pci0000:00/0000:00:02.0/drm/card0 (drm)
```

However if I unplug both cables (or just one, if the system only had one monitor), I see:

```
KERNEL[955.564511] change   /devices/pci0000:00/0000:00:02.0/drm/card0 (drm)
UDEV  [955.568427] change   /devices/pci0000:00/0000:00:02.0/drm/card0 (drm)
KERNEL[957.001857] change   /devices/pci0000:00/0000:00:02.0/drm/card0 (drm)
UDEV  [957.003971] change   /devices/pci0000:00/0000:00:02.0/drm/card0 (drm)
```

..and when I then plug them/it back in, I get nothing! The monitor isn't detected and I get no display. (On the Fedora machine, I do see replug events and get my display back.)

1. The system is booted with these kernel paramaters:

```bash
$ cat /proc/cmdline
BOOT_IMAGE=(hd1,gpt2)/vmlinuz-5.14.0-362.8.1.el9_3.x86_64 root=UUID=fba9b961-aaa4-4ae2-8ab1-0051c443c757 ro crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M resume=UUID=720f1edd-941c-449e-8d17-a6d0433d8d82 rhgb quiet
```

1. The follow kernel modules are loaded (both before and after hotplugging):

```bash
$ lsmod | grep -e drm -e i915
i915                 3796992  10
drm_buddy              20480  1 i915
intel_gtt              28672  1 i915
drm_ttm_helper         16384  1 nouveau
drm_display_helper    200704  2 i915,nouveau
drm_kms_helper        245760  4 drm_display_helper,i915,nouveau
syscopyarea            16384  1 drm_kms_helper
sysfillrect            16384  1 drm_kms_helper
sysimgblt              16384  1 drm_kms_helper
cec                    69632  2 drm_display_helper,i915
ttm                    98304  3 drm_ttm_helper,i915,nouveau
drm                   704512  12 drm_kms_helper,drm_display_helper,drm_buddy,drm_ttm_helper,i915,ttm,nouveau
i2c_algo_bit           16384  3 igb,i915,nouveau
video                  73728  3 dell_wmi,i915,nouveau
```

1. And checking the `dmesg` buffer, I see the following messages after boot (with no additions after hotplugging):

```bash
$ dmesg | grep -e i915 -e drm -e fb
[    0.274253] pci 0000:00:02.0: BAR 2: assigned to efifb
[    0.287283] pci 0000:00:1f.4: reg 0x20: [io  0xefa0-0xefbf]
[    0.493034] efifb: probing for efifb
[    0.493039] efifb: framebuffer at 0x80000000, using 9000k, total 9000k
[    0.493040] efifb: mode is 1920x1200x32, linelength=7680, pages=1
[    0.493041] efifb: scrolling: redraw
[    0.493041] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.496062] fb0: EFI VGA frame buffer device
[    1.543671] ACPI: bus type drm_connector registered
[    1.999687] i915 0000:00:02.0: vgaarb: deactivate vga console
[    2.001763] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    2.002485] i915 0000:00:02.0: [drm] Finished loading DMC firmware i915/kbl_dmc_ver1_04.bin (v1.4)
[    2.355823] i915 0000:00:02.0: [drm] [ENCODER:94:DDI A/PHY A] failed to retrieve link info, disabling eDP
[    2.358474] i915 0000:00:02.0: [drm] [ENCODER:110:DDI C/PHY C] is disabled/in DSI mode with an ungated DDI clock, gate it
[    2.358477] i915 0000:00:02.0: [drm] [ENCODER:120:DDI D/PHY D] is disabled/in DSI mode with an ungated DDI clock, gate it
[    2.397412] [drm] Initialized i915 1.6.0 20201103 for 0000:00:02.0 on minor 0
[    2.454382] fbcon: i915drmfb (fb0) is primary device
[    2.528446] i915 0000:00:02.0: [drm] fb0: i915drmfb frame buffer device
[    3.460761] systemd[1]: Starting Load Kernel Module drm...
[    3.472272] systemd[1]: modprobe@drm.service: Deactivated successfully.
[    3.472405] systemd[1]: Finished Load Kernel Module drm.
[    3.882919] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops i915_audio_component_bind_ops [i915])
```

1. Checking in the sysfs directory `/sys/devices`, I see the the aformentioned integrated graphics at PCIe address `00:02.0` appears to be setup as `card0`. If I print out the `enabled` folder for the 2 prots, before the hotplug with screen on, I see:

```bash
$ cat /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-DP-1/enabled 
enabled
$ cat /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-DP-2/enabled 
enabled
```

But after hotplugging the cables, I see the ports read as 'disabled', as those the display were still powered off or unplugged:

```bash
$ cat /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-DP-1/enabled 
disabled
$ cat /sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-DP-2/enabled 
disabled
```