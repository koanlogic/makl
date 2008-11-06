# handle install relocation via RELOC; also sanitize path names created by cf 
# (this file is automatically included by Makefile.conf)
# 
# $Id: reloc.mk,v 1.3 2008/11/06 09:29:34 tho Exp $

# prepend RELOC variable if set on '*install*' target
ifneq (, $(findstring install, $(MAKECMDGOALS)))
    ifneq ($(RELOC),)
        $(warning RELOC has been set: prepending $(RELOC) to all *DIRS)
    endif
    DESTDIR  := "$(RELOC)$(DESTDIR)"
    BINDIR   := "$(RELOC)$(BINDIR)"
    SBINDIR  := "$(RELOC)$(SBINDIR)"
    CONFDIR  := "$(RELOC)$(CONFDIR)"
    INCDIR   := "$(RELOC)$(INCDIR)"
    LIBDIR   := "$(RELOC)$(LIBDIR)"
    SHLIBDIR := "$(RELOC)$(SHLIBDIR)"
    LIBEXDIR := "$(RELOC)$(LIBEXDIR)"
    VARDIR   := "$(RELOC)$(VARDIR)"
    SHAREDIR := "$(RELOC)$(SHAREDIR)"
    MANDIR   := "$(RELOC)$(MANDIR)"
    DOCDIR   := "$(RELOC)$(DOCDIR)"
else    # on any other target, in case pathname contains holes, wrap it
    DESTDIR  := "$(DESTDIR)"
    BINDIR   := "$(BINDIR)"
    SBINDIR  := "$(SBINDIR)"
    CONFDIR  := "$(CONFDIR)"
    INCDIR   := "$(INCDIR)"
    LIBDIR   := "$(LIBDIR)"
    SHLIBDIR := "$(SHLIBDIR)"
    LIBEXDIR := "$(LIBEXDIR)"
    VARDIR   := "$(VARDIR)"
    SHAREDIR := "$(SHAREDIR)"
    MANDIR   := "$(MANDIR)"
    DOCDIR   := "$(DOCDIR)"
endif
