# $Id: lib.mk,v 1.1.1.1 2005/07/21 18:00:01 tat Exp $
#
# User variables:
# - LIB         The name of the library that shall be built.
# - OBJS        List of object files that compose the library.
# - CLEANFILES  Additional files that must be removed on clean target.
# - CFLAGS      Compiler flags.
# - LIBOWN, LIBGRP, LIBMODE   Installation credentials.
#
# Applicable targets:
# - all, clean, install.
#

OBJS = ${patsubst %.c,%.o,${SRCS}}

.c.o:
	${CC} ${CFLAGS} -c $< -o $*.o
	@${STRIP} ${STRIP_FLAGS} $*.o

lib${LIB}(${OBJS}) : ${OBJS}
	@echo "===> building standard ${LIB} library"
	rm -f lib${LIB}.a
	${AR} cq lib${LIB}.a `lorder ${OBJS} | tsort`
	${RANLIB} lib${LIB}.a

install:
	${INSTALL} -o ${LIBOWN} -g ${LIBGRP} -m ${LIBMODE} \
	    lib${LIB}.a ${DESTDIR}${LIBDIR}

clean:
	rm -f ${OBJS} ${CLEANFILES}
	rm -f lib${LIB}.a

include map.mk
include toolchain.mk
include deps.mk
