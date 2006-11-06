# $Id: darwin.mk,v 1.6 2006/11/06 09:48:50 tho Exp $
#
# Darwin 

ifdef SHLIB

SHLIB_OBJS = $(OBJS:.o=.so)
SHLIB_MAJOR ?= 0
SHLIB_MINOR ?= 0

#
# automatic rules for shared objects
#
.SUFFIXES: .so .c .cc .C .cpp .cxx

.c.so .cc.so .C.so .cpp.so .cxx.so:
	$(__CC) -fno-common $(CPICFLAGS) -DPIC $(__CCFLAGS) -c $< -o $*.so

#
# The default is to build a shared library. 
# If BUNDLE is set a loadable module will be built instead.
#
ifdef BUNDLE
    __WHAT = "a loadable module"
    SHLIB_CC_FLAGS = -bundle -flat_namespace -undefined suppress
    SHLIB_NAME = $(__LIB).bundle
else
    __WHAT = "a shared library"
    SHLIB_CC_FLAGS = -dynamiclib -install_name $(LIBDIR)/$(SHLIB_NAME)
    SHLIB_NAME ?= lib$(__LIB).$(SHLIB_MAJOR).dylib
    SHLIB_LINK ?= lib$(__LIB).dylib
endif

#
# build rules (__CC is set by lib.mk)
#
all-shared: $(SHLIB_NAME)

$(SHLIB_NAME): $(SHLIB_OBJS)
	@echo "===> building $(__LIB) as $(__WHAT)"
ifndef BUNDLE
	rm -f $(SHLIB_NAME) $(SHLIB_LINK)
	ln -sf $(SHLIB_NAME) $(SHLIB_LINK)
endif
	$(__CC) $(SHLIB_CC_FLAGS) -o $(SHLIB_NAME) $(SHLIB_OBJS) $(LDADD) $(LDFLAGS)

install-shared:
	$(INSTALL) $(_INSTALL_ARGS) -m $(LIBMODE) $(SHLIB_NAME) $(LIBDIR)
ifndef BUNDLE
	ln -sf $(SHLIB_NAME) $(LIBDIR)/$(SHLIB_LINK)
endif

uninstall-shared:
	rm -f $(LIBDIR)/$(SHLIB_NAME)
	rm -f $(LIBDIR)/$(SHLIB_LINK)

clean-shared:
	rm -f $(SHLIB_OBJS)
	rm -f $(SHLIB_NAME) $(SHLIB_LINK)

endif
