#
# $Id: party.mk,v 1.6 2006/04/19 09:06:24 stewy Exp $
# 
# User Variables:
# - PARTY_NAME  The name of the 3rd party package
# - PARTY_FILE  Package filename
# - PARTY_BASE  Base directory for build 
# - PARTY_DEP   Dependency file used to determine whether target is up to date
# - PARTY_CONF  Configure script to be used
# - PARTY_ARGS  Arguments to be passed to configure script
#
# Applicable Targets:
# - party clean

PARTY_CONF ?= ./configure
PARTY_DECOMP ?= tar
PARTY_DECOMP_ARGS ?= xzvf
PARTY_LOG ?= party.log
PARTY_BASE ?= ${PARTY_NAME}
PARTY_FILE ?= ${PARTY_NAME}.tar.gz

all: pre conf make install

pre:
	[ ! -e ${PARTY_LOG} ] || rm -f ${PARTY_LOG}
ifndef PARTY_NO_DECOMP
	@echo "decompressing ${PARTY_NAME}"
	${PARTY_DECOMP} ${PARTY_DECOMP_ARGS} ${PARTY_FILE} \
      1>> ${PARTY_LOG} 2>> ${PARTY_LOG}
endif

conf: beforeconf realconf afterconf
beforeconf:
realconf:
ifndef PARTY_NO_CONF
	@echo "configuring ${PARTY_NAME}"
	cd ${PARTY_BASE} && ${PARTY_CONF} ${PARTY_ARGS} \
      1>> ${PARTY_LOG} 2>> ${PARTY_LOG}
endif
afterconf:

make:
ifndef PARTY_NO_MAKE
	@echo "building ${PARTY_NAME}"
	${MAKE} -C ${PARTY_BASE} >> ${PARTY_LOG} \
      1>> ${PARTY_LOG} 2>> ${PARTY_LOG}
endif

install: beforeinstall realinstall afterinstall
beforeinstall:
realinstall:
ifndef PARTY_NO_INSTALL
	@echo "installing ${PARTY_NAME}"
	${MAKE} -C ${PARTY_BASE} install >> ${PARTY_LOG} \
      1>> ${PARTY_LOG} 2>> ${PARTY_LOG}
endif
afterinstall:

clean:
ifndef PARTY_NO_DECOMP
	@echo "cleaning ${PARTY_NAME}"
	rm -rf ${PARTY_BASE} \
      1>> ${PARTY_LOG} 2>> ${PARTY_LOG}
endif

# set standard MaKL targets even if they don't do anything
install uninstall depend cleandepend:

include ../etc/map.mk
