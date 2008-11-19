#
# $Id: makl_code.sh,v 1.12 2008/11/19 11:44:19 stewy Exp $
#

##\brief Compile a C file.
##
##  Compile a C file \e $1 with the supplied flags \e $2.
## 
##   \param $1 Pathname of the C file to be compiled 
##   \param $2 flags to be passed to the compiler
##   \return 0 on success, 1 on failure
##
makl_compile ()
{
    c_file="$1"
    shift
    cc_flags=$*
    cc_cmd="${CC} ${CFLAGS} -o out `basename ${c_file}` ${cc_flags} ${LDFLAGS}"

    [ -z "${c_file}" ] && return 1

    # XXX don't check cp return code here since internal tests
    # have makl_code.c already in place
    "${CP}" "${c_file}" "${makl_run_dir}" 2>/dev/null

    if [ -n "`makl_get "__verbose__"`" ]; then
        "${ECHO}" "makl_compile ${c_file}"
        "${ECHO}" "- - - - - - - - - - - - - - - - - - - -"
        "${CAT}" "${c_file}"
        "${ECHO}" "- - - - - - - - - - - - - - - - - - - -"
        "${ECHO}" "$ ${cc_cmd}"
        ( cd "${makl_run_dir}" && ${cc_cmd} )
    else 
        ( cd "${makl_run_dir}" && ${cc_cmd} ) 2>/dev/null
    fi

    if [ $? -ne 0 ]; then
        makl_info "compilation failed"
        return 1
    fi 

    return 0
}

##\brief Write to a C file. 
##
##  Write to a C file. Data is read from standard input.
## 
##   \param $1 name of file to be written
##   \param $2 whether the code is a snippet (1) or entire C file (0)
##   \param $3 file containing code
##
makl_write_c ()
{
    # create a clean file
    [ -r "$1" ] && "${RM}" -f "$1"

    if [ $2 -eq 1 ]; then
        "${ECHO}" "int main() {" >> "$1"
    fi
    
    "${CAT}" "$3" >> "$1"
    
    if [ $2 -eq 1 ]; then
        {
        "${ECHO}" "    return 0;"
        "${ECHO}" "}"
        } >> "$1"
    fi
    
    return 0
}

##\brief Compile C code.
##
##  Compile C code.
##
##   \param $1 whether the code is a snippet (1) or entire C file (0)
##   \param $2 file containing code 
##   \param $3 flags to be passed to the compiler
##
makl_compile_code ()
{
    file="${makl_run_dir}"/makl_code.c

    makl_write_c "${file}" $1 "$2"

    makl_compile "${file}" "$3"
    [ $? -eq 0 ] || return 1

    return 0
}

##\brief Execute C code.
##
##  Execute C code.
##
##   \param $1 whether the code is a snippet (1) or entire C file (0)
##   \param $2 file containing code
##   \param $3 flags to be passed to the compiler
## 
makl_exec_code ()
{
    file="${makl_run_dir}"/makl_code.c
    cwd=`pwd`
    
    makl_write_c "${file}" $1 $2
    makl_compile "${file}" $3 
    [ $? -eq 0 ] || return 1

    # skip execution on cross-compilation
    [ -z `makl_get "__cross_compile__"` ] || return 0

    cd "${makl_run_dir}" && eval ./out > /dev/null 2> /dev/null
    if [ $? -ne 0 ]; then 
        cd "${cwd}"
        return 2
    fi

    cd "${cwd}"
    return 0
}

##\brief Check resolution of a symbol
##
##  Define HAVE_$1 if symbol \e $1 can be resolved.
##  \e $1 determines whether the feature is optional or required.
##
##   \param $1 0:optional/1:required
##   \param $2 function name
##   \param $3 flags to be passed to the compiler
##
makl_checkresolv ()
{
    opt="$1"
    id="$2"
    flags="$3"
    shift; shift; shift

    tmpfile="${makl_run_dir}"/snippet.c
    "${RM}" -f "${tmpfile}"

    [ -z `makl_get "__noconfig__"` ] || return

    makl_info "checking symbol resolution: ${id}"

    for arg in $* ; do
        "${ECHO}" "#include ${arg}" >> "${tmpfile}"
    done
    "${CAT}" << EOF >> "${tmpfile}"
typedef void (*f_t)(void);
int main() {
    f_t fn = (f_t)${id};
    return 0;
}
EOF
   
    makl_compile_code 0 "${tmpfile}" "${flags}"

    if [ $? -eq 0 ]; then
        makl_set_var "HAVE_"`makl_upper ${id}`
        return 0
    else
        [ ${opt} -eq 0 ] || makl_err 1 "failed check on required symbol ${id}!"
        makl_warn "failed check on optional symbol ${id}"
        makl_unset_var "HAVE_"`makl_upper ${id}`
        return 1
    fi
}

