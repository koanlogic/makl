# $Id: netbsd.mk,v 1.5 2006/11/10 09:24:07 tho Exp $
#
# NetBSD

ifdef SHLIB

SHLIB_OBJS = $(OBJS:.o=.so)
SHLIB_MAJOR ?= 0
SHLIB_MINOR ?= 0

##
## Automatic rules for shared objects.
##
.SUFFIXES: .so .c .cc .C .cpp .cxx

.c.so:
	$(CC) -fpic -DPIC $(CFLAGS) -c $< -o $*.so

.cc.so .C.so .cpp.so .cxx.so:
	$(CXX) -fpic -DPIC $(CXXFLAGS) -c $< -o $*.so

##
## Set library naming vars
##
SHLIB_LINK ?= lib$(__LIB).so
SONAME ?= $(SHLIB_LINK).$(SHLIB_MAJOR)
SHLIB_NAME ?= $(SONAME).$(SHLIB_MINOR)
PICNAME ?= lib$(__LIB)_pic.a

##
## Build rules.
##
all-shared: $(SHLIB_NAME)

$(SHLIB_NAME): $(SHLIB_OBJS)
	@echo "===> building shared $(__LIB) library"
	rm -f $(SHLIB_NAME) $(SHLIB_LINK) $(SONAME)
	ln -sf $(SHLIB_NAME) $(SHLIB_LINK)
	ln -sf $(SHLIB_NAME) $(SONAME)
	$(AR) cq $(PICNAME) `$(LORDER) $(SHLIB_OBJS) | $(TSORT)`
	$(LD) -x -shared -R$(SHLIBDIR) -soname $(SONAME) -o \
	    $(SHLIB_NAME) /usr/lib/crtbeginS.o --whole-archive \
	    $(PICNAME) /usr/lib/crtendS.o

install-shared:
	$(INSTALL) $(__INSTALL_ARGS) -m $(LIBMODE) $(SHLIB_NAME) $(LIBDIR)
	ln -sf $(SHLIB_NAME) $(LIBDIR)/$(SHLIB_LINK)
	ln -sf $(SHLIB_NAME) $(LIBDIR)/$(SONAME)

uninstall-shared:
	rm -f $(LIBDIR)/$(SHLIB_NAME)
	rm -f $(LIBDIR)/$(SHLIB_LINK)
	rm -f $(LIBDIR)/$(SONAME)

clean-shared:
	rm -f $(SHLIB_OBJS)
	rm -f $(SHLIB_NAME) $(SHLIB_LINK) $(SONAME) $(PICNAME)

endif
