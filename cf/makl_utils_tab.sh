#
# $Id: makl_utils_tab.sh,v 1.11 2010/05/26 20:23:23 tho Exp $
#

#/*! 
#    @header    Tabs    Tabs handling routines
#*/

#/*! @function      makl_tab_find
#
#    @abstract      Find an identifier.
#    @discussion    Check whether id <tt>$2</tt> exists in table <tt>$1</tt>.
#
#    @param $1  table file
#    @param $2  id to be searched for
#
#    @return    0 if found, 1 otherwise.
#*/
makl_tab_find ()
{
    [ -r "$1" ] || return 1

    "${GREP}" "^$2|" "$1" > /dev/null

    return $?
}

#/*! @function      makl_tab_set
#
#    @abstract      Set the value of an element corresponding to an identifier.
#    @discussion    Set variable entry in table <tt>$1</tt> with id <tt>$2</tt>
#                   and at column <tt>$3</tt> to val <tt>$4</tt>.
#
#    @param $1  table file 
#    @param $2  id (row)
#    @param $3  column number
#    @param $@  value
#
#    @return    0 on success, 1 on failure
#*/
makl_tab_set ()
{ 
    tab="$1"
    id="$2"
    col=$3
    shift; shift; shift
    val="$@"

    # sanitize input parameters:
    # we need at least a table name, a row id and some suitable column
    # index to go further
    [ -n "${tab}" ] || return 1
    [ -n "${id}" ] || return 1
    [ ${col} -ge 0 ] || return 1

    # create table if it doesn't exist
    [ -e "${tab}" ] || "${TOUCH}" "${tab}"
    [ $? -eq 0 ] || return 1

    # table must be writeable
    [ -w "${tab}" ] || return 1

    # create row if it doesn't exist so that insert and replace ops
    # are treated the same way by awk
    "${GREP}" "^${id}|" "${tab}" > /dev/null || \
        "${ECHO}" "${id}||||||||||||||||" >> "${tab}"

    # escape initial and terminating '"' from "-surrounded ${val}'s, which 
    # would otherwise cause a 'division by zero' error in awk
    e_val="`"${ECHO}" ${val} | \
        "${SED}" -e 's/^\"/\\\\\"/' -e 's/\"$/\\\\\"/'`"
    [ $? -eq 0 ] || return 1

    # replace column
    "${AWK}" -F'|'                              \
        '{                                      \
            OFS=FS;                             \
            if ( $1 == "'"${id}"'" )            \
            {                                   \
                $'"${col}"'="'"${e_val}"'" ;    \
                print                           \
            }                                   \
            else                                \
                print                           \
        }' "${tab}" >> "${tab}".tmp
    [ $? -eq 0 ] || return 1

    # commit changes to master table
    "${MV}" "${tab}".tmp "${tab}"
    [ $? -eq 0 ] || return 1

    return 0    
}

#/*! @function      makl_tab_set_row
#
#    @abstract      Set row to given arguments.
#    @discussion    Set row of table <tt>$1</tt> to given arguments <tt>$@</tt>.
#
#    @param $1  table file 
#    @param $@  row values
#*/
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

    "${ECHO}" "${line}" >> "${file}"
}

#/*! @function      makl_tab_get
#
#    @abstract      Get a column value given an identifier.
#    @discussion    Get column <tt>$3</tt> of element with id <tt>$2</tt> in 
#                   file <tt>$1</tt>.
#
#    @param $1  table file 
#    @param $2  identifier to be retrieved
#    @param $3  target column
#
#    @return    0 if the element was found, 1 otherwise.
#*/
makl_tab_get ()
{
    tab="$1"
    id="$2"
    col=$3

    # sanitize input parameters
    [ -n "${tab}" ] || return 1
    [ -n "${id}" ] || return 1
    [ ${col} -ge 0 ] || return 1

    # table must be readable
    [ -r "${tab}" ] || return 1

    "${AWK}" -F'|' '                            \
            BEGIN { rc=1 }                      \
            {                                   \
                if ( $1 == "'"${id}"'" )        \
                {                               \
                    printf("%s", $'"${col}"');  \
                    rc=0                        \
                }                               \
            }                                   \
            END { exit rc }                     \
        ' "${tab}"

    return $?
}

#/*! @function      makl_tab_elem
#
#    @abstract      Output an element at an index of a row. 
#    @discussion    Output element at index <tt>$2</tt> of row <tt>$1</tt>.
#
#    @param $1  string of elements
#    @param $2  index of element
#*/
makl_tab_elem ()
{
    "${ECHO}" "$1" | "${CUT}" -s -f "$2" -d "|"
}

#/*! @function      makl_tab_var
#
#    @abstract      Get variable by name given a list of variables.
#    @discussion    Get variable by name <tt>$2</tt> given a list of variables 
#                   <tt>$1</tt>.  A semicolon is used as a list separator.
#
#    @param $1  input string
#    @param $2  required var
#
#    @return    0 if the variable was found, 1 otherwise.
#*/
makl_tab_var ()
{
    i=1
    found=0

    while : ; do
        elem=`"${ECHO}" $1 | "${CUT}" -f ${i} -d ";"`
        delim=`"${ECHO}" $1 | "${CUT}" -s -f ${i} -d ";"`
        [ -z "${elem}" ] && break
        var=`"${ECHO}" "${elem}" | "${CUT}" -f 1 -d "="`
        val=`"${ECHO}" "${elem}" | "${CUT}" -f 2 -d "="`
        if [ "${var}" = "$2" ] || [ -z "${delim}" ]; then
            found=1
            "${ECHO}" "${val}"
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
