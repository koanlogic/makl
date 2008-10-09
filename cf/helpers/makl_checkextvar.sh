#
# $Id: makl_checkextvar.sh,v 1.1 2008/10/09 09:48:47 stewy Exp $
#

##\brief Check if an extern variable is available
##
##  Define HAVE_$2 if the supplied extern variable is defined.
##
##  \e $1 determines whether the feature is optional or required.
##  \e $2 is the name of the extern variable to check
##
##   \param $1 0:optional/1:required
##   \param $2 variable name
##
makl_checkextvar ()
{
    tmpfile=${makl_run_dir}/snippet.c

    [ -z `makl_get "__noconfig__"` ] || return

    makl_info "checking for extern variable $2"

    ${ECHO} "
        extern void* $2;
        int main() {    
            void *_v = $2 ; 
            return 0;
        }
    " > ${tmpfile}

    makl_compile_code 0 ${tmpfile}

    if [ $? -eq 0 ]; then
        makl_set_var "HAVE_"`makl_upper $2` 
        return 0
    else
        [ $1 -eq 0 ] || makl_err 1 "failed extern var $2 check!"
        makl_unset_var "HAVE_"`makl_upper $2` 
        makl_warn "failed check on optional extern var $2 check"
        return 1
    fi
}

