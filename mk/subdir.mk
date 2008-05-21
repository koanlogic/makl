# $Id: subdir.mk,v 1.32 2008/05/21 16:14:46 tho Exp $
#
# Variables:
# - SUBDIR      A list of subdirectories that should be built as well.
#               Each of the targets will execute the same target in the
#               subdirectories.
#
# Applicable Targets:
# - any target (optionally with -pre and -post suffix - GNU make 3.81 only)

# can't use assert-var here because klone top-level Makefile uses subdir.mk 
# without MAKEFLAGS set so we can't locate priv/funcs.mk
ifndef SUBDIR
    $(error SUBDIR must be set when including the subdir.mk template !)
endif

ifeq ($(findstring .help, $(MAKECMDGOALS)),)

.DEFAULT_GOAL := all
MAKECMDGOALS ?= $(.DEFAULT_GOAL)

.PHONY: subdirs $(SUBDIR)

%: subdirs ;

subdirs: $(SUBDIR)

$(SUBDIR):
	@$(MAKE) -C $@ $(MAKECMDGOALS)

else    # MAKECMDGOALS == .help

##
## interface description
##
.help:
	@echo "-------------------                                            "
	@echo " Available targets                                             "
	@echo "-------------------                                            "
	@echo "*any* target provided by the subdirectories' Makefile's        "
	@echo
	@echo "---------------------                                          "
	@echo " Available variables                                           "
	@echo "---------------------                                          "
	@echo "SUBDIR   the list of subdirectories that should be built       "
	@echo "         as well.                                              "
	@echo
	@echo "If in doubt, check the source file at $(MAKL_DIR)/mk/subdir.mk "
	@echo

endif   # MAKECMDGOALS != .help
