#!/bin/sh
#
# The full path of the MaKL installation directory is supplied as the sole 
# script argument.

err ()
{
    echo "$1"
    exit 1
}

[ $# -ne 1 ] && err "$0 <MaKL_install_dir>"

echo
echo "In order to use MaKL you need to set a couple of variable in your shell's"
echo "environment, one is for MaKL itself (MAKL_DIR), the other for GNU make"
echo "(MAKEFLAGS)."
echo
echo For C compatible shells do: 
echo "$" setenv MAKL_DIR \"$1\"
echo "$" setenv MAKEFLAGS \"-I $1/mk\"
echo
echo "or, in case you are using a Bourne compatible shell:"
echo "$" export MAKL_DIR=\"$1\"
echo "$" export MAKEFLAGS=\"-I $1/mk\"
echo
