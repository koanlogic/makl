# $Id: Makefile,v 1.6 2007/12/12 08:57:52 tho Exp $

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
	rm -f $(BINDIR)/makltc && ln -s $(BINDIR)/$(PROG) $(BINDIR)/makltc

uninstall-hook-pre:
	rm -f $(BINDIR)/makl
	rm -f $(BINDIR)/maklconf
	rm -f $(BINDIR)/maklhelp

include prog.mk
