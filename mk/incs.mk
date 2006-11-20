#
# $Id: incs.mk,v 1.16 2006/11/20 13:33:39 tho Exp $
#
# Only define the install target.
#
# - INCS        the list of header files to install.
#

include ../etc/map.mk

all clean depend cleandepend:
	@echo "nothing to do for $(MAKECMDGOALS) target in $(CURDIR) ..."

all: all-hook-pre all-hook-post
clean: clean-hook-pre clean-hook-post
uninstall: uninstall-hook-pre uninstall-hook-post
depend: depend-hook-pre depend-hook-post
cleandepend: cleandepend-hook-pre cleandepend-hook-post

all-hook-pre all-hook-post:
clean-hook-pre clean-hook-post:
uninstall-hook-pre uninstall-hook-post:
depend-hook-pre depend-hook-post:
cleandepend-hook-pre cleandepend-hook-post:

include priv/funcs.mk
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

install: install-hook-pre beforeinstall realinstall install-hook-post

install-hook-pre install-hook-post:

uninstall:
	for f in $(INCS); do \
	    rm -f $(INCDIR)/`basename $$f`; \
	done
