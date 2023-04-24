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



# How to install vscode
VS Code is currently only shipped in a yum repository, so first add the repository:

```
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
``

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


# Zoom
Simplest way is just to download the official Fedora.rpm from https:/zoom.us. Then just double click on downloaded file in Files GUI. Will figure out Zoom install via command line later.


# Python venvs

If you're normally used to only Anaconda, stop, and take a deep breath. Weigh the value of your sanity, and then look into how to create Python venvs. This is a new-ish feature in Python, and will make your life better.



# Neovim and Copilot:

Following instructions from [here](https://docs.github.com/en/copilot/getting-started-with-github-copilot/getting-started-with-github-copilot-in-neovim).

```
sudo dnf install nodejs neovim
git clone https://github.com/github/copilot.vim \
   ~/.config/nvim/pack/github/start/copilot.vim
```

Then in vim:

```
:Copilot setup
:Copilot enable
```
