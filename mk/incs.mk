#
# $Id: incs.mk,v 1.6 2005/10/03 13:52:37 stewy Exp $
#
# Only define the install target.
#
# - INCS        the list of header files to install.
#

all clean depend cleandepend:
	@echo "nothing to do for ${MAKECMDGOALS} target in ${CURDIR} ..."		
    
beforeinstall:
	${MKINSTALLDIRS} ${INCDIR} && chown ${INCOWN}:${INCGRP} ${INCDIR}

realinstall:
	${INSTALL} -o ${INCOWN} -g ${INCGRP} -m ${INCMODE} ${INCS} ${INCDIR}

afterinstall:

install: beforeinstall realinstall afterinstall

uninstall:
	for f in ${INCS}; do \
	    rm -f ${INCDIR}/$$f; \
	done

include ../etc/map.mk
include ../etc/toolchain.mk
