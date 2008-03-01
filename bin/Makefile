# $Id: Makefile,v 1.8 2008/03/01 17:39:06 tho Exp $

include common.mk
include ../Makefile.conf

PROG = maklsh
LINKS = makl maklconf maklhelp makltc maklnew
LINKS += makl-conf makl-help makl-tc makl-new
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
