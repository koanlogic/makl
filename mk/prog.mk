#
# $Id: prog.mk,v 1.7 2005/10/03 13:52:37 stewy Exp $
#
# User Variables:
# - PROG        Program name.
# - OBJS        File objects that build the program.
# - LDADD       Library dependencies ...
# - LDFLAGS     ...
# - CLEANFILES  Additional clean files.
# - BIN{OWN,GRP,MODE,DIR} installation path and credentials ...
# - DESTDIR     Base installation directory.
#
# Applicable targets:
# - all, clean, install, uninstall.
#

OBJS = ${patsubst %.c,%.o,${SRCS}}

${PROG}: ${OBJS}
	${CC} ${CFLAGS} ${LDFLAGS} -o $@ ${OBJS} ${PRE_LDADD} ${LDADD} ${POST_LDADD}

CLEANFILES += ${PROG} ${OBJS}

clean:
	rm -f ${CLEANFILES}

beforeinstall:
	${MKINSTALLDIRS} ${BINDIR} && chown ${BINOWN}:${BINGRP} ${BINDIR}

realinstall:
	${INSTALL} ${INSTALL_COPY} ${INSTALL_STRIP} -o ${BINOWN} -g ${BINGRP} \
	    -m ${BINMODE} ${PROG} ${BINDIR}

afterinstall:

install: beforeinstall realinstall afterinstall

uninstall:
	rm -f ${BINDIR}/${PROG}

include ../etc/map.mk
include ../etc/toolchain.mk
include deps.mk
