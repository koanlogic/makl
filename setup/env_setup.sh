#!/bin/sh

[ $# -lt 4 ] && exit 1

__makl_dir=$1
__makl_version=$2
__login_shell=$3
__maklrc=$4

__available_shells="bash|sh|zsh|ksh|csh|tcsh"

## $1 makl_dir
## $2 makl_version
## $3 maklrc
function output_sh_compat ()
{
    echo "MAKL_VERSION=\"$2\""       > $3
    echo "export MAKL_VERSION"      >> $3
    echo ""                         >> $3
    echo "MAKL_DIR=\"$1\""          >> $3
    echo "export MAKL_DIR"          >> $3
    echo ""                         >> $3
    echo "MAKEFLAGS=\"-I $1/mk\""   >> $3
    echo "export MAKEFLAGS"         >> $3
}

## $1 makl_dir
## $2 makl_version
## $3 maklrc
function output_csh_compat ()
{
    echo "setenv MAKL_VERSION \"$2\""       > $3
    echo ""                                 >> $3
    echo "setenv MAKL_DIR \"$1\""           >> $3
    echo ""                                 >> $3
    echo "setenv MAKEFLAGS \"-I $1/mk\""    >> $3
}

function validate_shell ()
{
    local ans

    # stdin must be associated with the terminal
    [ ! -t 0 ] && return

    echo -n "Pick up a shell [$__login_shell]: "

    while read -p "$*" -e ans 
    do
        ans="`echo $ans | tr '[A-Z]' '[a-z]'`"

        case "${ans}" in
            ksh | bash | zsh | sh | csh | tcsh ) 
                __login_shell=${ans}
                return
                ;;
            "")
                # default
                return
                ;; 
            *) 
                echo "Choices are: $__available_shells" 1>&2 
                ;;
       esac
   done
}

function pickup_envfile ()
{
    local ans

    # stdin must be associated with the terminal
    [ ! -t 0 ] && return

    echo -n "Pick a suitable environment file [$__maklrc]: "

    while read -p "$*" -e ans 
    do
        case "${ans}" in
            "")
                # default
                return
                ;; 
            *) 
                __maklrc=${ans}
                return
                ;;
        esac
    done
}

validate_shell
pickup_envfile
[ -e ${__maklrc} ] && echo "warning: overriding an existing file"
touch ${__maklrc}
[ $? -ne 0 ] && exit 1

case ${__login_shell}
in
    csh | tcsh )
        __shell_compat="cshcompat"
        output_csh_compat $__makl_dir $__makl_version $__maklrc
        ;;
    *)
        __shell_compat="shcompat" 
        output_sh_compat $__makl_dir $__makl_version $__maklrc
        ;;
esac


