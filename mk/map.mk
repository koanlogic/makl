#
# $Id: map.mk,v 1.2 2005/07/26 08:24:19 tho Exp $
#
# Default pathnames and credentials needed by install targets.
# Change them at your convenience.

DESTDIR   ?= /
DEFOWN    ?= root
DEFGRP    ?= wheel
DEFMODE   ?= 444

BINDIR    ?= /bin/
BINOWN    ?= ${DEFOWN}
BINGRP    ?= ${DEFGRP}
BINMODE   ?= 555
NOBINMODE ?= ${DEFMODE}

INCDIR    ?= /usr/include/
INCOWN    ?= ${DEFOWN}
INCGRP    ?= ${DEFGRP}
INCMODE   ?= ${DEFMODE}

LIBDIR    ?= /usr/lib/
SHLIBDIR  ?= ${LIBDIR}
LIBOWN    ?= ${BINOWN}
LIBGRP    ?= ${BINGRP}
LIBMODE   ?= ${NOBINMODE}

SHAREDIR  ?= /usr/share/
SHAREOWN  ?= ${DEFOWN} 
SHAREGRP  ?= ${DEFGRP}
SHAREMODE ?= ${NOBINMODE}

MANDIR    ?= ${SHAREDIR}/man/
MANOWN    ?= ${SHAREOWN}
MANGRP    ?= ${SHAREGRP}
MANMODE   ?= ${NOBINMODE}

DOCDIR    ?= ${SHAREDIR}/doc/
DOCOWN    ?= ${SHAREOWN}
DOCGRP    ?= ${SHAREGRP}
DOCMODE   ?= ${NOBINMODE}
