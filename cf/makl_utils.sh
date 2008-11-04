#
# $Id: makl_utils.sh,v 1.3 2008/11/04 13:12:16 stewy Exp $
#

##\brief Set the package name.
##
##  Set the package name to \e $1.
##
##  \param $1 package name
##  
makl_pkg_name ()
{
    [ -z "$1" ] && makl_err 1 "makl_pkg_name(): undefined package name!"

    makl_info "setting package name to $1"

    makl_set "__package__" "$1"
}

##\brief Set the package version.
##
##  Set the package version to \e $1.
##  [format: "X.Y.Zdesc", where X, Y and Z are digits and desc is alphanumeric]
##  If no argument is supplied, a file named VERSION in the base 
##  directory containing the version is expected. 
##  The package name must already be defined by \e makl_pkg_name().
##
##  \param $1 package version (optional)
##  
makl_pkg_version ()
{
    file="VERSION"
    pkg=`makl_get "__package__"`

    [ -z "${pkg}" ] && \
        makl_err 1 "makl_pkg_version(): makl_pkg_name must be defined first!"

    [ -f "${file}" ] && [ -r "${file}" ] && \
        ver=`cat ${file} | sed 's/[\ 	]*$//'`	#remove trailing whitespace

    [ $? -eq 0 ] || ver=$1

    major=`${ECHO} ${ver} | cut -d '.' -f 1 | grep '^[0-9][0-9]*$'`
    [ $? -eq 0 ] || makl_err 2 "makl_pkg_version(): major must be numeric!"
    minor=`${ECHO} ${ver} | cut -d '.' -f 2 | grep '^[0-9][0-9]*$'`
    [ $? -eq 0 ] || makl_err 2 "makl_pkg_version(): minor must be numeric!"
    teenydesc=`${ECHO} ${ver} | cut -d '.' -f 3`
    teeny=`${ECHO} ${teenydesc} | sed -e 's/[a-zA-Z].*$//'`
    [ $? -eq 0 ] || makl_err 2 "makl_pkg_version(): teeny must be numeric!"
    desc=`${ECHO} ${teenydesc} | sed -e 's/^[0-9]\{1,\}//'`

    ver="${major}.${minor}.${teeny}${desc}"

    makl_info "setting version to ${ver}"

    makl_set_var "`makl_upper ${pkg}`_VERSION" ${ver} 1

    makl_set "__ver__" ${ver}
    makl_set "__ver_major__" ${major}
    makl_set "__ver_minor__" ${minor}
    makl_set "__ver_teeny__" ${teeny}
}

##\brief Print the OS name.
## 
##  Print a brief string representing the operating system type and version.
##
makl_os_name ()
{
    uname -rs | tr '[A-Z]' '[a-z]' | sed -e 's/ //'
}

##\brief Print the target OS name.
## 
##  Print a brief string representing the target operating system type and 
##  version.
##
makl_target_name ()
{
    if [ -z "${MAKL_PLATFORM}" ];  then
        uname -rs | tr '[A-Z]' '[a-z]' | sed -e 's/ //'
    else
        ${ECHO} "${MAKL_PLATFORM}" | tr '[A-Z]' '[a-z]' 
    fi
}

##\brief Write a message and exit.
##
##  Print the supplied error string to stderr and bail out with the given 
##  exit code.
## 
##   \param $1 exit code
##   \param $2 error string
##
makl_err ()
{
    exit_code=$1
    shift

    ${ECHO} 1>&2 "[err] $*"
    makl_cleanup_rundir
    exit ${exit_code}
}

## \brief Print info 
##
##   Print some basic info on MaKL operations.
##
##     \param $1 info string
##
makl_info ()
{
    ${ECHO} "$*"
}

##\brief Print a debug message. 
##
##  Print the supplied debug message to stderr if "makl_debug" variable is set
##  to "true", "yes", "on" or '1'.
##
##   \param $1 debug string
##
makl_dbg ()
{
    [ -z `makl_get "__verbose__"` ] || ${ECHO} 1>&2 "[dbg] $*"
}

##\brief Print a warning message.
##
##  Print the supplied warning message to stderr.
##  
##   \param $1 warning string
##
makl_warn ()
{
    ${ECHO} 1>&2 "[wrn] $*"
}

##\brief Print global variables.
##
##  Print MaKL global variables in use to stderr if 'makl_debug' is set.
##
makl_dbg_globals ()
{
    makl_dbg "MAKL_DIR: ${MAKL_DIR}"
    makl_dbg "makl_run_dir: ${makl_run_dir}"
    makl_dbg "makl_conf_h: ${makl_conf_h}"
    makl_dbg "makl_makefile_conf: ${makl_makefile_conf}"
}

##\brief Tool requirements check
##
##  Check existence of basic tool requirements.
##
##  \param $1 0 if tools don't use stdin, 1 otherwise
##  \param $@ list of tools
##
makl_check_tools ()
{
    has_stdin=0
    [ $1 -eq 0 ] || has_stdin=1
    shift
    
    for tool in "$@"; do
        if [ ${has_stdin} -eq 0 ]; then
            eval ${tool} 1> /dev/null 2> /dev/null
        else
            eval ${ECHO} | ${tool} 1> /dev/null 2> /dev/null
        fi
        if [ $? -eq 127 ]; then
            ${ECHO} "required tool not found: ${tool}!"
            exit 2
        fi
    done
}

