# $Id: openbsd.mk,v 1.9 2008/11/07 05:52:54 tho Exp $
#
# OpenBSD

ifdef SHLIB

SHLIB_OBJS = $(OBJS:.o=.so)
SHLIB_MAJOR ?= 0
SHLIB_MINOR ?= 0

##
## automatic rules for shared objects
##
.SUFFIXES: .so $(ALL_EXTS)

$(foreach e,$(C_EXTS),$(addsuffix .so,$(e))):
	$(CC) -fpic -DPIC $(CFLAGS) -c $< -o $*.so.o
	$(LD) -X -r $*.so.o -o $*.so
	$(RM) $*.so.o

$(foreach e,$(CXX_EXTS),$(addsuffix .so,$(e))):
	$(CXX) -fpic -DPIC $(CXXFLAGS) -c $< -o $*.so.o
	$(LD) -X -r $*.so.o -o $*.so
	$(RM) $*.so.o

SHLIB_NAME ?= lib$(__LIB).so.$(SHLIB_MAJOR).$(SHLIB_MINOR)

##
## build rules
##
all-shared: $(SHLIB_NAME)

$(SHLIB_NAME): $(SHLIB_OBJS)
	@$(ECHO) "===> building shared $(__LIB) library"
	$(RM) $(SHLIB_NAME)
	$(__CC) -shared -fpic -o $(SHLIB_NAME) `$(LORDER) $(SHLIB_OBJS) | $(TSORT)`

install-shared:
	$(INSTALL) $(__INSTALL_ARGS) -m $(LIBMODE) $(SHLIB_NAME) "$(SHLIBDIR)"

uninstall-shared:
	$(RM) "$(SHLIBDIR)/$(SHLIB_NAME)"
	-rmdir "$(SHLIBDIR)" 2>/dev/null

clean-shared:
	$(RM) $(SHLIB_OBJS)
	$(RM) $(SHLIB_NAME)

endif
