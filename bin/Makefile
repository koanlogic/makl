# $Id: Makefile,v 1.5 2006/12/09 22:42:10 tho Exp $

include common.mk
include ../Makefile.conf

PROG = maklsh
INSTALL_STRIP =

NO_ALL = true
NO_CLEAN = true
NO_DEPEND = true
NO_CLEANDEPEND = true

install-hook-post:
	rm -f $(BINDIR)/makl && ln -s $(BINDIR)/$(PROG) $(BINDIR)/makl
	rm -f $(BINDIR)/maklconf && ln -s $(BINDIR)/$(PROG) $(BINDIR)/maklconf
	rm -f $(BINDIR)/maklhelp && ln -s $(BINDIR)/$(PROG) $(BINDIR)/maklhelp

uninstall-hook-pre:
	rm -f $(BINDIR)/makl
	rm -f $(BINDIR)/maklconf
	rm -f $(BINDIR)/maklhelp

include prog.mk
