## How to install vscode
VS Code is currently only shipped in a yum repository, and so the following script will install the key and repository:

```
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
```

Then update the package cache and install the package using dnf (Fedora 22 and above):

```
dnf check-update
sudo dnf install code
```


# Python venvs

If you're normally used to only Anaconda, stop, and take a deep breath. Weigh the value of your sanity, and then look into how to create Python venvs. This is a new feature in Python, and will make your life better
