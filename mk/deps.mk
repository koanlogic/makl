#
# $Id: deps.mk,v 1.1 2005/07/21 18:00:01 tat Exp $
#
# SRCS  C sources to be included in the dependency list
# DPADD add libraries to the dependency list

DEPENDFILE ?= .depend

depend: beforedepend
	touch ${DEPENDFILE}
	${MKDEP} -f ${DEPENDFILE} ${CFLAGS} -a ${SRCS}

beforedepend:

cleandepend:
	rm -f ${DEPENDFILE}

include toolchain.mk
-include ${DEPENDFILE}
