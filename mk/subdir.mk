# $Id: subdir.mk,v 1.25 2008/03/04 20:32:31 tho Exp $
#
# Variables:
# - SUBDIR      A list of subdirectories that should be built as well.
#               Each of the targets will execute the same target in the
#               subdirectories.
#
# Applicable Targets:
# - any target (optionally with -pre and -post suffix)

# make filename used (Makefile, makefile, Makefile.subdir, mymakefile, etc.)
MAKEFILENAME = $(firstword $(MAKEFILE_LIST))

# additional flags
ifneq ($(strip $(MAKEFILENAME)),)
MAKE_ADD_FLAGS = -f $(MAKEFILENAME)
endif

ifdef HOOK_T

$(HOOK_T)-pre:
$(HOOK_T)-post:

else    # !HOOK_T

.PHONY: subdirs $(SUBDIR)

subdirs: $(SUBDIR)

# no explicit target, run make into subdirs
$(SUBDIR):
	@$(MAKE) SUBDIR_GOAL= -C $@ $(SUBDIR_GOAL)

ifndef SUBDIR_GOAL
# one or more explicit target has been provided. run $target-pre, make
# subdirs and $target-post
$(MAKECMDGOALS):
	@$(MAKE) $(MAKE_ADD_FLAGS) HOOK_T=$@ $@-pre
	@$(MAKE) $(MAKE_ADD_FLAGS) SUBDIR_GOAL=$@ subdirs
	@$(MAKE) $(MAKE_ADD_FLAGS) HOOK_T=$@ $@-post
endif

all: subdirs

endif   # HOOK_T

##
## interface description
##
ifeq ($(MAKECMDGOALS), .help)
.help:
	@echo "-------------------                                            "
	@echo " Available targets                                             "
	@echo "-------------------                                            "
	@echo "*any* target provided by the subdirectories' Makefile's        "
	@echo
	@echo "Each target T has T-pre and T-post companion targets.  These   "
	@echo "(void) targets are at client's disposal and will always be     "
	@echo "called before and after the associated target                  "
	@echo
	@echo "---------------------                                          "
	@echo " Available variables                                           "
	@echo "---------------------                                          "
	@echo "SUBDIR   the list of subdirectories that should be built       "
	@echo "         as well.                                              "
	@echo
	@echo "If in doubt, check the source file at $(MAKL_DIR)/mk/subdir.mk "
	@echo
endif
