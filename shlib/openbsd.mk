# $Id: openbsd.mk,v 1.3 2007/06/21 15:20:43 tho Exp $
#
# OpenBSD

ifdef SHLIB

SHLIB_OBJS = $(OBJS:.o=.so)
SHLIB_MAJOR ?= 0
SHLIB_MINOR ?= 0

#
# automatic rules for shared objects
#
.SUFFIXES: .so .c .cc .C .cpp .cxx

.c.so:
	$(CC) -fpic -DPIC $(CFLAGS) -c $< -o $*.so.o
	$(LD) -X -r $*.so.o -o $*.so
	rm -f $*.so.o

.cc.so .C.so .cpp.so .cxx.so:
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
	$(INSTALL) $(__INSTALL_ARGS) -m $(LIBMODE) $(SHLIB_NAME) $(RELOC)/$(LIBDIR)

uninstall-shared:
	rm -f $(RELOC)/$(LIBDIR)/$(SHLIB_NAME)

clean-shared:
	rm -f $(SHLIB_OBJS)
	rm -f $(SHLIB_NAME)

endif
