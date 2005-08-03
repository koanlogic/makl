# $Id: subdir.mk,v 1.4 2005/08/03 19:47:09 tho Exp $
#
# Variables:
# - SUBDIR      A list of subdirectories that should be built as well.
#               Each of the targets will execute the same target in the
#               subdirectories.
#
# Applicable Targets:
# - all, clean, install, uninstall, depend, cleandepend.

all clean install uninstall depend cleandepend:
	@for dir in ${SUBDIR} ; do \
	    ${MAKE} -C $${dir} ${MAKECMDGOALS} ; \
        [ $$? = 0 ] || exit $$? ; \
	done
