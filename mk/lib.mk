# $Id: lib.mk,v 1.11 2005/12/30 17:20:41 tat Exp $
#
# User variables:
# - LIB         The name of the library that shall be built.
# - OBJS        List of object files that compose the library.
# - CLEANFILES  Additional files that must be removed on clean target.
# - CFLAGS      Compiler flags.
# - LIBOWN, LIBGRP, LIBMODE   Installation credentials.
#
# Applicable targets:
# - all, clean, install, uninstall.
#

OBJS_T = ${patsubst %.cc,%.o,${SRCS}}
OBJS = ${patsubst %.c,%.o,${OBJS_T}}

.c.o:
	${CC} ${CFLAGS} -c $< -o $*.o

lib${LIB}.a: ${OBJS}
	@echo "===> building standard ${LIB} library"
	rm -f lib${LIB}.a
	${AR} cq lib${LIB}.a `${LORDER} ${OBJS} | ${TSORT}`
	${RANLIB} lib${LIB}.a

clean:
	rm -f ${OBJS} ${CLEANFILES}
	rm -f lib${LIB}.a

beforeinstall:
	${MKINSTALLDIRS} ${LIBDIR} && chown ${LIBOWN}:${LIBGRP} ${LIBDIR}

realinstall:
	${INSTALL} -o ${LIBOWN} -g ${LIBGRP} -m ${LIBMODE} lib${LIB}.a ${LIBDIR}

afterinstall:

install: beforeinstall realinstall afterinstall

uninstall:
	rm -f ${LIBDIR}/lib${LIB}.a


include ../etc/map.mk
include ../etc/toolchain.mk
include deps.mk
