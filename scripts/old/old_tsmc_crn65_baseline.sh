#!/bin/tcsh -f

#############################################################
################ environment setting ########################
#############################################################

setenv LANG C

set PWD = `pwd`
if ( ${HOME} == ${PWD} ) then
   echo "You can't start cadence from your HOME directory."
   exit(1)
endif

if (${?LD_LIBRARY_PATH}) then
	setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}
else
	setenv LD_LIBRARY_PATH ""
endif

#should re-enable
setenv CLIOSOFT_DIR /tools/clio/sos
setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/${CLIOSOFT_DIR}/lib:${CLIOSOFT_DIR}/lib/64bit

setenv CDS_AUTO_64BIT ALL
#setenv CDS_AUTO_64BIT "EXCLUDE:si"


setenv LM_LICENSE_FILE 8000@faust02.physik.uni-bonn.de
setenv CDSDIR /tools/cadence/IC618

setenv CDS ${CDSDIR}
setenv CDSHOME ${CDSDIR}
setenv CDS_HIER ${CDSDIR}

#The 11 items below should probably be re-enabled, just disabled to keep environment simple for now
#setenv ASSURAHOME /tools/cadence/ASSURA41-615
setenv MMSIM /tools/cadence/MMSIM11
#setenv AMSHOME /tools/cadence/INCISIV11
#setenv PVEHOME /tools/cadence/PVE11

#setenv USE_CALIBRE_VCO ixl
#setenv MGC_HOME /tools/mentor/calibre
#setenv SYN_HSPICE /tools/synopsis/hspice/bin

#setenv QRC_HOME ${PVEHOME}
#setenv QRC_ENABLE_EXTRACTION 1

#setenv GDM_USE_SHLIB_ENVVAR 1
#setenv SOS_CDS_EXIT yes

setenv CDS_Netlisting_Mode Analog
setenv SPECTRE_DEFAULTS     -E
setenv CDS_LOAD_ENV         CWDElseHome

setenv OA_HOME ${CDSDIR}/oa_v22.60.063
#these are wrong:
#setenv OA_HOME ${CDSDIR}/oa
#setenv OA_HOME /tools/cadence/EDI11/oa_v22.43.003

#full version version
#setenv PATH ${MMSIM}/tools/bin:${MMSIM}/tools/dfII/bin:${CDSDIR}/tools/bin:${CDSDIR}/tools/dfII/bin:${PVEHOME}/bin:${ASSURAHOME}/tools/bin:${ASSURAHOME}/tools/dfII/bin:${AMSHOME}/tools/dfII/bin:${AMSHOME}/tools/bin:${MGC_HOME}/bin:${CLIOSOFT_DIR}/bin:${SYN_HSPICE}:${PATH}

setenv PATH ${MMSIM}/tools/bin:${MMSIM}/tools/dfII/bin:${CDSDIR}/tools/bin:${CDSDIR}/tools/dfII/bin:${PATH}

setenv CDS_USE_PALETTE
# disable openGL for VIVA - old driver problems
setenv CDS_WAVESCAN_OPENGL "-Dsun.java2d.opengl=False" 
#setenv AHDLCMI_GCC_HOME $MMSIM/tools/systemc/gcc/install

#############################################################
####################### PDK SETTINGS ########################
#############################################################

setenv PDK_PATH "/tools/kits/TSMC/CRN65LP"
setenv PDK_RELEASE "/MSRF_1p9m_6X1Z1U_2.5IO_v1.7a"
setenv OPTION "1p6m3x1z1u"

setenv TSMC_DIR "/tools/kits/TSMC/CRN65LP/MSRF_1p9m_6X1Z1U_2.5IO_v1.7a"

################ Create the local cds.lib file
 if ( ! -e ./cds.lib ) then
	cp ${TSMC_DIR}/cds.lib .
	cp ${TSMC_DIR}/display.drf .
	cp ${TSMC_DIR}/assura_tech.lib .
	cp ${TSMC_DIR}/.cdsinit .
	cp ${TSMC_DIR}/cdsLibMgr.il .
	cp ${TSMC_DIR}/lib.defs .
	
   echo "Creating new config files"
 endif
 
   chmod 775 ./cds.lib
   chmod 775 ./display.drf
   chmod 775 ./assura_tech.lib
   chmod 775 ./.cdsinit
   chmod 775 ./cdsLibMgr.il
   chmod 775 ./lib.defs
   
################ Calibre Default Switches ################


############### Create Temp Direcotories ################

	if (! -d /tmp/$USER/DRC ) then
  		mkdir -p /tmp/$USER/DRC
	endif
	
    if (! -d ./DRC) then
	  ln -s /tmp/$USER/DRC DRC
    endif
  
    if (! -d /tmp/$USER/LVS ) then
  		mkdir -p /tmp/$USER/LVS
	endif
	
    if (! -d ./LVS) then
  	  ln -s /tmp/$USER/LVS LVS
    endif

   	if (! -d /tmp/$USER/SIM ) then
  		mkdir -p /tmp/$USER/SIM
	endif
	
    if (! -d ./SIM) then
  	  ln -s /tmp/$USER/SIM SIM
    endif
  
	if (! -d /tmp/$USER/XRC ) then
  		mkdir -p /tmp/$USER/XRC 
	endif
	
    if (! -d ./XRC) then
  	   ln -s /tmp/$USER/XRC  XRC
    endif
	
