#
# $Id: prog.mk,v 1.8 2005/12/30 17:20:41 tat Exp $
#
# User Variables:
# - USE_CXX     If defined use C++ compiler instead of C compiler
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

OBJS_T = ${patsubst %.cc,%.o,${SRCS}}
OBJS = ${patsubst %.c,%.o,${OBJS_T}}

ifndef USE_CXX
${PROG}: ${OBJS}
	${CC} ${CFLAGS} ${LDFLAGS} -o $@ ${OBJS} ${PRE_LDADD} ${LDADD} ${POST_LDADD}
else
${PROG}: ${OBJS}
	${CXX} ${CXXFLAGS} ${LDFLAGS} -o $@ ${OBJS} ${PRE_LDADD} ${LDADD} ${POST_LDADD}
endif

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
