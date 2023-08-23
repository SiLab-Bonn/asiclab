#!/usr/bin/env bash

# location of various tools.... are these only needed to add to the path below?
export CDS_INST_DIR=/tools/cadence/IC618
export SPECTRE_HOME=/tools/cadence/2020-21/RHELx86/SPECTRE_20.10.073
export QRC_HOME=/tools/cadence/EXT191
export CDSHOME=${CDS_INST_DIR}
export MMSIM_HOME=${SPECTRE_HOME}
export PVS_HOME=/tools/cadence/2019-20/RHELx86/PVS_19.10.000

# PATH setup
export PATH=${PVS_HOME}/bin:${PATH}
export PATH=${QRC_HOME}/bin:${PATH}
export PATH=${CDS_INST_DIR}/tools/plot/bin:${PATH}
export PATH=${CDS_INST_DIR}/tools/dfII/bin:${PATH}
export PATH=${CDS_INST_DIR}/tools/bin:${PATH}
export PATH=${MMSIM_HOME}/bin:${PATH}

# Virtuoso options
export SPECTRE_DEFAULTS=-E
export CDS_Netlisting_Mode=Analog
export CDS_AUTO_64BIT=ALL
export LM_LICENSE_FILE=8000@faust02.physik.uni-bonn.de


# Necesssary for PDK devices and Analog and Basic lib to appear
export PDK_PATH=/tools/kits/TSMC/CRN28HPC+
export PDK_RELEASE=HEP_DesignKit_TSMC28_HPCplusRF_v1.0
export PDK_OPTION=1P9M_5X1Y1Z1U_UT_AlRDL

# from the cdsusers/setup.csh file, modified for bash:
export OSS_IRUN_BIND2=YES
export PVS_QRCTECHDIR=${PDK_PATH}/${PDK_RELEASE}/pdk/{$PDK_OPTION}/cdsPDK/PVS_QUANTUS
export PV_COLOR_DIR=${PVS_QRCTECHDIR}/.color_setup

# possible display.drf files?
#./pdk/1P9M_5X1Y1Z1U_UT_AlRDL/cdsPDK/Techfile/display.drf
#./pdk/1P9M_5X1Y1Z1U_UT_AlRDL/cdsPDK/display.drf
#./pdk/1P9M_5X1Y1Z1U_UT_AlRDL/cdsPDK/v1.9a/display.drf