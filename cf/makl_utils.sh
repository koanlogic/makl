#
# $Id: makl_utils.sh,v 1.11 2010/06/07 19:50:04 stewy Exp $
#

#/*! 
#    @header    Utils   Utility Functions
#*/

#/*! @function      makl_version
#
#    @abstract      Print installed MaKL version.
#    @discussion    Print installed MaKL version...
#*/
makl_version ()
{
    if [ ! -r "${MAKL_DIR}"/VERSION ]; then
        makl_info "no VERSION file found in ${MAKL_DIR}"
        return
    fi

    "${CAT}" "${MAKL_DIR}"/VERSION

    return
}

#/*! @function      makl_test_dir
#
#    @abstract      Where MaKL configuration test files will be placed.
#    @discussion    Where MaKL configuration test files will be placed.
#                   Default is `pwd`/build.
#*/
makl_test_dir ()
{
    [ $# -eq 1 ] || makl_err 1 "makl_test_dir(): missing test directory name!"

    makl_info "setting test dir to $1"

    makl_set "__test_dir__" "$1"
}

#/*! @function      makl_pkg_name
#
#    @abstract      Set the package name.
#    @discussion    Set the package name to <tt>$1</tt>.
#
#    @param $1  package name
#*/
makl_pkg_name ()
{
    [ -z "$1" ] && makl_err 1 "makl_pkg_name(): undefined package name!"

    makl_info "setting package name to $1"

    makl_set "__package__" "$1"
}

#/*! @function      makl_pkg_version
#
#    @abstract      Set the package version.
#    @discussion    Set the package version to <tt>$1</tt>.  Format is 
#                   X.Y.Z[desc], where X, Y and Z are digits and desc is 
#                   alphanumeric.  If no argument is supplied, a file named 
#                   VERSION in the base directory containing the version is 
#                   expected.  The package name must already be defined by 
#                   makl_pkg_name().
#
#    @param $1  package version (optional)
#*/
makl_pkg_version ()
{
    file="VERSION"
    pkg=`makl_get "__package__"`

    [ -z "${pkg}" ] && \
        makl_err 1 "makl_pkg_version: makl_pkg_name must be called explicitly!"

    # remove trailing whitespace
    [ -f "${file}" ] && [ -r "${file}" ] && \
        ver=`"${CAT}" "${file}" | "${SED}" 's/[\ 	]*$//'`

    [ $? -eq 0 ] || ver=$1

    major=`"${ECHO}" ${ver} | "${CUT}" -d '.' -f 1 | "${GREP}" '^[0-9][0-9]*$'`
    [ $? -eq 0 ] || makl_err 2 "makl_pkg_version(): major must be numeric!"
    minor=`"${ECHO}" ${ver} | "${CUT}" -d '.' -f 2 | "${GREP}" '^[0-9][0-9]*$'`
    [ $? -eq 0 ] || makl_err 2 "makl_pkg_version(): minor must be numeric!"
    teenydesc=`"${ECHO}" ${ver} | "${CUT}" -d '.' -f 3`
    teeny=`"${ECHO}" ${teenydesc} | "${SED}" -e 's/[a-zA-Z].*$//'`
    [ $? -eq 0 ] || makl_err 2 "makl_pkg_version(): teeny must be numeric!"
    desc=`"${ECHO}" ${teenydesc} | "${SED}" -e 's/^[0-9]\{1,\}//'`

    ver="${major}.${minor}.${teeny}${desc}"

    makl_info "setting version to ${ver}"

    makl_set_var "`makl_upper ${pkg}`_VERSION" ${ver} 1

    # Also set numeric values for maj, min and teeny that can be
    # easily tested in source files, like:
    # #if LIBU_VERSION_MAJOR == 2 && LIBU_VERSION_MINOR > 1
    #   ... do something specific to libu 2.x with x>1 ...
    # #endif
    makl_set_var "`makl_upper ${pkg}`_VERSION_MAJOR" ${major}
    makl_set_var "`makl_upper ${pkg}`_VERSION_MINOR" ${minor}
    makl_set_var "`makl_upper ${pkg}`_VERSION_TEENY" ${teeny}

    makl_set "__ver__" ${ver}
    makl_set "__ver_major__" ${major}
    makl_set "__ver_minor__" ${minor}
    makl_set "__ver_teeny__" ${teeny}
}

#/*! @function      makl_os_name
#
#    @abstract      Print the OS name.
#    @discussion    Print a brief string representing the operating system 
#                   type and version.
#*/
makl_os_name ()
{
    "${UNAME}" -rs | "${TR}" '[A-Z]' '[a-z]' | "${SED}" -e 's/ //'
}

#/*! @function      makl_target_name
#
#    @abstract      Print the target OS name.
#    @discussion    Print a brief string representing the target operating 
#                   system type and version.
#*/
makl_target_name ()
{
    if [ -z "${MAKL_PLATFORM}" ];  then
        "${UNAME}" -rs | "${TR}" '[A-Z]' '[a-z]' | "${SED}" -e 's/ //'
    else
        "${ECHO}" "${MAKL_PLATFORM}" | "${TR}" '[A-Z]' '[a-z]' 
    fi
}

#/*! @function      makl_err
#
#    @abstract      Write a message and exit.
#    @discussion    Print the supplied error string to stderr and bail out 
#                   with the given exit code.
#
#    @param $1  exit code
#    @param $2  error string
#*/
makl_err ()
{
    exit_code=$1
    shift

    "${ECHO}" 1>&2 "[err] $*"
    makl_cleanup_rundir
    exit ${exit_code}
}

#/*! @function      makl_info
#
#    @abstract      Print an informational message.
#    @discussion    Print some basic info on MaKL operations. 
#
#    @param $1  info string
#*/
makl_info ()
{
    "${ECHO}" "$*"
}

#/*! @function      makl_dbg
#
#    @abstract      Print a debug message.
#    @discussion    Print the supplied debug message to stderr if 
#                   <tt>makl_debug</tt> variable is set to <tt>true</tt>, 
#                   <tt>yes</tt>, <tt>on</tt> or <tt>1</tt>.
#
#    @param $1  debug string
#*/
makl_dbg ()
{
    [ -z `makl_get "__verbose__"` ] || "${ECHO}" 1>&2 "[dbg] $*"
}

#/*! @function      makl_warn
#
#    @abstract      Print a warning message.
#    @discussion    Print the supplied warning message to stderr.
#
#    @param $1  warning string
#*/
makl_warn ()
{
    "${ECHO}" 1>&2 "[wrn] $*"
}

#/*! @function      makl_dbg_globals
#
#    @abstract      Print global variables.
#    @discussion    Print MaKL global variables in use to stderr if 
#                   <tt>makl_debug</tt> is set.
#*/
makl_dbg_globals ()
{
    makl_dbg "MAKL_DIR: ${MAKL_DIR}"
    makl_dbg "makl_run_dir: ${makl_run_dir}"
    makl_dbg "makl_conf_h: ${makl_conf_h}"
    makl_dbg "makl_makefile_conf: ${makl_makefile_conf}"
}

#/*! @function      makl_check_tools
#
#    @abstract      Tool requirements check.
#    @discussion    Check existence of basic tool requirements.
#
#    @param $1  0 if tools don't use stdin, 1 otherwise
#    @param $@  list of tools to be checked
#*/
makl_check_tools ()
{
    has_stdin=0
    [ $1 -eq 0 ] || has_stdin=1
    shift
    
    for tool in "$@"; do
        if [ ${has_stdin} -eq 0 ]; then
            eval ${tool} 1> /dev/null 2> /dev/null
        else
            eval "${ECHO}" | ${tool} 1> /dev/null 2> /dev/null
        fi
        if [ $? -eq 127 ]; then
            "${ECHO}" "required tool not found: ${tool}!"
            exit 2
        fi
    done
}

#/*! @function      makl_upper
#
#    @abstract      Transform lower case letters into upper case letters.
#    @discussion    Transform lower case letters into upper case letters.
#
#    @param $*  list of 0 or more strings to be converted
#*/
makl_upper ()
{
   "${ECHO}" $* | "${TR}" "[a-z]" "[A-Z]"
}

#/*! @function      makl_upper
#
#    @abstract      Cleanup run-time directory.
#    @discussion    Cleanup run-time directory (i.e. <tt>${makl_run_dir}</tt>).
#*/
makl_cleanup_rundir ()
{
    [ -z `makl_get "__noclean__"` ] || return 
    "${RM}" -rf "${makl_run_dir}"
}

#/*! @function      makl_die
#
#    @abstract      Clean MaKL exit.
#    @discussion    Exit from MaKL cleanly with return code <tt>$1</tt>.
#*/
makl_die ()
{
    makl_cleanup_rundir
    exit $1
}

#/*! @function      makl_yesno
#
#    @abstract      Yes/No Question.
#    @discussion    Write question <tt>$1</tt> to the terminal and wait for 
#                   the user to answer.
#
#    @param $1  question string
#
#    @return    0 if [yY] was typed, 1 if [nN].
#*/
makl_yesno ()
{
    "${ECHO}" -n "$1 " 
    
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
                "${ECHO}" -n "please say [yY] or [nN]: "
                ;;
        esac
    done
}

#/*! @function      makl_is_mode
#
#    @abstract      Check validity of a mode string.
#    @discussion    Check whether <tt>$1</tt> is a valid mode string (3 octal 
#                   digits).
#
#    @param $1  mode string
#
#    @return    0 if valid, 1 otherwise
#*/
makl_is_mode ()
{
    "${ECHO}" $1 | "${GREP}" '^[0-7][0-7][0-7]$' 1>/dev/null 2>/dev/null

    return $?
}

#/*! @function      _makl_set_dirs
#
#    @abstract      Generate default directories.
#    @discussion    Generate default installation directories starting from 
#                   <tt>__prefix__</tt>.  Note: should match <tt>etc/map.mk</tt>
#                   configuration.
#*/
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

#/*! @function      makl_file_sub
#
#    @abstract      Perform file substitution.
#    @discussion    Substitute values in given files with Makfile variables.
#
#    @param $@  the names of the output files for substitution (corresponding 
#                   <tt>.in</tt> file should exist)
#*/
makl_file_sub ()
{
    makl_set "__file_sub__" $*
}

_makl_file_sub ()
{
    subs=`makl_get "__file_sub__"`

    for sub in ${subs}; do 

        [ -r "${sub}.in" ] || \
            makl_err 2 "makl_file_sub(): could not find ${sub}.in"

        makl_info "applying substitutions to: ${sub}"

        "${CP}" "${sub}".in "${makl_run_dir}"/sub.tmp || \
            makl_err 2 "failed creating temporary file!"

        "${CAT}" "${makl_run_dir}"/vars_mk | {

            while read var; do

                name=`makl_tab_elem "${var}" 1`
                val=`makl_tab_elem "${var}" 3 | "${SED}" -e "s%\/%\\\\\/%g"`

                "${CAT}" "${makl_run_dir}"/sub.tmp | \
                    "${SED}" -e "s%@{{${name}}}%${val}%g" > \
                    "${makl_run_dir}"/sub2.tmp || \
                        makl_err 2 "failed writing temporary file!"

                "${MV}" "${makl_run_dir}"/sub2.tmp \
                    "${makl_run_dir}"/sub.tmp || 
                        makl_err 2 "failed moving temporary file!"
            done 
        }

        "${CP}" "${makl_run_dir}"/sub.tmp "${sub}" || \
            makl_err 2 "failed creating substituted file!"

    done

    "${RM}" -f "${makl_run_dir}"/sub.tmp "${makl_run_dir}"/sub2.tmp || \
        makl_err 2 "failed removing temporary files!"
}
