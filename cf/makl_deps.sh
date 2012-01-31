# $Id: makl_deps.sh,v 1.8 2010/05/26 20:23:23 tho Exp $
#

# Save required or optional dependency to file
_makl_req ()
{
    [ -z `makl_get "__noconfig__"` ] || return

    req=$1

    if [ ${req} -eq 1 ]; then
        makl_info "adding required $3 dependency $4"
        dft="1"
    else    # [ ${req} -eq 0 ]
        makl_info "adding optional $3 dependency $4"
        if [ $2 -eq 0 ]; then
            dft="00"
        else    # [ $2 -eq 1 ]
            dft="01"
        fi
        shift
    fi

    file="${makl_run_dir}"/deps_"$2"

    # check if requirement is already defined
    makl_tab_find "${file}" "$3"
    [ $? -eq 0 ] && return

    case "$2" in
        lib)
            "${ECHO}" "$3|${dft}|$4|$5||" >> "${file}"
        ;;
        featx)
            "${ECHO}" "$3|${dft}|$4" >> "${file}"
        ;;
        *)
            makl_err 2 "Invalid dependency type: $2"
        ;;
    esac

    if [ ${req} -eq 1 ]; then
        makl_args_add "$2" $3 "" "<*>" ""       #mark as required
    else
        makl_args_add "$2" $3 "" "<?>" ""       #mark as optional
    fi
}

#/*! @function      makl_require
#
#    @abstract      Add a required dependency.
#    @discussion    Add a required dependency of type <tt>$1</tt> and id 
#                   <tt>$2</tt>.  The remaining arguments are to be defined 
#                   based on the type:
#                   <ul>
#                       <li>
#                           'lib' $1 $2 $3 $4, where <tt>$3</tt> are CFLAGS, 
#                           and <tt>$4</tt> LDFLAGS for the library (both 
#                           optional).  By default the flags are determined 
#                           by the library name.
#                       </li>
#                       <li>
#                           'featx' $1 $2 $3, where <tt>$3</tt> (optional) is 
#                           the name of the variable to be defined containing 
#                           the path to the feature. If undefined, no variables
#                           will be set.
#                       </li>
#                   <ul>
#
#    @param $1  dependency type
#    @param $2  dependency id
#    @param $@  args
#*/
makl_require ()
{
    _makl_req 1 "$1" "$2" "$3" "$4"
}

#/*! @function      makl_optional
#
#    @abstract      Add an optional dependency.
#    @discussion    Add an optional dependency of type <tt>$2</tt> and id 
#                   <tt>$3</tt>.  The remaining arguments are to be defined 
#                   based on the type:
#                   <ul>
#                       <li>
#                           'lib' $1 $2 $3 $4 $5, where <tt>$4</tt> are CFLAGS, 
#                           and <tt>$5</tt> LDFLAGS for the library (both 
#                           optional).  By default the flags are determined 
#                           by the library name.
#                       </li>
#                       <li> 'featx' $1 $2 $3 $4, where <tt>$4</tt> (optional)
#                            is the name of the variables to be defined
#                            containing feature availability and path (for
#                            example "FOO" would yield variables "HAVE_FOO = 1"
#                            and "PATH_FOO = /path/to/foo").
#                       </li>
#                   <ul>
#
#    @param $1  enabled by default (1) or disabled by default (0)
#    @param $2  dependency type
#    @param $3  dependency id
#    @param $@  args
#*/
makl_optional ()
{
    _makl_req 0 "$1" "$2" "$3" "$4" "$5"
}

#/*! @function      makl_depend
#
#    @abstract      Create a dependency between dependencies.
#    @discussion    Create a dependency between dependencies.  Such behaviour 
#                   is type-specific.  For libraries this will append 
#                   <tt>$3</tt>'s CFLAGS and LDFLAGS to <tt>$1</tt>'s.
#
#    @param $1  dependency type
#    @param $2  dependency id
#    @param $3  dependency target
#*/
makl_depend ()
{
    file="${makl_run_dir}"/deps_"$1"

    makl_info "adding $1 dependency ($2->$3)"

    makl_tab_get "${file}" "$2" 1
    [ $? = 0 ] || makl_err 2 "invalid source dependency: $2"
    
    makl_tab_get "${file}" "$3" 1
    [ $? = 0 ] || makl_err 2 "invalid target dependency: $3"

    case "$1" in 
        lib)
            makl_tab_set "${file}" "$2" 5 "$3"
        ;;
        *)
            makl_err 2 "dependency behaviour not implemented for type: $1"
        ;;
    esac
}

