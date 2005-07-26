#
# $Id: deps.mk,v 1.2 2005/07/26 08:24:19 tho Exp $
#
# User variables:
# SRCS      C sources to be included in the dependency list.
# DPADD     Add libraries to the dependency list.
# 
# Available targets:
# - depend, broken up into {before,real,after}depend
# - cleandepend

DEPENDFILE ?= .depend

depend: beforedepend realdepend afterdepend

beforedepend:

realdepend:
	touch ${DEPENDFILE}
	${MKDEP} -f ${DEPENDFILE} ${CFLAGS} -a ${SRCS}

afterdepend:
ifdef PROG
ifdef DPADD
	echo ${PROG}: ${DPADD} >> ${DEPENDFILE}
endif
endif

cleandepend:
	rm -f ${DEPENDFILE}

include toolchain.mk
-include ${DEPENDFILE}
