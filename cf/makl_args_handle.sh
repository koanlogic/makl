#
# $Id: makl_args_handle.sh,v 1.15 2010/05/26 20:23:23 tho Exp $
#

#/*! @function      makl_args_init
#
#    @abstract      Initialise command line arguments.
#    @discussion    Initialise command-line arguments <tt>$@</tt> . This should
#                   be the first call in the configure script after global 
#                   initialisation (<tt>makl_init</tt>).
#
#    @param $@  command line arguments
#*/
makl_args_init ()
{
    makl_info "preprocessing command-line arguments"
    
    makl_set "__args__" "$@"

    for arg in "$@"; do
        cmd=`"${ECHO}" ${arg} | "${CUT}" -f1 -d "="`
        case "${cmd}" in 
            -h | --help)
                makl_set "__noconfig__"
                if [ -r configure.help ]; then
                    "${CAT}" configure.help
                    makl_die 0
                fi
                ;;
            -V | --version)
                __makl_version
                makl_die 0
                ;;
            -v | --verbose)
                __makl_verbose
                ;;
        esac
    done

    [ -z `makl_get "__noconfig__"` ] || return

    makl_info "checking for basic required tools"
    makl_check_tools 0 "${CC}" "${AR}" "${RANLIB}" "${LD}" "${ECHO}" \
                       "${NM}" "${STRIP}" "${INSTALL}"
    makl_check_tools 1 "${TSORT}"
}

#/*! @function      makl_args_handle
#
#    @abstract      Process the configure command-line arguments.
#    @discussion    Process the configure command-line arguments. This should 
#                   be the last call in the configure script (before 
#                   <tt>makl_term</tt>).
#
#    @param $@  command line arguments
#*/
makl_args_handle ()
{
    makl_info "handling command-line arguments"

    for arg in "$@"; do
        pref=`"${ECHO}" ${arg} | "${CUT}" -c1,2`
        cmd=`"${ECHO}" ${arg} | "${CUT}" -f1 -d"="`
        case "${cmd}" in 
            -g | --help_gen)
                __makl_help_gen  
                ;;
            -h | --help) 
                # if help file doesn't exist yet, generate it
                if [ ! -r configure.help ]; then
                    __makl_help_gen  
                   "${CAT}" configure.help
                   makl_die 0
                fi                        
                ;;
            # pass through previously-handled arguments
            -V | --version) ;;
            -v | --verbose) ;;
            --prefix) 
                _makl_arg_handle "${arg}"
                ;;
               
            *)
                [ "${pref}" = "--" ] || \
                    _makl_args_err "Undefined command: ${arg}!"
                _makl_arg_handle "${arg}"
                ;;
        esac
    done
    
    # check generated dependencies
    _makl_deps_check
    _makl_set_dirs
}

_makl_help_print ()
{
    {
        "${ECHO}" 
        "${ECHO}" "'MaKL' - a painless C project configuration tool"
        "${ECHO}" 
        "${ECHO}" "Usage: ./CONFIGURE_SCRIPT [OPTION] ..."
        "${ECHO}" 
        "${ECHO}" "OPTION can be defined as follows:"
        "${ECHO}" 
        _makl_help_opts
        "${ECHO}"
        "${ECHO}" "Legend:"       
        "${ECHO}" "  <*>: required dependency" 
        "${ECHO}" "  <?>: optional dependency" 
        "${ECHO}"
    } > configure.help
}

## Handler. RESERVED for makl internals
__makl_makl () 
{
    makl_dbg "ignoring internal handler 'makl' (id=$1, val=$2)"
}
    
