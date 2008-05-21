# $Id: subdir.mk,v 1.30 2008/05/21 12:02:06 tho Exp $
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

# when using GNU make == 3.81, support target hooks, otherwise basic subdir
# recursion is in place
ifeq ($(MAKE_VERSION), 3.81)
    include subdir-hooks.mk
else
    include subdir-basic.mk
endif

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
ifeq ($(MAKE_VERSION), 3.81)
	@echo "Each target T has T-pre and T-post companion targets.  These   "
	@echo "(void) targets are at client's disposal and will always be     "
	@echo "called before and after the associated target.                 "
	@echo "A set of target with pattern <subdir>.<goal> is used internally"
	@echo "to handle recursion.  Should you need to explicitly set a      "
	@echo "given build dependency between subdirectories in any of the    "
	@echo "goals, you must use the internal target format to express it.  "
	@echo "E.g. to tell MaKL that the directory then_dir must be built    "
	@echo "after the prerequisite_dir has been successfully built, you    "
	@echo "will add the following line:                                   "
	@echo "     then_dir.all: prerequisite_dir.all                        "
	@echo "This is particularly important when doing parallel builds where"
	@echo "the order in which subdirectories are specified in the SUBDIR  "
	@echo "variable is not necessarily honoured by GNU make.              "
else    # GNU make < 3.81
	@echo "With GNU make version $(MAKE_VERSION), target hooking is not   "
	@echo "supported.  Should you need this feature, upgrade to version   "
	@echo "3.81.                                                          "
endif   # GNU make == 3.81
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