##\brief Transform lower case letters into upper case letters.
## 
##  Transform lower case letters into upper case letters.
##
##   \param $* list of 0 or more strings to be converted
##
makl_upper ()
{
   ${ECHO} $* | tr "[a-z]" "[A-Z]"
}

##\brief Cleanup run-time directory.
##
##  Cleanup run-time directory ${makl_run_dir}.
##
makl_cleanup_rundir ()
{
    [ -z `makl_get "__noclean__"` ] || return 
    rm -rf ${makl_run_dir}
}

##\brief Clean MaKL exit
##
## Exit from MaKL cleanly with return code $1
##
##  \param $1 - the return code
## 
makl_die ()
{
    makl_cleanup_rundir
    exit $1
}

##\brief Yes/No Question.
##
##  Write question \e $1 to the terminal and wait for the user to answer.
##
##   \param $1 - question string
##   \return 0 if [yY] was typed, 1 if [nN].
##
makl_yesno ()
{
    ${ECHO} -n "$1 " 
    
    while [ /bin/true ]; do 
        read answer
        case ${answer} in
            [Yy])
                return 0
                ;;
            [nN])
                return 1
                ;;
            *)
                ${ECHO} -n "please say [yY] or [nN]: "
                ;;
        esac
    done
}

##\brief Check validity of a mode string.
##
##  Check whether \e $1 is a valid mode string (3 octal digits).
##
##  \param $1 - mode string
##  \return 0 if valid, 1 otherwise
##
makl_is_mode ()
{
    ${ECHO} $1 | grep '^[0-7][0-7][0-7]$' 1>/dev/null 2>/dev/null

    return $?
}

## \brief Generate default directories.
##
##  Generate default installation directories starting from "__prefix__".
##  Note: should match etc/map.mk configuration
##
_makl_set_dirs()
{
    pfx=`makl_get "__prefix__"`

    makl_set_var "DESTDIR"  "${pfx}" 1
    
    [ -z "`makl_get_var_mk "BINDIR"`" ] && \
        makl_set_var "BINDIR"   "${pfx}"/bin 1

    [ -z "`makl_get_var_mk "SBINDIR"`" ] && \
        makl_set_var "SBINDIR"  "${pfx}"/sbin 1

    [ -z "`makl_get_var_mk "CONFDIR"`" ] && \
        makl_set_var "CONFDIR"  "${pfx}"/etc 1

    [ -z "`makl_get_var_mk "INCDIR"`" ] && \
        makl_set_var "INCDIR"   "${pfx}"/include 1

    [ -z "`makl_get_var_mk "LIBDIR"`" ] && \
        makl_set_var "LIBDIR"   "${pfx}"/lib 1
        
    [ -z "`makl_get_var_mk "SHLIBDIR"`" ] && \
        makl_set_var "SHLIBDIR" "${pfx}"/lib 1

    [ -z "`makl_get_var_mk "LIBEXDIR"`" ] && \
        makl_set_var "LIBEXDIR" "${pfx}"/libexec 1
        
    [ -z "`makl_get_var_mk "VARDIR"`" ] && \
        makl_set_var "VARDIR"   "${pfx}"/var 1

    [ -z "`makl_get_var_mk "SHAREDIR"`" ] && \
        makl_set_var "SHAREDIR" "${pfx}"/share 1
        
    [ -z "`makl_get_var_mk "MANDIR"`" ] && \
        makl_set_var "MANDIR"   "`makl_get_var_mk "SHAREDIR"`"/man 1

    [ -z "`makl_get_var_mk "DOCDIR"`" ] && \
        makl_set_var "DOCDIR"   "`makl_get_var_mk "SHAREDIR"`"/doc 1
}

## \brief Perform file substitution.
##
##  Substitute values in given files with Makfile variables.
##  
##      \param $@ the names of the output files for substitution
##                  (corresponding .in file should exist)
##
makl_file_sub ()
{
    makl_set "__file_sub__" $*
}

_makl_file_sub ()
{
    subs=`makl_get "__file_sub__"`

    for sub in ${subs}; do 
        [ -r "${sub}.in" ] || makl_err 2 "makl_file_sub(): could not find ${sub}.in"
        makl_info "applying substitutions to: ${sub}"
        cp ${sub}.in /tmp/sub.tmp
        cat ${makl_run_dir}/vars_mk | {
            while read var; do
                name=`makl_tab_elem "${var}" 1`
                val=`makl_tab_elem "${var}" 3 | sed -e "s%\/%\\\\\/%g"`
                cat /tmp/sub.tmp | sed -e "s%@{{${name}}}%${val}%g" > /tmp/sub2.tmp
                mv /tmp/sub2.tmp /tmp/sub.tmp
            done 
        }
        cp /tmp/sub.tmp ${sub}
    done
    rm -f /tmp/sub.tmp /tmp/sub2.tmp
}
