# $Id: lib.mk,v 1.54 2008/10/21 14:44:12 tho Exp $
#
# User variables:
# - LIB         The name of the library that shall be built.
# - SHLIB       If set, shared libraries are also built
# - CLEANFILES  Additional files that must be removed on clean target.
# - CFLAGS      Compiler flags.
# - CPICFLAGS   Shared libs extra compiler flags
# - LIBOWN, LIBGRP, LIBMODE   Installation credentials.
# - OBJDIR      Directory where compiled/linked files go
#
# Applicable targets:
# - all, clean, depend, cleandepend, install, uninstall.

include priv/funcs.mk

# check non-optional user variables (LIB and SRCS)
ifneq ($(MAKECMDGOALS), .help)
    $(call assert-var, LIB)
    $(call assert-var, SRCS)
endif

ifndef OBJDIR
OBJDIR = $(CURDIR)
endif

ifneq ($(notdir $(CURDIR)),$(notdir $(OBJDIR)))
include priv/obj.mk
else
VPATH = $(__SRCDIR)

# strip lib name (__LIB is exported to shlib.mk)
__LIB = $(strip $(LIB))
LIB_NAME = lib$(__LIB).a

# handled file extensions
C_EXTS = .c
CXX_EXTS = .cc .C .cpp .cxx .c++
ALL_EXTS = $(C_EXTS) $(CXX_EXTS)

# filter out all possible C/C++ extensions to get the objects from SRCS
OBJS = $(call calc-objs, $(SRCS), $(ALL_EXTS))
OBJS += $(EXTRA_OBJS)

##
## Default obj format is ELF
##
OBJFORMAT ?= elf

# automatic build rules
.SUFFIXES: .o $(ALL_EXTS)

# i.e. .c.o:
$(foreach e,$(C_EXTS),$(addsuffix .o,$(e))):
	$(CC) $(CFLAGS) -c $< -o $*.o

# use more compact old-fashioned suffix rules instead of implicit rules here
# .cc.o .C.o .cpp.o .cxx.o .c++.o:
$(foreach e,$(CXX_EXTS),$(addsuffix .o,$(e))):
	$(CXX) $(CXXFLAGS) -c $< -o $*.o

##
## all(build) target
##
ifndef NO_ALL
all: all-hook-pre all-static all-shared all-hook-post

all-static: $(LIB_NAME)

# always create archive ex-nihil
$(LIB_NAME): $(OBJS)
	@echo "===> building standard $(__LIB) library"
	rm -f $@
	$(AR) $(ARFLAGS) $@ `$(LORDER) $^ | $(TSORT)`
	$(RANLIB) $@

all-hook-pre all-hook-post:
else
all:
endif

##
## clean target
##
ifndef NO_CLEAN
clean: clean-hook-pre clean-static clean-shared clean-hook-post

CLEANFILES += $(OBJS) $(LIB_NAME)

clean-static:
	rm -f $(CLEANFILES)

clean-hook-pre clean-hook-post:
else
clean:
endif

##
## distclean target
##
include distclean.mk

##
## install target
##
ifndef NO_INSTALL
install: install-hook-pre realinstall install-hook-post

# build arguments list for 'realinstall' operation
__CHOWN_ARGS = $(call calc-chown-args, $(LIBOWN), $(LIBGRP))
__INSTALL_ARGS = $(call calc-install-args, $(LIBOWN), $(LIBGRP))

$(LIBDIR):
	$(MKINSTALLDIRS) $(LIBDIR)
ifneq ($(strip $(__CHOWN_ARGS)),)
	chown $(__CHOWN_ARGS) $(LIBDIR)
endif

realinstall: $(LIBDIR) install-static install-shared

install-static:
	$(INSTALL) $(__INSTALL_ARGS) -m $(LIBMODE) $(LIB_NAME) $(LIBDIR)

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
	rm -f $(LIBDIR)/$(LIB_NAME)
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
	@echo "---------------------                                               "
	@echo " Available variables                                                "
	@echo "---------------------                                               "
	@echo "LIB              the library name                                   "
	@echo "DPADD            additional build dependencies                      "
	@echo "CLEANFILES       additional clean files (use +=)                    "
	@echo "DISTCLEANFILES   additional files to be removed when 'distclean'ing "
	@echo "CFLAGS           flags to be supplied to the C compiler             "
	@echo "CXXFLAGS         flags supplied to be supplied to the C++ compiler  "
	@echo "EXTRA_OBJS       other file objects that build the library          "
	@echo "LIBOWN           user ID of the installed executable                "
	@echo "LIBGRP           group ID of the installed excutable                "
	@echo "LIBMODE          file mode bits of the installed executable         "
	@echo "LIBDIR           destination directory of the installed executable  "
	@echo "SHLIB            if set shared library will also be built           "
	@echo "OBJDIR           directory where the compiled/linked objects go     "
	@echo
	@echo "The following flags are available only if SHLIB is set:             "
	@echo "SHLIB_MAJOR   shared library major number (i.e. the 1 in 1.2.3)     "
	@echo "SHLIB_MINOR   shared library minor number (i.e. the 2 in 1.2.3)     "
	@echo "SHLIB_TEENY   shared library teeny number (i.e. the 3 in 1.2.3)     "
	@echo "CPICFLAGS     extra compiler flags (Linux, Darwin, FreeBSD)         "
	@echo "BUNDLE        (Darwin only) build a loadable module instead         "
	@echo "SHLIB_LDFLAGS flags to be supplied to the linker (Darwin, use +=)   "
	@echo "SHLIB_NAME    complete name of the shared library or bundle         "
	@echo "SONAME        shared object name (all but Darwin)                   "
	@echo "SHLIB_LINK    link name (all but Darwin)                            "
	@echo "SHLIB_LINK1   first link name (Darwin only)                         "
	@echo "SHLIB_LINK2   second link name (Darwin only)                        "
	@echo "PICNAME       name of the pic archive (NetBSD only)                 "
	@echo
	@echo "If in doubt, check the source file at $(MAKL_DIR)/mk/lib.mk         "
	@echo

endif
