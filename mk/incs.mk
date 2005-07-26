#
# $Id: incs.mk,v 1.2 2005/07/26 08:24:19 tho Exp $
#
# User variables:
# - INCS        the list of include files to install.
#
# Available targets:
# - Only define the install target (all, clean, depend, cleandepend are NOPs).

all clean depend cleandepend:
	@echo "nothing to do for ${MAKECMDGOALS} target in ${CURDIR} ..."		

install:
	${INSTALL} -o ${INCOWN} -g ${INCGRP} -m ${INCMODE} \
	    ${INCS} ${DESTDIR}${INCDIR} 

include map.mk
include toolchain.mk
