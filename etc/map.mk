#
# $Id: map.mk,v 1.1 2005/10/03 13:52:37 stewy Exp $
#
# Default pathnames and credentials needed by install targets.
# Change them at your convenience.

DESTDIR   ?= /
DEFOWN    ?= root
DEFGRP    ?= wheel
DEFMODE   ?= 444

BINDIR    ?= ${DESTDIR}/bin
BINOWN    ?= ${DEFOWN}
BINGRP    ?= ${DEFGRP}
BINMODE   ?= 555
NOBINMODE ?= ${DEFMODE}

INCDIR    ?= ${DESTDIR}/include
INCOWN    ?= ${DEFOWN}
INCGRP    ?= ${DEFGRP}
INCMODE   ?= ${DEFMODE}

LIBDIR    ?= ${DESTDIR}/lib
SHLIBDIR  ?= ${LIBDIR}
LIBOWN    ?= ${BINOWN}
LIBGRP    ?= ${BINGRP}
LIBMODE   ?= ${NOBINMODE}

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
