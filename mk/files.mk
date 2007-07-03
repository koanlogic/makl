#
# $Id: files.mk,v 1.5 2007/07/03 10:58:05 tho Exp $
#
# User Variables:
# - FILES               files to be installed
# - FILES_DIR           destination directory
# - FILES_GRP,OWN,MODE  files' installation credentials and mode
#
# Applicable targets:
# - install, uninstall

include ../etc/map.mk

# check preconditions
ifndef FILES
$(error FILES must be set when including the files.mk template !)
endif
ifndef FILES_DIR
$(error FILES_DIR must be set when including the files.mk template !)
endif

##
## all(build) target (nothing but hooks)
##
ifndef NO_ALL
all: all-hook-pre all-hook-post

all-hook-pre all-hook-post:

else    # NO_ALL
all:
endif   # !NO_ALL

##
## clean target (nothing but hooks)
##
ifndef NO_CLEAN
clean: clean-hook-pre clean-hook-post

clean-hook-pre clean-hook-post:

else    # NO_CLEAN
clean:
endif   # !NO_CLEAN

##
## install target
## 
ifndef NO_INSTALL
install: install-hook-pre realinstall install-hook-post

include priv/funcs.mk
# build arguments list for 'realinstall' operation
__CHOWN_ARGS = $(call calc-chown-args, $(FILES_OWN), $(FILES_GRP))
__INSTALL_ARGS = $(call calc-install-args, $(FILES_OWN), $(FILES_GRP))

$(RELOC)$(FILES_DIR):
	$(MKINSTALLDIRS) $(RELOC)$(FILES_DIR)
ifneq ($(strip $(__CHOWN_ARGS)),)
	chown $(__CHOWN_ARGS) $(RELOC)$(FILES_DIR)
endif

realinstall: $(RELOC)$(FILES_DIR)
	$(INSTALL) $(INSTALL_COPY) $(__INSTALL_ARGS) -m $(FILES_MODE) $(FILES) \
        $(RELOC)$(FILES_DIR)

install-hook-pre install-hook-post:

else        # NO_INSTALL
install:
endif       # !NO_INSTALL

##
## uninstall target
##
ifndef NO_UNINSTALL
uninstall: uninstall-hook-pre realuninstall uninstall-hook-post

realuninstall:
	for f in $(FILES); do \
	    rm -f $(RELOC)$(FILES_DIR)/`basename $$f` ; \
	done
	-rmdir $(RELOC)$(FILES_DIR) 2>/dev/null

uninstall-hook-pre uninstall-hook-post:

else        # NO_UNINSTALL
uninstall:
endif       # !NO_UNINSTALL

##
## dummy depend and cleandepend targets
##
depend cleandepend:
