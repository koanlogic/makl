# usage:
#
#   <POSIX bourne shell> configure.sh [--gnu_make=/path/to/gnu/make]
#                                     [--bourne_shell=/path/to/bourne/shell]
#                                     [--boot_file=/path/to/custom/boot/file]

MAKL_DIR="`pwd`"
export MAKL_DIR
makl_conf_h="/dev/null"
export makl_conf_h

# setup a temporary toolchain to please makl.init
host="`uname -rs | tr '[A-Z]' '[a-z]' | sed -e 's/ //g'`"
MAKL_PLATFORM=$host 
export MAKL_PLATFORM
TC_SETUP_SOURCED="true"
export TC_SETUP_SOURCED
echo "set up temporary toolchain to please makl.init (will be overwritten)"
. setup/tc_setup.sh

# initialize makl/cf
. "${MAKL_DIR}"/cf/makl.init
makl_args_init "$@"

# initialize command line handlers:
#
# --gnu_make=...
makl_args_def           \
    "gnu_make"          \
    "=GNUMAKEPATH" ""   \
    "set GNU make executable path on this system"
__makl_gnu_make ()
{
    [ $# -eq 1 ] || makl_err 1 "--gnu_make needs one argument"
    makl_set_var_mk GNU_MAKE "$@"
}

# --bourne_shell=...
makl_args_def               \
    "bourne_shell"          \
    "=BOURNESHELLPATH" ""   \
    "set Bourne shell executable path on this system"
__makl_bourne_shell ()
{
    [ $# -eq 1 ] || makl_err 1 "--bourne_shell needs one argument"
    makl_set_var_mk BOURNE_SHELL "$@"
}

# --boot_file=...
makl_args_def           \
    "boot_file"         \
    "=BOOTFILEPATH" ""  \
    "explicitly supply a MaKL bootstrap file"
__makl_boot_file ()
{
    [ $# -eq 1 ] || makl_err 1 "--boot_file needs one argument"
    BOOT_FILE="$@"
}

makl_args_def       \
    "no_man"        \
    "" ""           \
    "disable compilation of man pages (using xml2man)"
__makl_no_man ()
{
    makl_set_var_mk "NO_MAN"
}


# tool deps
makl_optional           1    "featx"   "xml2man"    "PATH_XML2MAN"

makl_args_handle "$@"

# set destination for MaKL bells and whistles
makl_set_var_mk MAKL_ROOT "`makl_get_var_mk SHAREDIR`/makl-`cat VERSION`"

# if no explicit bootstrap file was supplied, go for autodetection
if [ -z "${BOOT_FILE}" ]
then
    case $host
    in
        linux*)     boot_file="boot/linux.cfg" ;; 
        darwin*)    boot_file="boot/darwin.cfg" ;;
        freebsd*)   boot_file="boot/freebsd.cfg" ;; 
        netbsd*)    boot_file="boot/netbsd.cfg" ;; 
        openbsd*)   boot_file="boot/openbsd.cfg" ;; 
        solaris*)   boot_file="boot/solaris.cfg" ;;
        cygwin*)    boot_file="boot/cygwin.cfg" ;;
        mingw*)     boot_file="boot/mingw.cfg" ;;
        sunos*)     boot_file="boot/solaris.cfg" ;;
        dragonfly*) boot_file="boot/dragonfly.cfg" ;;
        *) 
            echo "no boot file for $host found: trying the default..." 
            boot_file="boot/default.cfg"
            ;;
    esac
else
    boot_file="${BOOT_FILE}"
fi

# source-in platform configuration
echo "using $boot_file for bootstrapping MaKL"
. "$boot_file"

# NOTE: command line has precedence over bootstrap settings
[ -z "`makl_get_var_mk GNU_MAKE`" ] && \
        makl_set_var_mk "GNU_MAKE" "${gnu_make}"
[ -z "`makl_get_var_mk BOURNE_SHELL`" ] && \
        makl_set_var_mk "BOURNE_SHELL" "${bourne_shell}"

# check that needed tools are in place
t1="`makl_get_var_mk GNU_MAKE`"
t2="`makl_get_var_mk BOURNE_SHELL`"
[ -x "${t1}" ] || \
        makl_err 1 "${t1} not found, install it first. ${gnu_make_hint}"
[ -x "${t2}" ] || \
        makl_err 1 "${t2} not found, install it first. ${bourne_shell_hint}"

# do final toolchain/shlib setup
MAKL_TC_FILE="${toolchain_file}"
export MAKL_TC_FILE
MAKL_SHLIB_FILE="${shlib_file}"
export MAKL_SHLIB_FILE

# apply substitution as needed
# assume TC_SETUP_SOURCED is still there
. setup/tc_setup.sh

makl_file_sub "bin/maklsh"              \
              "bin/lib/maklsh_catalog"  \
              "bin/lib/maklsh_run"      \
              "bin/lib/maklsh_tc"       \
              "bin/lib/maklsh_funcs"

# write Makefile.conf
. "${MAKL_DIR}"/cf/makl.term

# output optional platform specific message 
[ -n "${install_hint}" ] && echo ${install_hint}
exit 0
