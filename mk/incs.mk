#
# $Id: incs.mk,v 1.3 2005/07/27 08:35:57 stewy Exp $
#
# Only define the install target.
#
# - INCS        the list of include files to install.
#

all clean depend cleandepend:
	@echo "nothing to do for ${MAKECMDGOALS} target in ${CURDIR} ..."		
    
beforeinstall:
realinstall:
	${INSTALL} -o ${INCOWN} -g ${INCGRP} -m ${INCMODE} \
	    ${INCS} ${DESTDIR}${INCDIR} 
afterinstall:
install: beforeinstall realinstall afterinstall

uninstall:
	rm -f ${DESTDIR}${INCDIR}${INCS}
    

include map.mk
include toolchain.mk
