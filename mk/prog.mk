#
# $Id: prog.mk,v 1.4 2005/08/03 19:47:09 tho Exp $
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
	mkdir -p ${BINDIR} && chown ${BINOWN}:${BINGRP} ${BINDIR}

realinstall:
	${INSTALL} ${INSTALL_COPY} ${INSTALL_STRIP} -o ${BINOWN} -g ${BINGRP} \
	    -m ${BINMODE} ${PROG} ${BINDIR}

afterinstall:

install: beforeinstall realinstall afterinstall

uninstall:
	rm -f ${BINDIR}/${PROG}

include map.mk
include toolchain.mk
include deps.mk
