include common.mk
include ../Makefile.conf

INCS = a.h b.h x.h
INCOWN = pippo
INCGRP = bluto

include incs.mk

test:
	@$(ECHO) "==> install headers rule:"
	@$(MAKE) -n install
	@$(ECHO) "==> uninstall headers rule:"
	@$(MAKE) -n uninstall
