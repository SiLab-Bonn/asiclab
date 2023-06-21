# FlexNet License Server Configuration
The license server is running on faust02 and can be accessed via web interface http://faust02.physik.uni-bonn.de:8888 to check its status, update licenses, read log files etc.
For the admin section, you need to use the root account credentials.

The binaries and license files live on penelope in `/cadence/other/lmadmin` and are mounted on faust02.

## lmadmin
The FlexNet binary (`/cadence/other/lmadmin/lmadmin`) manages all licenses and provides the web interface. After a reboot, this binary has to be started manually.

## Licenses and vendor deamons
Licenses are separated by vendor. Each license file (and the matching vendor daemon binary) is stored in a separate folder in `/cadence/other/lmadmin/license`.

# Client Configuration
To access the licenses from a client, add the server address to your environment: `export LM_LICENSE_FILE=8000@faust02.physik.uni-bonn.de`. Add this line to your ~/.bashrc or application-specific startup script if needed.
