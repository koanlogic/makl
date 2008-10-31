# $Id: mingw.mk,v 1.1 2008/10/31 02:10:12 tho Exp $
#
# import __LIB, OBJS, OBJFORMAT from lib.mk
# export SHLIB_NAME to lib.mk 
# export CPICFLAGS, SHLIB_MAJOR, SHLIB_MINOR, SONAME to userspace
# export {all,install,uninstall,clean}-shared targets to lib.mk

ifdef SHLIB

SHLIB_OBJS = $(OBJS:.o=.so)

##
## automatic rules for shared objects
##
.SUFFIXES: .so $(ALL_EXTS)

$(foreach e,$(CXX_EXTS),$(addsuffix .so,$(e))):
	$(CXX) $(CPICFLAGS) -DBUILD_DLL $(CXXFLAGS) -c $< -o $*.so

$(foreach e,$(C_EXTS),$(addsuffix .so,$(e))):
	$(CC) $(CPICFLAGS) -DBUILD_DLL $(CFLAGS) -c $< -o $*.so

##
## set library naming vars
##
SHLIB_NAME ?= lib$(__LIB).dll

##
## build rules
##
all-shared: $(SHLIB_NAME)

$(SHLIB_NAME): $(SHLIB_OBJS)
	@echo "===> building dynamically linked library $(__LIB)"
	rm -f $(SHLIB_NAME)
	$(CC) -shared -Wl,--out-implib,lib$(__LIB).a -o $(SHLIB_NAME) \
	    `$(LORDER) $(SHLIB_OBJS) | $(TSORT)` $(LDADD) $(LDFLAGS) 

install-shared:
	$(INSTALL) $(__INSTALL_ARGS) -m $(LIBMODE) $(SHLIB_NAME) $(LIBDIR)

uninstall-shared:
	rm -f $(LIBDIR)/$(SHLIB_NAME)

clean-shared:
	rm -f $(SHLIB_OBJS)
	rm -f $(SHLIB_NAME)

endif
