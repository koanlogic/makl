# $Id: lib.mk,v 1.19 2006/06/22 18:52:55 tho Exp $
#
# User variables:
# - LIB         The name of the library that shall be built.
# - SHLIB       If set, shared libraries are also built
# - CLEANFILES  Additional files that must be removed on clean target.
# - CFLAGS      Compiler flags.
# - CPICFLAGS   Shared libs extra compiler flags
# - LIBOWN, LIBGRP, LIBMODE   Installation credentials.
#
# Applicable targets:
# - all, clean, install, uninstall.
#
# TODO: profiled and special PIC libs (i.e. PIC archives)

include ../etc/map.mk

# filter out all possible C/C++ extensions to get the objects from SRCS
OBJS_c = $(SRCS:.c=.o)
OBJS_cpp = $(OBJS_c:.cpp=.o)
OBJS_cc = $(OBJS_cpp:.cc=.o)
OBJS_cxx = $(OBJS_cc:.cxx=.o)
OBJS_C = $(OBJS_cxx:.C=.o)
OBJS = $(OBJS_C)

OBJFORMAT ?= elf

# strip lib name
_LIB = $(strip $(LIB))

# by default just do static libs
_LIBS = lib$(_LIB).a

# when the user defines SHLIB in its Makefile, shared libs are also built,
# various shlib variables are set depending on the platform executable format:
ifdef SHLIB
SHLIB_OBJS = $(OBJS:.o=.so)
SHLIB_MAJOR ?= 0
SHLIB_MINOR ?= 0
ifeq ($(strip $(OBJFORMAT)), mach-o)
    SHLIB_NAME ?= lib$(_LIB).$(SHLIB_MAJOR).dylib
    SHLIB_LINK ?= lib$(_LIB).dylib
else 
ifeq ($(strip $(OBJFORMAT)), elf)
    SHLIB_LINK ?= lib$(_LIB).so
    SONAME ?= $(SHLIB_LINK).$(SHLIB_MAJOR)
    SHLIB_NAME ?= $(SONAME).$(SHLIB_MINOR)
else 
ifeq ($(strip $(OBJFORMAT)), aout)
    SHLIB_LINK ?= lib$(_LIB).so
    SHLIB_NAME ?= $(SHLIB_LINK).$(SHLIB_MAJOR).$(SHLIB_MINOR)
else
    $(error OBJFORMAT must be one of mach-o, elf or aout)
endif
endif
endif

# add the shared library to the list of libraries that we need to build
_LIBS += $(SHLIB_NAME)
endif

.SUFFIXES: .o .so .c .cc .C .cpp .cxx

.c.o:
	$(CC) $(CFLAGS) -c $< -o $*.o

.c.so:
	$(CC) $(CPICFLAGS) -DPIC $(CFLAGS) -c $< -o $*.so

.cc.o .C.o .cpp.o .cxx.o:
	$(CXX) $(CXXFLAGS) -c $< -o $*.o

.cc.so .C.so .cpp.so .cxx.so:
	$(CXX) $(CPICFLAGS) -DPIC $(CXXFLAGS) -c $< -o $*.so

all: $(_LIBS)

lib$(_LIB).a: $(OBJS)
	@echo "===> building standard $(_LIB) library"
	rm -f lib$(_LIB).a
	$(AR) $(ARFLAGS) lib$(_LIB).a `$(LORDER) $(OBJS) | $(TSORT)`
	$(RANLIB) lib$(_LIB).a

$(SHLIB_NAME): $(SHLIB_OBJS)
	@echo "===> building shared $(_LIB) library"
	rm -f $(SHLIB_NAME) $(SHLIB_LINK)
	ln -sf $(SHLIB_NAME) $(SHLIB_LINK)
ifeq ($(strip $(OBJFORMAT)), mach-o)
	$(CC) -dynamiclib -o $(SHLIB_NAME) $(SHLIB_OBJS) $(LDADD)
else
ifeq ($(strip $(OBJFORMAT)), elf)
	$(CC) -shared -o $(SHLIB_NAME) -Wl,-soname,$(SONAME) \
	    `$(LORDER) $(SHLIB_OBJS) | $(TSORT)` $(LDADD)
else
ifeq ($(strip $(OBJFORMAT)), aout)
	$(CC) -shared -Wl,-x,-assert,pure-text \
	    -o $(SHLIB_NAME) \
	    `$(LORDER) $(SHLIB_OBJS) | $(TSORT)` $(LDADD)
endif
endif
endif

clean:
	rm -f $(OBJS) $(SHLIB_OBJS) $(CLEANFILES)
	rm -f lib$(_LIB).a
	rm -f $(SHLIB_NAME) $(SHLIB_LINK)

# build arguments list for '(before,real)install' operations
_CHOWN_ARGS =
_INSTALL_ARGS =
ifneq ($(strip $(LIBOWN)),)
    _CHOWN_ARGS = $(LIBOWN)
    _INSTALL_ARGS = -o $(LIBOWN) 
endif
ifneq ($(strip $(LIBGRP)),)
	_CHOWN_ARGS = $(join $(LIBOWN), :$(LIBGRP))
    _INSTALL_ARGS += -g $(LIBGRP) 
endif

beforeinstall:
	$(MKINSTALLDIRS) $(LIBDIR)
ifneq ($(strip $(_CHOWN_ARGS)),)
	chown $(_CHOWN_ARGS) $(LIBDIR)
endif

realinstall:
	$(INSTALL) $(_INSTALL_ARGS) -m $(LIBMODE) lib$(_LIB).a $(LIBDIR)
ifdef SHLIB
	$(INSTALL) $(_INSTALL_ARGS) -m $(LIBMODE) $(SHLIB_NAME) $(LIBDIR)
	ln -sf $(SHLIB_NAME) $(LIBDIR)/$(SHLIB_LINK)
endif

afterinstall:

install: beforeinstall realinstall afterinstall

uninstall:
	rm -f $(LIBDIR)/lib$(_LIB).a
	rm -f $(LIBDIR)/$(SHLIB_NAME)
	rm -f $(LIBDIR)/$(SHLIB_LINK)

include deps.mk
