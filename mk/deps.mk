#
# $Id: deps.mk,v 1.4 2005/10/03 13:52:37 stewy Exp $
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

include ../etc/toolchain.mk
-include ${DEPENDFILE}
