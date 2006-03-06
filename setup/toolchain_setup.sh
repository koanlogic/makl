#!/bin/sh
#
# With no arguments the script tries to divine platform and toolchain file.  
# If an argument is supplied it is interpreted as the toolchain file to install.
#
# $Id: toolchain_setup.sh,v 1.17 2006/03/06 16:15:18 tat Exp $

KL_COM=http://www.koanlogic.com/

if [ -z ${MAKL_DIR} ]; then
    echo "set MAKL_DIR in the shell environment before running any MaKL script"
    exit 1
fi

for f in ${MAKL_DIR}/cf/makl_utils ${MAKL_DIR}/tc/makl_tc ; do
    . $f
done

rsname=`uname -rs | tr [A-Z] [a-z] | sed -e 's/ //'`

# if MAKL_TC is set then use that toolchain file otherwise look to the command
# line args otherwise try to guess the platform
if [ "${MAKL_TC}" ]; then
    tc_file=${MAKL_TC}
else
    if [ $# -ne 0 ]; then
        tc_file=${MAKL_DIR}/tc/$1.tc
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

    # if the toolchain does not exists try to download from kl.com/makl/*.tc
    if [ ! -f ${tc_file} ]; then
        (cd ${MAKL_DIR}/tc/ && ${FETCH:=wget} ${KL_COM}/makl/`basename ${tc_file}`) 
    fi
fi


echo "MaKL: installing toolchain file '${tc_file}'"

makl_tc ${tc_file} ${MAKL_DIR}/etc/toolchain.cf ${MAKL_DIR}/etc/toolchain.mk
