#
# $Id: makl_func_strerror_r.sh,v 1.4 2008/11/10 15:35:28 tho Exp $
#

#\brief Define HAVE_STRERROR_R if strerror_r() is found, and STRERROR_R_CHAR_P
#       if it returns a char pointer (e.g. default glibc default on Linux)
#       instead of an int.
#       $1 determines whether the feature is optional or required.
#   
#   \param $1 0:optional,1:required
#
makl_func_strerror_r ()
{
    tmpfile="${makl_run_dir}"/snippet.c

    [ -z `makl_get "__noconfig__"` ] || return

    makl_info "checking for function strerror_r"

    # test function compilation 
    "${CAT}" << EOF > "${tmpfile}"
    char buf[100];
    strerror_r(0, buf, sizeof(buf));
EOF
    
    makl_compile_code 1 "${tmpfile}"

    if [ $? -eq 0 ]; then

        makl_set_var_h "HAVE_STRERROR_R"
        
        # Determine whether strerror_r returns a char* or an int by forcing a
        # int return value with extern() and assuming that the return value will
        # be a non-null string in the first case and will always be 0 in the 
        # second case
        "${CAT}" << EOF > "${tmpfile}"
#include <sys/errno.h>

extern int strerror_r(); 

int main() {
    char buf[1024];
    return ((strerror_r(EACCES, buf, sizeof(buf)) == 0));
}
EOF

        makl_exec_code 0 "${tmpfile}"

        if [ $? -eq 0 ]; then
            makl_set_var_h "STRERROR_R_CHAR_P"
        fi

        return 0
    else
        [ $1 -eq 0 ] || makl_err 2 "failed check on required function strerror_r!"
        makl_warn "failed check on optional function strerror_r"
        return 1
    fi
}
