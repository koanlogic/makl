#
# $Id: common.mk,v 1.8 2007/07/03 13:33:27 tho Exp $
#
# Common include, to be placed on top of your Makefile, so that the following
# includes and variables' settings can override toolchain and map values.

MAKL_ETC ?= ../etc

include $(MAKL_ETC)/toolchain.mk
include ../etc/map.mk

# prepend RELOC variable if set on 'install' target
#ifeq ($(MAKECMDGOALS), install)
#    ifneq ($(RELOC),) 
#        $(warning RELOC has been set: prepending $(RELOC) to all *DIRS)
#        DESTDIR  := $(RELOC)$(DESTDIR)
#        BINDIR   := $(RELOC)$(BINDIR)
#        SBINDIR  := $(RELOC)$(SBINDIR)
#        CONFDIR  := $(RELOC)$(CONFDIR)
#        INCDIR   := $(RELOC)$(INCDIR)
#        LIBDIR   := $(RELOC)$(LIBDIR)
#        SHLIBDIR := $(RELOC)$(SHLIBDIR)
#        LIBEXDIR := $(RELOC)$(LIBEXDIR)
#        VARDIR   := $(RELOC)$(VARDIR)
#        SHAREDIR := $(RELOC)$(SHAREDIR)
#        MANDIR   := $(RELOC)$(MANDIR)
#        DOCDIR   := $(RELOC)$(DOCDIR)
#    endif
#endif
