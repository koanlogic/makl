#!/bin/sh

if [ -z ${MAKL_DIR} ]; then
    echo "set MAKL_DIR in the shell environment before running any MaKL script"
    exit 1
fi

for f in ${MAKL_DIR}/cf/makl_utils ${MAKL_DIR}/tc/makl_tc ; do
    . $f
done

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

echo
echo "MaKL: installing toolchain for platform ${platform}."
echo

makl_tc ${MAKL_DIR}/tc/${platform}.tc   \
        ${MAKL_DIR}/cf/toolchain.sh     \
        ${MAKL_DIR}/mk/toolchain.mk
