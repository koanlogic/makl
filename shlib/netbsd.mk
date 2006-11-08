# $Id: netbsd.mk,v 1.2 2006/11/08 14:40:15 tho Exp $
#
# NetBSD

ifdef SHLIB

SHLIB_OBJS = $(OBJS:.o=.so)
SHLIB_MAJOR ?= 0
SHLIB_MINOR ?= 0

# default object fmt
OBJFORMAT ?= elf

#
# automatic rules for shared objects
#
.SUFFIXES: .so .c .cc .C .cpp .cxx

.c.so:
	$(CC) -fpic -DPIC $(CFLAGS) -c $< -o $*.so

.cc.so .C.so .cpp.so .cxx.so:
	$(CXX) -fpic -DPIC $(CXXFLAGS) -c $< -o $*.so

#
# set library naming vars (perhaps specific to OBJFORMAT)
#
ifeq ($(strip $(OBJFORMAT)), aout)
    SHLIB_LINK ?= lib$(__LIB).so
    SHLIB_NAME ?= $(SHLIB_LINK).$(SHLIB_MAJOR).$(SHLIB_MINOR)
else
ifeq ($(strip $(OBJFORMAT)), elf)
    SHLIB_LINK ?= lib$(__LIB).so
    SONAME ?= $(SHLIB_LINK).$(SHLIB_MAJOR)
    SHLIB_NAME ?= $(SONAME).$(SHLIB_MINOR)
else
    $(error OBJFORMAT must be one of aout or elf on NetBSD platform)
endif
endif

#
# build rules
#
all-shared: $(SHLIB_NAME)

$(SHLIB_NAME): $(SHLIB_OBJS)
	@echo "===> building shared $(__LIB) library ($(OBJFORMAT))"
	rm -f $(SHLIB_NAME) $(SHLIB_LINK)
	ln -sf $(SHLIB_NAME) $(SHLIB_LINK)
ifeq ($(strip $(OBJFORMAT)), aout)
	$(CC) -shared -Wl,-x,-assert,pure-text \
	    -o $(SHLIB_NAME) \
	    `$(LORDER) $(SHLIB_OBJS) | $(TSORT)` $(LDADD) ${LDFLAGS} 
else
ifeq ($(strip $(OBJFORMAT)), elf)
	$(AR) cq lib$(__LIB)_pic.a `$(LORDER) $(SHLIB_OBJS) | $(TSORT)`
	$(LD) -x -shared -R$(SHLIBDIR) -soname $(SONAME) -o \
	    $(SHLIB_NAME) /usr/lib/crtbeginS.o --whole-archive \
	    lib$(__LIB)_pic.a /usr/lib/crtendS.o
endif
endif

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
	rm -f $(SHLIB_NAME) $(SHLIB_LINK)

endif
