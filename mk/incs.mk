#
# $Id: incs.mk,v 1.1.1.1 2005/07/21 18:00:01 tat Exp $
#
# Only define the install target (all, clean, depend, cleandepend are NOPs).
#
# - INCS        the list of include files to install.

all clean depend cleandepend:
	@echo "nothing to do for ${MAKECMDGOALS} target in ${CURDIR} ..."		
install:
	${INSTALL} -o ${INCOWN} -g ${INCGRP} -m ${INCMODE} \
	    ${INCS} ${DESTDIR}${INCDIR} 

include map.mk
include toolchain.mk