## Handler. Print out the help menu.
__makl_help () 
{
    [ $# -eq 0 ] || _makl_args_err "--help: wrong number of arguments!"
  
    [ -r configure.help ] || _makl_help_print
    
    "${CAT}" configure.help

    makl_cleanup_rundir
}

## Handler. Generate new configure.help based on configuration.
__makl_help_gen ()
{
    [ $# -eq 0 ] || _makl_args_err "--help_gen: wrong number of arguments!"

    _makl_help_print
}

## Handler. Activate verbose debugging output.
__makl_verbose ()
{
    [ $# -eq 0 ] || _makl_args_err "--verbose: wrong number of arguments!"

    makl_set "__verbose__" 1
}

## Handler. Print out the version.
__makl_version ()
{
    [ $# -eq 0 ] || _makl_args_err "--version: wrong number of arguments!"

    file="${MAKL_DIR}/VERSION"

    # remove trailing whitespace
    [ -f "${file}" ] && [ -r "${file}" ] && \
        ver=`"${CAT}" "${file}" | "${SED}" 's/[\    ]*$//'` 
   
    "${ECHO}" "${ver}" | \
        "${GREP}" '^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9a-zA-Z]*$' 1> /dev/null
    [ $? -eq 0 ] || \
        makl_err 2 "--version: version must have format 'X.Y.Z'" \
                             "where X, Y and Z are digits."

    "${ECHO}" "MaKL version: ${ver}"

    makl_cleanup_rundir
}

## Print out the help options.
_makl_help_opts() 
{
    file_args="${makl_run_dir}"/args 

    # print out arguments
    [ -e "${file_args}" ] && \
    "${CAT}" "${file_args}" | {
        while read line; do 
            id=`makl_tab_elem "${line}" 1`
            pms=`makl_tab_elem "${line}" 2`
            dft=`makl_tab_elem "${line}" 3`
            dsc=`makl_tab_elem "${line}" 4`
            [ -e "${makl_run_dir}/args_${id}" ] && \
            "${CAT}" "${makl_run_dir}"/args_"${id}" | { 
                while read lin; do
                    ID=`makl_tab_elem "${lin}" 1`
                    DFT=`makl_tab_elem "${lin}" 2`
                    PFX=`makl_tab_elem "${lin}" 3`
                    DSC=`makl_tab_elem "${lin}" 4`
                    _makl_args_print "${id}" "${pms}" "${dsc}" "${ID}" \
                                    "${DFT}" "${PFX}" "${DSC}"

                done
            } || {
                "${ECHO}" -n "--"${id}${pms} "     "  ${dsc}
                [ "${dft}" = " " ] || "${ECHO}" -n " [${dft}]"
            }
            "${ECHO}"
        done
    }
}

## Handler. Don't clean cache at end of execution.
__makl_noclean ()
{
    [ $# -eq 0 ] || _makl_args_err "--noclean: wrong number of arguments!"

    makl_set "__noclean__" 1
}

## Handler.  Configure for cross-compilation. The only effect at present is to 
##           avoid code execution when testing code snippets.
__makl_cross_compile ()
{
    [ $# -eq 0 ] || _makl_args_err "--cross_compile: wrong number of arguments!"

    makl_set "__cross_compile__" 1
}

## Handler.  Set the base installation directory to $1. Such directory will 
##           become the default base directory for all data types.
__makl_prefix ()
{
    [ $# -eq 1 ] || _makl_args_err "--prefix: wrong number of arguments!"

    makl_set "__prefix__" "$1"
}

## Handler.  Set the base directory for a specific data type $1.  
##           For a list of valid directory types please refer to "makl-conf --help".
##           $2 indicates the path to the base directory.
__makl_dir ()
{
    [ $# -eq 2 ] || _makl_args_err "--dir: wrong number of arguments!"
      
    f_dirs="${makl_run_dir}"/args_dir
    makl_tab_find "${f_dirs}" "$1"
    
    [ $? -eq 0 ] || makl_err 2 "_makl_dir: Bad directory type: $1"
    
    makl_set_var `makl_upper $1`"DIR" "$2" 1
}

## Handler. Set the default file owner id to $1.
__makl_defown ()
{
    [ $# -eq 1 ] || _makl_args_err "--defown: wrong number of arguments!"
    
    makl_set_var_mk "DEFOWN" "$1"
}

## Handler.  Set default file group id to $1.
__makl_defgrp ()
{
    [ $# -eq 1 ] || _makl_args_err "--defgrp: wrong number of arguments!"
    
    makl_set_var_mk "DEFGRP" "$1"
}

## Handler.  Set default file mode for regular files to $1. The mode should be 
##           a string formed by 3 octal digits (RWX).
__makl_defmode ()
{
    [ $# -eq 1 ] || _makl_args_err "--defmode: wrong number of arguments!"

    makl_is_mode "$1"
    [ $? -eq 0 ] || makl_err 2 "Invalid mode: $1 (3 octal digits)"
    
    makl_set_var_mk "DEFMODE" "$1"
}

## Handler.  Set default file mode for binary files to $1. The mode should be 
##           a string formed by 3 octal digits (RWX).
__makl_defbinmode ()
{
    [ $# -eq 1 ] || _makl_args_err "--defbinmode: wrong number of arguments!"

    makl_is_mode "$1"
    [ $? -eq 0 ] || makl_err 2 "Invalid mode: $1 (3 octal digits)"
    
    makl_set_var_mk "DEFBINMODE" "$1"
}

## Handler.  Enable a feature of type $1 with id $2.  Please refer to 
##           "makl-conf --help" for valid feature types and ids.
__makl_enable ()
{
    [ $# -eq 2 ] || _makl_args_err "--enable: wrong number of arguments!"

    f_feat="${makl_run_dir}"/deps_"$1"
    [ -f "${f_feat}" ] || \
        _makl_args_err "--makl_enable: Invalid feature type $1"

    req=`makl_tab_get ${f_feat} "$2" 2`
    [ "${req}" = "1" ] && makl_err 2 "cannot enable a required feature!"
    makl_tab_set ${f_feat} "$2" 2 "01"
}

## Handler.  Disable a feature of type $1 with id $2.  Please refer to 
##           "makl-conf --help" for valid feature types and ids.
__makl_disable ()
{
    [ $# -eq 2 ] || _makl_args_err "--disable: wrong number of arguments!"

    f_feat="${makl_run_dir}"/deps_"$1"
    [ -f "${f_feat}" ] || \
        _makl_args_err "--makl_disable: Invalid feature type $1"
    
    req=`makl_tab_get ${f_feat} "$2" 2`
    [ "${req}" = "1" ] && makl_err 2 "cannot disable a required feature!"
    makl_tab_set "${f_feat}" "$2" 2 "00"
}

## Handler.  Set parameters for an executable feature $1; $2 is the path of 
##           the file corresponding to the feature.
__makl_featx ()
{
    [ $# -eq 2 ] || _makl_args_err "--featx: wrong number of arguments!"

    f_featx="${makl_run_dir}"/args_featx
    makl_tab_find "${f_featx}" "$1"
    [ $? -eq 0 ] || _makl_args_err "--makl_featx: Invalid featx: $1"

    makl_tab_set "${f_featx}" "$1" 2 "$2"
}

## Handler.  Set parameters for a library dependency $1; $2 is the path of the 
##           base directory for the library.
__makl_lib ()
{
    [ $# -eq 2 ] || _makl_args_err "--lib: wrong number of arguments!"
    [ "$1" ] || _makl_args_err "--makl_lib: missing library id!"

    libs="${makl_run_dir}"/args_lib
    makl_tab_find "${libs}" "$1"
    [ $? -eq 0 ] || _makl_args_err "--makl_lib: undefined library $1"
    
    makl_tab_set "${libs}" "$1" 2 "$2"
}

## Handler.  Set the name of the directory $2 from prefix in which library $1 
##           should be sought. The default is 'lib' otherwise.
__makl_find_lib ()
{
    [ $# -eq 2 ] || _makl_args_err "--find_lib: wrong number of arguments!"
    [ "$1" ] || _makl_args_err "--find_lib: missing lib name!"

    libs="${makl_run_dir}"/args_lib
    makl_tab_find "${libs}" "$1"
    [ $? -eq 0 ] || _makl_args_err "--find_lib: undefined library $1"

    makl_tab_set "${libs}" "$1" 4 "$2"
}

## Handler.  Set parameters for all library dependencies: $1 is the path of the
##           base directory for the libraries.
__makl_libs ()
{
    [ $# -eq 1 ] || _makl_args_err "--libs: wrong number of arguments!"

    makl_set "__libs__" "$1"
}

## Print an error message $1 followed by the usage printout.  This function is 
## to be called on an user argument error.  Give up with exit code 1.
_makl_args_err ()
{
    __makl_help
    "${ECHO}"
    makl_err 1 "$1"
}

## Handle the command-line argument $1 by calling the corresponding function.
_makl_arg_handle ()
{
    lval=`"${ECHO}" $1 | "${CUT}" -f1 -d"="`
    rval=`"${ECHO}" $1 | "${CUT}" -s -f2- -d"="`

    cmd=`"${ECHO}" ${lval} | "${CUT}" -f3 -d"-"`
    id=`"${ECHO}" ${lval} | "${CUT}" -f4 -d"-"` 
    
    makl_dbg "running command '${cmd}' id '${id}'"

    if [ -z "${cmd}" ]; then
        _makl_args_err "Unspecified command!" 
    else 
        if [ -z "${id}" ]; then
            if [ -z "${rval}" ]; then
                __makl_${cmd} 
            else 
                __makl_${cmd} "${rval}"
            fi
        elif [ -z "${rval}" ]; then
            __makl_${cmd} ${id} 
        else
            __makl_${cmd} ${id} "${rval}"
        fi
    fi           
    [ $? -eq 0 ] || _makl_args_err "Failed command: '${cmd}'!"
}
