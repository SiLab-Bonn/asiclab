Follow these steps to download, unpack, and install the corresponding EDA tools, which needs to be done before the `setup_*****.md` instructions. The latter is for installing Linux packages, and creating scripts which can be sourced to set the necessary ENV variables nad 

# Europratice EDA tools
This provides Cadence, Synopsys, and Siemens tools.

It they can all be downloaded over FTP from the europratice website 

```
wget -r -nH --cut-dirs=3 --ftp-user=user --ftp-password=password -nc ftp://download.msc.rl.ac.uk/Synopsys/2023-24_easy_installs/ -P /eda/store/
```

# Synopsys/Cirranova PyCells and Pycell studio

This isn't necessary for the 

[Visited the register page](https://www.synopsys.com/cgi-bin/pycellstudio/req1.cgi)

Got email with username and password.

I tried [authenticating via this method](https://stackoverflow.com/questions/1324421/how-to-get-past-the-login-page-with-wget) but it didn't let me download the .tar.gz file anyways. So I just used ssh -X to remote start a firefox window on penelope.

From [this link](https://www.synopsys.com/cgi-bin/pycellstudio/download/install.cgi) I learned that, the steps are:

1. Download the appropriate Complete Kit for your platform and OpenAccess version. If you are not yet using OpenAccess, choose the most recent version.

2. Uncompress the download package in a temporary directory by typing:
```
% tar -xfz <name_of_package>
```

3. On a command line in the ciranova_installer-<platform> directory, type:

```
% ./installer
```

At the end of the installation process, the script will return a path name ending in a directory called "quickstart." Open the "README.txt" file in that quickstart directory, and follow its instructions.

The Linux command 'cnversion' will return the PyCell Studio release date and version.