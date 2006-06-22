# $Id: subdir.mk,v 1.7 2006/06/22 18:52:55 tho Exp $
#
# Variables:
# - SUBDIR      A list of subdirectories that should be built as well.
#               Each of the targets will execute the same target in the
#               subdirectories.
#
# Applicable Targets:
# - all, clean, purge, install, uninstall, depend, cleandepend.

all clean purge install uninstall depend cleandepend:
	@for dir in $(SUBDIR) ; do \
	    $(MAKE) -C $$dir $(MAKECMDGOALS) ; \
        [ $$? = 0 ] || exit $$? ; \
	done
