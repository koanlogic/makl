# $Id: makl_deps.sh,v 1.1 2008/10/09 09:48:47 stewy Exp $
#

# Save required or optional dependency to file
_makl_req ()
{
    if [ -z `makl_get "__noconfig__"` ]; then

        if [ $1 -eq 1 ]; then
            makl_info "adding required $3 dependency $4"
            dft="1"
        else    # [ $1 -eq 0 ]
            makl_info "adding optional $3 dependency $4"
            if [ $2 -eq 0 ]; then
                dft="00"
            else    # [ $2 -eq 1 ]
                dft="01"
            fi
            shift
        fi

        file=${makl_run_dir}/deps_$2
        
        # check if requirement is already defined
        makl_tab_find ${file} $3
        [ $? -eq 0 ] && return

        case $2 in
            lib)
                ${ECHO} "$3|${dft}|$4|$5||" >> ${file}
            ;;
            featx)
                ${ECHO} "$3|${dft}|$4" >> ${file}
            ;;
            *)
                makl_err 2 "Invalid dependency type: $2"
            ;;
        esac
    fi

    makl_args_add $2 $3 "" "<*>" ""
}

##\brief Add a required dependency.
##
##  Add a required dependency of type \e $1 and id \e $2.
##  The remaining arguments are to be defined based on the type:
##   \li 'lib' $1 $2 $3 $4, where \e $3 are CFLAGS, and \e $4 LDFLAGS for the
##                        library (both optional). By default the flags are
##                        determined by the library name.
##   \li 'featx' $1 $2 $3, where \e $3 (optional) is the name of the variable 
##                       to be defined containing the path to the feature. 
##                       If undefined, no variables will be set.
##
##   \param $1 dependency type
##   \param $2 dependency id
##   \param $@ args
##   
makl_require ()
{
    _makl_req 1 "$1" "$2" "$3" "$4"
}

##\brief Add an optional dependency.
##
##  Add an optional dependency of type \e $2 and id \e $3.
##  The remaining arguments are to be defined based on the type:
##   \li 'lib' $1 $2 $3 $4 $5, where \e $4 are CFLAGS, and \e $5 LDFLAGS for the
##                             library (both optional). By default the flags are
##                             determined by the library name.
##   \li 'featx' $1 $2 $3 $4, where \e $4 (optional) is the name of the variable
##                            to be defined containing the path to the feature. 
##                            If undefined, no variables will be set.
##
##   \param $1 enabled by default (1) or disabled by default (0)
##   \param $2 dependency type
##   \param $3 dependency id
##   \param $@ args
##   
makl_optional ()
{
    _makl_req 0 "$1" "$2" "$3" "$4" "$5"
}

##\brief Create a dependency between dependencies.
##
## Create a dependency between dependencies. Such behaviour is type-specific.
## For libraries this will append \a $3's CFLAGS and LDFLAGS to \a $1's.
## 
##  \param $1 dependency type
##  \param $2 dependency id
##  \param $3 dependency target
##
makl_depend ()
{
    file=${makl_run_dir}/deps_$1

    makl_info "adding $1 dependency ($2->$3)"

    makl_tab_get ${file} $2 1
    [ $? = 0 ] || makl_err 2 "invalid source dependency: $2"
    
    makl_tab_get ${file} $3 1
    [ $? = 0 ] || makl_err 2 "invalid target dependency: $3"

    case $1 in 
        lib)
            makl_tab_set ${file} $2 5 $3
        ;;
        *)
            makl_err 2 "dependency behaviour not implemented for type: $1"
        ;;
    esac
}

##\brief Search for dynamic library in default directories or specified.
##
##  Search for dynamic library \e $1 in default directories (as defined in 
##        etc/args.cf).
##  Compilation is tested with CFLAGS \e $2 and LDFLAGS \e $3.
##
##   \param $1 required lib  
##   \param $2 cflags
##   \param $3 ldflags
##   \param 0 on success, 1 on lib not found.
##
_makl_search_lib ()
{
    req=$1
    cflags=$2
    ldflags=$3
    f_args=${makl_run_dir}/args
    f_args_lib=${makl_run_dir}/args_lib

    # get feature argument defaults
    dft=`makl_tab_get ${f_args} "lib" 3`

    # get specific options
    path=`makl_tab_get ${f_args_lib} ${req} 2`
    libdir=`makl_tab_get ${f_args_lib} ${req} 4`

    if [ -z "${libdir}" ]; then
        libdir="lib"
    fi

    if [ -z "${path}" ]; then
        # look for base dir in __libs__ 
        libs=`makl_get "__libs__"`
        if [ "${libs}" ]; then
            makl_libdep "${req}" "${libs}" "${cflags}" "${ldflags}" "${libdir}"
            [ $? -eq 0 ] && return 0
        fi
        val=`makl_tab_var "${dft}" "BASE"` 
        dirs=`${ECHO} ${val} | sed 's/:/ /g'`
    else
        dirs=${path} 
    fi

    for dir in ${dirs}; do
        makl_libdep "${req}" "${dir}" "${cflags}" "${ldflags}" "${libdir}"
        [ $? -eq 0 ] && return 0
    done 

    return 1
}

