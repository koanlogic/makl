#
# $Id: makl_args.sh,v 1.4 2008/11/14 13:11:17 tho Exp $
#


##\brief Define a command line argument from multiple strings.
##
##  Define a command line argument from multiple strings.
##
##   \param $@ argument strings
##
makl_args_def ()
{
    file="${makl_run_dir}"/args

    makl_tab_set_row "${file}" "$@"
}

##\brief Add an argument instance with given arguments.
##
##  Add an argument instance with given arguments.
##
##   \param $1 argument id 
##   \param $2 argument value
##   \param $3 default value
##   \param $4 prefix
##   \param $5 arg description
## 
makl_args_add ()
{
    file="${makl_run_dir}"/args
    
    makl_tab_find "${file}" "$1" || makl_err 2 "Argument not defined: $1"
    makl_tab_set "${file}_$1" "$2" 2 "$3" 
    makl_tab_set "${file}_$1" "$2" 3 "$4"
    makl_tab_set "${file}_$1" "$2" 4 "$5"
}

##\brief Print out a command-line argument description.
##
##  Prints out a human-readable description of a command-line argument.
##
##   \param $1 id of the command-line argument
##   \param $2 parameters
##   \param $3 short description
##   \param $4 id of the argument (instance)
##   \param $5 default values (instance)
##   \param $6 prefix string (instance)
##   \param $7 short description (instance)
##
_makl_args_print () 
{
    a=`"${ECHO}" -n "$6  --$1$2" | 
        "${SED}" 's/X/'"$4"'/'`

    if [ -z "$7" ]; then
        b=`"${ECHO}" -n "$3" | 
            "${SED}" 's/X/'"$4"'/'`
    else
        b=`"${ECHO}" -n "$3" | 
            "${SED}" 's/X/'"$7"'/'`
    fi

    "${ECHO}" -n "${a}    ${b}"
    [ "$5" = " " ] || "${ECHO}" -n " [$5]"
    "${ECHO}"
}
