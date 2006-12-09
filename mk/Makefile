# $Id: Makefile,v 1.5 2006/12/09 22:49:32 tho Exp $

include common.mk
include ../Makefile.conf

FILES = $(shell echo *.mk)
FILES_DIR = $(MAKL_ROOT)/mk
FILES_MODE = 0444

install-hook-post:
	$(MAKE) -C priv install

uninstall-hook-post:
	$(MAKE) -C priv uninstall

include files.mk
