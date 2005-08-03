#
# $Id: incs.mk,v 1.4 2005/08/03 19:47:09 tho Exp $
#
# Only define the install target.
#
# - INCS        the list of include files to install.
#

all clean depend cleandepend:
	@echo "nothing to do for ${MAKECMDGOALS} target in ${CURDIR} ..."		
    
beforeinstall:
	mkdir -p ${INCDIR} && chown ${INCOWN}:${INCGRP} ${INCDIR}

realinstall:
	${INSTALL} -o ${INCOWN} -g ${INCGRP} -m ${INCMODE} ${INCS} ${INCDIR}

afterinstall:

install: beforeinstall realinstall afterinstall

uninstall:
	for f in ${INCS}; do \
	    rm -f ${INCDIR}/$$f; \
	done

include map.mk
include toolchain.mk
