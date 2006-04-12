# $Id: lib.mk,v 1.17 2006/04/12 14:42:08 tho Exp $
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
_LIB = $(strip ${LIB})

.c.o:
	${CC} ${CFLAGS} -c $< -o $*.o

lib${_LIB}.a: ${OBJS}
	@echo "===> building standard ${_LIB} library"
	rm -f lib${_LIB}.a
	${AR} ${ARFLAGS} lib${_LIB}.a `${LORDER} ${OBJS} | ${TSORT}`
	${RANLIB} lib${_LIB}.a

clean:
	rm -f ${OBJS} ${CLEANFILES}
	rm -f lib${_LIB}.a

# build arguments list for '{before,real}install' operations
_CHOWN_ARGS =
_INSTALL_ARGS =
ifneq ($(strip ${LIBOWN}),)
    _CHOWN_ARGS = ${LIBOWN}
    _INSTALL_ARGS = -o ${LIBOWN} 
endif
ifneq ($(strip ${LIBGRP}),)
	_CHOWN_ARGS = $(join ${LIBOWN}, :${LIBGRP})
    _INSTALL_ARGS += -g ${LIBGRP} 
endif

beforeinstall:
	${MKINSTALLDIRS} ${LIBDIR}
ifneq ($(strip ${_CHOWN_ARGS}),)
	chown ${_CHOWN_ARGS} ${LIBDIR}
endif

realinstall:
	${INSTALL} ${_INSTALL_ARGS} -m ${LIBMODE} lib${_LIB}.a ${LIBDIR}

afterinstall:

install: beforeinstall realinstall afterinstall

uninstall:
	rm -f ${LIBDIR}/lib${_LIB}.a

include deps.mk
