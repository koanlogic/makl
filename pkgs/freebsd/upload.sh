#!/bin/sh

# get version
v="`grep PORTVERSION Makefile | cut -d'=' -f2`"

# strip trailing/leading blanks
v=$(echo "$v" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

# build makl pkg name
makl_pkg="makl-$v.tbz"

# upload
scp $makl_pkg root@koanlogic.com:/var/www-anemic/www/download/makl/
