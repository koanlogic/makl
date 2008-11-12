# $Id: cygwin.mk,v 1.5 2008/11/12 14:19:49 tho Exp $
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
	rm -f $(SHLIB_NAME)
	$(__CC) -o $(SHLIB_NAME) $(SHLIB_LDFLAGS)
	    `$(LORDER) $(SHLIB_OBJS) | $(TSORT)` $(LDADD) $(LDFLAGS)

install-shared:
	$(INSTALL) $(__INSTALL_ARGS) -m $(LIBMODE) $(SHLIB_NAME) $(SHLIBDIR)

uninstall-shared:
	rm -f $(SHLIBDIR)/$(SHLIB_NAME)
	-rmdir $(SHLIBDIR) 2>/dev/null

clean-shared:
	rm -f $(SHLIB_OBJS)
	rm -f $(SHLIB_NAME)
	rm -f $(SHLIB_IMP)

endif
