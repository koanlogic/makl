# $Id: subdir.mk,v 1.9 2006/11/06 09:16:35 tho Exp $
#
# Variables:
# - SUBDIR      A list of subdirectories that should be built as well.
#               Each of the targets will execute the same target in the
#               subdirectories.
#
# Applicable Targets:
# - any target

all $(MAKECMDGOALS):
	@for dir in $(SUBDIR) ; do \
	    $(MAKE) -C $$dir $(MAKECMDGOALS) ; \
        [ $$? = 0 ] || exit $$? ; \
	done
