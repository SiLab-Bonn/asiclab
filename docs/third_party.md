# Additional Desktop 

# H.264 Support

As of Fedora 37+, H.264 decoders were removed from the based distribution due to legal reasons (alongside H.265). To install alternative H.264 decoders, you can follow the instructions found [here:](https://fedoraproject.org/wiki/OpenH264)

```
sudo dnf config-manager --set-enabled fedora-cisco-openh264
```

and then install the plugins:

```
sudo dnf install gstreamer1-plugin-openh264 mozilla-openh264
```

Afterwards you need open Firefox, go to menu -> Add-ons -> Plugins and enable OpenH264 plugin.

You can do a simple test whether your H.264 works in RTC on [this page](https://mozilla.github.io/webrtc-landing/pc_test.html) (check Require H.264 video). 

# how to install and uninstall standalone rpm packages

To install, just click it. To uninstall.

Execute the following command to discover the name of the installed package:

```rpm -qa | grep PackageName```

This returns PackageName, the RPM name of your Micro Focus product which is used to identify the install package.
Execute the following command to uninstall the product:

```rpm -e PackageName```

# How to install vscode
VS Code is currently only shipped in a yum repository, so first add the repository:

```
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
```

Then install install the key

```
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
```

Update the package cache

```
dnf check-update
```

and install the package using dnf (Fedora 22 and above):

```
sudo dnf install code
```


# Additional packages:

ngspice wol xclock xpdf pandoc inkscape evolution code seahorse texlive iperf apptainer


# Zoom
Simplest way is just to download the official Fedora.rpm from https:/zoom.us. Then just double click on downloaded file in Files GUI. Will figure out Zoom install via command line later.

https://eu02web.zoom.us/support/down4j




# Python venvs

If you're normally used to only Anaconda, stop, and take a deep breath. Weigh the value of your sanity, and then look into how to create Python venvs. This is a new-ish feature in Python, and will make your life better.



# Thunderbird Email

```
sudo dnf install thunderbird
```

Uni-Bonn email setup described [here](https://confluence.team.uni-bonn.de/display/HRZDOK/Einrichten+von+E-Mail+Clients#expand-AccountSetUp) is summarized below:

### Incoming Server Settings:

```
Protocol: IMAP
Hostname: mail.uni-bonn.de
Port: 933
Connection Security: SSL/TLS
Authentication Method: Normal Password
Username: kcaisley@uni-bonn.de
```

### Outgoing Server Settings:

```
Protocol: IMAP
Server Name: mail.uni-bonn.de
Port: 587
Connection Security: STARTTLS
Authentication Method: Normal Password
Username: kcaisley@uni-bonn.de
```
