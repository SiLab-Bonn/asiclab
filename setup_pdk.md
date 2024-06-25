# TSMC 28nm

should also use BSIM 4.5. Only has one metal stack choice of 1p9, but CERN is evaluating 1p8. HPC+ replaced standard HPC.

In general, you want to seperate design data from the startup working directory of cadence. The files in this startup area should mostly be copied from the reference implementation given by the PDK. This is sometimes called a 'skel', for skeleton.

## 28nm Change log:

## 06.2022 -> Installed V1.0 of 28nm CERN PDK

Start first by fetching from Europractice Kits

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

Joining the split .gz files:

https://asic-support-28.web.cern.ch/tech-docs/pdk-install/


From here, we can just follow the basic untar and copy procedure. Everthing is already setup with:


```bash
cat HEP_DesignKit_TSMC28_HPCplusRF_v1.0.tar.gz.part_* > HEP_DesignKit_TSMC28_HPCplusRF_v1.0.tar.gz
```

To untar the files, with progress bar:

```
pv HEP_DesignKit_TSMC28_HPCplusRF_v1.0.tar.gz | tar -xz
```

Placed in `/tools/kits/TSMC/28HPC+/2022_v1.0`


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

## 07.2023 28nm PDK version 1.1 released -> installed 04.2024
Downloaded to `/tools/kits/TSMC/28HPC+/downloads`

Files include:

```
HEP_PDK_TSMC28_HPCplusRF_v1.1__dig_12T_30L.tar.gz
HEP_PDK_TSMC28_HPCplusRF_v1.1__dig_12T_35L.tar.gz
HEP_PDK_TSMC28_HPCplusRF_v1.1__dig_12T_40L.tar.gz
HEP_PDK_TSMC28_HPCplusRF_v1.1__dig_7T_30L.tar.gz
HEP_PDK_TSMC28_HPCplusRF_v1.1__dig_7T_35L.tar.gz
HEP_PDK_TSMC28_HPCplusRF_v1.1__dig_7T_40L.tar.gz
HEP_PDK_TSMC28_HPCplusRF_v1.1__dig_9T_30L.tar.gz
HEP_PDK_TSMC28_HPCplusRF_v1.1__dig_9T_35L.tar.gz
HEP_PDK_TSMC28_HPCplusRF_v1.1__dig_9T_40L.tar.gz
HEP_PDK_TSMC28_HPCplusRF_v1.1__iopads.tar.gz
HEP_PDK_TSMC28_HPCplusRF_v1.1__pdk-main.tar.gz
```

Which unpack to one dir called `HEP_DesignKit_TSMC28_HPCplusRF_v1.1`.
Then I simply copied it to the new directory via `cp -r HEP_DesignKit_TSMC28_HPCplusRF_v1.1/* /tools/kits/TSMC/28HPC+/2023_v1.1/`

Run rsync to make sure directories are equal, then change permissions recursively:

```
cd /mnt/md127/tools/kits/TSMC/28HPC+
rsync -av downloads/HEP_DesignKit_TSMC28_HPCplusRF_v1.1/ 2023_v1.1/
sudo chown -R asiclab:tsmc28 /path/to/your/directory
```



