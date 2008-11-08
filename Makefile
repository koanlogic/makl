#
# $Id: Makefile,v 1.39 2008/11/08 06:05:26 tho Exp $
#

.DEFAULT_GOAL = help
.PHONY: install uninstall rc toolchain

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

install uninstall: Makefile.conf etc/toolchain.mk
	@for d in $(SUBDIRS); do \
		$(MAKE) -I"$(CURDIR)/mk" -C $$d $(MAKECMDGOALS) ; \
	done ;

Makefile.conf etc/toolchain.mk:
	@echo "You must run configure.sh first.  Please see INSTALL file."
	@exit 1

help:
	@echo
	@echo "Available targets:"
	@echo
	@echo "   * install     install a system wide MaKL (see INSTALL file)  "
	@echo "   * uninstall   delete MaKL installed objects from host        "
	@echo "   * toolchain   install platform toolchain files               "
	@echo "   * rc          create a file containing runtime MaKL variables"
	@echo
	@echo "****************************************************************"
	@echo "   The toolchain and rc targets are now obsolete.  They are     "
	@echo "   retained for backwards compatibility only.  Please consider  "
	@echo "   using the new install mechanism (see INSTALL for details).   "
	@echo "****************************************************************"
	@echo

rc:
	setup/env_setup.sh \
		"$(CURDIR)" $(MAKL_VERSION) "$(LOGIN_SHELL)" "$(MAKLRC)" 0

toolchain: $(MAKL_ETC)
ifdef MAKL_PLATFORM
	@env MAKL_DIR="$(CURDIR)" MAKL_TC=$(MAKL_PLATFORM) \
		MAKL_SHLIB=$(MAKL_PLATFORM) /bin/sh setup/tc_setup.sh
else
	@env MAKL_DIR="$(CURDIR)" /bin/sh setup/tc_setup.sh
endif


