# at the kernel level
kms (Kernel mode setting)
drm (Direct rendering manager)


# In mesg | grep drm

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

unplug 1:
KERNEL[920.660497] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)
UDEV  [920.666026] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)

replug 1:
KERNEL[924.803333] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)
UDEV  [924.807285] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)

unplug 1+2:
KERNEL[955.564511] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)
UDEV  [955.568427] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)
KERNEL[957.001857] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)
UDEV  [957.003971] change   /devices/pci0000:00/0000:00:02.0/drm/card1 (drm)

replug 1+2:

nothing!


But on Fedora, I get something!
