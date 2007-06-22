#
# $Id: prog.mk,v 1.30 2007/06/22 08:15:32 tho Exp $
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
$(PROG): $(OBJS) $(LDADD)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(__LDS)
else
$(PROG): $(OBJS) $(LDADD)
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
install: install-hook-pre realinstall install-hook-post

include priv/funcs.mk
# build arguments list for 'realinstall' operation
__CHOWN_ARGS = $(call calc-chown-args, $(BINOWN), $(BINGRP))
__INSTALL_ARGS = $(call calc-install-args, $(BINOWN), $(BINGRP))

$(RELOC)$(BINDIR):
	$(MKINSTALLDIRS) $(RELOC)$(BINDIR)
ifneq ($(strip $(__CHOWN_ARGS)),)
	chown $(__CHOWN_ARGS) $(RELOC)$(BINDIR)
endif

realinstall: $(RELOC)$(BINDIR)
	$(INSTALL) $(INSTALL_COPY) $(INSTALL_STRIP) $(__INSTALL_ARGS) \
	    -m $(BINMODE) $(PROG) $(RELOC)$(BINDIR)

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
	rm -f $(RELOC)$(BINDIR)/$(PROG)
	-rmdir $(RELOC)$(BINDIR) 2>/dev/null

uninstall-hook-pre uninstall-hook-post:
else
uninstall:
endif

include priv/deps.mk
