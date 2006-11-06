#
# $Id: incs.mk,v 1.12 2006/11/06 09:16:34 tho Exp $
#
# Only define the install target.
#
# - INCS        the list of header files to install.
#

include ../etc/map.mk

all clean depend cleandepend:
	@echo "nothing to do for $(MAKECMDGOALS) target in $(CURDIR) ..."		

# build arguments list for '(before,real)install' operations

clean:
	rm -f $(CLEANFILES)

include __funcs.mk
# build arguments list for '(before,real)install' operations
__CHOWN_ARGS = $(call calc-chown-args, $(INCOWN), $(INCGRP))
__INSTALL_ARGS = $(call calc-install-args, $(INCOWN), $(INCGRP))
    
beforeinstall:
	$(MKINSTALLDIRS) $(INCDIR)
ifneq ($(strip $(__CHOWN_ARGS)),)
	chown $(__CHOWN_ARGS) $(INCDIR)
endif

realinstall:
	$(INSTALL) $(__INSTALL_ARGS) -m $(INCMODE) $(INCS) $(INCDIR)

afterinstall:

install: beforeinstall realinstall afterinstall

uninstall:
	for f in $(INCS); do \
	    rm -f $(INCDIR)/$$f; \
	done
