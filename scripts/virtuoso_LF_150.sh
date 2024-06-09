#!/bin/bash

# Usage instructions:
# * `cd ~/cadence/*PDK environment dir*}`
# * `source ./virtuoso_**.sh`
# * `virtuoso &`

# Cadence tools should be started from a PDK specific working dir, e.g. `~/cadence/tsmc65`
if [ "$HOME" == "$PWD" ]; then
   echo "You shouldn't start cadence tools from your HOME directory."
   echo "It will create a bunch of Virtuoso-specific stuff you don't want in there."
   echo "Instead use a PDK-specific working dir, e.g: ~/cadence/tsmc28"
   # having just an exit will cause sourcing the script to crash the terminal
   # having just a `return` will casues execution of this script to fail
   # therefore, we do both:
   return 2> /dev/null; exit  # learned from https://www.baeldung.com/linux/safely-exit-scripts#the-return-command
fi

### FlexLM: License manager server
export LM_LICENSE_FILE="8000@faust02.physik.uni-bonn.de"

# Tells Cadence tools which version of OA to use, if it can't intuit the OS
export OA_UNSUPPORTED_PLAT=linux_rhel60
# Make sure all CDS tools start in 64-bit mode
export CDS_AUTO_64BIT=ALL

# Variables to just avoid repetition & easily change to new release
export CDS_TOOLS_PREFIX="/tools/cadence"
export RELEASE_YEAR="2023-24"

####################### Tool Specific Settings ########################

### Cadence Virtuoso: Full custom analog design
export CDS_IC="${CDS_TOOLS_PREFIX}/${RELEASE_YEAR}/RHELx86/IC_23.10.020"
# This line is required by some design kits...
export CDSDIR=$CDS_IC
# When using ADE set netlisting mode to analog ("dfIIconfig.pdf"), p16. Alternative is 'digital'
export CDS_Netlisting_Mode=Analog
# Required for tutorial material and cadence libraries (eg analogLib). Not used to set path
export CDSHOME=$CDS_IC
export CDS_USE_PALETTE
# provides commands `virtuoso` 
export PATH="${PATH}:${CDS_IC}/tools/bin"
export PATH="${PATH}:${CDS_IC}/tools/dfII/bin"
export PATH="${PATH}:${CDS_IC}/tools/plot/bin"
alias help_cds_ic='$CDS_IC/tools/cdnshelp/bin/cdnshelp &'

### Cadence Spectre: Analog simulation
export CDS_SPECTRE="${CDS_TOOLS_PREFIX}/${RELEASE_YEAR}/RHELx86/SPECTRE_23.10.242"
export SPECTRE_DEFAULTS=-E
# provides commands `spectre`, `ultrasim`, `aps`
export PATH="${PATH}:${CDS_SPECTRE}/bin"
export PATH="${PATH}:${CDS_SPECTRE}/tools/bin"
export PATH="${PATH}:${CDS_SPECTRE}/tools/dfII/bin"
export PATH="${PATH}:${CDS_SPECTRE}/tools/plot/bin"
# Create alias to easily start help
alias help_cds_spectre='$CDS_SPECTRE/tools/cdnshelp/bin/cdnshelp &'

# Calibre DRC/LVS/ERC/PERC/RCX/
export CALIBRE_HOME=/tools/Siemens/2023-24/RHELx86/CALIBRE_2023.4_17/aoj_cal_2023.4_17.10
export PATH="${PATH}:${CALIBRE_HOME}/bin"
alias help_mg_cal='${CALIBRE_HOME}/bin/mgcdocs'
#${CALIBRE_HOME}/docs/pdfdocs/Calbr_Doc_Set.pdx
# calibredrv, calibre -gui, calibrewb
export MGC_HOME="${CALIBRE_HOME}" # Stated in LF15A pdk, DGp12, to be required

# Cliosoft: Version control system for OA design libs
export CLIOSOFT_DIR=/tools/clio/sos7
export PATH="${CLIOSOFT_DIR}/bin:${PATH}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CLIOSOFT_DIR}/lib"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CLIOSOFT_DIR}/lib/64bit"
export SOS_CDS_EXIT=yes

####################### PDK Specific Settings ########################

# See Perl script: /tools/kits/LF/PDK_LF15Ai_V0_6_3/tools/installation/workarea.PDK_LF15Ai_V0_6_3
# Which generates a file like: /users/ydieter/cadence/lf_200/lf15ai_141
# But we can do it manually too. See page 12 of LF150 user guide:

export LF15A_HOME="/tools/kits/LF/PDK_LF15Ai_V1_4_1"
export LF15A_OPTION="6metal"
export LF15A-DISPLAY="true"

# Now we just need: cds.lib, .cdsinit (copy from $LF15A_HOME/tools/user)

# .cdsinit defines Cadence bindkeys (.cdesiger.tcl would be for Synopsys)
# cds.lib which defines

# And do I need assura_tech.lib?

