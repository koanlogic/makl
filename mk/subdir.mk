# $Id: subdir.mk,v 1.13 2007/02/24 15:40:52 tat Exp $
#
# Variables:
# - SUBDIR      A list of subdirectories that should be built as well.
#               Each of the targets will execute the same target in the
#               subdirectories.
#
# Applicable Targets:
# - any target (optionally with -pre and -post suffix)

ifdef HOOK_T
$(HOOK_T)-pre:
$(HOOK_T)-post:
else
.PHONY: $(SUBDIR)

# no explicit target, run make into subdirs
$(SUBDIR):
	@for dir in $(SUBDIR) ; do \
		$(MAKE) -C $$dir ; \
		[ $$? = 0 ] || exit $$? ; \
	 done

# one or more explicit target has been provided. run $target-pre, make
# subdirs and $target-post
$(MAKECMDGOALS):
	@$(MAKE) HOOK_T=$@ $@-pre
	@for dir in $(SUBDIR) ; do \
		$(MAKE) -C $$dir $(MAKECMDGOALS) ; \
		[ $$? = 0 ] || exit $$? ; \
	 done
	@$(MAKE) HOOK_T=$@ $@-post

endif

