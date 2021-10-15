#ALTERAPATH=/opt/altera/quartus2/13.0sp1
ALTERAPATH=/opt/altera/intelFPGA_lite/20.1

if [ -d ${ALTERAPATH}/quartus/bin/ ] ; then
  export PATH=${ALTERAPATH}/quartus/bin/:"${PATH}"
  export QSYS_ROOTDIR="${ALTERAPATH}/quartus/sopc_builder/bin"
fi
