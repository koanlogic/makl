#!/bin/sh
#
# With no arguments the script tries to divine platform and toolchain file.  
# If an argument is supplied it is interpreted as the toolchain file to install.
#
# $Id: toolchain_setup.sh,v 1.11 2005/11/28 09:55:23 tho Exp $

if [ -z ${MAKL_DIR} ]; then
    echo "set MAKL_DIR in the shell environment before running any MaKL script"
    exit 1
fi

for f in ${MAKL_DIR}/cf/makl_utils ${MAKL_DIR}/tc/makl_tc ; do
    . $f
done

rsname=`uname -rs | tr [A-Z] [a-z] | sed -e 's/ //'`

if [ $# -ne 0 ]; then
    tc_file=$1 
else
    case ${rsname}
    in 
        freebsd[45]*)
            platform="freebsd4,5"
            ;;
        linux2.6*)
            platform="linux26"
            ;;
        darwin[67]*)
            platform="darwin6,7"
            ;;
        *mingw* | *MINGW*)
            platform="mingw"
            ;;
        *)
            platform="default"
            ;;
    esac        

    tc_file=${MAKL_DIR}/tc/${platform}.tc
fi

echo
echo "MaKL: installing toolchain file '${tc_file}'"

makl_tc ${tc_file} ${MAKL_DIR}/etc/toolchain.cf ${MAKL_DIR}/etc/toolchain.mk
