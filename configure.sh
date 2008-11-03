export MAKL_DIR="`pwd`"
export makl_conf_h="/dev/null"

# setup a fake toolchain to please makl.init
env MAKL_TC=default MAKL_SHLIB=null setup/tc_setup.sh

. "${MAKL_DIR}"/cf/makl.init
makl_args_init "$@"

makl_args_def           \
    "gnu_make"          \
    "=GNUMAKEPATH" ""   \
    "set GNU make executable path on this system"
__makl_gnu_make ()
{
    [ $# -eq 1 ] || makl_err 1 "--gnu_make needs one argument"
    makl_set_var_mk GNU_MAKE "$@"
}

makl_args_def               \
    "bourne_shell"          \
    "=BOURNESHELLPATH" ""   \
    "set Bourne shell executable path on this system"
__makl_bourne_shell ()
{
    [ $# -eq 1 ] || makl_err 1 "--bourne_shell needs one argument"
    makl_set_var_mk BOURNE_SHELL "$@"
}

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

makl_set_var_mk MAKL_ROOT "`makl_get_var_mk SHAREDIR`/makl-`cat VERSION`"

# if no explicit bootstrap file was supplied, go for autodetection
if [ -z "${BOOT_FILE}" ]
then
    host="`makl_target_name`"
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
fi

# source-in configuration
echo "using $boot_file for bootstrapping MaKL"
. "$boot_file"

# command line has precedence over cfg
[ -z "`makl_get_var_mk GNU_MAKE`" ] && \
        makl_set_var_mk "GNU_MAKE" "${gnu_make}"
[ -z "`makl_get_var_mk BOURNE_SHELL`" ] && \
        makl_set_var_mk "BOURNE_SHELL" "${bourne_shell}"

# do toolchain/shlib setup
env MAKL_TC_FILE="${toolchain_file}" MAKL_SHLIB_FILE="${shlib_file}" \
                  setup/tc_setup.sh
       
# apply substitution as needed
makl_file_sub "bin/maklsh"              \
              "bin/lib/maklsh_catalog"  \
              "bin/lib/maklsh_tc"       \
              "bin/lib/maklsh_conf"     \
              "bin/lib/maklsh_funcs"

. $MAKL_DIR/cf/makl.term

# need to fix reloc.mk path because we don't have MAKL_DIR in place when 
# including Makefile.conf (would hit the {un,}install top level target)
sed -e 's/reloc/$(MAKL_DIR)\/mk\/reloc/' $MAKL_DIR/Makefile.conf > .conf
mv .conf "${MAKL_DIR}"/Makefile.conf
