# $Id: dragonfly.mk,v 1.1 2008/11/07 10:43:06 tho Exp $
#
# DragonFly

ifdef SHLIB

SHLIB_OBJS = $(OBJS:.o=.so)
SHLIB_MAJOR ?= 0
SHLIB_MINOR ?= 0

##
## Automatic rules for shared objects.
##
.SUFFIXES: .so $(ALL_EXTS)

$(foreach e,$(CXX_EXTS),$(addsuffix .so,$(e))):
	$(CXX) $(CPICFLAGS) -DPIC $(CXXFLAGS) -c $< -o $*.so

$(foreach e,$(C_EXTS),$(addsuffix .so,$(e))):
	$(CC) $(CPICFLAGS) -DPIC $(CFLAGS) -c $< -o $*.so

##
## Set library naming vars
##
SHLIB_LINK ?= lib$(__LIB).so
SONAME ?= $(SHLIB_LINK).$(SHLIB_MAJOR)
SHLIB_NAME ?= $(SONAME)

##
## build rules
##
all-shared: $(SHLIB_NAME)

$(SHLIB_NAME): $(SHLIB_OBJS)
	@echo "===> building shared $(__LIB) library"
	rm -f $(SHLIB_NAME) $(SHLIB_LINK)
	ln -sf $(SHLIB_NAME) $(SHLIB_LINK)
	$(__CC) -shared -Wl,-soname,$(SONAME) \
	    -o $(SHLIB_NAME) \
	    `$(LORDER) $(SHLIB_OBJS) | $(TSORT)` $(LDADD) ${LDFLAGS} 

install-shared:
	$(INSTALL) $(__INSTALL_ARGS) -m $(LIBMODE) $(SHLIB_NAME) $(SHLIBDIR)
	ln -sf $(SHLIB_NAME) $(SHLIBDIR)/$(SHLIB_LINK)

uninstall-shared:
	rm -f $(SHLIBDIR)/$(SHLIB_NAME)
	rm -f $(SHLIBDIR)/$(SHLIB_LINK)
	-rmdir $(SHLIBDIR) 2>/dev/null

clean-shared:
	rm -f $(SHLIB_OBJS)
	rm -f $(SHLIB_NAME) $(SHLIB_LINK)

endif
