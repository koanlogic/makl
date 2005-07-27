# $Id: subdir.mk,v 1.3 2005/07/27 08:35:57 stewy Exp $
#
# Variables:
# - SUBDIR      A list of subdirectories that should be built as well.
#               Each of the targets will execute the same target in the
#               subdirectories.
#
# Applicable Targets:
# - all, clean, install, uninstall ...

all clean install uninstall depend cleandepend:
	@for dir in ${SUBDIR} ; do \
	    ${MAKE} -C $${dir} ${MAKECMDGOALS} ; \
        [ $$? = 0 ] || exit $$? ; \
	done
