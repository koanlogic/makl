#
# $Id: map.mk,v 1.3 2006/05/18 12:13:17 stewy Exp $
#
# Default pathnames and credentials needed by install targets.
# Change them at your convenience.

DESTDIR   ?= /
DEFOWN    ?=
DEFGRP    ?=
DEFMODE   ?= 444

BINDIR    ?= ${DESTDIR}/bin
BINOWN    ?= ${DEFOWN}
BINGRP    ?= ${DEFGRP}
BINMODE   ?= 555
NOBINMODE ?= ${DEFMODE}

SBINDIR   ?= ${DESTDIR}/sbin
SBINOWN   ?= ${DEFOWN}
SBINGRP   ?= ${DEFGRP}
SBINMODE  ?= ${BINMODE}

CONFDIR   ?= ${DESTDIR}/etc
CONFOWN   ?= ${DEFOWN}
CONFGRP   ?= ${DEFGRP}
CONFMODE  ?= ${NOBINMODE}

INCDIR    ?= ${DESTDIR}/include
INCOWN    ?= ${DEFOWN}
INCGRP    ?= ${DEFGRP}
INCMODE   ?= ${NOBINMODE}

LIBDIR    ?= ${DESTDIR}/lib
SHLIBDIR  ?= ${LIBDIR}
LIBOWN    ?= ${BINOWN}
LIBGRP    ?= ${BINGRP}
LIBMODE   ?= ${NOBINMODE}

LIBEXDIR  ?= ${DESTDIR}/libexec
LIBEXOWN  ?= ${DEFOWN}
LIBEXGRP  ?= ${DEFGRP}
LIBEXMODE ?= ${BINMODE}

VARDIR    ?= ${DESTDIR}/var
VAROWN    ?= ${DEFOWN}
VARGRP    ?= ${DEFGRP}
VARMODE   ?= ${NOBINMODE}

SHAREDIR  ?= ${DESTDIR}/share
SHAREOWN  ?= ${DEFOWN}
SHAREGRP  ?= ${DEFGRP}
SHAREMODE ?= ${NOBINMODE}

MANDIR    ?= ${SHAREDIR}/man
MANOWN    ?= ${SHAREOWN}
MANGRP    ?= ${SHAREGRP}
MANMODE   ?= ${NOBINMODE}

DOCDIR    ?= ${SHAREDIR}/doc
DOCOWN    ?= ${SHAREOWN}
DOCGRP    ?= ${SHAREGRP}
DOCMODE   ?= ${NOBINMODE}
