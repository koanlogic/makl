#!/bin/sh 
#
# environment variables:
#   - FETCH       wget like command
#   - MAKL_TC     toolchain file (basename with no extension)
#   - MAKL_SHLIB  shlib file (basename with no extension)
#
# precedence rules for setting {tc,shlib}_file's is:
#   - environment, i.e. MAKL_TC | MAKL_SHLIB
#   - guess platform
# as a last resort try KL website.

err ()
{
    echo $*
    exit 1
}

# $1: shlib | tc
# $2: filename
locate_file ()
{
    if [ ! -f $2 ] 
    then 
        (cd ${MAKL_DIR}/$1/ && \
                      ${FETCH:=wget} ${KL_WEBSITE}/makl/`basename $2`) \
        > /dev/null 2> /dev/null
    fi
}

KL_WEBSITE="http://www.koanlogic.com"

# check MAKL_DIR
[ -z ${MAKL_DIR} ] && exit 1

# load makl cf functions + makl_tc
for f in ${MAKL_DIR}/tc/makl_tc ${MAKL_DIR}/cf/makl_*
do
    . ${f}
done

# guess
case `makl_os_name`
in
    linux*)
        shlib="linux"
        toolchain=${shlib}
        ;;
    openbsd*)
        shlib="openbsd"
        toolchain=${shlib}
        ;;
    freebsd*)
        shlib="freebsd"
        toolchain=${shlib}
        ;;
    netbsd*)
        shlib="netbsd"
        toolchain=${shlib}
        ;;
    freebsd*)
        shlib="freebsd"
        toolchain=${shlib}
        ;;
    darwin*)
        shlib="darwin"
        toolchain=${shlib}
        ;;
    *mingw*)
        shlib="null"            # not yet supported
        toolchain="mingw"
        ;;
    *)
        shlib="null"
        toolchain="default"
        ;;
esac

# set tc_file: in case toolchain file was not found locally, try to download 
# from KL site
[ ! -z ${MAKL_TC} ] && toolchain="${MAKL_TC}"
tc_file=${MAKL_DIR}/tc/${toolchain}.tc
locate_file tc ${tc_file}
[ $? -ne 0 ] && err "toolchain file \"${toolchain}\" could not be located"

# set shlib_file: in case shlib file was not found locally, try to download 
# from KL site
[ ! -z ${MAKL_SHLIB} ] && shlib="${MAKL_SHLIB}"
shlib_file=${MAKL_DIR}/shlib/${shlib}.mk
locate_file shlib ${shlib_file}
# as a last-last resort install the null shlib file
[ $? -ne 0 ] && shlib_file=${MAKL_DIR}/shlib/null.mk

# install shlib
echo "installing shlib file \"${shlib_file}\""
cp ${shlib_file} ${MAKL_DIR}/mk/priv/shlib.mk \
       || err "shlib installation failed"

# install toolchain
echo "installing toolchain file \"${tc_file}\""
makl_tc ${tc_file} ${MAKL_DIR}/etc/toolchain.cf ${MAKL_DIR}/etc/toolchain.mk \
       || err "toolchain installation failed"

exit 0
