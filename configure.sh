# usage:
#
#   <POSIX bourne shell> configure.sh [--gnu_make=/path/to/gnu/make]
#                                     [--bourne_shell=/path/to/bourne/shell]
#                                     [--boot_file=/path/to/custom/boot/file]

export MAKL_DIR="`pwd`"
export makl_conf_h="/dev/null"

# setup a temporary toolchain to please makl.init
host="`uname -rs | tr '[A-Z]' '[a-z]' | sed -e 's/ //g'`"
export MAKL_PLATFORM=$host 
export TC_SETUP_SOURCED="true"
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
        solaris*)   boot_file="boot/solaris.cfg" ;;
        cygwin*)    boot_file="boot/cygwin.cfg" ;;
        mingw*)     boot_file="boot/mingw.cfg" ;;
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

# do final toolchain/shlib setup
export MAKL_TC_FILE="${toolchain_file}"
export MAKL_SHLIB_FILE="${shlib_file}"
# assume TC_SETUP_SOURCED is still there
. setup/tc_setup.sh
       
# apply substitution as needed
makl_file_sub "bin/maklsh"              \
              "bin/lib/maklsh_catalog"  \
              "bin/lib/maklsh_tc"       \
              "bin/lib/maklsh_conf"     \
              "bin/lib/maklsh_funcs"

# write Makefile.conf
. $MAKL_DIR/cf/makl.term

# need to fix reloc.mk path because we don't have MAKL_DIR in place when 
# including Makefile.conf (would hit the {un,}install top level target)
sed -e 's/reloc/$(MAKL_DIR)\/mk\/reloc/' $MAKL_DIR/Makefile.conf > .conf
mv .conf "${MAKL_DIR}"/Makefile.conf