#/*! @function      _makl_search_lib
#
#    @abstract      INTERNAL.  Search for dynamic library in default 
#                   directories or specified.
#    @discussion    Search for dynamic library <tt>$1</tt> in default 
#                   directories (as defined in etc/args.cf).  Compilation is
#                   tested with CFLAGS <tt>$2</tt> and LDFLAGS <tt>$3</tt>.
#
#    @param $1  required lib  
#    @param $2  cflags
#    @param $3  ldflags
#
#    @return    0 on success, 1 on lib not found.
#*/
_makl_search_lib ()
{
    req=$1
    cflags=$2
    ldflags=$3
    f_args="${makl_run_dir}"/args
    f_args_lib="${makl_run_dir}"/args_lib

    # get feature argument defaults
    dft=`makl_tab_get "${f_args}" "lib" 3`

    # get specific options
    path=`makl_tab_get "${f_args_lib}" "${req}" 2`
    libdir=`makl_tab_get "${f_args_lib}" "${req}" 4`

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
        dirs=`"${ECHO}" "${val}" | "${SED}" 's/:/ /g'`
    else
        dirs="${path}"
    fi

    for dir in ${dirs}; do
        makl_libdep "${req}" "${dir}" "${cflags}" "${ldflags}" "${libdir}"
        [ $? -eq 0 ] && return 0
    done 

    return 1
}

#/*! @function      _makl_search_featx
#
#    @abstract      INTERNAL.  Search for an executable feature.
#    @discussion    Search for executable feature <tt>$1</tt> in default 
#                   directories (as defined in etc/args.cf).  It is assumed 
#                   that the id corresponds to the filename of the executable 
#                   file.
#
#    @param $1  feature id
#
#    @return    0 on success, 1 on lib not found.
#*/
_makl_search_featx ()
{
    f_args="${makl_run_dir}"/args
    f_args_x="${makl_run_dir}"/args_featx
    f_deps_x="${makl_run_dir}"/deps_featx

    # get feature argument defaults
    dft=`makl_tab_get ${f_args} "featx" 3`

    # get specific options
    path=`makl_tab_get ${f_args_x} $1 2`

    # get dependency values
    varname=`makl_tab_get ${f_deps_x} $1 3`
    [ -z ${varname} ] && varname=$1

    if [ "${path}" ]; then
        # check path given as argument
        if [ -x "${path}" ]; then
            makl_set_var "HAVE_"`makl_upper ${varname}`
            makl_set_var "PATH_"`makl_upper ${varname}` "${path}" 1
            return 0
        fi
    else
        # get paths defined by BASE
        val=`makl_tab_var "${dft}" "BASE"` 
        dirs=`"${ECHO}" ${val} | "${SED}" 's/:/ /g'`

        # search for executable file
        for dir in ${dirs}; do
            if [ -x "${dir}/$1" ]; then
                makl_set_var "HAVE_"`makl_upper ${varname}`
                makl_set_var "PATH_"`makl_upper ${varname}` ${dir}/$1 1
                return 0
            fi
        done 
    fi

    # error if we reach this
    makl_unset_var "HAVE_"`makl_upper $1`
    return 1
}

#/*! @function      _makl_require_check
#
#    @abstract      INTERNAL.  Check that dependencies of a given type have 
#                   been fulfilled.
#
#    @param $1  dependency type (lib or featx)
#*/
_makl_require_check ()
{
    f_req="${makl_run_dir}"/deps_"$1"
    f_have="${makl_run_dir}"/deps_"$1".found

    [ ! -r "${f_req}" ] && return 0
    [ -r "${f_have}" ] || "${TOUCH}" "${f_have}"

    "${RM}" -f "${makl_run_dir}"/err

    "${CAT}" "${f_req}" | {
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
                    "${ECHO}" -n ${_dep} > "${makl_run_dir}"/err
                    break
                else
                    if [ "${_req}" = "01" ]; then
                        "${ECHO}" -n ${_dep} > "${makl_run_dir}"/warn
                    fi
                fi
            fi
        done
    }

    if [ -r "${makl_run_dir}/err" ]; then
        makl_err 3 "unfulfilled dependency: '`"${CAT}" ${makl_run_dir}/err`'!"
        "${RM}" "${makl_run_dir}"/err
    fi  
    if [ -r "${makl_run_dir}/warn" ]; then
        makl_warn "could not find optional dependency '`"${CAT}" ${makl_run_dir}/warn`'"
        "${RM}" "${makl_run_dir}"/warn
    fi
}

#/*! @function      makl_lib_testcode
#
#    @abstract      Set the test code for a library.
#    @discussion    Set the test code for library <tt>$1</tt>.  Data is read 
#                   from standard input.
#
#    @param $1  library id
#*/
makl_lib_testcode ()
{
    file="${makl_run_dir}"/lib_testcode_"$1".c

    # create a clean file
    [ -r "${file}" ] && "${RM}" -f "${file}"

    while read line; do
        "${ECHO}" "${line}" >> "${file}"
    done
}

#/*! @function      _makl_deps_check
#
#    @abstract      INTERNAL.  Check dependencies.
#    @discussion    This function is called on termination to check 
#                   dependencies and generate appropriate variables.
#*/
_makl_deps_check ()
{
    [ -z `makl_get "__noconfig__"` ] || return
    makl_info "checking dependencies"
    _makl_require_check "lib"
    _makl_require_check "featx"
}
