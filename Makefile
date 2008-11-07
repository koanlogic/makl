#
# $Id: Makefile,v 1.38 2008/11/07 19:30:01 tho Exp $
#

.PHONY: install uninstall

SUBDIRS =  misc
SUBDIRS += bin
SUBDIRS += cf
SUBDIRS += mk
SUBDIRS += tc
SUBDIRS += etc
SUBDIRS += shlib
SUBDIRS += helpers
SUBDIRS += setup
SUBDIRS += tmpl
SUBDIRS += doc/man

MAKL_VERSION = $(shell cat VERSION)
LOGIN_SHELL ?= sh
MAKLRC ?= makl.env

install: Makefile.conf etc/toolchain.mk
	@for d in $(SUBDIRS); do \
		$(MAKE) -I"$(CURDIR)/mk" -C $$d install ; \
	done ;

uninstall: Makefile.conf
	@for d in $(SUBDIRS); do \
		$(MAKE) -I"$(CURDIR)/mk" -C $$d uninstall ; \
	done ;

rc:
	setup/env_setup.sh \
		"$(CURDIR)" $(MAKL_VERSION) "$(LOGIN_SHELL)" "$(MAKLRC)" 0

Makefile.conf etc/toolchain.mk:
	@echo "Run configure.sh through the available POSIX Bourne shell first."
	@exit 1

% : ; @echo "available targets are intall, uninstall and rc"
