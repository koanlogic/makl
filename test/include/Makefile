include common.mk
include ../Makefile.conf

INCS = a.h b.h x.h

include incs.mk

test:
	@$(ECHO) "==> install headers rule:"
	@$(MAKE) -n install
	@$(ECHO) "==> uninstall headers rule:"
	@$(MAKE) -n uninstall
