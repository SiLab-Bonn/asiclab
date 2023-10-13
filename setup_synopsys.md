# SFTP Download Instructions

Use the command-line sftp utility to connect to the Synopsys Electronic File Transfer (EFT) system using the SFTP protocol:

sftp <SolvNetPlus_username>@eft.synopsys.com
(For example: sftp johndoe@eft.synopsys.com)
Enter your SolvNetPlus password

At the **sftp**> prompt, enter the following commands to download the Synopsys tools:

1. cd site19237
2. cd MyProducts
3. cd rev/installer_v5.6
4. Enter `ls` or `dir` to see the list of product files
5. `get filename` to retrieve the file(s)
6. Enter "quit" to log off the server

> NOTE: For products that use the Synopsys Installer, the product files will be named .spf or .part0n. Typically, you will need to download one or more "common" and OS "platform" files (for example, *common.spf and *linux64.spf). The Synopsys Installer is a separate download, in the site_nnnn_/MyProducts/rev/installer_version directory. For assistance on using the Synopsys Installer, see the [Installation Guide](https://www.synopsys.com/install).**


# Container and Installer Instructions:

https://solvnetplus.synopsys.com/s/article/Synopsys-Container-Installation-Configuration-1576165810868

# Setup Script
```
#setup TCAD stuffs
export LM_LICENSE_FILE=8000@faust02.physik.uni-bonn.de
export STROOT=/tools/synopsys/installs/sentaurus/R_2020.09-SP1
export PATH=$STROOT/bin:$PATH
export STDB=/users/kcaisley/tcad
alias ll='ls -l'
alias la='ls -la'
echo set up dependencies
```


