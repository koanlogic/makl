# $Id: null.mk,v 1.1 2006/12/01 07:41:27 tho Exp $

ifdef SHLIB

all-shared install-shared uninstall-shared clean-shared:
	$(warning missing shared libraries support for $(shell uname -s) platform)

endif # SHLIB
