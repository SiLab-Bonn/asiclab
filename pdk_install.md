

## Europratice Kits

To download files larger than 100 MB you have to use the Querio FTP server instead. You can login to the FTP server using the same user name and password used to login to Querio.

To access the files on the FTP server,


For security reasons, the FTP server will only accept encrypted connections. Therefore you have to configure your FTP client to use implicit SSL/TLS encryption.

The table below gives an overview of the FTP server settings that your FTP client requires in order to connect. Note that your FTP client may not need all of these settings to be explicitly defined. For example the port and transfer mode are usually automatically set by the FTP client.

| Server/host:         | data.europractice-ic.com       |
| :------------------- | ------------------------------ |
| Port:                | 990                            |
| User name:           | Same as your Querio user name. |
| Password:            | Same as your Querio password.  |
| Security/encryption: | SSL/TLS implicit               |
| Transfer mode:       | Passive                        |



The following transcript shows how to download:

```
[asiclab@penelope kits]$ sudo dnf install lftp
[asiclab@penelope kits]$ lftp ftps://data.europractice-ic.com
lftp data.europractice-ic.com:~> set ssl:verify-certificate no
lftp data.europractice-ic.com:~> login kennedycaisley
Password: 
lftp kennedycaisley@data.europractice-ic.com:~> pwd
ftps://kennedycaisley@data.europractice-ic.com
lftp kennedycaisley@data.europractice-ic.com:~> pwd
ftps://kennedycaisley@data.europractice-ic.com
lftp kennedycaisley@data.europractice-ic.com:~> ls
dr-x------   1 Querio Querio            0 Jul 28  2022 CERN
lftp kennedycaisley@data.europractice-ic.com:/> cd CERN/
lftp kennedycaisley@data.europractice-ic.com:/CERN> mirror TSMC28
```

As seen above, the easiest method to recursively download an entire directory is to have an identically named on on the local machine, and to use the `lftp ~> mirror <directory name>` command.

Also note that `set ssl:verify-certificate no` is unsecure, as it could allow for man in the middle attacks, but the better method [shown here](https://stackoverflow.com/questions/23900071/how-do-i-get-lftp-to-use-ssl-tls-security-mechanism-from-the-command-line#44095714) didn't work, and I'm not paid enough to figure out why.

### Joining the split .gz files:


```bash
cat HEP_DesignKit_TSMC28_HPCplusRF_v1.0.tar.gz.part_* > HEP_DesignKit_TSMC28_HPCplusRF_v1.0.tar.gz
```



### To untar the files, with progress bar:

```
pv HEP_DesignKit_TSMC28_HPCplusRF_v1.0.tar.gz | tar -xz
```



To run the installPdk.pl file, a perl module is needed? No we don't need this, as we are using the CERN standard PDK install.

```
sudo dnf install perl-FileHandle
HEP_DesignKit_TSMC28_HPCplusRF_v1.0/pdk/1P9M_5X1Y1Z1U_UT_AlRDL/cdsPDK/pdkInstall.pl
```



## 65nm PDK notes

PDK Install Directory Structure

```
Techfile/            : Includes all temporary files which are used for install program
Assura/              : Assura LVS/QRC command files
Calibre/             : Calibre DRC/LVS/XRC command files
CCI/                 : Calibre Star-RCXT CCI flow technology files directory
PDK_doc/             : Includes all documents, please check ReleaseNote 
                       before using this PDK.
REVISION             : Revision history
cds.lib              : cds library mapping file
display.drf          : Virtuoso display file
readme               : readme file
ReleaseNote.txt      : PDK detail information
pdkInstall.pl        : PDK installation utility
pdkInstall.cfg       : PDK installation configuraion
skill/               : skill directory includes all callback and utility
models/              : hspice/spectre/eldo models
techfile             : Virtuoso tech file
mapfile              : layout editor mapfile
tsmcN65/             : PDK library
```

#### SPICE Models

    PROCESS  : 65nm Mixed Signal RF SALICIDE Low-K IMD (1.2/2.5/over-drive 3.3V)(CRN65LP)
    MODEL    : BSIM4 ( V4.5 )
    DOC. NO. : T-N65-CM-SP-007
    VERSION  : V1.7
    DATE     : March 21, 2012
    
    PROCESS  : 65nm Mixed Signal RF SALICIDE Low-K IMD (1.2/3.3V)(CRN65LP)
    MODEL    : BSIM4 ( V4.5 )
    DOC. NO. : T-N65-CM-SP-012
    VERSION  : v1.5
    DATE     : March 21, 2012
    
    SPECTRE VERSION : 7.1.0.048
    HSPICE  VERSION : A-2008.03
    ELDO    VERSION : v2009.2a

  Moreover, this PDK has been tested to work with the following software
  versions:


       *ICFB              IC6.1.5.500.5			cadence
       *Spectre           sub-version  7.2.0.477.isr16 	cadence	
       *Hspice            2008.03-SP1			sysnopsys
       *ELDO              2009.2			mentor
       *Calibre           v2009.3_15.12			cadence
       *Assura            AV4.1_USR2_HF9-615		mentor
       *QRC               EXT101_2_HF3			mentor (for resistance specifically)
       *StarRC            E-2010.12-SP2			synopsys
       *Perl              v5.12.2
       *ncsim             08.20-s003			for digital sim, from cadence

## 28nm Install

https://asic-support-28.web.cern.ch/documents/cern_tsmc28HPCplus_pdk_final.pdf

https://asic-support-28.web.cern.ch/tech-docs/pdk_install/

We can just follow the basic untar and copy procedure. Everthing is already setup with:

```bash
# In cds.lib

# DO NOT MODIFY LINES BELOW
# base Cadence Virtuoso and PDK libraries (including MSOA)
INCLUDE $PDK_PATH/$PDK_RELEASE/pdk/$PDK_OPTION/cdsPDK_MSOA/cds.lib

# PDK Digital libraries
INCLUDE $PDK_PATH/$PDK_RELEASE/TSMCHOME/digital/Back_End/cdk/cds.lib.$PDK_OPTION
```

```bash
# In start.sh
setenv PDK_PATH <folder where you want to install the PDK>
setenv PDK_RELEASE HEP_DesignKit_TSMC28_HPCplusRF_v1.0
setenv PDK_OPTION 1P9M_5X1Y1Z1U_UT_AlRDL
```

