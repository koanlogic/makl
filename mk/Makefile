# $Id: Makefile,v 1.6 2006/12/10 07:14:44 tho Exp $

include common.mk
include ../Makefile.conf

FILES = $(shell echo *.mk)
FILES_DIR = $(MAKL_ROOT)/mk
FILES_MODE = 0444

include files.mk

install-hook-post:
	$(MAKE) -C priv install

uninstall-hook-post:
	$(MAKE) -C priv uninstall
