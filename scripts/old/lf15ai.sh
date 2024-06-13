#!/bin/csh -f

set PWD = `pwd`
if ( ${HOME} == ${PWD} ) then
   echo "You can't start cadence from your HOME directory."
   exit(1)
endif

####
setenv CDS_PSFXL_FLUSH_INTERVAL 10
setenv CDS_PSFXL_INIT_FLUSH_INTERVAL 10
setenv CDS_PSFXL_MAX_FLUSH_INTERVAL 300
####

setenv CDS_AUTO_64BIT ALL

setenv LF_PDF_READER_HOME /usr/bin
setenv LF_PDF_READER acroread

setenv LF15A_HOME /tools/kits/LF/PDK_LF15Ai_V1_4_1
setenv LF_OPTION 6metal
setenv LF15A_OPTION ${LF_OPTION}
setenv LF15A_MIM cmims2
setenv CCDIR /tools/synopsys/installs/customdesigner

setenv OA_UNSUPPORTED_PLAT linux_rhel50_gcc48x
#setenv OA_UNSUPPORTED_PLAT linux_rhel60

setenv LM_LICENSE_FILE 8000@faust02.physik.uni-bonn.de

setenv CDSDIR /tools/cadence/IC617
#setenv CDSDIR /tools/cadence/2017-18/RHELx86/IC_6.1.7.715
setenv CDS ${CDSDIR}
setenv CDSHOME ${CDSDIR}

setenv LANG C
setenv GDM_USE_SHLIB_ENVVAR 1
setenv CLIOSOFT_DIR /tools/clio/sos7
setenv SOS_CDS_EXIT yes

setenv ASSURAHOME /tools/cadence/2017-18/RHELx86/ASSURA_04.15.111
setenv MMSIM /tools/cadence/2017-18/RHELx86/SPECTRE_16.10.614
setenv AMSHOME /tools/cadence/2017-18/RHELx86/INCISIVE_15.20.038

#setenv MGC_HOME /tools/mentor/calibre
setenv USE_CALIBRE_VCO ixl
#setenv MGC_HOME /tools/mentor/calibre
setenv MGC_HOME /tools/mentor/ixl_cal_2016.1_14.11
setenv SYN_HSPICE /tools/synopsis/hspice/bin

setenv CDS_Netlisting_Mode Analog
setenv SPECTRE_DEFAULTS     -E
setenv CDS_LOAD_ENV         CWDElseHome

setenv EXT /tools/cadence/EXT181
setenv QRC_ENABLE_EXTRACTION 1

setenv CDS_USE_PALETTE
setenv CDS_WAVESCAN_OPENGL "-Dsun.java2d.opengl=False" # disable openGL for VIVA - old driver problems
setenv DD_USE_LIBDEFS no

setenv CNI_ROOT ${LF15A_HOME}/tools/plugins/PyCellStudio_linux_rhel40_gcc483_64_L-2016.06-2-T-20180104_Py262
setenv CNI_PLAT_ROOT $CNI_ROOT/plat_linux_gcc483_64
setenv OA_COMPILER gcc44x
setenv PYTHONHOME $CNI_PLAT_ROOT/3rd
setenv PYTHONPATH $CNI_ROOT/pylib:$CNI_PLAT_ROOT/lib
setenv OA_PLUGIN_PATH $CNI_ROOT/quickstart
setenv CNI_LOG_DEFAULT  /dev/null

setenv PATH ${CNI_PLAT_ROOT}/3rd/bin:${CNI_PLAT_ROOT}/bin:${CNI_ROOT}/bin:${MMSIM}/tools/bin:${MMSIM}/tools/dfII/bin:${CDSDIR}/tools/bin:${CDSDIR}/tools/dfII/bin:${ASSURAHOME}/tools/bin:${ASSURAHOME}/tools/dfII/bin:${EXT}/bin:${EXT}/tools/bin:${AMSHOME}/tools/dfII/bin:${AMSHOME}/tools/bin:${MGC_HOME}/bin:${CLIOSOFT_DIR}/bin:${SYN_HSPICE}:${PATH}
setenv LD_LIBRARY_PATH ${CLIOSOFT_DIR}/lib:${CLIOSOFT_DIR}/lib/64bit:${CNI_PLAT_ROOT}/3rd/lib:${CNI_PLAT_ROOT}/lib

################ check CDSDIR environment variable 

if (${?CDSDIR}) then
  # checks, if CDS-tree exists at specified location
  if ( (! -e ${CDSDIR}/tools/dfII/bin)) then
     echo -n "Fatal Error: "
     echo "CDSDIR is set to $CDSDIR, which is not a valid CDS software tree."
     exit 1
  endif
else
   echo -n "Error: "
   echo "Environment variable CDSDIR is not set\!"
   echo -n "Info: "
   echo "Please set CDSDIR to the location of the CDS software tree."
   exit 1
endif

################ Create the local cds.lib file
   if ((! -e ./.cdsinit)  && \
         ( -e ${LF15A_HOME}/tools/setup)) then
   
   echo "Creating new config files"
   
   cp ${LF15A_HOME}/tools/user/.cdsinit . 
   cp ${LF15A_HOME}/tools/user/.cdesigner.tcl .
   
  #cp ${LF15A_HOME}/tools/user/display.drf .
   cp ${LF15A_HOME}/tools/user/cds.lib .
   cp ${LF15A_HOME}/tools/user/assura_tech.lib .
   
   cp ${LF15A_HOME}/tools/user/.cgidrcdb . 
   cp ${LF15A_HOME}/tools/user/.vuerc .
 
#   ln -s ${LF15A_HOME}/libraries/techfiles/analog_layer.map virtuoso_layer.map
   
 endif
    
   chmod 775 ./.cdsinit
   chmod 775 ./.cdesigner.tcl
   
   chmod 775 ./cds.lib
   #chmod 775 ./display.drf
   
   chmod 775 ./.cgidrcdb
   chmod 775 ./.vuerc
   chmod 775 ./assura_tech.lib .
   

############### Create Temp Direcotories
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
  
    if (! -d ./XRC) then
  	   ln -s /tmp/$USER/XRC  XRC
    endif


########################################

${CDSDIR}/tools/dfII/bin/virtuoso

exit(0)

################ end of c-shell script
