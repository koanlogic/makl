# $Id: darwin.mk,v 1.4 2006/11/05 11:22:03 tho Exp $
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
    SHLIB_NAME = bundle_$(_LIB).so
else
    __WHAT = "a shared library"
    SHLIB_CC_FLAGS = -dynamiclib -install_name $(LIBDIR)/$(SHLIB_NAME)
    SHLIB_NAME ?= lib$(_LIB).$(SHLIB_MAJOR).dylib
    SHLIB_LINK ?= lib$(_LIB).dylib
endif

#
# build rules (__CC is set by lib.mk)
#
all-shared: $(SHLIB_NAME)

$(SHLIB_NAME): $(SHLIB_OBJS)
	@echo "===> building $(_LIB) as $(__WHAT)"
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
