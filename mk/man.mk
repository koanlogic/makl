#
# $Id: man.mk,v 1.9 2006/01/31 17:06:22 tho Exp $
#
# User Variables:
# - MANFILES   Manual page(s) to be installed.
# - MANOWN     Installation credentials for files and directories (owner).
# - MANGRP     Installation credentials for files and directories (group).
# - MANMODE    Installation permission for files in 'absolute' mode.
# - MANDIR     Top level man pages' directory.
# - MLINKS     Ordered couplets of man page and its symlink.
#
# Applicable targets:
# - install, uninstall.
#

include ../etc/map.mk

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

_CHOWN_ARGS =
_INSTALL_ARGS =
ifneq ($(strip ${MANOWN}),)
    _CHOWN_ARGS = ${MANOWN}
    _INSTALL_ARGS = -o ${MANOWN}
endif
ifneq ($(strip ${MANGRP}),)
    _CHOWN_ARGS += $(join ${MANOWN}, :${MANGRP})
    _INSTALL_ARGS += -g ${MANGRP}
endif

ifneq (${_SUBDIRS},)
beforeinstall-dirs:
	@for d in ${_SUBDIRS}; do \
		${MKINSTALLDIRS} ${MANDIR}/man$$d ; \
	done

beforeinstall-dirperms:
ifneq ($(strip ${_CHOWN_ARGS}),)
	@for d in ${_SUBDIRS}; do \
		chown ${_CHOWN_ARGS} ${MANDIR}/man$$d ; \
	done
endif

realinstall:
	@for f in ${MANFILES}; do \
		${INSTALL} ${INSTALL_COPY} ${_INSTALL_ARGS} -m ${MANMODE} \
            $$f ${MANDIR}/man$${f##*.} ; \
	done

uninstall:
	@for f in ${MLINKS} ${MANFILES} ; do \
		rm -f ${MANDIR}/man$${f##*.}/$$f ; \
	done

else 
# i.e. no valid man file names found in MANFILES
uninstall beforeinstall-dirs beforeinstall-dirperms realinstall manlinks:
endif

install: beforeinstall-dirs beforeinstall-dirperms realinstall manlinks
