#
# $Id: prog.mk,v 1.3 2005/07/27 08:35:57 stewy Exp $
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
	${CC} ${CFLAGS} ${LDFLAGS} -o $@ ${OBJS} ${LDADD}

CLEANFILES += ${PROG} ${OBJS}

clean:
	rm -f ${CLEANFILES}

beforeinstall:
realinstall:
	${INSTALL} ${INSTALL_COPY} ${INSTALL_STRIP} -o ${BINOWN} -g ${BINGRP} \
	    -m ${BINMODE} ${PROG} ${DESTDIR}${BINDIR}

afterinstall:
install: beforeinstall realinstall afterinstall

uninstall:
	rm -f ${DESTDIR}${BINDIR}${PROG}
 

include map.mk
include toolchain.mk
include deps.mk
