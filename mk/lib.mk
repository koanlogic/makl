# $Id: lib.mk,v 1.42 2008/03/04 20:32:31 tho Exp $
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

include $(MAKL_ETC)/shlib.mk
include priv/deps.mk

##
## interface description
##
.help:
	@echo
	@echo "-------------------                                              "
	@echo " Available targets                                               "
	@echo "-------------------                                              "
	@echo "all         build the library (default target)                   "
	@echo "clean       remove the library and all intermediate objects      "
	@echo "install     install the library                                  "
	@echo "uninstall   remove the installed library                         "
	@echo "depend      write include and other library deps to .depend      "
	@echo "cleandepend delete .depend file                                  "
	@echo
	@echo "Each target T given above has T-hook-pre and T-hook-post         "
	@echo "companion targets.  These (void) targets are at client's disposal"
	@echo "and will always be called before and after the associated target "
	@echo
	@echo "The targets all, clean, install, uninstall also exist in -shared "
	@echo "flavour in case SHLIB is set."
	@echo
	@echo "---------------------                                            "
	@echo " Available variables                                             "
	@echo "---------------------                                            "
	@echo "LIB           the library name                                   "
	@echo "DPADD         additional build dependencies                      "
	@echo "CLEANFILES    additional clean files (use +=)                    "
	@echo "CFLAGS        flags to be supplied to the C compiler             "
	@echo "CXXFLAGS      flags supplied to be supplied to the C++ compiler  "
	@echo "LIBOWN        user ID of the installed executable                "
	@echo "LIBGRP        group ID of the installed excutable                "
	@echo "LIBMODE       file mode bits of the installed executable         "
	@echo "LIBDIR        destination directory of the installed executable  "
	@echo "SHLIB         if set shared library will also be built           "
	@echo
	@echo "The following flags are available only if SHLIB is set:          "
	@echo "SHLIB_MAJOR   shared library major number (i.e. the 1 in 1.2.3)  "
	@echo "SHLIB_MINOR   shared library minor number (i.e. the 2 in 1.2.3)  "
	@echo "SHLIB_TEENY   shared library teeny number (i.e. the 3 in 1.2.3)  "
	@echo "CPICFLAGS     extra compiler flags (Linux, Darwin, FreeBSD)      "
	@echo "BUNDLE        (Darwin only) build a loadable module instead      "
	@echo "SHLIB_LDFLAGS flags to be supplied to the linker (use +=)        "
	@echo "SHLIB_NAME    complete name of the shared library or bundle      "
	@echo "SONAME        shared object name (all but Darwin)                "
	@echo "SHLIB_LINK    link name (all but Darwin)                         "
	@echo "SHLIB_LINK1   first link name (Darwin only)                      "
	@echo "SHLIB_LINK2   second link name (Darwin only)                     "
	@echo "PICNAME       name of the pic archive (NetBSD only)              "
	@echo
	@echo "If in doubt, check the source file at $(MAKL_DIR)/mk/lib.mk      "
	@echo