## 01.2024 28nm DRC v2.2 released -> installed 04.2024
[See link here for download link.](https://asic-support-28.web.cern.ch/tech-docs/drc-decks/)
Downloaded to `tools/kits/TSMC/28HPC+/downloads`

File is called `2024.02__tsmc28_calibre_decks_v2.2a.zip`

Git based installed instructions from `README.me` were:

```
Clone the repository in the PDK installation path as follows:
cd $PDK_PATH/$PDK_RELEASE/pdk/$PDK_OPTION
git clone https://gitlab.cern.ch/asic-design-support/hep28/calibre-decks.git ./Calibre
```

But we don't have git access, so we did the following instead.

```
rsync -av /mnt/md127/tools/kits/TSMC/28HPC+/downloads/2024.02__tsmc28_calibre_decks_v2.2a/ /mnt/md127/tools/kits/TSMC/28HPC+/2023_v1.1/pdk/1P9M_5X1Y1Z1U_UT_AlRDL/Calibre/
sudo chown -R asiclab:tsmc28 /mnt/md127/tools/kits/TSMC/28HPC+
```

## Spice models heirarchy

In 28nm, toplevel.scs -> crn28ull_1d8_elk_v1d8_2p2_shrink0d9_embedded_usage.scs (.LIB TTMacro_MOS_MOSCAP) -> cln28ull_1d8_elk_v1d8_3.scs (TT_MOS_CAP)


## 28nm forum notes (Nov 30th, 2023)

Marco Andorono, CERN:
- CERN IP blocks plus a distributed list of different institution shared IP designs
- analog IP, digital soft IP (software like, rtl code, verified), hard digital IP (output of flow: layouts, good for highly optimized floor plan)
- after 3-way NDA, and EDA tool sharing (one per IP) and CERN design sharing letter (one per institute)
- IP block datasheet template
- IP block design doesn't stop with layout, it need documentation and files for using in digital-on-top flow (LIB, abstract)
- Abstract generation for analog block will haver a user guide soon
- Lib file has timing arcs, power, etc. Liberate AMS generator can automate this.
- OD/PO dummy fill should be done at block level, there is a script for this
- Latch up violations should be avoided using guard rings
- Triple guard rings are recommended for blocks, and between power domains. Using LVS logical boundary

Frank Bandi, CERN:
- Analog blocks: Bandgap, 8bit ADC, SLVS TX/RX, TID monitoring, Radhard ESD and CMOS IO pads (from Sofics)
- Integrated DC-DC converters, LDOs, shunt LDOs
- 14b Sigma delta ADC, Fin 20kHz, for monitoring
- Fast and slow rail-to-rail

Adam Klekotko and Stefan Biereigel, KU Leuven/CERN:
- DART28 25.6 Gbps per lane, NRZ, four lanes.
- High Speed Transmitter macro block:
	- 12.8 Ghz all digital PLL w/ LC oscillator
	- TMR high-speed serializer (20:1): uses (True single phase clocking) TSPC logic dynamic circuits, storing data in node capacitance. Faster than static circuits.
	- pre-emphasis
	- Dual-use driver (DUDE) for silicon photonics ring modulator or 100ohm differential transmission line
- Clock coming from PLL needed duty-cycle correct, and balancing of even-odd jitter (EOJ)
- Single lane operation, 120mW per channel. Driver > Serializer > All other blocks
- HST block has RTL (divider and low speed serializer) and Full custom (high-speed serlizer and output) part
- Liberate AMS only captures interfaces timing, long run time,
- Mixed signal simulation takes a long time to run
- STA flow is best! Load OA schematic/layout into innovus, each block and heirachy is characterized with .lib, and then in innovus you can simulate


## Review of PDK Docs:

Some earlier discussion of 28nm:

[](https://agenda.infn.it/event/12813/contributions/16317/attachments/11832/13318/PLL.pdf)

[](https://agenda.infn.it/event/12813/contributions/16303/attachments/11836/13322/FullCustom.pdf)

full custom layout, digital pll, 

>   The “very essential” rules for design in 28 nm are:
    Design Rule #1: Use only transistors for your design
    Design Rule #2: If you need passive components, then go back to Rule #1


All document are found in prefix: `/tools/kits/TSMC/CRN28HPC+/HEP_DesignKit_TSMC28_HPCplusRF_v1.0/pdk/1P9M_5X1Y1Z1U_UT_AlRDL/cdsPDK/PDK_doc/TSMC_DOC_WM/`

- `PDK/Application_note_for_customized_cells.pdf`: instructions on adding 3rd party IP into TSMC PDK, by streaming in layouts, assigning pins
- `PDK/N28_APP_of_MonteCarlo_statistical_simulation.pdf`: MonteCarlo is done by changing `top_tt` library for `top_globalmc_localmc` model cards of transistors. Is this do-able with Spectre natively, or do we need 'ADE XL' as a front end?
- `PDK/parasitic_rc_UserGuide.pdf`: Raphael 2D and 3D parasitic models for PEX. (Actually in pdk, under do-not-use) See: ![](https://cseweb.ucsd.edu/classes/fa12/cse291-c/slides/L5extract.pdf)
- `PDK/tsmcN28MSOAEnablement.pdf`: summarizes metal stack up, MSOA (mixed signal open access) explanation
- `PDK/tsmc_PDK_usage_guide.pdf`: I see that I need to copy `display.drf` and `ln -s` link in `models` and `steam` to my `tsmc28` init directory.
- `model/2d5 (or 1d8) /cln28ull_v1d0_2_usage_guide.pdf`: And finally, the master document for transitor models. Version 2d5 vs 1d8 folder doesn't matter
  - primitive MOSFET models have been replaced with macro model (compiled TMI shared library)
  - core transistor is BSIM6 version BSIMBULK binary model, surrounding layout effect are macro
  - diodes use standard spice model
  - resistors, mom varactors, and fmom use TSMC proprietary models
  - You should see a `** TMI Share Library Version XXXXXX` in the sim log, if not there may be problem
  - SPICE netlist difference
    ```
    For primitive model:
    M1 d g s b nch l=30n w=0.6u
    .print dc I1(M1)
    
    For macro model:
    X1 d g s b nch_mac l=30n w=0.6u
    .print dc I1(X1.main)
    ```
  - Layout effects are modeled in either SPICE model or macro surroundings
  - OD rouding, poly rounding, contact placement, and edge finger LOD are in macro
  - LOD, WPE, PSE (poly space effect), OSE (OD to OD space effect), MBE (metal boundary effect), RDR
  - In BSIM6 there are Instance Parameters which are set and passed in the netlist, and there are model parameters which are part of the compiled model binary, and don't change from device to device.
  - How are parameters passed to the macro model? Perhaps it relies on the same input instance parameters that the core BSIM model uses?
  - RDR = restrictive design rules. Should double check these devices, if the length is under 100nm.
  - There is a 0.9 shrinkage in the "model usage files", so don't add it in netlists. It comes from the 'geoshrink' or in Spectre called the `.param scalefactor`. Therefore don't 
  - There are four modes for variation simulation: trad. total corner, global corner, local monte carlo, global+local monte carlo
  - Variation models are selected with high-level `.lib` statements, check slides 36-40 for instructions
  - Full MC (Case 4) give most silicon accuracy, but is expensive. Instead use global corner (Case 2) for digital long path circuit, as global var dominates.
  - And for analog design, mismatch matters, so do Case 2+MC or just Case 3 which includes MC by default
  - you can run mismatch only for key devices, if designer
  - `soa_warn=yes` will give warnings for over voltage
  - `.lib 'usage.l' noise_mc` and related command will enable flicker noise models, which are independant of device corner
  


# TSMC 65nm


## 65nm Stackup

3 Metal stacks
(1p6 ,1p7, 1p9)

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


## 65nm options that were selected for TSMC65 pdk at install time (back in 2012)
*Available process types are: 
   1 - LO
   2 - MM
   3 - RF
Please enter your choice: (1,2...)
*Available voltages are: 
   1 - 1.2V / 2.5V / 2.5V under-drive 1.8V / 2.5V over-drive 3.3V
   2 - 1.2V / 3.3V
Please enter your choice: (1,2)
*Available types of MiM cap are: 
   1 -  MIM_1.0fF                     
   2 -  MIM_1.5fF                     
   3 -  MIM_2.0fF                     
Please enter your choice: (1,2...)
*Available metal options are: 
   1 - 1p9m_6X2Z0U_ALRDL 
   2 - 1p9m_6X1Z1U_ALRDL *ind_1z1u  *Star_RC  *Cal_RC  *QRC
   3 - 1p8m_6X1Z0U_ALRDL *ind_1z
   4 - 1p8m_6X0Z1U_ALRDL *ind_1u 
   5 - 1p8m_5X2Z0U_ALRDL 
   6 - 1p8m_5X1Z1U_ALRDL *ind_1z1u
   7 - 1p7m_5X1Z0U_ALRDL *ind_1z
   8 - 1p7m_5X0Z1U_ALRDL *ind_1u 
   9 - 1p7m_4X2Z0U_ALRDL            *Star_RC  *Cal_RC  *QRC 
   10 - 1p7m_4X1Z1U_ALRDL *ind_1z1u
   11 - 1p6m_4X1Z0U_ALRDL *ind_1z   *Star_RC  *Cal_RC  *QRC
   12 - 1p6m_4X0Z1U_ALRDL *ind_1u 
   13 - 1p6m_3X2Z0U_ALRDL 
   14 - 1p6m_3X1Z1U_ALRDL *ind_1z1u
   15 - 1p5m_3X1Z0U_ALRDL *ind_1z


*** Select process : RF
*** Select voltage : 1.2V / 2.5V / 2.5V under-drive 1.8V / 2.5V over-drive 3.3V
*** Select MiM cap  :  MIM_2.0fF                     
*** Select metal option : 1p9m_6X1Z1U_ALRDL *ind_1z1u  *Star_RC  *Cal_RC  *QRC

## 65nm SPICE Models

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
       *Calibre           v2009.3_15.12			mentor
       *Assura            AV4.1_USR2_HF9-615		cadence
       *QRC               EXT101_2_HF3			mentor (for resistance specifically)
       *StarRC            E-2010.12-SP2			synopsys
       *Perl              v5.12.2
       *ncsim             08.20-s003			for digital sim, from cadence


## 65nm Changelog

### 02.2024 65nm DRC version 2.6_2a -> Installed 03.2024

[New update was made available](https://asic-support-65.web.cern.ch/tech-docs/drc-decks/)

Dowloaded three ZIPs:

```
65nm-calibre-decks-1p6m3x1z1u.zip
65nm-calibre-decks-1p7m4x1z1u.zip
65nm-calibre-decks-1p9m6x1z1u.zip
```

Extracted each, with an eponymous name.

Just to be sure, we have the 

Came in files

```
TSMC65_CERN_V1.7A_1_pre8.0_2017_PDKs_1p6_1p7_1p9.tar.gz
TSMC65_CERN_V1.7A_1_pre8.0_2017_digital_IO.tar.gz
TSMC65_CERN_V1.7A_1_pre8.0_2017_digital9t.tar.gz
TSMC65_CERN_V1.7A_1_pre8.0_2017_digital7t.tar.gz
TSMC65_CERN_V1.7A_1_pre8.0_2017_digital12t.tar.gz
```

- Installed this version V1.7A_1 65nm PDK into fresh `/tools/kits/TSMC/65LP/2024`


## 65nm core and TOX devices

* For TSMC 65: 1.2V was core, IO voltages 1.8, 2.5, 3.3 V
* Core devices have a thinner oxide, which is good for TID hardness
    * we don't want to use IO devices, due to thicker oxide
    * oxide thickness is a property of geometry, and uses a seperate mask
* On the other hand, transistor thresholds flavors are not geometry determined but instead by doping profiles.
    * you are limited by 
* check CERN PDK, to understand which flavors of thresholda are compatible -> every additional threshold costs money
- Requesting runs for Cern needs to be done 4 months in advance. Today is ~Aug 1.
    - 4 months from Aug 1 is Nov 30 MPW
    - 4.5 months from Aug 1 is Dec 15 MPW
    - 6 months from Aug 1 is Feb 2 mini@sic
    - If I want any of these next two runs, I should send my email application to CERN tomorrow.


# IHP 130nm
There is a /skel directory which has an example `cshrc.cadence` file.


# LFoundary PDKs

### This doesn't appear to work
```
Host pdksftp.lfoundry.com
    Port 6317
    HostKeyAlgorithms +ssh-rsa
    PubkeyAcceptedKeyTypes +ssh-rsa
    KexAlgorithms diffie-hellman-group1-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1
    Ciphers aes128-cbc,aes192-cbc,aes256-cbc,3des-cbc
```

Just used an older machine to ssh.

