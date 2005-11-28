#
# $Id: party.mk,v 1.4 2005/11/28 14:22:38 tho Exp $
# 
# User Variables:
# - PARTY_BASE  The name of the 3rd party package
# - PARTY_DEP   Dependency file used to determine whether target is up to date
# - PARTY_CONF  Configure script to be used
# - PARTY_ARGS  Arguments to be passed to configure script
#
# Applicable Targets:
# - party clean

PARTY_CONF ?= configure

${PARTY_DEP}:
ifndef PARTY_NO_CONF
	cd ${PARTY_BASE} && ./${PARTY_CONF} ${PARTY_ARGS} 
endif
ifndef PARTY_NO_MAKE
	${MAKE} -C ${PARTY_BASE}
endif
ifndef PARTY_NO_INSTALL
	${MAKE} -C ${PARTY_BASE} install
endif

party: ${PARTY_DEP}

clean:
	${MAKE} -C ${PARTY_BASE} clean

# set standard MaKL targets even if they don't do nothing
install uninstall depend cleandepend:

include ../etc/map.mk
