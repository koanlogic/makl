# $Id: subdir.mk,v 1.10 2006/12/10 07:39:02 tho Exp $
#
# Variables:
# - SUBDIR      A list of subdirectories that should be built as well.
#               Each of the targets will execute the same target in the
#               subdirectories.
#
# Applicable Targets:
# - any target

# if not specified, default target is "all"
ifndef MAKECMDGOALS
MAKECMDGOALS = all
endif

$(MAKECMDGOALS):
	@for dir in $(SUBDIR) ; do \
	    $(MAKE) -C $$dir $(MAKECMDGOALS) ; \
        [ $$? = 0 ] || exit $$? ; \
	done
