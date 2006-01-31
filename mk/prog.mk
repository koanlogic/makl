#
# $Id: prog.mk,v 1.12 2006/01/31 21:15:52 tho Exp $
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

include ../etc/map.mk

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

# build arguments list for '{before,real}install' operations
_CHOWN_ARGS =
_INSTALL_ARGS =
ifneq ($(strip ${BINOWN}),)
    _CHOWN_ARGS = ${BINOWN}
    _INSTALL_ARGS = -o ${BINOWN}
endif
ifneq ($(strip ${BINGRP}),)
    _CHOWN_ARGS = $(join ${BINOWN}, :${BINGRP})
    _INSTALL_ARGS += -g ${BINGRP}
endif

beforeinstall:
	${MKINSTALLDIRS} ${BINDIR}
ifneq ($(strip ${_CHOWN_ARGS}),)
	chown ${_CHOWN_ARGS} ${BINDIR}
endif

realinstall:
	${INSTALL} ${INSTALL_COPY} ${INSTALL_STRIP} ${_INSTALL_ARGS} \
	    -m ${BINMODE} ${PROG} ${BINDIR}

afterinstall:

install: beforeinstall realinstall afterinstall

uninstall:
	rm -f ${BINDIR}/${PROG}

include deps.mk
