#
# $Id: makl_checktmzone.sh,v 1.3 2008/11/07 16:16:07 stewy Exp $
#

##\brief Check if tm_zone is defined into "struct tm"
##
##  Define HAVE_TMZONE if tm_zone variable exists in "sturct tm" 
##  \e $1 determines whether the feature is optional or required.
##
##   \param $1 0:optional/1:required
##
makl_checktmzone ()
{
    tmpfile="${makl_run_dir}"/snippet.c

    [ -z `makl_get "__noconfig__"` ] || return

    makl_info "checking for tm_zone support"

    cat << EOF > "${tmpfile}"
#include <time.h>

int main() {    
    struct tm tt;  
    tt.tm_zone = ""; 
    return 0;
}
EOF

    makl_compile_code 0 "${tmpfile}"

    if [ $? -eq 0 ]; then
        makl_set_var "HAVE_TMZONE"
        return 0
    else
        [ $1 -eq 0 ] || makl_err 1 "failed tm_zone check!"
        makl_unset_var "HAVE_TMZONE"
        makl_warn "failed check on optional tm_zone check"
        return 1
    fi
}

