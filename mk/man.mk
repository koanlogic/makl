#
# $Id: man.mk,v 1.1 2005/09/19 19:07:01 tho Exp $
#
# User Variables:
# - MANFILES                Manual page(s) to be installed.
# - MAN{OWN,GRP,MODE,DIR}   Installation path and credentials.
#
# Applicable targets:
# - install, uninstall.
#

# Make sure all of the standard targets are defined, even if they do nothing.
all clean depend cleandepend:

_SUBDIRS = $(strip $(patsubst .%, %, $(sort $(suffix $(MANFILES)))))

ifneq (${_SUBDIRS},)
beforeinstall:
	@for d in ${_SUBDIRS}; do \
		${MKINSTALLDIRS} ${MANDIR}/$$d && \
		chown ${MANOWN}:${MANGRP} ${MANDIR}/$$d ; \
	done

realinstall:
	@for f in ${MANFILES}; do \
		echo "installing $$f in ${MANDIR}/man$${f##*.}" ; \
	done

uninstall:
	@for f in ${MANFILES}; do \
		echo "uninstalling $$f from ${MANDIR}/man$${f##*.}" ; \
	done && \
	echo "removing ${_SUBDIRS} from ${MANDIR}"

else 
# i.e. no valid man file names found in MANFILES
uninstall beforeinstall realinstall:
endif

install: beforeinstall realinstall

include map.mk
include toolchain.mk
