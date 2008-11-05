# $Id: man.mk,v 1.28 2008/11/05 15:24:15 tho Exp $
#
# User Variables:
# - MANFILES   Manual page(s) to be installed.
# - MANOWN     Installation credentials for files and directories (owner).
# - MANGRP     Installation credentials for files and directories (group).
# - MANMODE    Installation permission for files in 'absolute' mode.
# - MANDIR     Top level man pages' directory.
# - MLINKS     Ordered couplets of man page and its symlink.
#
# Applicable targets:
# - install, uninstall.

include priv/funcs.mk

# check minimal precondition when target != .help
# i.e. MANFILES must be set and __SUBDIRS must evaluate to something
ifneq ($(MAKECMDGOALS), .help)
    $(call assert-var, MANFILES)
    __SUBDIRS = $(strip $(patsubst .%, %, $(sort $(suffix $(MANFILES)))))
    ifeq ($(__SUBDIRS),)
        $(error no valid filenames found in MANFILES !)
    endif
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

# build arguments list for install operations
include priv/funcs.mk

__CHOWN_ARGS = $(call calc-chown-args, $(MANOWN), $(MANGRP))
__INSTALL_ARGS = $(call calc-install-args, $(MANOWN), $(MANGRP))

##
## install target
##
ifndef NO_INSTALL
install: install-hook-pre dirs dirperms realinstall manlinks install-hook-post

install-hook-pre install-hook-post:

dirs:
	@for d in $(__SUBDIRS); do \
		$(MKINSTALLDIRS) $(MANDIR)/man$$d ; \
	done

dirperms:
ifneq ($(strip $(__CHOWN_ARGS)),)
	@for d in $(__SUBDIRS); do \
		chown $(__CHOWN_ARGS) $(MANDIR)/man$$d ; \
	done
endif

realinstall:
	@for f in $(MANFILES); do \
		$(INSTALL) $(INSTALL_COPY) $(__INSTALL_ARGS) -m $(MANMODE) \
            $$f $(MANDIR)/man$${f##*.} ; \
	done

ifneq ($(MLINKS),)
manlinks:
	@set $(MLINKS); \
	while test $$# -ge 2 ; do \
		name=$$1 ; \
		shift ; \
		dir=$(MANDIR)/man$${name##*.} ; \
		l=$$dir/$$name ; \
		name=$$1 ; \
		shift ; \
		dir=$(MANDIR)/man$${name##*.} ; \
		t=$$dir/$$name ; \
		if test $$l -nt $$t -o ! -f $$t ; then \
			echo $$t -\> $$l ; \
			ln -f $$l $$t ; \
		fi ; \
	done
else
manlinks:
endif

else
install:
endif

##
## uninstall target
##
ifndef NO_UNINSTALL
uninstall:
	-for f in $(MLINKS) $(MANFILES) ; do \
		rm -f $(MANDIR)/man$${f##*.}/$$f ; \
		rmdir $(MANDIR)/man$${f##*.} 2>/dev/null; \
	done
	-rmdir $(MANDIR) 2>/dev/null

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
	@echo "install     install the files                                       "
	@echo "uninstall   remove the installed files                              "
	@echo
	@echo "Each target T given above (and also all other standard MaKL         "
	@echo "targets, unless explicitly inhibited via NO_<TARGET> variable)      "
	@echo "has T-hook-pre and T-hook-post companion targets.                   "
	@echo "These (void) targets are at client's disposal and will always be    "
	@echo "called before and after the associated target                       "
	@echo
	@echo "---------------------                                               "
	@echo " Available variables                                                "
	@echo "---------------------                                               "
	@echo "MANFILES         manual page(s) to be installed                     "
	@echo "MANDIR           top level man pages' directory                     "
	@echo "MANOWN           ID of the installed files                          "
	@echo "MANGRP           ID of the installed files                          "
	@echo "MANMODE          mode bits of the installed files                   "
	@echo "MLINKS           ordered couplets of man page and its symlink       "
	@echo "DISTCLEANFILES   additional files to be removed when 'distclean'ing "
	@echo
	@echo "If in doubt, check the source file at $(MAKL_DIR)/mk/man.mk         "
	@echo
