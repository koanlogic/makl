#
# $Id: makl_utils_tab.sh,v 1.5 2008/11/10 21:18:13 tho Exp $
#


##\brief Find an identifier.
##
##  Check whether id \e $2 exists in table \e $1. 
##
##   \param $1 table file
##   \param $2 id to be searched for
##   \return 0 if found, 1 otherwise.
##
makl_tab_find ()
{
    [ -r "$1" ] || return 1

    "${GREP}" "^$2|" "$1" > /dev/null

    return $?
}

##\brief Set the value of an element corresponding to an identifier.
##
##  Set variable entry in table \e $1 with id \e $2 and at column 
##  \e $3 to val \e $4.
##
##   \param $1 table file 
##   \param $2 id (row)
##   \param $3 column number
##   \param $@ value
##
makl_tab_set ()
{ 
    tab="$1"; id="$2"; col=$3
    shift; shift; shift
    val="$@"
    line=""
    line_n=""
    l=""
    new=""
    i=1

    # create file if doesn't exist
    [ -e "${tab}" ] || "${TOUCH}" "${tab}"

    line=`"${GREP}" "^${id}|" "${tab}"`

    if [ $? -eq 0 ]; then     
       # subst the value

       # delete the old line
       "${GREP}" -v "^${id}|" "${tab}" > "${tab}".tmp
       "${MV}" "${tab}".tmp "${tab}"

    # ""-surrounded val would give 'division by zero' in awk
    __val="`"${ECHO}" ${val} | "${SED}" -e 's/^\"//' -e 's/\"$//'`"
    "${ECHO}" "${line}" | \
          "${AWK}" -F'|' '{ OFS=FS; $'"${col}"'="'"${__val}"'" ; print }' \
                >> "${tab}"
    else
        # add a new var
        line_n="${id}"

        n=1
        lim=`expr ${col} - 1`   # avoid bash-ism, was "lim=$((${col}-1))"

        while [ ${n} -lt ${lim} ]; do
            line_n="${line_n}|"
            n=`expr ${n} + 1`   # avoid bash-ism, was: "n=$((n+1))"
        done

        line_n="${line_n}|${val}|||||||||||"

        ${ECHO} "${line_n}" >> "${tab}"
    fi

    return 0    
}

##\brief Set row to given arguments.
##
##  Set row of table \e $1 to given arguments \e $@.
##
##   \param $1 table file
##   \param $@ row values
##
makl_tab_set_row ()
{
    line=""
    file="$1"
    i=1

    # create file if doesn't exist
    [ -e "$1" ] || "${TOUCH}" "$1"

    shift

    makl_tab_find "${file}" "$1"
    [ $? -eq 0 ] && return

    for arg in "$@"; do
        if [ ${i} -eq 1 ]; then
            line="${arg}"
        else
            [ -z "${arg}" ] && arg=" "
            line="${line}|${arg}"
        fi
        i=`expr ${i} + 1`   # avoid bash-ism, was: "i=$((${i}+1))"
    done

    ${ECHO} "${line}" >> "${file}"
}

##\brief Get a column value given an identifier.
##
##  Get column \e $3 of element with id \e $2 in file \e $1.
##
##   \param $1 table file 
##   \param $2 identifier to be retrieved
##   \param $3 target column
##   \return 0 if the element was found, 1 otherwise.
##
makl_tab_get ()
{
    [ -r "$1" ] || return 1

    found=`"${GREP}" "^$2|" "$1"`
    [ $? -eq 0 ] || return $? 

    val=`${ECHO} "${found}" | "${CUT}" -s -f $3 -d "|"`
    ret=$?

    ${ECHO} -n "${val}"
    return ${ret}
}

##\brief Output an element at an index of a row.
##
##  Output element at index \e $2 of row \e $1.
##
##   \param $1 string of elements
##   \param $2 index of element
##
makl_tab_elem ()
{
    ${ECHO} "$1" | "${CUT}" -s -f "$2" -d "|"
}

##\brief Get variable by name given a list of variables.
##
##  Get variable by name \e $2 given a list of variables \e $1.
##  A semicolon is used as a list separator.
##
##   \param $1 input string
##   \param $2 required var
##   \return 0 if the variable was found, 1 otherwise.
##
makl_tab_var ()
{
    i=1
    found=0

    while true; do
        elem=`${ECHO} $1 | "${CUT}" -f ${i} -d ";"`
        delim=`${ECHO} $1 | "${CUT}" -s -f ${i} -d ";"`
        [ -z "${elem}" ] && break
        var=`${ECHO} "${elem}" | "${CUT}" -f 1 -d "="`
        val=`${ECHO} "${elem}" | "${CUT}" -f 2 -d "="`
        if [ "${var}" = "$2" ] || [ -z "${delim}" ]; then
            found=1
            ${ECHO} "${val}"
            break
        fi
        # stop if we have no separator
        i=`expr ${i} + 1`   # avoid bash-ism, was: "i=$((${i}+1))"
    done

    if [ ${found} -eq 0 ]; then
        return 1
    else
        return 0
    fi
}
