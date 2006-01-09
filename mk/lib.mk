# $Id: lib.mk,v 1.12 2006/01/09 15:33:49 tho Exp $
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

include ../etc/map.mk

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

# build arguments list for '{before,real}install' operations
_CHOWN_ARGS =
_INSTALL_ARGS =
ifneq ($(strip ${LIBOWN}),)
    _CHOWN_ARGS = ${LIBOWN}
    _INSTALL_ARGS = -o ${LIBOWN} 
endif
ifneq ($(strip ${LIBGRP}),)
	_CHOWN_ARGS += $(join ${LIBOWN}, :${LIBGRP})
    _INSTALL_ARGS += -g ${LIBGRP} 
endif

beforeinstall:
	${MKINSTALLDIRS} ${LIBDIR}
ifneq (${_CHOWN_ARGS},)
	chown ${_CHOWN_ARGS} ${LIBDIR}
endif

realinstall:
	${INSTALL} ${_INSTALL_ARGS} -m ${LIBMODE} lib${LIB}.a ${LIBDIR}

afterinstall:

install: beforeinstall realinstall afterinstall

uninstall:
	rm -f ${LIBDIR}/lib${LIB}.a

include ../etc/toolchain.mk
include deps.mk
