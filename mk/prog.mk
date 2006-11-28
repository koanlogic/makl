#
# $Id: prog.mk,v 1.25 2006/11/28 15:26:24 tho Exp $
#
# User Variables:
# - USE_CXX     If defined use C++ compiler instead of C compiler
# - PROG        Program name.
# - OBJS        File objects that build the program.
# - LDADD       Library dependencies ...
# - LDFLAGS     ...
# - CLEANFILES  Additional clean files.
# - BIN(OWN,GRP,MODE,DIR) installation path and credentials ...
#
# Applicable targets:
# - all, clean, install, uninstall (depend and cleandend via priv/deps.mk).
#

include ../etc/map.mk

# filter out all possible C/C++ extensions to get the objects from SRCS
OBJS_c = $(SRCS:.c=.o)
OBJS_cpp = $(OBJS_c:.cpp=.o)
OBJS_cc = $(OBJS_cpp:.cc=.o)
OBJS_cxx = $(OBJS_cc:.cxx=.o)
OBJS_C = $(OBJS_cxx:.C=.o)
OBJS = $(OBJS_C)

__LDS = $(PRE_LDADD) $(LDADD) $(POST_LDADD) $(LDFLAGS)

##
## all(build) target
##
ifndef NO_ALL
all: all-hook-pre $(PROG) all-hook-post

all-hook-pre all-hook-post:

## linking stage
ifndef USE_CXX
$(PROG): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(__LDS)
else
$(PROG): $(OBJS)
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

CLEANFILES += $(PROG) $(OBJS)

realclean:
	rm -f $(CLEANFILES)

clean-hook-pre clean-hook-post:
else
clean:
endif

##
## install target
## 
ifndef NO_INSTALL
install: install-hook-pre install-dir-setup realinstall install-hook-post

include priv/funcs.mk
# build arguments list for '(before,real)install' operations
__CHOWN_ARGS = $(call calc-chown-args, $(BINOWN), $(BINGRP))
__INSTALL_ARGS = $(call calc-install-args, $(BINOWN), $(BINGRP))

install-dir-setup:
	$(MKINSTALLDIRS) $(BINDIR)
ifneq ($(strip $(__CHOWN_ARGS)),)
	chown $(__CHOWN_ARGS) $(BINDIR)
endif

realinstall:
	$(INSTALL) $(INSTALL_COPY) $(INSTALL_STRIP) $(__INSTALL_ARGS) \
	    -m $(BINMODE) $(PROG) $(BINDIR)

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
	rm -f $(BINDIR)/$(PROG)

uninstall-hook-pre uninstall-hook-post:
else
uninstall:
endif

include priv/deps.mk
