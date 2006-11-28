# $Id: man.mk,v 1.16 2006/11/28 15:52:24 tho Exp $
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

include ../etc/map.mk

# check minimal precondition:
# MANFILES must be set 
ifndef MANFILES
$(error MANFILES must be set when including the man.mk template !)
endif

# MANFILES must be set correctly
__SUBDIRS = $(strip $(patsubst .%, %, $(sort $(suffix $(MANFILES)))))
ifeq ($(__SUBDIRS),)
$(error no valid filenames found in MANFILES !)
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
	@for f in $(MLINKS) $(MANFILES) ; do \
		rm -f $(MANDIR)/man$${f##*.}/$$f ; \
	done

else
uninstall:
endif
