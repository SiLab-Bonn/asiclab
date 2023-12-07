# Installing GUI apps from zip

Installing Typora, Thunderbird, or any other plain zip program. [Instructions](https://support.mozilla.org/en-US/kb/installing-thunderbird-linux)

1. Go to the [Thunderbird's download page](https://www.thunderbird.net/download/) and click on the Free Download button.
2. Open a terminal and go to the folder where your download has been saved. For example:

    ```
    cd ~/Downloads 
    ```

3. Extract the contents of the downloaded file by typing:

    ```
    tar xjf thunderbird-*.tar.bz2 
    ```

4. Move the uncompressed Thunderbird folder to /opt:

    ```
    cp thunderbird /opt 
    ```

5. Create a symlink to the Thunderbird executable:

    ```
    ln -s /opt/thunderbird/thunderbird /usr/local/bin/thunderbird 
    ```

6. Download and install a copy of the desktop file:

    ```
    wget https://raw.githubusercontent.com/mozilla/sumo-kb/main/installing-thunderbird-linux/thunderbird.desktop -P /usr/local/share/applications 
    ```

# H.264 Support

As of Fedora 37+, H.264 decoders were removed from the based distribution due to legal reasons (alongside H.265). To install alternative H.264 decoders, you can follow the instructions found [here:](https://fedoraproject.org/wiki/OpenH264)

```
sudo dnf config-manager --set-enabled fedora-cisco-openh264
```

and then install the plugins:

```
sudo dnf install openh264 gstreamer1-plugin-openh264 mozilla-openh264
```

Afterwards you need open Firefox, go to menu -> Add-ons -> Plugins and enable OpenH264 plugin.

You can do a simple test whether your H.264 works in RTC on [this page](https://mozilla.github.io/webrtc-landing/pc_test.html) (check Require H.264 video).


# Install and uninstall standalone rpm packages

To manuall installl an rpm package:

```
sudo rpm --import [package.rpm]
```

Execute the following command to discover the name of the installed package:

```rpm -qa | grep PackageName```

This returns PackageName, the RPM name of your Micro Focus product which is used to identify the install package.
Execute the following command to uninstall the product:

```rpm -e PackageName```


# Additional programs:

- mc
- hwinfo
- htop
- thunderbird
- libreoffice-calc, libreoffice-impress, libreoffice-writer
- chromium
- gnome-tweaks
- groupinstall "Workstation"
- inkscape

# VS Code
VS Code is currently only shipped in a yum repository, so first add the repository:

```
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
```

Then add the package repo to `/etc/yum.repos.d`, via:

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

# Zoom

Check the link for the latest rpm package from the `download` website. Then download it via `wget`, for example :

```bash
wget https://zoom.us/client/5.16.10.668/zoom_x86_64.rpm
```

Get the latest public key like so:

```
# This is currently not working, due to RHEL9 deprecating SHA1:

"warning: Signature not supported. Hash algorithm SHA1 not available."

wget https://zoom.us/linux/download/pubkey
sudo rpm --import pubkey
```

Finally, you may need to set SELinux to 'permissive' mode, to prevent it from blocking Zoom usage:

```
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/using_selinux/changing-selinux-states-and-modes_using-selinux#changing-to-permissive-mode_changing-selinux-states-and-modes
```

# Python venvs

If you're normally used to only Anaconda, stop, and take a deep breath. Weigh the value of your sanity, and then look into how to create Python venvs. This is a new-ish feature in Python, and will make your life better.


# Email

### Incoming Server Settings:

```
Protocol: IMAP
Hostname: mail.uni-bonn.de
Port: 993
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

# Calendar:

```
Username: kcaisley
CalDAV: https://mail.uni-bonn.de/CalDAV/Work/
```

# Gnome extensions

Go to https://extensions.gnome.org/local/ and enable 'Launch new ...'

- is there a way to do this from command line?
