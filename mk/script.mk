# $Id: script.mk,v 1.8 2008/05/10 07:07:13 tho Exp $
#
# Helper for shell or other interpreted scripts installation|removal which
# uses the prog.mk template.
#
# User Variables:
# - SCRIPT      the name of the script to be installed
#
# Available Targets:
# - install, uninstall

# SCRIPT full name (!= SCRIPT in case {pre,suf}fix has been supplied
__SCRIPT = $(strip $(SCRIPT_PREFIX))$(strip $(SCRIPT))$(strip $(SCRIPT_SUFFIX))

ifneq ($(MAKECMDGOALS), .help)

include priv/funcs.mk 

# check preconditions 
$(call assert-var, SCRIPT)

# use prog interface cleanly
PROG = $(SCRIPT)
PROG_PREFIX = $(SCRIPT_PREFIX)
PROG_SUFFIX = $(SCRIPT_SUFFIX)
SRCS = __unset__        # must be faked because prog.mk assert on it
NO_ALL = true
NO_CLEAN = true
NO_DEPEND = true
NO_CLEANDEPEND = true
INSTALL_STRIP =

# if any of SCRIPT_{PRE,SUF}FIX is set handle aliasing on all and clean goals
ifneq ($(__SCRIPT),$(strip $(SCRIPT)))
all: ; cp $(SCRIPT) $(__SCRIPT)
clean: ; rm -f $(__SCRIPT)
endif

include prog.mk

else    # target == .help
##
## interface description 
##
.help:
	@echo
	@echo "-------------------                                              "
	@echo " Available targets                                               "
	@echo "-------------------                                              "
ifneq ($(__SCRIPT),$(strip $(SCRIPT)))
	@echo "all         create alias of the original script                  "
	@echo "clean       delete alias of the original script                  "
endif
	@echo "install     install the script                                   "
	@echo "uninstall   remove the installed script                          "
	@echo
	@echo "Each target T given above has T-hook-pre and T-hook-post         "
	@echo "companion targets.  These (void) targets are at client's disposal"
	@echo "and will always be called before and after the associated target "
	@echo
	@echo "---------------------                                            "
	@echo " Available variables                                             "
	@echo "---------------------                                            "
	@echo "SCRIPT           the script file name                            "
	@echo "SCRIPT_PREFIX    concatenate this as prefix to SCRIPT            "
	@echo "SCRIPT_SUFFIX    concatenate this as postfix to SCRIPT           "
	@echo
	@echo "If in doubt, check the source file at $(MAKL_DIR)/mk/script.mk   "
	@echo
endif   # target != .help


