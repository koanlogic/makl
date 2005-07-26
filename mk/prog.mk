#
# $Id: prog.mk,v 1.2 2005/07/26 08:24:19 tho Exp $
#
# User Variables:
# - PROG        Program name.
# - SRCS        List of program sources.
# - LDADD       Library dependencies.
# - LDFLAGS     Linker flags.
# - CLEANFILES  Additional clean files.
# - BIN{OWN,GRP,MODE,DIR} Installation path and credentials.
# - DESTDIR     Base installation directory.
#
# Available targets:
# - all, clean, install, depend, cleandepend

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