##\brief Check existence of a function.
##
##  Define HAVE_$1 if function \e $1 is found.
##  \e $1 determines whether the feature is optional or required.
##
##   \param $1 0:optional/1:required
##   \param $2 function name
##   \param $3 number of arguments 
##   \param $4 flags to be pas"${SED}" to the compiler
##   \param $* header files (optional)
##
makl_checkfunc ()
{
    opt="$1"
    id="$2"
    nargs=$3
    flags="$4"
    shift; shift; shift ; shift

    makl_info "checking existence of function: ${id}"
 
    tmpfile="${makl_run_dir}"/snippet.c
    "${RM}" -f "${tmpfile}"

    [ -z `makl_get "__noconfig__"` ] || return

    for arg in $* ; do
        "${ECHO}" "#include ${arg}" >> "${tmpfile}"
    done

    {
        "${ECHO}"    "int main() {"
        "${ECHO}" -n "    ${id}("
        i=0
        if [ ${nargs} ]; then
            while [ ${i} -lt ${nargs} ]; do
                last=`expr ${nargs} - 1`
                "${ECHO}" -n "0"
                if [ ${i} -ne ${last} ]; then
                    "${ECHO}" -n ","
                fi
                i=`expr ${i} + 1`  # avoid bash-ism: "i=$((${i}+1))"
            done
        fi
        "${ECHO}" ");"
        "${ECHO}"    "    return 0;"
        "${ECHO}"    "}"
    } >> "${tmpfile}"
   
    makl_compile_code 0 "${tmpfile}" "${flags}"

    if [ $? -eq 0 ]; then
        makl_set_var "HAVE_"`makl_upper ${id}`
        return 0
    else
        [ ${opt} -eq 0 ] || makl_err 1 "failed check on required function ${id}!"
        makl_warn "failed check on optional function ${id}"
        makl_unset_var "HAVE_"`makl_upper ${id}`
        return 1
    fi
}

##\brief Check existence of a header.
##
##  Define HAVE_$2 if header \e $3 is found.
##  \e $1 determines whether the feature is optional or required.
##
##  \param $1 0:optional,1:required
##  \param $2 id of header
##  \param $3 header file
##  \param $* header files to include first
##
makl_checkheader ()
{
    [ -z `makl_get "__noconfig__"` ] || return

    opt=$1
    id=$2
    header=$3
    shift; shift; shift;
    tmpfile="${makl_run_dir}"/snippet.c
    "${RM}" -f "${tmpfile}"

    makl_info "checking for header ${id}"

    for arg in $* ; do
        "${ECHO}" "#include ${arg}" >> "${tmpfile}"
    done
    "${CAT}" << EOF >> "${tmpfile}"
#include ${header}
int main() { return 0; }
EOF
    
    makl_compile_code 0 "${tmpfile}"

    if [ $? -eq 0 ]; then
        makl_set_var "HAVE_"`makl_upper ${id}`
        return 0
    else
        [ ${opt} -eq 0 ] || makl_err 1 "failed check on required header ${id}!"
        makl_unset_var "HAVE_"`makl_upper ${id}`
        makl_warn "failed check on optional header ${id}"
        return 1
    fi
}

##\brief Check existence of a type.
##
##  Define HAVE_$1 if type \e $2 is found. 
##  \e $1 determines whether the feature is optional or required.
##  Extra includes can be listed in \e $*.
## 
##  \param $1 0:optional,1:required
##  \param $2 data type
##  \param $* includes
##
makl_checktype ()
{
    [ -z `makl_get "__noconfig__"` ] || return

    makl_info "checking for type $2"

    opt=$1
    type="$2"
    shift
    shift
    tmpfile="${makl_run_dir}"/snippet.c
    "${RM}" -f "${tmpfile}"

    # substitute whitespace with underscores 
    def_type=`"${ECHO}" "${type}" | "${SED}" 's/\ /_/g'`

    for arg in $*; do
        "${ECHO}" "#include ${arg}" >> "${tmpfile}"
    done
    # on some systems (e.g. VxWorks) type checks are not picked up correctly
    # by the compiler, so force a check using sizeof() */
    "${CAT}" << EOF >> "${tmpfile}"
int main() {
    ${type} x;
    return (sizeof(${type}) && 0);
}
EOF
    makl_compile_code 0 "${tmpfile}"

    if [ $? -eq 0 ]; then
        makl_set_var "HAVE_"`makl_upper ${def_type}`
        return 0
    else
        [ ${opt} -eq 0 ] || makl_err 1 "failed check on required type ${type}!"
        makl_unset_var "HAVE_"`makl_upper ${def_type}`
        makl_warn "failed check on optional type $2"
        return 1
    fi
}

