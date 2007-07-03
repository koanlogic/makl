# handle install relocation (automatically included by Makefile.conf)
#
# $Id: reloc.mk,v 1.1 2007/07/03 14:50:52 tho Exp $

# prepend RELOC variable if set on 'install' target
ifeq ($(MAKECMDGOALS), install)
    ifneq ($(RELOC),)
        $(warning RELOC has been set: prepending $(RELOC) to all *DIRS)
        DESTDIR  := $(RELOC)$(DESTDIR)
        BINDIR   := $(RELOC)$(BINDIR)
        SBINDIR  := $(RELOC)$(SBINDIR)
        CONFDIR  := $(RELOC)$(CONFDIR)
        INCDIR   := $(RELOC)$(INCDIR)
        LIBDIR   := $(RELOC)$(LIBDIR)
        SHLIBDIR := $(RELOC)$(SHLIBDIR)
        LIBEXDIR := $(RELOC)$(LIBEXDIR)
        VARDIR   := $(RELOC)$(VARDIR)
        SHAREDIR := $(RELOC)$(SHAREDIR)
        MANDIR   := $(RELOC)$(MANDIR)
        DOCDIR   := $(RELOC)$(DOCDIR)
    endif
endif
