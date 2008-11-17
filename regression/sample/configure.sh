#
# Source in MaKL functions and variables.
#
. "${MAKL_DIR}/cf/makl.init"

makl_info "installed MaKL version is: `makl_version`"

#
# Initialise command-line arguments.  
# This is the first call in the configure script after global initialisation.
#
makl_args_init "$@"

#
# Include user-defined command line arguments and handlers.
#
# Specifically, the mk_extra included file defines the '--extra-<xyz>=<...>"
# command line argument by which the values of any 'XYZ' variable can be 
# extended.
# E.g.:
#   $ makl-conf --extra-cflags="-W -Wall"
# will result in the following setting inside Makefile.conf:
#   CFLAGS += -W -Wall
#
. build/mk_extra

#
# Set package name (needed by subsequent makl_pkg_version).
#
makl_pkg_name "makl_sample"

#
# Set package version.
# This is needed by '--enable_shared' handler for setting shared libraries 
# major/teeny/minor numbers.  Package version is read from the VERSION file
# which is expected to be found in the same directory as the configure script.
#
makl_pkg_version

#
# set HOST_OS variable to the host operating system.
# This is just to show combined use of 'makl_set_var' and 'makl_target_name' :)
# Note the 3rd argument: if supplied - any value, here '1' could be safely 
# replaced by any other non-void character string - the value is interpreted
# as a string (i.e. quoted in conf.h).
#
makl_set_var "HOST_OS" "`makl_target_name`" 1

#
# The following is used in order to avoid relative paths which may inhibit
# OBJDIR machinery operations.  It's good practice to set and use it even 
# if you don't need to handle cross compilations.  Note the '_mk' postfix
# which means that the setting is done into the Makefile.conf only.
#
makl_set_var_mk "SRCDIR" "`pwd`"

#
# Check available C types.
#
# A first argument '0' (i.e. false), means that availability is not mandatory.
# When set to '1', if the type is not available, an error occurs.
# The third (optional) arguments hints makl about where to search for the
# needed type.
#
# Expected output to conf.h is:
#   #define HAVE_<UPPERCASE_TYPE> 1
# in case type has been found,
#   #undef HAVE_<UPPERCASE_TYPE>
# otherwise.
#
# Expected output to Makefile.conf is:
#   HAVE_<UPPERCASE_TYPE> = 1
# in case type has been found, nothing otherwise.
#
makl_checktype 0 "long double"
makl_checktype 0 "long long"
makl_checktype 0 "bool"                "<stdbool.h>"
makl_checktype 0 "float complex"       "<complex.h>"
makl_checktype 0 "double complex"      "<complex.h>"
makl_checktype 0 "long double complex" "<complex.h>"
makl_checktype 0 "very unusual type"

#
# Check #define'd symbols.
#
# A first argument '0' (i.e. false), means that availability is not mandatory.
# When set to '1', if the symbol is not available, an error occurs.
# 2nd to nth (optional) arguments are for header files where to search for
# symbol definition.
#
# Expected output is the same as per 'makl_checktype', with the symbol name
# substituting the type name.
#
makl_checksymbol 0 "TCP_NODELAY" "<sys/types.h>" "<netinet/tcp.h>"
makl_checksymbol 0 "VERY_UNUSUAL_SYMBOL"

# 
# Check available functions.
#
# A first argument '0' (i.e. false), means that availability is not mandatory.
# When set to '1', if the function is not available, an error occurs.
# The third argument is for flags to be passed to the compiler ("" if none).
# Rest (optional) arguments [fourth -> nth] is for header files where the
# function is supposed to be declared.
#
# Expected output is the same as per 'makl_checktype', with the function 
# symbolic name (the 2nd argument) substituting the type name.
#
makl_checkfunc 0 "daemon"       "" "<stdlib.h>"
makl_checkfunc 0 "setsockopt"   "" "<sys/socket.h>"
makl_checkfunc 0 "getpid"       "" "<unistd.h>"
makl_checkfunc 0 "link"         "" "<unistd.h>"
makl_checkfunc 0 "unlink"       "" "<unistd.h>"
makl_checkfunc 0 "sleep"        "" "<unistd.h>"
makl_checkfunc 0 "mkstemps"     "" "<unistd.h>"
makl_checkfunc 0 "fnmatch"      "" "<fnmatch.h>"
makl_checkfunc 0 "strtok_r"     "" "<string.h>"
makl_checkfunc 0 "strsep"       "" "<string.h>"
makl_checkfunc 0 "strlcpy"      "" "<string.h>"
makl_checkfunc 0 "strlcat"      "" "<string.h>"
makl_checkfunc 0 "gettimeofday" "" "<sys/time.h>"
makl_checkfunc 0 "timegm"       "" "<time.h>"
makl_checkfunc 0 "syslog"       "" "<syslog.h>"
makl_checkfunc 0 "strange_foo"  ""

#
# Check for strerror() availability and flavour.
#
# Define HAVE_STRERROR_R if strerror_r() is found, and STRERROR_R_CHAR_P
# if it returns a char pointer (e.g. GNU libc on Linux) instead of an int 
# (POSIX).
#
makl_func_strerror_r 0

#
# Check available header files.
#
# A first argument '0' (i.e. false), means that availability is not mandatory.
# When set to '1', if the header is not available, an error occurs.
# The 3rd argument is for header file name, while 4th to nth (optional)
# arguments are used in the generated C test file in order to close possible
# cross-references.
#
# Expected output is the same as per 'makl_checktype', with the header symbolic
# name (the 2nd argument) substituting the type name.
#
makl_checkheader 0 "sysuio" "<sys/uio.h>" "<sys/types.h>"
makl_checkheader 0 "paths"  "<paths.h>"
makl_checkheader 0 "stdlib" "<stdlib.h>"

#
# Handle user input.
#
makl_args_handle "$@"

# 
# Close pending tasks.
#
. "${MAKL_DIR}/cf/makl.term"

#
# Save per-project MAKEFLAGS, needed to locate included Makefiles' when OBJDIR 
# is in use.
#
echo "MAKL_MAKEFLAGS=\"-I `pwd`\"" > makl.conf

echo
echo "MaKL autoconfiguration ended."
echo
echo "Please take the time to look into the following two files"
echo "  C/C++ header file: '${makl_conf_h}'"
echo "  and GNU/P make file: '${makl_makefile_conf}'"
echo
