#!/bin/sh
#
# With no arguments the script tries to divine platform and toolchain file.  
# If an argument is supplied it is interpreted as the toolchain file to install.
#

if [ -z ${MAKL_DIR} ]; then
    echo "set MAKL_DIR in the shell environment before running any MaKL script"
    exit 1
fi

for f in ${MAKL_DIR}/cf/makl_utils ${MAKL_DIR}/tc/makl_tc ; do
    . $f
done

if [ $# -ne 0 ]; then
    tc_file=$1 
else
    case `uname -s`
    in 
        "FreeBSD")
            platform="freebsd"
            ;;
        "Darwin")
            platform="darwin"
            ;;
        *)
            platform="default"
            ;;
    esac        

    tc_file=${MAKL_DIR}/tc/${platform}.tc
fi

echo
echo "MaKL: installing toolchain file '${tc_file}'"
echo

makl_tc ${tc_file} ${MAKL_DIR}/cf/toolchain.sh ${MAKL_DIR}/mk/toolchain.mk
