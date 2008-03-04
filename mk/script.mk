# $Id: script.mk,v 1.5 2008/03/04 20:32:31 tho Exp $
#
# Helper for shell or other interpreted scripts installation|removal which
# uses the prog.mk template.
#
# User Variables:
# - SCRIPT      the name of the script to be installed
#
# Available Targets:
# - install, uninstall

# check preconditions (when target != .help)
ifneq ($(MAKECMDGOALS), .help)
ifndef SCRIPT
    $(warning SCRIPT must be defined when including script.mk template !)
endif
endif

PROG = $(SCRIPT)
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
