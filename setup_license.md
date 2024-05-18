# FlexNet License Server Configuration
The license server is running on faust02 and can be accessed via web interface http://faust02.physik.uni-bonn.de:8888 to check its status, update licenses, read log files etc.
For the admin section, you need to use the root account credentials.

The binaries and license files live on penelope in `/cadence/other/lmadmin` and are mounted on faust02.

## lmadmin
The FlexNet binary (`/cadence/other/lmadmin/lmadmin`) manages all licenses and provides the web interface. After a reboot, this binary has to be started manually.

## Licenses and vendor deamons
Licenses are separated by vendor. Each license file (and the matching vendor daemon binary) is stored in a separate folder in `/cadence/other/lmadmin/licenses`.

## Updating a license
New license files (usually received via email) are moved to the vendor-specific folder e.g. via scp. Old license files can be deleted or renamed. In some license files, a few adjustments in the header must be made. The Mentor Graphics file must include the host name (also make sure to remove the server port from the header) and the server daemon path.

The vendor-specific server has to be restarted via the management page (section `Vendor Daemon Configuration`) for the new license to become active.

## Updating a vendor daemon
Licenses may require a minimum vendor dameon version. You might be able to start the daemon after replacing the license, but won't be able to use the license and you will find error messages in the log files.

Synopsys:
- Download the "Installer" and the "Synopsys Common Licensing" (SCL) files via (S)FTP or their website https://www.synopsys.com/support/licensing-installation-computeplatforms/licensing.html.
- Following the readme, run the installer and point it to the downloaded SCL files. Enter the site number, which can be found in the license file, when prompted.
- The installation script copies a bunch of files to the given target directory (/usr/synopsys by default) but only of them seems to be needed for our purpose: `[target dir]/scl/2023.09/linux64/bin/snpslmd`.
  Copy this file to `/cadence/other/lmadmin/licenses/snpslmd/`. Feel free to rename the file, but keep is consistent with the vendor daemon configuration of FlexNet.
- In the web interface, stop and start the daemon and check the daemon log file.

# Client Configuration
To access the licenses from a client, add the server address to your environment: `export LM_LICENSE_FILE=8000@faust02.physik.uni-bonn.de`. Add this line to your ~/.bashrc or application-specific startup script if needed.

# EP Instructions:
Before you start the license server you will need to edit the license file. Edit the SERVER line to specify the server name (faust02) and edit the VENDOR line to specify the path to the snpslmd vendor daemon (including executable name).
It also might me required to either remove the port number from the first line or match it to the actual port the daemon is using on.
The key file example below shows the fields that you need, where `server_name` and `vendor_daemon_path` are to be edited:

```
SERVER server_name 123456789012 27020
VENDOR snpslmd vendor_daemon_path
USE_SERVER
INCREMENT SSS snpslmd 1.0 31-Dec-2022 1 0E75D6C8DFSDFSSFDE933A \
VENDOR_STRING="2ba5a b9253 3611c 47b02 bcc52 3f2bf a54d3 d32de e85f3 fcb11 \
```

Under windows the license server is setup and configured using the LMTOOL utility. This enables you to add the
license server as a Windows service. The documentation included with SCL provides further details of this.
Under Linux, the license server is started manually using the lmgrd executable. For example,

```
% lmgrd –c key –l log
```

# me?

export CLIOSOFT_DIR=/cadence/clio/sos_7.20.p1_linux64
export PATH="${CLIOSOFT_DIR}/bin:${PATH}"