##\brief Check existence of an extern variable.
##
##  Define HAVE_$1 if the extern variable \e $2 is found. 
##  \e $1 determines whether the feature is optional or required.
## 
##  \param $1 0:optional,1:required
##  \param $2 extern variables
##  \param $* optional compilation flags
##
makl_checkextern()
{
    [ -z `makl_get "__noconfig__"` ] || return

    makl_info "checking for extern variable $2"

    opt=$1
    var=$2
    shift
    shift
    tmpfile="${makl_run_dir}"/snippet.c

    # this fails when the linker doesn't find the variable in any linked
    # libraries
    "${CAT}" << EOF > "${tmpfile}"
extern void* ${var};
int main()
{
    return (int) & ${var};
}
EOF
  
    makl_compile_code 0 "${tmpfile}" $*

    if [ $? -eq 0 ]; then
        makl_set_var "HAVE_"`makl_upper ${var}`
        return 0
    else
        [ ${opt} -eq 0 ] || \
            makl_err 1 "failed check on required extern variable ${var}!"
        makl_unset_var "HAVE_"`makl_upper ${var}`
        makl_warn "failed check on optional extern variable $2"
        return 1
    fi
}

##\brief Check existence of a symbol
##
##  Define HAVE_$2 if the symbol \e $2 is found. 
##  \e $1 determines whether the feature is optional or required.
##   
##  The symbol may be an external variable, function or a #define.
##   
##  \param $1 0:optional,1:required
##  \param $2 symbol
##  \param $* header files
##
makl_checksymbol()
{
    [ -z `makl_get "__noconfig__"` ] || return

    makl_info "checking for symbol $2"

    opt=$1
    var=$2
    shift
    shift
    tmpfile="${makl_run_dir}"/snippet.c
    "${RM}" -f "${tmpfile}"

    for arg in $*; do
        "${ECHO}" "#include ${arg}" >> "${tmpfile}"
    done
    # this fails if the symbol is not defined (no #define, no variable, 
    # no function)
    "${CAT}" << EOF >> "${tmpfile}"
#ifdef ${var}
int main() { return 0; }
#else
int main()
{
    void *p = (void*)(${var});
    return 0;
}
#endif
EOF
    
    makl_compile_code 0 "${tmpfile}"

    if [ $? -eq 0 ]; then
        makl_set_var "HAVE_"`makl_upper ${var}`
        return 0
    else
        [ ${opt} -eq 0 ] || makl_err 1 "failed check on required symbol ${var}!"
        makl_unset_var "HAVE_"`makl_upper ${var}`
        makl_warn "failed check on optional symbol ${var}"
        return 1
    fi
}

##\brief Check existence of an element in a struct
##
##  Define HAVE_$2_$3 if the element \e $3 exists in the struct \e $2
##  \e $1 determines whether the feature is optional or required.
##   
##  \param $1 0:optional,1:required
##  \param $2 type
##  \param $3 elem
##  \param $* header files
##
makl_checkstructelem()
{
    [ -z `makl_get "__noconfig__"` ] || return

    opt=$1
    type=$2
    elem=$3
    shift; shift; shift
    tmpfile="${makl_run_dir}"/snippet.c
    "${RM}" -f "${tmpfile}"

    def_type=`"${ECHO}" ${type} | "${SED}" 's/\ /_/g'`

    makl_info "checking for ${elem} in ${type}"

    for arg in $*; do
        "${ECHO}" "#include ${arg}" >> "${tmpfile}"
    done
    # this fails if elem is not a field of the supplied type
    "${CAT}" << EOF >> "${tmpfile}"
${type} _a_;
int main()
{
    void *_p_ = (void*)(&(_a_.${elem}));
    return 0;
}
EOF

    makl_compile_code 0 "${tmpfile}"

    if [ $? -eq 0 ]; then
        makl_set_var "HAVE_"`makl_upper ${def_type}_${elem}`
        return 0
    else
        [ ${opt} -eq 0 ] || \
            makl_err 1 "failed check on required struct elem ${elem}!"
        makl_unset_var "HAVE_"`makl_upper ${def_type}_${elem}`
        makl_warn "failed check on optional struct elem ${elem}"
        return 1
    fi
}