## \brief Search for an executable feature.
##  
##  Search for executable feature \e $1 in default directories (as defined
##  in etc/args.cf). It is assumed that the id corresponds to the filename 
##  of the executable file.
##
##  \param $1 feature id
##
_makl_search_featx ()
{
    f_args=${makl_run_dir}/args
    f_args_x=${makl_run_dir}/args_featx
    f_deps_x=${makl_run_dir}/deps_featx

    # get feature argument defaults
    dft=`makl_tab_get ${f_args} "featx" 3`

    # get specific options
    path=`makl_tab_get ${f_args_x} $1 2`

    # get dependency values
    var=`makl_tab_get ${f_deps_x} $1 3`
    
    # get paths defined by BASE
    if [ -z "${path}" ]; then
        val=`makl_tab_var "${dft}" "BASE"` 
        dirs=`${ECHO} ${val} | sed 's/:/ /g'`
    else
        dirs=`dirname ${path}`
    fi

    # search for executable file
    for dir in ${dirs}; do
        if [ -x "${dir}/$1" ]; then
            makl_set_var "HAVE_"`makl_upper $1`
            [ -z "${var}" ] || makl_set_var "PATH_"`makl_upper $1` ${dir}/$1 1
            return 0
        fi
    done 

    makl_unset_var "HAVE_"`makl_upper $1`
    return 1
}

##\brief Check that "type" dependencies have been fulfilled.
##
##   \param $1 dependency type
##   
_makl_require_check ()
{
    f_req=${makl_run_dir}/deps_$1
    f_have=${makl_run_dir}/deps_$1.found

    [ ! -r "${f_req}" ] && return 0
    [ -r "${f_have}" ] || touch ${f_have}

    rm -f ${makl_run_dir}/err

    cat ${f_req} | {
        while read line; do
            _dep=`makl_tab_elem "${line}" 1`
            _req=`makl_tab_elem "${line}" 2`

            case "${_req}" in 
                1)  makl_info "searching for required $1 feature ${_dep}" ;;
                01) makl_info "searching for optional $1 feature ${_dep}" ;;
                00) makl_info "disabled optional $1 feature ${_dep}" ; break ;;
                *)  makl_err  2 "bad req: ${_req}" ; break ;;
            esac

            case $1 in
                lib)
                    cflags=`makl_tab_elem "${line}" 3`
                    ldflags=`makl_tab_elem "${line}" 4`

                    # default link directive
                    if [ -z "${ldflags}" ]; then
                        ldflags="-l${_dep}"
                    fi
                    _makl_search_lib "${_dep}" "${cflags}" "${ldflags}"
                    ;;
                featx) 
                    _makl_search_featx "${_dep}"
                    ;;
            esac

            if [ $? -ne 0 ]; then
                if [ "${_req}" = "1" ]; then
                    ${ECHO} -n ${_dep} > ${makl_run_dir}/err
                    break
                else
                    if [ "${_req}" = "01" ]; then
                        ${ECHO} -n ${_dep} > ${makl_run_dir}/warn
                    fi
                fi
            fi
        done
    }

    if [ -r "${makl_run_dir}/err" ]; then
        makl_err 3 "unfulfilled dependency: '`cat ${makl_run_dir}/err`'!"
        rm ${makl_run_dir}/err
    fi  
    if [ -r "${makl_run_dir}/warn" ]; then
        makl_warn "could not find optional dependency '`cat ${makl_run_dir}/warn`'"
        rm ${makl_run_dir}/warn
    fi
}

##\brief Set the test code for a library.
##
##  Set the test code for library \e $1. 
##  Data is read from standard input.
##
##   \param $1 library id
##
makl_lib_testcode ()
{
    file=${makl_run_dir}/lib_testcode_$1.c

    # create a clean file
    [ -r "${file}" ] && rm -f ${file}

    while read line; do
        ${ECHO} ${line} >> ${file}
    done
}

## \brief Check dependencies
##
## This function is called on termination to check dependencies and generate 
## appropriate variables.
## 
_makl_deps_check ()
{
    [ -z `makl_get "__noconfig__"` ] || return
    makl_info "checking dependencies"
    _makl_require_check "lib"
    _makl_require_check "featx"
}
