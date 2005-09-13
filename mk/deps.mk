#
# $Id: deps.mk,v 1.3 2005/09/13 08:01:09 tho Exp $
#
# User variables:
# SRCS      C sources to be included in the dependency list.
# DPADD     Add generic files to the dependency list.
# LDADD     Add archive files to the dependency list.
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
ifdef LDADD
	echo ${PROG}: ${LDADD} >> ${DEPENDFILE}
endif
endif

cleandepend:
	rm -f ${DEPENDFILE}

include toolchain.mk
-include ${DEPENDFILE}
