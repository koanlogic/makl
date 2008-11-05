. "${MAKL_DIR}/cf/makl.init"

makl_args_init "$@"

# include user-defined command line arguments and handlers
. build/mk_extra

# set package name (needed by makl_pkg_version)
makl_pkg_name "makl_sample"

# set package version (needed by --enable_shared handler)
makl_pkg_version

# the following is used in order to avoid relative paths which may inhibit
# OBJDIR machinery operations
makl_set_var_mk "SRCDIR" "`pwd`"

makl_args_handle "$@"

. "${MAKL_DIR}/cf/makl.term"

# save per-project MAKEFLAGS (also needed to locate included Makefiles'
# when OBJDIR is in use)
echo "MAKL_MAKEFLAGS=\"-I `pwd`\"" > makl.conf
