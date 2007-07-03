#
# $Id: map.mk,v 1.4 2007/07/03 13:33:27 tho Exp $
#
# Default pathnames and credentials needed by install targets.
# Change them at your convenience.

DESTDIR   ?= /
DEFOWN    ?=
DEFGRP    ?=
DEFMODE   ?= 444

BINDIR    ?= $(DESTDIR)/bin
BINOWN    ?= $(DEFOWN)
BINGRP    ?= $(DEFGRP)
BINMODE   ?= 555
NOBINMODE ?= $(DEFMODE)

SBINDIR   ?= $(DESTDIR)/sbin
SBINOWN   ?= $(DEFOWN)
SBINGRP   ?= $(DEFGRP)
SBINMODE  ?= $(BINMODE)

CONFDIR   ?= $(DESTDIR)/etc
CONFOWN   ?= $(DEFOWN)
CONFGRP   ?= $(DEFGRP)
CONFMODE  ?= $(NOBINMODE)

INCDIR    ?= $(DESTDIR)/include
INCOWN    ?= $(DEFOWN)
INCGRP    ?= $(DEFGRP)
INCMODE   ?= $(NOBINMODE)

LIBDIR    ?= $(DESTDIR)/lib
SHLIBDIR  ?= $(LIBDIR)
LIBOWN    ?= $(BINOWN)
LIBGRP    ?= $(BINGRP)
LIBMODE   ?= $(NOBINMODE)

LIBEXDIR  ?= $(DESTDIR)/libexec
LIBEXOWN  ?= $(DEFOWN)
LIBEXGRP  ?= $(DEFGRP)
LIBEXMODE ?= $(BINMODE)

VARDIR    ?= $(DESTDIR)/var
VAROWN    ?= $(DEFOWN)
VARGRP    ?= $(DEFGRP)
VARMODE   ?= $(NOBINMODE)

SHAREDIR  ?= $(DESTDIR)/share
SHAREOWN  ?= $(DEFOWN)
SHAREGRP  ?= $(DEFGRP)
SHAREMODE ?= $(NOBINMODE)

MANDIR    ?= $(SHAREDIR)/man
MANOWN    ?= $(SHAREOWN)
MANGRP    ?= $(SHAREGRP)
MANMODE   ?= $(NOBINMODE)

DOCDIR    ?= $(SHAREDIR)/doc
DOCOWN    ?= $(SHAREOWN)
DOCGRP    ?= $(SHAREGRP)
DOCMODE   ?= $(NOBINMODE)

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
