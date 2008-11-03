# environment variables:
#   - FETCH             like command
#   - MAKL_TC_FILE      toolchain file (full path)
#   - MAKL_TC           toolchain file (basename relative to ${MAKL_DIR}/tc)
#   - MAKL_SHLIB_FILE   shlib file (full path)
#   - MAKL_SHLIB        file (basename relative to ${MAKL_DIR}/shlib)
#   - MAKL_ETC          directory (where toolchain.{cf,mk} and shlib.mk belong)
#
# precedence rules for setting {tc,shlib}_file's is:
#   - environment MAKL_TC_FILE | MAKL_SHLIB_FILE
#   - environment MAKL_TC | MAKL_SHLIB
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
    KL_WEBSITE="http://www.koanlogic.com"

    if [ ! -f "$2" ] 
    then 
        (cd ${MAKL_DIR}/$1/ && \
            ${FETCH:=wget} ${KL_WEBSITE}/download/makl/`basename $2`) \
        > /dev/null 2> /dev/null
    fi
}

# check MAKL_DIR
[ -z "${MAKL_DIR}" ] && exit 1

# check for user supplied MAKL_ETC
[ -z "${MAKL_ETC}" ] && MAKL_ETC="${MAKL_DIR}"/etc

# load makl cf functions + makl_tc
for f in "${MAKL_DIR}"/tc/makl_tc "${MAKL_DIR}"/cf/makl_*
do
    . "${f}"
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
    *cygwin*)
        shlib="null"            # not yet supported
        toolchain="cygwin"
        ;;
    *)
        shlib="null"
        toolchain="default"
        ;;
esac

# set tc_file 
# in case MAKL_TC_FILE is set, set internal 'tc_file' from it, otherwise
# (toolchain by name) in case toolchain file was not found locally, try 
# to download from KL site
if [ -z "${MAKL_TC_FILE}" ]
then
    [ ! -z "${MAKL_TC}" ] && toolchain="${MAKL_TC}"
    tc_file="${MAKL_DIR}"/tc/"${toolchain}".tc
    locate_file tc "${tc_file}"
    [ $? -ne 0 ] && \
        err "toolchain file \"${toolchain}\" could not be located as ${tc_file}"
else
    tc_file="${MAKL_TC_FILE}"
    [ ! -f "${tc_file}" ] && err "toolchain file \"${tc_file}\" not found"
fi

# set shlib_file
# in case MAKL_SHLIB_FILE is set, use its content to set internal 'shlib_file'
# otherwise (shlib by name) in case shlib file was not found locally, try to 
# download from KL site
if [ -z "${MAKL_SHLIB_FILE}" ]
then
    [ ! -z "${MAKL_SHLIB}" ] && shlib="${MAKL_SHLIB}"
    shlib_file="${MAKL_DIR}"/shlib/"${shlib}".mk
    locate_file shlib "${shlib_file}"
    # as a last-last resort install the null shlib file
    [ $? -ne 0 ] && shlib_file="${MAKL_DIR}"/shlib/null.mk
else
    shlib_file="${MAKL_SHLIB_FILE}"
    [ ! -f "${shlib_file}" ] && err "shlib file \"${shlib_file}\" not found"
fi

# install shlib
echo "installing shlib file \"${shlib_file}\""
cp "${shlib_file}" "${MAKL_ETC}"/shlib.mk \
       || err "shlib installation failed"

# install toolchain
echo "installing toolchain file \"${tc_file}\""
makl_tc "${tc_file}" "${MAKL_ETC}/toolchain.cf" "${MAKL_ETC}/toolchain.mk" \
       || err "toolchain installation failed"

exit 0
