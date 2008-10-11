#
# $Id: makl_checkinline.sh,v 1.1 2008/10/09 09:48:47 stewy Exp $
#

##\brief Check if 'inline' keyword is supported by the compiler
##
##  Define HAVE_INLINE if 'inline' keyword is supported.
##  \e $1 determines whether the feature is optional or required.
##
##   \param $1 0:optional/1:required
##
makl_checkinline ()
{
    tmpfile=${makl_run_dir}/snippet.c

    [ -z `makl_get "__noconfig__"` ] || return

    makl_info "checking for inline keyword support"

    {
        ${ECHO} "inline int _f(void) { return 0; }"
        ${ECHO} "int main() { return _f(); }"

    } > ${tmpfile}
    
    makl_compile_code 0 ${tmpfile}

    if [ $? -eq 0 ]; then
        makl_set_var "HAVE_INLINE"
        return 0
    else
        [ $1 -eq 0 ] || makl_err 1 "failed inline keyword check!"
        makl_unset_var "HAVE_INLINE"
        makl_warn "failed check on optional inline keyword support"
        return 1
    fi
}
