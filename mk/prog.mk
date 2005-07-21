#
# $Id: prog.mk,v 1.1.1.1 2005/07/21 18:00:01 tat Exp $
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
# - all, clean, install 
#

OBJS = ${patsubst %.c,%.o,${SRCS}}

${PROG}: ${OBJS}
	${CC} ${CFLAGS} ${LDFLAGS} -o $@ ${OBJS} ${LDADD}

CLEANFILES += ${PROG} ${OBJS}

clean:
	rm -f ${CLEANFILES}

install:
	${INSTALL} ${INSTALL_COPY} ${INSTALL_STRIP} -o ${BINOWN} -g ${BINGRP} \
	    -m ${BINMODE} ${PROG} ${DESTDIR}/${BINDIR}

include map.mk
include toolchain.mk
include deps.mk
