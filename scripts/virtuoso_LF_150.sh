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


export OA_HOME=/eda/cadence/2018-19/RHELx86/IC_6.1.7.722/oa_v22.50.092
# Tells Cadence tools which version of OA to use, if it can't intuit the OS
export OA_UNSUPPORTED_PLAT=linux_rhel50_gcc48x
# Make sure all CDS tools start in 64-bit mode
export CDS_AUTO_64BIT=ALL

####################### Tool Specific Settings ########################

source /eda/cadence/2018-19/scripts/IC_6.1.7.722_RHELx86.sh
# source /eda/cadence/2023-24/scripts/IC_23.10.020_RHELx86.sh

source /eda/cadence/2018-19/scripts/SPECTRE_18.10.077_RHELx86.sh
# source /eda/cadence/2023-24/scripts/SPECTRE_23.10.242_RHELx86.sh

# source /eda/Siemens/2023-24/scripts/CALIBRE_2023.4_17_RHELx86.sh

source /eda/cadence/2018-19/scripts/ASSURA_04.16.001_618_RHELx86.sh
# source /eda/cadence/2023-24/scripts/ASSURA_04.16.115_231_RHELx86.sh

# Cliosoft: Version control system for OA design libs
export CLIOSOFT_DIR=/eda/clio/sos7
export PATH="${CLIOSOFT_DIR}/bin:${PATH}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CLIOSOFT_DIR}/lib"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${CLIOSOFT_DIR}/lib/64bit"
export SOS_CDS_EXIT=yes

####################### PDK Specific Settings ########################

# See Perl script: /eda/kits/LF/PDK_LF15Ai_V0_6_3/tools/installation/workarea.PDK_LF15Ai_V0_6_3
# Which generates a file like: /users/ydieter/cadence/lf_200/lf15ai_141
# But we can do it manually too. See page 12 of LF150 user guide:

export MGC_HOME="${CALIBRE_HOME}" # Stated in LF15A Designers Guide page 12, to be required

export LF15A_HOME="/eda/kits/LF/PDK_LF15Ai_V1_4_1"
export LF15A_OPTION="6metal"
export LF15A_DISPLAY="true"


## Following variables are used for the Ciranova plug in

## CNI_ROOT
## Root path of CNI plug in; select according DFII installation
export CNI_ROOT="${LF15A_HOME}/tools/plugins/PyCellStudio_linux_rhel40_gcc483_64_L-2016.06-2-T-20180104_Py262"


## CNI_PLAT_ROOT
## Path for plug in; select according DFII installation
export CNI_PLAT_ROOT="${CNI_ROOT}/plat_linux_gcc483_64"

## Following variables need no change
export CNI_LOG_DEFAULT="/dev/null"
export LD_LIBRARY_PATH="${CNI_PLAT_ROOT}/3rd/lib:${CNI_PLAT_ROOT}/lib:${LD_LIBRARY_PATH}"
export OA_COMPILER="gcc483"
export OA_PLUGIN_PATH="${CNI_ROOT}/quickstart:${OA_PLUGIN_PATH}"
export PATH="${CNI_PLAT_ROOT}/3rd/bin:${CNI_PLAT_ROOT}/bin:${CNI_ROOT}/bin:${PATH}"
export PYTHONHOME="${CNI_PLAT_ROOT}/3rd"
export PYTHONPATH="${CNI_ROOT}/pylib:${CNI_PLAT_ROOT}/lib:${PYTHONPATH}"


# Create the copy default Virtuoso + Assura(for fast LVS/PEX) files locally, if not already present
if [ ! -f ./cds.lib ]; then
    echo "Copying default config files (cds.lib, .cdsinit) from PDK to local dir..."
    cp "$LF15A_HOME/tools/user/cds.lib" .
    cp "$LF15A_HOME/tools/user/.cdsinit" .
    cp "$LF15A_HOME/tools/user/assura_tech.lib" .
    echo "Copying done!"
fi

############### Create Temp Directories ################

directories=("DRC" "LVS" "SIM" "XRC")

# Fancy loop which repeats the same process for the four locations listed above
for dir in "${directories[@]}"; do
    if [ ! -d /tmp/"$USER"/"$dir" ]; then
        mkdir -p /tmp/"$USER"/"$dir"
        echo "Created directory: /tmp/$USER/$dir"
    fi

    if [ ! -d ./"$dir" ]; then
        ln -s /tmp/"$USER"/"$dir" "$dir"
        echo "Created local symbolic link: $dir"
    fi
done

# https://www.baeldung.com/linux/safely-exit-scripts#1-the-return-and-exit-combo
return 2> /dev/null; exit

