#
# $Id: man.mk,v 1.2 2005/09/20 07:56:12 tho Exp $
#
# User Variables:
# - MANFILES                Manual page(s) to be installed.
# - MAN{OWN,GRP,MODE,DIR}   Installation path and credentials.
# - MLINKS                  Ordered couplets of man page and its symlink
#
# Applicable targets:
# - install, uninstall.
#

# Make sure all of the standard targets are defined, even if they do nothing.
all clean depend cleandepend:

_SUBDIRS = $(strip $(patsubst .%, %, $(sort $(suffix $(MANFILES)))))

ifneq (${MLINKS},)
manlinks:
	@set ${MLINKS}; \
		while test $$# -ge 2 ; do \
			name=$$1 ; \
			shift ; \
			dir=${MANDIR}/man$${name##*.} ; \
			l=$${dir}/$${name} ; \
			name=$$1 ; \
			shift ; \
			dir=${MANDIR}/man$${name##*.} ; \
			t=$${dir}/$${name} ; \
			if test $$l -nt $$t -o ! -f $$t ; then \
				echo $$t -\> $$l ; \
				ln -f $$l $$t ; \
			fi ; \
		done
else
manlinks:
endif

ifneq (${_SUBDIRS},)
beforeinstall:
	@for d in ${_SUBDIRS}; do \
		${MKINSTALLDIRS} ${MANDIR}/man$$d && \
		chown ${MANOWN}:${MANGRP} ${MANDIR}/man$$d ; \
	done

realinstall:
	@for f in ${MANFILES}; do \
		${INSTALL} ${INSTALL_COPY} -o ${MANOWN} -g ${MANGRP} -m ${MANMODE} \
            $$f ${MANDIR}/man$${f##*.} ; \
	done


uninstall:
	@for f in ${MLINKS} ${MANFILES} ; do \
		rm -f ${MANDIR}/man$${f##*.}/$$f ; \
	done

else 
# i.e. no valid man file names found in MANFILES
uninstall beforeinstall realinstall manlinks:
endif

install: beforeinstall realinstall manlinks

include map.mk
include toolchain.mk
