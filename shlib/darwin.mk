# $Id: darwin.mk,v 1.2 2006/07/07 16:10:01 stewy Exp $
#
# Darwin 

ifdef SHLIB

SHLIB_OBJS = $(OBJS:.o=.so)
SHLIB_MAJOR ?= 0
SHLIB_MINOR ?= 0

#
# automatic rules for shared objects
#
.SUFFIXES: .so .c .cc .C .cpp .cxx

.c.so:
	$(CC) $(CPICFLAGS) -DPIC $(CFLAGS) -c $< -o $*.so

.cc.so .C.so .cpp.so .cxx.so:
	$(CXX) $(CPICFLAGS) -DPIC $(CXXFLAGS) -c $< -o $*.so

#
# set library naming vars (perhaps specific to OBJFORMAT)
#
ifeq ($(strip $(OBJFORMAT)), mach-o)
    SHLIB_NAME ?= lib$(_LIB).$(SHLIB_MAJOR).dylib
    SHLIB_LINK ?= lib$(_LIB).dylib
else
ifeq ($(strip $(OBJFORMAT)), elf)
    SHLIB_LINK ?= lib$(_LIB).so
    SONAME ?= $(SHLIB_LINK).$(SHLIB_MAJOR)
    SHLIB_NAME ?= $(SONAME).$(SHLIB_MINOR)
else
    $(error OBJFORMAT must be one of mach-o or elf on darwin platform)
endif
endif

#
# build rules
#
all-shared: $(SHLIB_NAME)

$(SHLIB_NAME): $(SHLIB_OBJS)
	@echo "===> building shared $(_LIB) library"
	rm -f $(SHLIB_NAME) $(SHLIB_LINK)
	ln -sf $(SHLIB_NAME) $(SHLIB_LINK)
ifeq ($(strip $(OBJFORMAT)), mach-o)
	$(CC) ${LDFLAGS} -dynamiclib -o $(SHLIB_NAME) $(SHLIB_OBJS) $(LDADD)
else
ifeq ($(strip $(OBJFORMAT)), elf)
	$(CC) ${LDFLAGS} -shared -o $(SHLIB_NAME) -Wl,-soname,$(SONAME) \
	    `$(LORDER) $(SHLIB_OBJS) | $(TSORT)` $(LDADD)
endif
endif

install-shared:
	$(INSTALL) $(_INSTALL_ARGS) -m $(LIBMODE) $(SHLIB_NAME) $(LIBDIR)
	ln -sf $(SHLIB_NAME) $(LIBDIR)/$(SHLIB_LINK)

uninstall-shared:
	rm -f $(LIBDIR)/$(SHLIB_NAME)
	rm -f $(LIBDIR)/$(SHLIB_LINK)

clean-shared:
	rm -f $(SHLIB_OBJS)
	rm -f $(SHLIB_NAME) $(SHLIB_LINK)

endif
