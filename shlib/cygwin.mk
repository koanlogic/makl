# $Id: cygwin.mk,v 1.7 2008/11/13 12:28:13 tho Exp $
#
# import __LIB, OBJS, OBJFORMAT from lib.mk
# export SHLIB_NAME to lib.mk 
# export CPICFLAGS, SHLIB_MAJOR, SHLIB_MINOR, SONAME to userspace

ifdef SHLIB

SHLIB_OBJS = $(OBJS)

##
## set library naming (add 'cyg' prefix to differentiate from native MinGW)
##
SHLIB_NAME ?= cyg$(__LIB).dll
SHLIB_IMP ?= lib$(__LIB).dll.a

SHLIB_LDFLAGS += -shared 
SHLIB_LDFLAGS += -Wl,--out-implib=$(SHLIB_IMP)
SHLIB_LDFLAGS += -Wl,--export-all-symbols
SHLIB_LDFLAGS += -Wl,--enable-auto-import
#SHLIB_LDFLAGS += -Wl,--whole-archive $(LIB_NAME)
#SHLIB_LDFLAGS += -Wl,--no-whole-archive

##
## build rules
##
all-shared: $(SHLIB_NAME)

$(SHLIB_NAME): $(SHLIB_OBJS)
	@echo "===> building $(__LIB) as dynamic linked library"
	$(RM) -f $(SHLIB_NAME)
	$(__CC) -o $(SHLIB_NAME) $(SHLIB_LDFLAGS) \
	    `$(LORDER) $(SHLIB_OBJS) | $(TSORT)` $(LDADD) $(LDFLAGS)

# build arguments list for 'install-shared' operation
__CHOWN_ARGS_BIN = $(call calc-chown-args, $(BINOWN), $(BINGRP))
__INSTALL_ARGS_BIN = $(call calc-install-args, $(BINOWN), $(BINGRP))

$(BINDIR):
	$(MKINSTALLDIRS) "$(BINDIR)"
ifneq ($(strip $(__CHOWN_ARGS_BIN)),)
	chown $(__CHOWN_ARGS_BIN) "$(BINDIR)"
endif

$(SHLIBDIR):
	$(MKINSTALLDIRS) "$(SHLIBDIR)"
ifneq ($(strip $(__CHOWN_ARGS)),)
	chown $(__CHOWN_ARGS) "$(SHLIBDIR)"
endif

# cyg*.dll's go to /bin, while import library go to /lib
install-shared: $(BINDIR) $(SHLIBDIR)
	$(INSTALL) $(__INSTALL_ARGS_BIN) -m $(BINMODE) $(SHLIB_NAME) "$(BINDIR)"
	$(INSTALL) $(__INSTALL_ARGS) -m $(LIBMODE) $(SHLIB_IMP) "$(SHLIBDIR)"

uninstall-shared:
	$(RM) -f "$(SHLIBDIR)/$(SHLIB_NAME)"
	-rmdir "$(SHLIBDIR)" 2>/dev/null

clean-shared:
	$(RM) -f $(SHLIB_OBJS)
	$(RM) -f $(SHLIB_NAME)
	$(RM) -f $(SHLIB_IMP)

endif
