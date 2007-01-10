# $Id: script.mk,v 1.2 2007/01/10 12:14:40 tho Exp $
#
# Helper for shell or other interpreted scripts installation|removal which
# uses the prog.mk template.
#
# User Variables:
# - SCRIPT      the name of the script to be installed
#
# Available Targets:
# - install, uninstall

# check precondition
ifndef SCRIPT
    $(warning SCRIPT must be defined when including script.mk template !)
endif

PROG = $(SCRIPT)
NO_ALL = true
NO_CLEAN = true
NO_DEPEND = true
NO_CLEANDEPEND = true
INSTALL_STRIP =

include prog.mk
