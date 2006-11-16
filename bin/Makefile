# $Id: Makefile,v 1.3 2006/11/16 16:54:48 tho Exp $

include common.mk
include ../Makefile.conf

PROG = maklsh
INSTALL_STRIP =

all depend cleandepend:

install-hook-post:
	ln -s $(BINDIR)/$(PROG) $(BINDIR)/makl
	ln -s $(BINDIR)/$(PROG) $(BINDIR)/maklconf

uninstall-hook-pre:
	rm -f $(BINDIR)/makl
	rm -f $(BINDIR)/maklconf
	rm -f $(BINDIR)/maklhelp

include prog.mk
