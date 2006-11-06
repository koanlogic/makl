# $Id: lib.mk,v 1.24 2006/11/06 09:37:01 tho Exp $
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

all: all-hook-pre all-static all-shared all-hook-post

# if SHLIB is defined, all these targets must be set in shlib.mk
ifndef SHLIB
all-shared:
install-shared:
uninstall-shared:
clean-shared:
endif

# filter out all possible C/C++ extensions to get the objects from SRCS
OBJS_c = $(SRCS:.c=.o)
OBJS_cpp = $(OBJS_c:.cpp=.o)
OBJS_cc = $(OBJS_cpp:.cc=.o)
OBJS_cxx = $(OBJS_cc:.cxx=.o)
OBJS_C = $(OBJS_cxx:.C=.o)
OBJS = $(OBJS_C)

# set compiler and flags
ifdef USE_CXX
    __CC = $(CXX)
    __CCFLAGS = $(CXXFLAGS)
else
    __CC = $(CC)
    __CCFLAGS = $(CFLAGS)
endif

# default obj format is ELF
OBJFORMAT ?= elf

# strip lib name
__LIB = $(strip $(LIB))

# when the user defines SHLIB in its Makefile, shared libs are also built,
# various shlib variables are set depending on the host platform.
include shlib.mk

.SUFFIXES: .o .c .cc .C .cpp .cxx

.c.o:
	$(CC) $(CFLAGS) -c $< -o $*.o

.cc.o .C.o .cpp.o .cxx.o:
	$(CXX) $(CXXFLAGS) -c $< -o $*.o

all-static: lib$(__LIB).a

all-hook-pre:
all-hook-post:

lib$(__LIB).a: $(OBJS)
	@echo "===> building standard $(__LIB) library"
	rm -f lib$(__LIB).a
	$(AR) $(ARFLAGS) lib$(__LIB).a `$(LORDER) $(OBJS) | $(TSORT)`
	$(RANLIB) lib$(__LIB).a

clean: clean-static clean-shared

clean-static:
	rm -f $(OBJS) $(CLEANFILES)
	rm -f lib$(__LIB).a

# build arguments list for '(before,real)install' operations
include priv/funcs.mk
__CHOWN_ARGS = $(call calc-chown-args, $(LIBOWN), $(LIBGRP))
__INSTALL_ARGS = $(call calc-install-args, $(LIBOWN), $(LIBGRP))

beforeinstall:
	$(MKINSTALLDIRS) $(LIBDIR)
ifneq ($(strip $(__CHOWN_ARGS)),)
	chown $(__CHOWN_ARGS) $(LIBDIR)
endif

realinstall: install-static install-shared

install-static:
	$(INSTALL) $(__INSTALL_ARGS) -m $(LIBMODE) lib$(__LIB).a $(LIBDIR)

# hook target
afterinstall:

install: beforeinstall realinstall afterinstall

uninstall: uninstall-static uninstall-shared

uninstall-static:
	rm -f $(LIBDIR)/lib$(__LIB).a

include deps.mk

# XXX A.OUT naming conventions
### ifeq ($(strip $(OBJFORMAT)), aout)
###    SHLIB_LINK ?= lib$(__LIB).so
###    SHLIB_NAME ?= $(SHLIB_LINK).$(SHLIB_MAJOR).$(SHLIB_MINOR)
