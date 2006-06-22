#
# $Id: incs.mk,v 1.11 2006/06/22 10:18:36 tho Exp $
#
# Only define the install target.
#
# - INCS        the list of header files to install.
#

include ../etc/map.mk

all clean depend cleandepend:
	@echo "nothing to do for $(MAKECMDGOALS) target in $(CURDIR) ..."		

# build arguments list for '(before,real)install' operations
_CHOWN_ARGS =
_INSTALL_ARGS =
ifneq ($(strip $(INCOWN)),)
    _CHOWN_ARGS = $(INCOWN)
    _INSTALL_ARGS = -o $(INCOWN)
endif
ifneq ($(strip $(INCGRP)),)
    _CHOWN_ARGS = $(join $(INCOWN), :$(INCGRP))
    _INSTALL_ARGS += -g $(INCGRP)
endif
    
beforeinstall:
	$(MKINSTALLDIRS) $(INCDIR)
ifneq ($(strip $(_CHOWN_ARGS)),)
	chown $(_CHOWN_ARGS) $(INCDIR)
endif

realinstall:
	$(INSTALL) $(_INSTALL_ARGS) -m $(INCMODE) $(INCS) $(INCDIR)

afterinstall:

install: beforeinstall realinstall afterinstall

uninstall:
	for f in $(INCS); do \
	    rm -f $(INCDIR)/$$f; \
	done
