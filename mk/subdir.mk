#
# $Id: subdir.mk,v 1.2 2005/07/26 08:24:19 tho Exp $
#
# Variables:
# - SUBDIR      A list of subdirectories that should be built as well.
#               Each of the targets will execute the same target in the
#               subdirectories.
#
# Applicable Targets:
# - all, clean, install, depend, cleandepend.

all clean install depend cleandepend:
	@for dir in ${SUBDIR} ; do \
        ${MAKE} -C $${dir} ${MAKECMDGOALS} ; \
done

# TODO stop on make failure.
