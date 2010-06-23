
# $Id: incs.mk,v 1.29 2008/06/13 21:09:31 tho Exp $
#
# Only define the install and uninstall targets.
#
# - INCS        the list of header files to install.
#

include priv/funcs.mk

# check non-optional user variable (INCS)
ifneq ($(MAKECMDGOALS), .help)
    $(call assert-var, INCS)
endif

##
## all target (nothing but hooks)
##
ifndef NO_ALL
all: all-hook-pre all-hook-post
all-hook-pre all-hook-post:
else
all:
endif

##
## clean target (nothing but hooks)
##
ifndef NO_CLEAN
clean: clean-hook-pre clean-hook-post
clean-hook-pre clean-hook-post:
else
clean:
endif

##
## distclean target
##
include distclean.mk

##
## depend target (nothing but hooks)
##
ifndef NO_DEPEND
depend: depend-hook-pre depend-hook-post
depend-hook-pre depend-hook-post:
else
depend:
endif

##
## cleandepend target (nothing but hooks)
##
ifndef NO_CLEANDEPEND
cleandepend: cleandepend-hook-pre cleandepend-hook-post
cleandepend-hook-pre cleandepend-hook-post:
else
cleandepend:
endif

include priv/funcs.mk

##
## install target 
##
ifndef NO_INSTALL
install: install-hook-pre realinstall install-hook-post

install-hook-pre install-hook-post:

# build arguments list for 'realinstall' operation
__CHOWN_ARGS = $(call calc-chown-args, $(INCOWN), $(INCGRP))
__INSTALL_ARGS = $(call calc-install-args, $(INCOWN), $(INCGRP))
    
$(INCDIR):
	$(MKINSTALLDIRS) "$(INCDIR)"
ifneq ($(strip $(__CHOWN_ARGS)),)
	chown $(__CHOWN_ARGS) "$(INCDIR)"
endif

realinstall: $(INCDIR)
	$(INSTALL) $(__INSTALL_ARGS) -m $(INCMODE) $(INCS) "$(INCDIR)"

else
install:
endif

##
## uninstall target 
##
ifndef NO_UNINSTALL
uninstall: uninstall-hook-pre realuninstall uninstall-hook-post

uninstall-hook-pre uninstall-hook-post:

realuninstall:
	for f in $(INCS); do \
	    $(RM) -f "$(INCDIR)/`basename "$$f"`"; \
	done
	-rmdir "$(INCDIR)" 2>/dev/null

else
uninstall:
endif

##
## interface description
##
.help:
	@echo
	@echo "-------------------                                                 "
	@echo " Available targets                                                  "
	@echo "-------------------                                                 "
	@echo "install     install the header files                                "
	@echo "uninstall   remove the installed header files                       "
	@echo
	@echo "Each target T given above (and also all other standard MaKL         "
	@echo "targets, unless explicitly inhibited) has T-hook-pre and            "
	@echo "T-hook-post companion targets.  These (void) targets are at         "
	@echo "client's disposal and will always be called before and after the    "
	@echo "associated target"
	@echo
	@echo "---------------------                                               "
	@echo " Available variables                                                "
	@echo "---------------------                                               "
	@echo "INCS             the list of header files to install                "
	@echo "INCOWN           user ID of the installed files                     "
	@echo "INCGRP           group ID of the installed files                    "
	@echo "INCMODE          file mode bits of the installed files              "
	@echo "DISTCLEANFILES   additional files to be removed when 'distclean'ing "
	@echo
	@echo "If in doubt, check the source file at $(MAKL_DIR)/mk/incs.mk     "
	@echo
