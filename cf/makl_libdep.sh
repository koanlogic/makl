#
# $Id: makl_libdep.sh,v 1.8 2010/05/26 20:23:23 tho Exp $
#

#/*! @function      makl_compile
#
#    @abstract      Evaluate the library dependency.
#    @discussion    Evaluate a library dependency <tt>$1</tt>, given a base 
#                   directory <tt>$2</tt>, CFLAGS <tt>$3</tt>, LDFLAGS 
#                   <tt>$4</tt> and directory for lib search <tt>$5</tt>.
#                   If no flags are specified, the id is used as a library name
#                   for linking.
#                   On success, HAVE_<tt>$1</tt>, HAVE_<tt>$1</tt>_CFLAGS and 
#                   HAVE_<tt>$1</tt>_LDADD and/or HAVE_<tt>$1</tt>_LDFLAGS are 
#                   defined. (XXX check return code)
#
#    @param $1  library id
#    @param $2  base directory ("" if not specified)
#    @param $3  CFLAGS 
#    @param $4  LDFLAGS
#    @param $5  lib directory name
#
#    @return    0 on success, 1 (or 2) on failure
#*/
makl_libdep ()
{
    dep=$1
    dep_cap=`makl_upper ${dep}`
    base=$2
    cflags=$3
    ldflags=$4
    libdir=$5
    cwd=`pwd`
    tst="${makl_run_dir}/lib_testcode_${dep}.c"
    ldadd=${base}/${libdir}/lib${dep}.a
    f_deps="${makl_run_dir}"/deps_lib 

    if [ ! -r "${tst}" ]; then
        tst=`makl_get "__test_dir__"`/lib${dep}.c
        if [ ! -r "${tst}" ]; then
            makl_warn "makl_libdep: no test file for ${dep} (${tst})!" 
            return 2
        fi
    fi

    [ -z "${base}" ] || cflags="-I${base}/include ${cflags}" 
    [ -z "${base}" ] || ldflags="-L${base}/${libdir} ${ldflags}"

    if [ -r "${f_deps}" ]; then
        cflags_prog="${cflags}"
        ldflags_prog="${ldflags}"
        # append CFLAGS,LDFLAGS of dependency for test compilation 
        deps=`makl_tab_get "${f_deps}" "${dep}" 5`
        if [ "${deps}" ]; then
            for dep in "${deps}"; do
                depid=`makl_upper ${dep}`
                cflags_prog="${cflags_prog} `makl_get_var_mk LIB${depid}_CFLAGS`"
                ldflags_prog="${ldflags_prog} `makl_get_var_mk LIB${depid}_LDFLAGS`"
            done
        fi
    fi

    # compile and link the test program (static linkage)
    if [ -z `makl_get "__verbose__"` ]; then
        eval makl_compile ${tst} "${cflags_prog}" "${ldadd}" \
            1> /dev/null 2> /dev/null
    else 
        eval makl_compile ${tst} "${cflags_prog}" "${ldadd}"
    fi
    rc_s=$?

    # try also dynamic linkage
    if [ -z `makl_get "__verbose__"` ]; then
        eval makl_compile ${tst} "${cflags_prog}" "${ldflags_prog}" \
            1> /dev/null 2> /dev/null
    else 
        eval makl_compile ${tst} "${cflags_prog}" "${ldflags_prog}" 
    fi
    rc_d=$?

    # neither static nor dynamic linkage successful - fail
    if [ ${rc_s} -ne 0 -a ${rc_d} -ne 0 ]; then
        makl_unset_var "HAVE_LIB${dep_cap}"
        return 1
    fi

    # skip execution on cross-compilation
    if [ -z `makl_get "__cross_compile__"` ]; then
        cd "${makl_run_dir}" 

        case `makl_target_name` in
            *darwin*)
                eval DYLD_LIBRARY_PATH="${base}"/"${libdir}" ./out \
                    > /dev/null 2> /dev/null
                ;;
            *)
                eval LD_LIBRARY_PATH="${base}"/"${libdir}" ./out \
                    > /dev/null 2> /dev/null
                ;;
        esac

        if [ $? -ne 0 ]; then
            makl_dbg "Test file execution for lib${dep} failed!"
            cd ${cwd}
            makl_unset_var "HAVE_LIB${dep_cap}"
            return 2 
        fi
    fi

    # set LIB${dep_cap}_CFLAGS and LIB${dep_cap}_LDADD in Makefile.conf
    makl_set_var_mk "LIB${dep_cap}_CFLAGS" "${cflags}"
    if [ ${rc_s} -eq 0 ]; then
        makl_set_var_mk "LIB${dep_cap}_LDADD" "${ldadd}"
    fi
    if [ ${rc_d} -eq 0 ]; then
        makl_set_var_mk "LIB${dep_cap}_LDFLAGS" "${ldflags}"
    fi

    # set HAVE_LIB${dep_cap} in Makefile.conf and conf.h 
    makl_set_var "HAVE_LIB${dep_cap}"

    cd ${cwd}
    return 0
}
