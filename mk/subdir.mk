# $Id: subdir.mk,v 1.8 2006/11/01 19:37:28 stewy Exp $
#
# Variables:
# - SUBDIR      A list of subdirectories that should be built as well.
#               Each of the targets will execute the same target in the
#               subdirectories.
#
# Applicable Targets:
# - all, clean, purge, install, uninstall, depend, cleandepend.

all $(MAKECMDGOALS):
	@for dir in $(SUBDIR) ; do \
	    $(MAKE) -C $$dir $(MAKECMDGOALS) ; \
        [ $$? = 0 ] || exit $$? ; \
	done
