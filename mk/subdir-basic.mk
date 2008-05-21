# $Id: subdir-basic.mk,v 1.1 2008/05/21 11:09:45 tho Exp $

ifeq ($(findstring .help, $(MAKECMDGOALS)),)

.DEFAULT_GOAL := all
MAKECMDGOALS ?= $(.DEFAULT_GOAL)

# can't use assert-var here because klone top-level Makefile uses subdir.mk 
# without MAKEFLAGS set so we can't locate priv/funcs.mk
ifndef SUBDIR
    $(error SUBDIR must be set when including the subdir.mk template !)
endif

.PHONY: subdirs $(SUBDIR)
# the following implies each generated template
%: subdirs ;

subdirs: $(SUBDIR)

$(SUBDIR):
	@$(MAKE) -C $@ $(MAKECMDGOALS)

else    # .help

##
## interface description
##
.help:
	@echo "-------------------                                            "
	@echo " Available targets                                             "
	@echo "-------------------                                            "
	@echo "*any* target provided by the subdirectories' Makefile's        "
	@echo
	@echo "With GNU make version $(MAKE_VERSION), target hooking is not   "
	@echo "supported.  Should you need this feature, upgrade to version   "
	@echo "3.81.                                                          "
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
