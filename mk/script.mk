# $Id: script.mk,v 1.6 2008/05/08 15:53:35 tho Exp $
#
# Helper for shell or other interpreted scripts installation|removal which
# uses the prog.mk template.
#
# User Variables:
# - SCRIPT      the name of the script to be installed
#
# Available Targets:
# - install, uninstall

include priv/funcs.mk 

# check preconditions (when target != .help)
ifneq ($(MAKECMDGOALS), .help)
    $(call assert-var, SCRIPT)
endif

PROG = $(SCRIPT)
SRCS = __unset__        # must be faked because prog.mk assert on it
NO_ALL = true
NO_CLEAN = true
NO_DEPEND = true
NO_CLEANDEPEND = true
INSTALL_STRIP =

# private .help target 
ifneq ($(MAKECMDGOALS), .help)
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
	@echo "SCRIPT        the script file name                               "
	@echo
	@echo "If in doubt, check the source file at $(MAKL_DIR)/mk/script.mk   "
	@echo
endif   # target != .help
