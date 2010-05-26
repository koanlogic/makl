#
# $Id: makl_var.sh,v 1.5 2010/05/26 20:23:23 tho Exp $
#

#/*! 
#    @header    Variables   ...
#*/

#/*! @function      makl_set_var_h
#
#    @abstract      Set the value of a header variable.
#    @discussion    Set header variable <tt>$1</tt> to <tt>$2</tt>.  
#                   If <tt>$3</tt> is set, the value is to be interpreted
#                   as a string (default is constant).
#
#    @param $1  symbol to be set
#    @param $2  value of symbol (optional)
#    @param $3  whether the value is to be interpreted as a string
#*/
makl_set_var_h ()
{
    var="$1"
    val="$2"

    # if value is not defined, set to 1
    [ "${val}" ] || val="1"

    if [ "$3" ];  then                #string
        val="\"${val}\""
    else                            #constant
        val="${val}"
    fi

    makl_dbg "setting header variable $1 to ${val}"
    _makl_var_set "h" "$1" 1 "${val}"
}

#/*! @function      makl_set_var_mk
#
#    @abstract      Set the value of a makefile variable.
#    @discussion    Set makefile variable <tt>$1</tt> to <tt>$2</tt>.  
#
#    @param $1  symbol to be set
#    @param $2  value of symbol
#*/
makl_set_var_mk ()
{
    file="${makl_run_dir}"/vars_mk

    var=$1
    val=$2

    # if value is not defined, set to 1
    [ "${val}" ] || val="1"

    makl_dbg "setting makefile variable $1 to ${val}"
    _makl_var_set "mk" "$1" 1 "${val}"

    # flag the fact that variable has been set, which 
    # overrides any previous environment value
    makl_tab_set "${file}" "${var}" 4 1
}

#/*! @function      makl_add_var_mk
#
#    @abstract      Append a value to a makefile variable.
#    @discussion    Append <tt>$*</tt> to makefile variable <tt>$1</tt>.
#                   Equivalent to makl_append_var_mk.
#
#    @param $1  symbol to be set
#    @param $*  values to be added
#*/
makl_add_var_mk ()
{
    file="${makl_run_dir}"/vars_mk

    var=$1
    val=$2

    isset=`makl_tab_get "${file}" "${var}" 4`
    found=`env | "${GREP}" "^${var}="`

    val=`makl_get_var_mk "${var}"`

    # grab from environment if defined and not already set
    if [ $? -eq 0 -a ! "${isset}" = "1" ]; then
            val=`"${ECHO}" "${found}" | "${CUT}" -s -d= -f 2`" ${val}"
    fi

	shift

	for arg in "$@"; do
		val="${val} ${arg}"
	done

    makl_dbg "appending ${val} to makefile variable ${var}"
    _makl_var_set "mk" "${var}" 1 "${val}"
}

# Alias of makl_add_var_mk
makl_append_var_mk ()
{
    makl_add_var_mk $@
}

#/*! @function      makl_unset_var_h
#
#    @abstract      Unset the value of a header variable.
#    @discussion    Unset the value of header variable <tt>$1</tt>.
#
#    @param $1  symbol to unset
#*/
makl_unset_var_h ()
{
    makl_dbg "unsetting header variable $1"

    _makl_var_set "h" "$1" 0 
}

#/*! @function      makl_unset_var_mk
#
#    @abstract      Unset the value of a makefile variable.
#    @discussion    Unset the value of makefile variable <tt>$1</tt>.
#
#    @param $1  symbol to unset
#*/
makl_unset_var_mk ()
{
    makl_dbg "unsetting makefile variable $1"

    _makl_var_set "mk" "$1" 0
}

#/*! @function      makl_set_var
#
#    @abstract      Set a variable in both makefile and header.
#    @discussion    Set <tt>$1</tt> to <tt>$2</tt> in both makefile and header.
#
#    @param $1  symbol to set
#    @param $2  value of symbol
#    @param $3  whether the value is to be interpreted as a string
#*/
makl_set_var ()
{
    makl_set_var_mk "$1" "$2" 
    makl_set_var_h "$1" "$2" $3
}

