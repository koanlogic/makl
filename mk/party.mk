#
# $Id: party.mk,v 1.1 2005/11/24 22:26:48 stewy Exp $
# 
# User Variables:
# - PARTY_BASE	The name of the 3rd party package
# - PARTY_DEP		Dependency file used to determine whether target is up to date
# - PARTY_CONF	Configure script to be used
# - PARTY_ARGS	Arguments to be passed to configure script
#
# Applicable Targets:
# - party

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
