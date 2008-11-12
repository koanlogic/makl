#
# $Id: prog.mk,v 1.48 2008/11/12 15:53:19 stewy Exp $
#
# User Variables:
# - USE_CXX     If defined use C++ compiler instead of C compiler
# - PROG        Program name
# - SRCS        Source files that build $(PROG)
# - LDADD       Library dependencies 
# - LDFLAGS     Flags to be passed to the linker
# - CLEANFILES  Additional clean files
# - BIN(OWN,GRP,MODE,DIR) Installation path and credentials
# - OBJDIR      Directory where compiled/linked files go
#
# Applicable targets:
# - all, clean, install, uninstall (depend and cleandend via priv/deps.mk).
#
include priv/funcs.mk

# check non-optional user variables (PROG and SRCS)
ifneq ($(MAKECMDGOALS), .help)
    $(call assert-var, PROG)
    $(call assert-var, SRCS)
endif

# always set an OBJDIR (defaulting to CURDIR)
ifndef OBJDIR
OBJDIR = $(CURDIR)
endif

# tell makl to go into the OBJDIR and restart itself (see priv/obj.mk for
# details): when re-invoked, the 'else' branch is entered, which contains all 
# the target rules with the 'right' VPATH settings
ifneq ($(notdir $(CURDIR)),$(notdir $(OBJDIR)))
include priv/obj.mk
else
# __SRCDIR has been set in obj.mk
VPATH = $(__SRCDIR)

# set complete PROG name
__PROG = $(strip $(PROG_PREFIX))$(strip $(PROG))$(strip $(PROG_SUFFIX))

ALL_EXTS = .c .cc .C .cpp .cxx .c++

# filter out all possible C/C++ extensions to get the objects from SRCS
OBJS = $(call calc-objs, $(SRCS), $(ALL_EXTS))
OBJS += $(EXTRA_OBJS)

# dependency chain
__LDS = $(PRE_LDADD) $(LDADD) $(POST_LDADD) $(LDFLAGS)

##
## all(build) target
##
ifndef NO_ALL
all: all-hook-pre $(__PROG) all-hook-post

all-hook-pre all-hook-post:

## linking stage
ifndef USE_CXX
$(__PROG): $(OBJS) $(LDADD)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(__LDS)
else
$(__PROG): $(OBJS) $(LDADD)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJS) $(__LDS)
endif

else
all:
endif

##
## clean target
##
ifndef NO_CLEAN
clean: clean-hook-pre realclean clean-hook-post

CLEANFILES += $(__PROG) $(OBJS)

realclean:
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
__CHOWN_ARGS = $(call calc-chown-args, $(BINOWN), $(BINGRP))
__INSTALL_ARGS = $(call calc-install-args, $(BINOWN), $(BINGRP))

$(BINDIR):
	$(MKINSTALLDIRS) $(BINDIR)
ifneq ($(strip $(__CHOWN_ARGS)),)
	chown $(__CHOWN_ARGS) $(BINDIR)
endif

realinstall: $(BINDIR)
ifneq ($(strip $(STRIP)),)
	$(STRIP) $(__PROG)
endif
	$(INSTALL) $(INSTALL_COPY) $(__INSTALL_ARGS) \
	    -m $(BINMODE) $(__PROG) $(BINDIR)

install-hook-pre install-hook-post:
else
install:
endif

##
## uninstall target
##
ifndef NO_UNINSTALL
uninstall: uninstall-hook-pre realuninstall uninstall-hook-post

realuninstall:
	rm -f $(BINDIR)/$(__PROG)
	-rmdir $(BINDIR) 2>/dev/null

uninstall-hook-pre uninstall-hook-post:
else
uninstall:
endif

include priv/deps.mk

##
## interface description
##
.help:
	@echo
	@echo "-------------------                                                 "
	@echo " Available targets                                                  "
	@echo "-------------------                                                 "
	@echo "all         build the executable (it's the default target)          "
	@echo "clean       remove the executable and intermediate objects          "
	@echo "install     install the program                                     "
	@echo "uninstall   remove the installed program                            "
	@echo "depend      write include and library dependencies to .depend       "
	@echo "cleandepend delete .depend file                                     "
	@echo
	@echo "Each target T given above has T-hook-pre and T-hook-post            "
	@echo "companion targets.  These (void) targets are at client's disposal   "
	@echo "and will always be called before and after the associated target    "
	@echo
	@echo "---------------------                                               "
	@echo " Available variables                                                "
	@echo "---------------------                                               "
	@echo "USE_CXX          if defined use C++ linker instead of C linker      "
	@echo "PROG             the executable program name                        "
	@echo "PROG_PREFIX      concatenate this as prefix to PROG                 "
	@echo "PROG_SUFFIX      concatenate this as postfix to PROG                "
	@echo "CFLAGS           flags given to the C compiler                      "
	@echo "CXXFLAGS         flags given to the C++ compiler                    "
	@echo "EXTRA_OBJS       other file objects that build the program          "
	@echo "LDADD            library dependencies                               "
	@echo "LDFLAGS          flags to be given to the linker                    "
	@echo "DPADD            additional build dependencies                      "
	@echo "CLEANFILES       additional clean files (use +=)                    "
	@echo "DISTCLEANFILES   additional files to be removed when 'distclean'ing "
	@echo "BINOWN           user ID of the installed executable                "
	@echo "BINGRP           group ID of the installed excutable                "
	@echo "BINMODE          file mode bits of the installed executable         "
	@echo "BINDIR           destination directory of the installed executable  "
	@echo "OBJDIR           directory where the compiled/linked objects go     "
	@echo
	@echo "If in doubt, check the source file at $(MAKL_DIR)/mk/prog.mk        "
	@echo

endif   #...
