# $Id: Makefile,v 1.2 2006/12/10 07:14:44 tho Exp $

include common.mk
include ../Makefile.conf

FILES = $(shell echo makl*)
FILES_DIR = $(MAKL_ROOT)/cf
FILES_MODE = 0444

include files.mk

install-hook-post:
	$(MAKE) -C helpers install

uninstall-hook-post:
	$(MAKE) -C helpers uninstall
