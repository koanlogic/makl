#
# $Id: lib.mk,v 1.2 2005/07/26 08:24:19 tho Exp $
#
# User variables:
# - LIB         The name of the library that shall be built.
# - SRCS        List of source files that compose the library.
# - CLEANFILES  Additional files that must be removed on clean target.
# - CFLAGS      Compiler flags.
# - LIBOWN, LIBGRP, LIBMODE   Installation credentials.
#
# Available targets:
# - all, clean, install, depend, cleandepend.

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
