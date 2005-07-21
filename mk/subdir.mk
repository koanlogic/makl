# $Id: subdir.mk,v 1.1.1.1 2005/07/21 18:00:01 tat Exp $
#
# Variables:
# - SUBDIR      A list of subdirectories that should be built as well.
#               Each of the targets will execute the same target in the
#               subdirectories.
#
# Applicable Targets:
# - all, clean, install, ...

all clean install depend cleandepend:
	@for dir in ${SUBDIR} ; do \
	    ${MAKE} -C $${dir} ${MAKECMDGOALS} ; \
	done