#/*! @function      makl_unset_var
#
#    @abstract      Unset a variable in both makefile and header.
#    @discussion    Unset <tt>$1</tt> in both makefile and header.
#
#    @param $1  symbol to unset
#
#    @return    0 on success, 1 otherwise.
#*/
makl_unset_var ()
{
    if [ ! "$1" -o -z "$1" ]; then
        makl_warn "makl_unset_var called with no argument"
        return 1
    fi
   
    makl_unset_var_h  "$1"
    makl_unset_var_mk "$1"

    return 0
}


#/*! @function      makl_get_var_h
#
#    @abstract      Get the value of a header variable.
#    @discussion    Get the value of header variable <tt>$1</tt>.
#
#    @return    the value of the variable
#*/
makl_get_var_h ()
{
    _makl_var_get "h" "$1"

    return $?
}

#/*! @function      makl_get_var_mk
#
#    @abstract      Get the value of a makefile variable.
#    @discussion    Get the value of makefile variable <tt>$1</tt>.
#
#    @return    the value of the variable
#*/
makl_get_var_mk () 
{
    _makl_var_get "mk" "$1"

    return $?
}

#/*! @function      makl_set
#
#    @abstract      Set the value of an internal variable.
#    @discussion    Set the value of internal variable <tt>$1</tt> to 
#                   <tt>$2</tt>.
#
#    @param $1  name of variable
#    @param $2  value of variable
#*/
makl_set ()
{
    name="$1"
    shift
    _makl_var_set "cf" "${name}" 1 $@
}

#/*! @function      makl_append
#
#    @abstract      Append the value of an internal variable.
#    @discussion    Append <tt>$2</tt> to the value of internal variable 
#                   <tt>$1</tt>.
#
#    @param $1  name of variable
#    @param $2  value to be appended
#*/
makl_append ()
{
    val=`makl_get $1`
    makl_set "$1" "${val} $2"
}

#/*! @function      makl_unset
#
#    @abstract      Unset the value of an internal variable.
#    @discussion    Unset the value of internal variable <tt>$1</tt>.
#
#    @param $1  synmbol to unset
#*/
makl_unset ()
{
    _makl_var_set "cf" "$1" 0
}

#/*! @function      makl_get
#
#    @abstract      Get the value of an internal variable.
#    @discussion    Get the value of internal variable <tt>$1</tt>.
#
#    @param $1  name of the variable
#
#    @return    0 if element was found, 1 otherwise.
#*/
makl_get ()
{
    _makl_var_get "cf" "$1"

    return $?
}

#/*! @function      makl_vars_def
#
#    @abstract      Define a variable group.
#    @discussion    Define a group of variables (var=val) of type <tt>$1</tt>
#                   and with description <tt>$2</tt>.
#
#    @param $1  type of variable
#    @param $2  description
#*/
makl_vars_def ()
{
    file="${makl_run_dir}"/vars
    
    makl_tab_find "${file}" $1
    [ $? -eq 0 ] && return
    
    makl_tab_set_row "${file}" "$1" "$2"

    # create file to store instances of variable
    file="${file}_$1"
    "${TOUCH}" "${file}"
}

#/*! @function      _makl_var_set
#
#    @abstract      INTERNAL.  Set or unset a variable.
#    @discussion    Set or unset a variable of type <tt>$1</tt> and name 
#                   <tt>$2</tt> to <tt>$4</tt> as selected by <tt>$3</tt>.
#
#    @param $1  type
#    @param $2  variable name 
#    @param $3  1:set, 0:unset
#    @param $@  variable value
#*/
_makl_var_set ()
{
    
    file="${makl_run_dir}"/vars_"$1"; name="$2"; set=$3
    shift; shift; shift

    makl_tab_set "${file}" "${name}" 2 "${set}"
    makl_tab_set "${file}" "${name}" 3 "$@"
}

#/*! @function      _makl_var_get
#
#    @abstract      INTERNAL.  Get the value of a variable.
#    @discussion    Get the value of a variable of type <tt>$1</tt> and with 
#                   name <tt>$2</tt>.
#
#    @param $1  type of variable
#    @param $2  variable name 
#
#    @return    0 if the element was found, 1 otherwise.
#*/
_makl_var_get ()
{
    file="${makl_run_dir}"/vars_"$1"
    
    makl_tab_get "${file}" "$2" 3
    return $?
}
