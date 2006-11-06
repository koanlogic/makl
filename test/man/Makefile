include common.mk
include ../Makefile.conf

MANFILES = a.1 b.3

MLINKS += a.1 hello.1 
MLINKS += b.3 world.3

MANOWN = pippo
MANGRP = bluto

include man.mk

test:
	@$(ECHO) "==> install man pages rule:"
	@$(MAKE) -n install
	@$(ECHO) "==> uninstall man pages rule:"
	@$(MAKE) -n uninstall
