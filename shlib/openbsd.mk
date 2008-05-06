# $Id: openbsd.mk,v 1.6 2008/05/06 10:54:54 tho Exp $
#
# OpenBSD

ifdef SHLIB

SHLIB_OBJS = $(OBJS:.o=.so)
SHLIB_MAJOR ?= 0
SHLIB_MINOR ?= 0

#
# automatic rules for shared objects
#
.SUFFIXES: .so $(ALL_EXTS)

$(foreach e,$(C_EXTS),$(addsuffix .so,$(e))):
	$(CC) -fpic -DPIC $(CFLAGS) -c $< -o $*.so.o
	$(LD) -X -r $*.so.o -o $*.so
	rm -f $*.so.o

$(foreach e,$(CXX_EXTS),$(addsuffix .so,$(e))):
	$(CXX) -fpic -DPIC $(CXXFLAGS) -c $< -o $*.so.o
	$(LD) -X -r $*.so.o -o $*.so
	rm -f $*.so.o

SHLIB_NAME ?= lib$(__LIB).so.$(SHLIB_MAJOR).$(SHLIB_MINOR)

#
# build rules
#
all-shared: $(SHLIB_NAME)

$(SHLIB_NAME): $(SHLIB_OBJS)
	@echo "===> building shared $(__LIB) library"
	rm -f $(SHLIB_NAME)
	$(CC) -shared -fpic -o $(SHLIB_NAME) `$(LORDER) $(SHLIB_OBJS) | $(TSORT)`

install-shared:
	$(INSTALL) $(__INSTALL_ARGS) -m $(LIBMODE) $(SHLIB_NAME) $(LIBDIR)

uninstall-shared:
	rm -f $(LIBDIR)/$(SHLIB_NAME)

clean-shared:
	rm -f $(SHLIB_OBJS)
	rm -f $(SHLIB_NAME)

endif
