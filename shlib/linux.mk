# $Id: linux.mk,v 1.14 2008/11/07 11:15:44 tho Exp $
#
# Linux

ifdef SHLIB

SHLIB_OBJS = $(OBJS:.o=.so)
SHLIB_MAJOR ?= 0
SHLIB_MINOR ?= 0

##
## automatic rules for shared objects
##
.SUFFIXES: .so $(ALL_EXTS)

$(foreach e,$(CXX_EXTS),$(addsuffix .so,$(e))):
	$(CXX) $(CPICFLAGS) -DPIC $(CXXFLAGS) -c $< -o $*.so

$(foreach e,$(C_EXTS),$(addsuffix .so,$(e))):
	$(CC) $(CPICFLAGS) -DPIC $(CFLAGS) -c $< -o $*.so

##
## set library naming vars
##
SHLIB_LINK ?= lib$(__LIB).so
SONAME ?= $(SHLIB_LINK).$(SHLIB_MAJOR)
SHLIB_NAME ?= $(SONAME).$(SHLIB_MINOR)

##
## build rules
##
all-shared: $(SHLIB_NAME)

$(SHLIB_NAME): $(SHLIB_OBJS)
	@$(ECHO) "===> building shared $(__LIB) library"
	$(RM) -f $(SHLIB_NAME) $(SHLIB_LINK)
	ln -sf $(SHLIB_NAME) $(SHLIB_LINK)
	$(__CC) -shared -Wl,-soname,$(SONAME) \
	    -o $(SHLIB_NAME) \
	    `$(LORDER) $(SHLIB_OBJS) | $(TSORT)` $(LDADD) $(LDFLAGS)

$(SHLIBDIR):
	$(MKINSTALLDIRS) "$(SHLIBDIR)"
ifneq ($(strip $(__CHOWN_ARGS)),)
	chown $(__CHOWN_ARGS) "$(SHLIBDIR)"
endif

install-shared: $(SHLIBDIR)
	$(INSTALL) $(__INSTALL_ARGS) -m $(LIBMODE) $(SHLIB_NAME) "$(SHLIBDIR)"
	ln -sf $(SONAME) "$(SHLIBDIR)/$(SHLIB_LINK)"
	ln -sf $(SHLIB_NAME) "$(SHLIBDIR)/$(SONAME)"

uninstall-shared:
	$(RM) -f "$(SHLIBDIR)/$(SHLIB_NAME)"
	$(RM) -f "$(SHLIBDIR)/$(SHLIB_LINK)"
	$(RM) -f "$(SHLIBDIR)/$(SONAME)"
	-rmdir "$(SHLIBDIR)" 2>/dev/null

clean-shared:
	$(RM) -f $(SHLIB_OBJS)
	$(RM) -f $(SHLIB_NAME) $(SHLIB_LINK)

endif
