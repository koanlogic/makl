# $Id: lib.mk,v 1.31 2006/12/09 19:35:25 tho Exp $
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
# - all, clean, depend, cleandepend, install, uninstall.

include ../etc/map.mk

# strip lib name
__LIB = $(strip $(LIB))

# filter out all possible C/C++ extensions to get the objects from SRCS
OBJS_c = $(SRCS:.c=.o)
OBJS_cpp = $(OBJS_c:.cpp=.o)
OBJS_cc = $(OBJS_cpp:.cc=.o)
OBJS_cxx = $(OBJS_cc:.cxx=.o)
OBJS_C = $(OBJS_cxx:.C=.o)
OBJS = $(OBJS_C)

##
## Default obj format is ELF
##
OBJFORMAT ?= elf

# automatic build rules
.SUFFIXES: .o .c .cc .C .cpp .cxx

.c.o:
	$(CC) $(CFLAGS) -c $< -o $*.o

.cc.o .C.o .cpp.o .cxx.o:
	$(CXX) $(CXXFLAGS) -c $< -o $*.o

##
## all(build) target
##
ifndef NO_ALL
all: all-hook-pre all-static all-shared all-hook-post

all-static: lib$(__LIB).a

lib$(__LIB).a: $(OBJS)
	@echo "===> building standard $(__LIB) library"
	rm -f lib$(__LIB).a
	$(AR) $(ARFLAGS) lib$(__LIB).a `$(LORDER) $(OBJS) | $(TSORT)`
	$(RANLIB) lib$(__LIB).a

all-hook-pre all-hook-post:
else
all:
endif

##
## clean target
##
ifndef NO_CLEAN
clean: clean-hook-pre clean-static clean-shared clean-hook-post

CLEANFILES += $(OBJS) lib$(__LIB).a

clean-static:
	rm -f $(CLEANFILES)

clean-hook-pre clean-hook-post:
else
clean:
endif

##
## install target
##
ifndef NO_INSTALL
install: install-hook-pre realinstall install-hook-post

# build arguments list for 'realinstall' operation
include priv/funcs.mk
__CHOWN_ARGS = $(call calc-chown-args, $(LIBOWN), $(LIBGRP))
__INSTALL_ARGS = $(call calc-install-args, $(LIBOWN), $(LIBGRP))

$(LIBDIR):
	$(MKINSTALLDIRS) $(LIBDIR)
ifneq ($(strip $(__CHOWN_ARGS)),)
	chown $(__CHOWN_ARGS) $(LIBDIR)
endif

realinstall: $(LIBDIR) install-static install-shared

install-static:
	$(INSTALL) $(__INSTALL_ARGS) -m $(LIBMODE) lib$(__LIB).a $(LIBDIR)

install-hook-pre install-hook-post:

else
install:
endif

##
## uninstall target
##
ifndef NO_INSTALL
uninstall: uninstall-hook-pre realuninstall uninstall-hook-post

realuninstall: uninstall-static uninstall-shared

uninstall-static:
	rm -f $(LIBDIR)/lib$(__LIB).a
	-rmdir $(LIBDIR) 2>/dev/null

uninstall-hook-pre uninstall-hook-post:

else
uninstall:
endif

##
## Shared library trampoline.
## If the user defines SHLIB in its Makefile, shared libs are also built.
## If SHLIB is defined, the shlib targets must be set in the platform 
## specific shlib.mk file.
##
ifndef SHLIB
all-shared install-shared uninstall-shared clean-shared: 
endif

## Prepare the compiler used for the shared lib ld stage.
## This is user driven: if the USE_CXX variable is set in the parent Makefile,
## then the C++ compiler will be used, otherwise plain C compiler 
## This is probably a gcc-ism - needs a closer look with another (non-GNU) 
## toolchain.
__CC = $(if $(strip $(USE_CXX)), $(CXX), $(CC))

include priv/shlib.mk
include priv/deps.mk
