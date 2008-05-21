# $Id: subdir.mk,v 1.29 2008/05/21 11:09:45 tho Exp $
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

ifeq ($(MAKE_VERSION), 3.81)
    include subdir-hooks.mk
else
    include subdir-basic.mk
endif
