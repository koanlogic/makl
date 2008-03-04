# $Id: script.mk,v 1.4 2008/03/04 11:16:50 tho Exp $
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
	@$(ECHO)
	@$(ECHO) "-------------------                                              "
	@$(ECHO) " Available targets                                               "
	@$(ECHO) "-------------------                                              "
	@$(ECHO) "install     install the script                                   "
	@$(ECHO) "uninstall   remove the installed script                          "
	@$(ECHO)
	@$(ECHO) "Each target T given above has T-hook-pre and T-hook-post         "
	@$(ECHO) "companion targets.  These (void) targets are at client's disposal"
	@$(ECHO) "and will always be called before and after the associated target "
	@$(ECHO)
	@$(ECHO) "---------------------                                            "
	@$(ECHO) " Available variables                                             "
	@$(ECHO) "---------------------                                            "
	@$(ECHO) "SCRIPT        the script file name                               "
	@$(ECHO)
	@$(ECHO) "If in doubt, check the source file at $(MAKL_DIR)/mk/script.mk   "
	@$(ECHO)
endif   # target != .help
