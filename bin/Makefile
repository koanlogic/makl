# $Id: Makefile,v 1.7 2008/02/24 12:13:58 tho Exp $

include common.mk
include ../Makefile.conf

PROG = maklsh
LINKS = makl maklconf maklhelp makltc maklnew
INSTALL_STRIP =

NO_ALL = true
NO_CLEAN = true
NO_DEPEND = true
NO_CLEANDEPEND = true

install-hook-post:
	for f in $(LINKS) ; do                      \
	    rm -f $(BINDIR)/$$f ;                   \
	    ln -s $(BINDIR)/$(PROG) $(BINDIR)/$$f ; \
	done

uninstall-hook-pre:
	for f in $(LINKS) ; do      \
	    rm -f $(BINDIR)/$$f ;   \
	done

include prog.mk
