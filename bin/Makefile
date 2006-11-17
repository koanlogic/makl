# $Id: Makefile,v 1.4 2006/11/17 02:49:31 tho Exp $

include common.mk
include ../Makefile.conf

PROG = maklsh
INSTALL_STRIP =

all depend cleandepend:

install-hook-post:
	rm -f $(BINDIR)/makl && ln -s $(BINDIR)/$(PROG) $(BINDIR)/makl
	rm -f $(BINDIR)/maklconf && ln -s $(BINDIR)/$(PROG) $(BINDIR)/maklconf
	rm -f $(BINDIR)/maklhelp && ln -s $(BINDIR)/$(PROG) $(BINDIR)/maklhelp

uninstall-hook-pre:
	rm -f $(BINDIR)/makl
	rm -f $(BINDIR)/maklconf
	rm -f $(BINDIR)/maklhelp

include prog.mk
