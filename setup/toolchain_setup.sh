#!/bin/sh
#
# With no arguments the script tries to divine platform and toolchain file.  
# If an argument is supplied it is interpreted as the toolchain file to install.
#
# $Id: toolchain_setup.sh,v 1.14 2006/01/31 13:52:02 tat Exp $

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
        freebsd*)
            platform="freebsd"
            ;;
        linux*)
            platform="linux"
            ;;
        darwin*)
            platform="darwin"
            ;;
        netbsd*)
            platform="netbsd"
            ;;
        openbsd*)
            platform="openbsd"
            ;;
        *mingw*)
            platform="mingw"
            ;;
        *)
            platform="default"
            ;;
    esac        

    tc_file=${MAKL_DIR}/tc/${platform}.tc
fi

echo "MaKL: installing toolchain file '${tc_file}'"

makl_tc ${tc_file} ${MAKL_DIR}/etc/toolchain.cf ${MAKL_DIR}/etc/toolchain.mk
