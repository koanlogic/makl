# $Id: Makefile,v 1.4 2006/12/09 22:42:10 tho Exp $

include common.mk
include ../Makefile.conf

FILES = $(shell echo *.sh)
FILES_DIR = $(MAKL_ROOT)/mk
FILES_MODE = 0444

install-hook-post:
	$(MAKE) -C priv install

uninstall-hook-post:
	$(MAKE) -C priv uninstall

include files.mk
