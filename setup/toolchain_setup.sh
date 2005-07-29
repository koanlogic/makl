#!/bin/sh

if [ -z ${makl_dir} ]; then
    echo "set makl_dir in the shell environment before running any MaKL script"
    exit 1
fi

for f in ${makl_dir}/cf/makl_utils ${makl_dir}/tc/makl_tc ; do
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

makl_tc ${makl_dir}/tc/${platform}.tc   \
        ${makl_dir}/cf/toolchain.sh     \
        ${makl_dir}/mk/toolchain.mk
