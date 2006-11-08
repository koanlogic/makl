# $Id: darwin.mk,v 1.9 2006/11/08 14:40:15 tho Exp $
#
# Darwin 

ifdef SHLIB

SHLIB_OBJS = $(OBJS:.o=.so)
SHLIB_MAJOR ?= 1
SHLIB_MINOR ?= 0
SHLIB_TEENY ?= 0

BUNDLE_EXT ?= bundle

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
    SHLIB_LDFLAGS = -bundle -flat_namespace -undefined suppress
    SHLIB_NAME = $(__LIB).$(BUNDLE_EXT)
else
    __WHAT = "a shared library"
    __COMPAT_VER = $(SHLIB_MAJOR).$(SHLIB_MINOR)
    __CURRENT_VER = $(SHLIB_MAJOR).$(SHLIB_MINOR).$(SHLIB_TEENY)
    SHLIB_LDFLAGS += -dynamiclib -install_name $(SHLIBDIR)/$(SHLIB_NAME)
    SHLIB_LDFLAGS += -compatibility_version $(__COMPAT_VER)
    SHLIB_LDFLAGS += -current_version $(__CURRENT_VER)
    SHLIB_NAME ?= lib$(__LIB).$(__CURRENT_VER).dylib
    SHLIB_LINK1 ?= lib$(__LIB).dylib
    SHLIB_LINK2 ?= lib$(__LIB).$(SHLIB_MAJOR).dylib
endif

#
# build rules (__CC is set by lib.mk)
#
all-shared: $(SHLIB_NAME)

$(SHLIB_NAME): $(SHLIB_OBJS)
	@echo "===> building $(__LIB) as $(__WHAT)"
ifndef BUNDLE
	rm -f $(SHLIB_NAME) $(SHLIB_LINK)
	ln -sf $(SHLIB_NAME) $(SHLIB_LINK1)
	ln -sf $(SHLIB_NAME) $(SHLIB_LINK2)
endif
	$(__CC) $(SHLIB_LDFLAGS) -o $(SHLIB_NAME) $(SHLIB_OBJS) $(LDADD) $(LDFLAGS)

install-shared:
	$(INSTALL) $(__INSTALL_ARGS) -m $(LIBMODE) $(SHLIB_NAME) $(SHLIBDIR)
ifndef BUNDLE
	ln -sf $(SHLIB_NAME) $(SHLIBDIR)/$(SHLIB_LINK1)
	ln -sf $(SHLIB_NAME) $(SHLIBDIR)/$(SHLIB_LINK2)
endif

uninstall-shared:
	rm -f $(SHLIBDIR)/$(SHLIB_NAME)
ifndef BUNDLE
	rm -f $(SHLIBDIR)/$(SHLIB_LINK1)
	rm -f $(SHLIBDIR)/$(SHLIB_LINK2)
endif

clean-shared:
	rm -f $(SHLIB_OBJS)
	rm -f $(SHLIB_NAME)
ifndef BUNDLE
	rm -f $(SHLIB_LINK1) $(SHLIB_LINK2)
endif

endif
