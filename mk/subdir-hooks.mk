# $Id: subdir-hooks.mk,v 1.3 2008/05/21 16:14:46 tho Exp $
#
# Variables:
# - SUBDIR      A list of subdirectories that should be built as well.
#               Each of the targets will execute the same target in the
#               subdirectories.
#
# Applicable Targets:
# - any target (optionally with -pre and -post suffix - GNU make 3.81 only)

ifneq ($(MAKE_VERSION), 3.81)
    $(error subdir-hooks template not supported by GNU make $(MAKE_VERSION))
endif

# can't use assert-var here because klone top-level Makefile uses subdir.mk 
# without MAKEFLAGS set so we can't locate priv/funcs.mk
ifndef SUBDIR
    $(error SUBDIR must be set when including the subdir.mk template !)
endif

ifeq ($(findstring .help, $(MAKECMDGOALS)),)

.DEFAULT_GOAL := all
MAKECMDGOALS ?= $(.DEFAULT_GOAL)

.PHONY: subdirs $(SUBDIR)

# the following implies each generated template
subdirs: $(MAKECMDGOALS)

# subdir_mk template generator
# $1 = goal 
# $2 = subdir list
define subdir_mk
    $(1)_SUBGOAL = $(addsuffix .$(1),$(2))
    $(1): $(1)-pre $$($(1)_SUBGOAL) $(1)-post
    $(1)-pre $(1)-post:
    $$($(1)_SUBGOAL) : %.$(1): ; @$(MAKE) -C $$* $(1)
    .PHONY: $(1) $$($(1)_SUBGOAL) $(1)-pre $(1)-post
endef

# create rules using the subdir_mk template for each supplied target 
$(foreach T,$(MAKECMDGOALS),$(eval $(call subdir_mk,$(T),$(SUBDIR))))

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
