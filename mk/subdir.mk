# $Id: subdir.mk,v 1.12 2007/02/22 14:01:32 tat Exp $
#
# Variables:
# - SUBDIR      A list of subdirectories that should be built as well.
#               Each of the targets will execute the same target in the
#               subdirectories.
#
# Applicable Targets:
# - any target (optionally with -pre and -post suffix)

# if not specified, default target is "all"
ifndef MAKECMDGOALS
MAKECMDGOALS = all
endif

ifndef HOOK
$(MAKECMDGOALS):
	@for target in $(MAKECMDGOALS) ; do \
	    $(MAKE) HOOK=$${target} $${target}-pre ; \
        [ $$? = 0 ] || exit $$? ; \
		for dir in $(SUBDIR) ; do \
			$(MAKE) -C $$dir $(MAKECMDGOALS) ; \
			[ $$? = 0 ] || exit $$? ; \
		done; \
	    $(MAKE) HOOK=$${target} $${target}-post ; \
        [ $$? = 0 ] || exit $$? ; \
	done ;
else
$(HOOK)-pre:
$(HOOK)-post:
endif

