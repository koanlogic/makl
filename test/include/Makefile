include common.mk
-include ../Makefile.conf

INCS = a.h b.h x.h
INCS += "h ole.h"
#INCOWN = tho
#INCGRP = staff
INCDIR = /tmp/MAKL TEST/include

include incs.mk

test:
	@$(ECHO) "==> install headers rule:"
	@$(MAKE) -n install
	@$(ECHO) "==> uninstall headers rule:"
	@$(MAKE) -n uninstall
