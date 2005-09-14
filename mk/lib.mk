# $Id: lib.mk,v 1.6 2005/09/14 15:10:35 tho Exp $
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

OBJS = ${patsubst %.c,%.o,${SRCS}}

.c.o:
	${CC} ${CFLAGS} -c $< -o $*.o
	@${STRIP} ${STRIP_FLAGS} $*.o

lib${LIB}(${OBJS}) : ${OBJS}
	@echo "===> building standard ${LIB} library"
	rm -f lib${LIB}.a
	${AR} cq lib${LIB}.a `${LORDER} ${OBJS} | tsort`
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


include map.mk
include toolchain.mk
include deps.mk
