#!/bin/sh
#
# If MAKL_TC is set then use that toolchain file, otherwise look at the command
# line arguments, as a last resort try to guess the platform.
#
# $Id: toolchain_setup.sh,v 1.19 2006/09/24 13:35:55 tat Exp $

KL_WEBSITE=http://www.koanlogic.com/

if [ -z ${MAKL_DIR} ]; then
    echo "set MAKL_DIR in the shell environment before running any MaKL script"
    exit 1
fi

for f in ${MAKL_DIR}/cf/makl_utils ${MAKL_DIR}/tc/makl_tc ; do
    . $f
done

rsname=`uname -rs | tr [A-Z] [a-z] | sed -e 's/ //'`

if [ "${MAKL_TC}" ]; then
    tc_file=${MAKL_TC}
else
    # if we've been passed a specific platform, use it.
    if [ $# -ne 0 ]; then
        tc_file=${MAKL_DIR}/tc/$1.tc
        # if the toolchain does not exists try to download it from KL web site
        if [ ! -f "${tc_file}" ]; then
            (cd ${MAKL_DIR}/tc/ && \
             ${FETCH:=wget} ${KL_WEBSITE}/makl/`basename ${tc_file}`)
        fi
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
fi

echo "MaKL: installing toolchain file '${tc_file}'"

makl_tc ${tc_file} ${MAKL_DIR}/etc/toolchain.cf ${MAKL_DIR}/etc/toolchain.mk
